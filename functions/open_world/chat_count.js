'use strict';
function publicChatCount(world) {
  const n = Number(world?.chatMessageCount);
  return Number.isFinite(n) && n >= 0 ? Math.floor(n) : 0;
}
function isPublicWorld(world) {
  return world?.isPublic === true && world?.publicPlayable === true &&
    world?.isDraft !== true && world?.status === 'public';
}
function isPublicChatRoom(room, world) {
  if (!isPublicWorld(world) || room?.isPrivateTest === true) return false;
  if (room?.entrySource === 'public') return true;
  // Older non-owner sessions were incorrectly tagged entrySource=private.
  // The server has already verified room ownership/world membership. A
  // non-owner can enter this handler only while the world is publicly playable.
  return typeof room?.userId === 'string' && !!room.userId &&
    typeof world?.createdBy === 'string' && !!world.createdBy &&
    room.userId !== world.createdBy;
}
function recordPublicChatSend({tx, action, room, world, worldRef, publicRef, publicExists}) {
  if (action !== 'send' || !isPublicChatRoom(room, world)) return false;
  const next = publicChatCount(world) + 1;
  // Caller reads world + projection inside the same transaction, after the
  // existing requestId guard. Concurrent sends retry; no extra external writes.
  tx.update(worldRef, {chatMessageCount:next});
  if (publicExists) tx.update(publicRef, {chatMessageCount:next, playCount:next});
  return true;
}
module.exports = {publicChatCount, isPublicChatRoom, recordPublicChatSend};
