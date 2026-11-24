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
  const data = await response.json();
  if (!response.ok) throw new Error(`Gemini HTTP ${response.status}: ${String(data.error?.status || 'UNKNOWN').slice(0,80)}`);
  const candidate = data.candidates?.[0];
  const part = candidate?.content?.parts?.find(p=>!p.thought && p.inlineData?.data && p.inlineData?.mimeType?.startsWith('image/'));
  if (!part) throw new Error(`No image: ${candidate?.finishReason || data.promptFeedback?.blockReason || 'UNKNOWN'}`);
  const bytes = Buffer.from(part.inlineData.data,'base64');
  if (!bytes.length || bytes.length > 12*1024*1024) throw new Error('Unexpected output size');
  return {bytes,mimeType:detectMime(bytes),elapsedMs:Date.now()-started,usage:data.usageMetadata || null,model:MODEL};
}
module.exports = {generateImage,detectMime,MODEL};
