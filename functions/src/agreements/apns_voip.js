 'use strict';
const http2=require('http2');
const crypto=require('crypto');
let cached={jwt:null,at:0};
function jwtToken(teamId,keyId,privateKey) {
  const now=Math.floor(Date.now()/1000);
  if(cached.jwt && now-cached.at<3000)return cached.jwt;
  const enc=o=>Buffer.from(JSON.stringify(o)).toString('base64url');
  const body=enc({alg:'ES256',kid:keyId})+'.'+enc({iss:teamId,iat:now});
  const sig=crypto.sign('sha256',Buffer.from(body),{key:privateKey,dsaEncoding:'ieee-p1363'}).toString('base64url');
  cached={jwt:body+'.'+sig,at:now};return cached.jwt;
}
async function sendVoipToUser({db,userId,payload,logger}) {
  const privateKey=(process.env.APPLE_VOIP_APNS_PRIVATE_KEY||'').replace(/\\n/g,'\n');
  const teamId=process.env.APPLE_VOIP_TEAM_ID||'';
  const keyId=process.env.APPLE_VOIP_KEY_ID||'';
  const bundleId=process.env.APPLE_VOIP_BUNDLE_ID||'';
  // 必須使用 Runner 的真實 Bundle ID（不是套件顯示名稱）。
  if(!privateKey||!teamId||!keyId||!bundleId)return {successCount:0,configured:false};
  const tokens=await db.collection('role_voip_tokens').doc(userId).collection('devices').limit(20).get();
  if(tokens.empty)return {successCount:0,configured:true};
  const host=process.env.APPLE_VOIP_APNS_SANDBOX==='true'?'https://api.sandbox.push.apple.com':'https://api.push.apple.com';
  const bearer=jwtToken(teamId,keyId,privateKey);
  const client=http2.connect(host);let successCount=0;
  try {
    for(const doc of tokens.docs){
      const token=doc.data()?.token;
      if(!/^[a-f0-9]{64,256}$/.test(token||''))continue;
      const content=JSON.stringify({aps:{},...payload});
      const result=await new Promise(resolve=>{
        const req=client.request({':method':'POST',':path':`/3/device/${token}`,
          'apns-topic':`${bundleId}.voip`,'apns-push-type':'voip','apns-priority':'10',
          'apns-expiration':`${Math.floor(Date.now()/1000)+30}`,
          authorization:`bearer ${bearer}`,'content-type':'application/json'});
        let status=0;let body='';
        req.on('response',headers=>{status=Number(headers[':status']||0)});
        req.on('data',chunk=>body+=chunk);
        req.on('end',()=>resolve({status,body}));
        req.on('error',e=>resolve({status:0,body:String(e)}));
        req.setTimeout(8000,()=>req.close());req.end(content);
      });
      if(result.status===200)successCount++;
      else {
        logger.warn('VoIP APNs delivery rejected',{status:result.status,reason:result.body.slice(0,200)});
        // 裝置 token 已失效時，只刪除這筆 token，不影響別人的排程。
        if([400,410].includes(result.status)&&/BadDeviceToken|Unregistered|DeviceTokenNotForTopic/.test(result.body))
          await doc.ref.delete();
      }
    }
  } finally {client.close();}
  return {successCount,configured:true};
}
module.exports={sendVoipToUser};
