'use strict';
// Original voice preview authentication check, dependency-injected without changing the body.
function createVoiceLoginGuard({HttpsError}) {
  function requireLogin(request) {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "請先登入後再使用語音功能");
    }
  }
  return requireLogin;
}
module.exports={createVoiceLoginGuard};
