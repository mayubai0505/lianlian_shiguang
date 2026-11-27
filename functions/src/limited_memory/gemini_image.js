'use strict';
const MODEL = 'gemini-3.1-flash-lite-image';
function detectMime(buffer) {
  if (buffer.length >= 8 && buffer.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10]))) return 'image/png';
  if (buffer.length >= 3 && buffer[0]===255 && buffer[1]===216 && buffer[2]===255) return 'image/jpeg';
  if (buffer.length >= 12 && buffer.toString('ascii',0,4)==='RIFF' && buffer.toString('ascii',8,12)==='WEBP') return 'image/webp';
  throw new Error('Unsupported image format');
}
async function generateImage({apiKey, input, prompt, fetchImpl = fetch}) {
  if (!apiKey) throw new Error('Missing Gemini API key');
  if (!Buffer.isBuffer(input) || input.length === 0 || input.length > 5*1024*1024) throw new Error('Reference must be 1 byte–5 MiB');
  const mimeType = detectMime(input);
  const started = Date.now();
  const response = await fetchImpl(`https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`, {
    method:'POST', headers:{'Content-Type':'application/json','x-goog-api-key':apiKey},
    signal:AbortSignal.timeout(150000),
    body:JSON.stringify({contents:[{role:'user',parts:[{inlineData:{mimeType,data:input.toString('base64')}},{text:prompt}]}],generationConfig:{responseModalities:['IMAGE'],imageConfig:{aspectRatio:'9:16',imageSize:'1K'}}})
  });
  let data;
  try { data = await response.json(); } catch (_) {
    console.warn('[LM_GEMINI_HTTP]', {httpStatus:response.status, model:MODEL, inputMime:mimeType, inputBytes:input.length, promptLength:prompt.length, responseFormat:'non-json'});
    throw new Error(`Gemini HTTP ${response.status}: non-JSON response`);
  }
  if (!response.ok) {
    const err=data?.error||{};
    // Provider descriptions may echo request content. Log only known diagnostic
    // categories and schema field names, never arbitrary provider message text.
    const message=typeof err.message==='string'?err.message:'';
    const rules={image_decode:/decode|corrupt|invalid image|image format|unsupported image/i,image_dimensions:/dimension|resolution|pixel|image size/i,aspect_ratio:/aspect.?ratio/i,image_size:/image.?size/i,model:/model|not supported/i,modality:/modalit/i,inline_data:/inline.?data|mime.?type|base64/i,request_schema:/unknown (?:name|field)|invalid json|invalid value|field violation/i,safety:/safety|prohibited|blocked/i,token_limit:/token|too long|payload.*large/i,api_key:/api.?key|credential/i,quota:/quota|billing|credit/i};
    const categories=Object.entries(rules).filter(([,re])=>re.test(message)).map(([name])=>name);
    const fields=(Array.isArray(err.details)?err.details:[]).flatMap(d=>Array.isArray(d?.fieldViolations)?d.fieldViolations:[]).map(v=>v?.field).filter(v=>typeof v==='string'&&/^(?:contents|generationConfig|generation_config|model)(?:[.\[\]0-9A-Za-z_]{0,120})$/.test(v)).slice(0,10);
    const status=typeof err.status==='string'&&/^[A-Z_]{1,80}$/.test(err.status)?err.status:'UNKNOWN';
    console.warn('[LM_GEMINI_HTTP]', {httpStatus:response.status, status, model:MODEL,inputMime:mimeType,inputBytes:input.length,promptLength:prompt.length,categories,fields,aspectRatio:'9:16',imageSize:'1K'});
    throw new Error(`Gemini HTTP ${response.status}: ${status}${categories.length?' ['+categories.join(',')+']':''}`);
  }
  const candidate = data.candidates?.[0];
  const part = candidate?.content?.parts?.find(p=>!p.thought && p.inlineData?.data && p.inlineData?.mimeType?.startsWith('image/'));
  if (!part) throw new Error(`No image: ${candidate?.finishReason || data.promptFeedback?.blockReason || 'UNKNOWN'}`);
  const bytes = Buffer.from(part.inlineData.data,'base64');
  if (!bytes.length || bytes.length > 12*1024*1024) throw new Error('Unexpected output size');
  return {bytes,mimeType:detectMime(bytes),elapsedMs:Date.now()-started,usage:data.usageMetadata || null,model:MODEL};
}
module.exports = {generateImage,detectMime,MODEL};
