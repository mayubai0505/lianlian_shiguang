'use strict';
const fs=require('node:fs');
const path=require('node:path');
const {generateImage}=require('../src/limited_memory/gemini_image');
const {buildLimitedMemoryPrompt}=require('../src/limited_memory/build_limited_memory_prompt');
(async()=>{
 const [file,characterName='測試角色',characterTitle='',personality='溫柔、浪漫']=process.argv.slice(2);
 if(!file) throw Error('Usage: node scripts/test_limited_memory_local.js IMAGE [NAME] [TITLE] [PERSONALITY]');
 if(fs.statSync(file).size>5*1024*1024) throw Error('Reference image exceeds 5 MiB');
 const result=await generateImage({apiKey:process.env.LIMITED_MEMORY_GEMINI_KEY,input:fs.readFileSync(file),prompt:buildLimitedMemoryPrompt({characterName,characterTitle,personality})});
 const ext={'image/png':'png','image/jpeg':'jpg','image/webp':'webp'}[result.mimeType];
 const output=path.resolve(`limited_memory_test_${Date.now()}.${ext}`);
 fs.writeFileSync(output,result.bytes,{flag:'wx'});
 console.log(JSON.stringify({output,elapsedMs:result.elapsedMs,model:result.model,usage:result.usage},null,2));
})().catch(e=>{console.error(e.message);process.exitCode=1;});
