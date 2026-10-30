'use strict';
module.exports = function createNotificationTexts(db) {
// ============================================================
// 通知多國語系共用工具
// ============================================================
const NOTIFICATION_TEXTS = {
  zh_Hant: {
    announcementTitle: "戀戀拾光有新公告",
    announcementBody: "新的官方公告已發布，點擊查看。",
    creatorMomentTitle: (name) => `${name} 發布了新的瞬間`,
    creatorMomentBody: "你關注的創作者有新動態，點擊看看。",
    characterMomentTitle: (name) => `${name} 發布了新的瞬間`,
    characterMomentBody: "你關注的創作者旗下角色有新動態，點擊看看。",
    autoLikeTitle: "角色按讚了你的瞬間",
    autoLikeBody: (name) => `${name} 喜歡了你的瞬間動態。`,
    autoReplyTitle: "動態有新回應",
    autoReplyBody: (name, content, isReply) => isReply
      ? `${name} 回覆了你的留言：「${content}」`
      : `${name} 回覆了你的動態：「${content}」`,
  },
  zh_Hans: {
    announcementTitle: "恋恋拾光有新公告",
    announcementBody: "新的官方公告已发布，点击查看。",
    creatorMomentTitle: (name) => `${name} 发布了新的瞬间`,
    creatorMomentBody: "你关注的创作者有新动态，点击看看。",
    characterMomentTitle: (name) => `${name} 发布了新的瞬间`,
    characterMomentBody: "你关注的创作者旗下角色有新动态，点击看看。",
    autoLikeTitle: "角色点赞了你的瞬间",
    autoLikeBody: (name) => `${name} 喜欢了你的瞬间动态。`,
    autoReplyTitle: "动态有新回复",
    autoReplyBody: (name, content, isReply) => isReply
      ? `${name} 回复了你的留言：“${content}”`
      : `${name} 回复了你的动态：“${content}”`,
  },
  en: {
    announcementTitle: "New announcement from Lianlian Shiguang",
    announcementBody: "A new official announcement is available. Tap to view it.",
    creatorMomentTitle: (name) => `${name} posted a new Moment`,
    creatorMomentBody: "A creator you follow has a new update. Tap to view it.",
    characterMomentTitle: (name) => `${name} posted a new Moment`,
    characterMomentBody: "A character from a creator you follow has a new update.",
    autoLikeTitle: "A character liked your Moment",
    autoLikeBody: (name) => `${name} liked your Moment.`,
    autoReplyTitle: "New reply on your Moment",
    autoReplyBody: (name, content, isReply) => isReply
      ? `${name} replied to your comment: “${content}”`
      : `${name} replied to your Moment: “${content}”`,
  },
  ja: {
    announcementTitle: "恋恋拾光から新しいお知らせ",
    announcementBody: "新しい公式お知らせが公開されました。タップして確認してください。",
    creatorMomentTitle: (name) => `${name}が新しい瞬間を投稿しました`,
    creatorMomentBody: "フォロー中のクリエイターに新しい投稿があります。",
    characterMomentTitle: (name) => `${name}が新しい瞬間を投稿しました`,
    characterMomentBody: "フォロー中のクリエイターのキャラクターに新しい投稿があります。",
    autoLikeTitle: "キャラクターがあなたの瞬間にいいねしました",
    autoLikeBody: (name) => `${name}があなたの瞬間を気に入りました。`,
    autoReplyTitle: "瞬間に新しい返信があります",
    autoReplyBody: (name, content, isReply) => isReply ? `${name}がコメントに返信しました：「${content}」` : `${name}が瞬間に返信しました：「${content}」`,
  },
  ko: {
    announcementTitle: "연연습광 새 공지",
    announcementBody: "새 공식 공지가 등록되었습니다. 눌러서 확인해 보세요.",
    creatorMomentTitle: (name) => `${name}님이 새 순간을 게시했어요`,
    creatorMomentBody: "팔로우 중인 크리에이터의 새 소식이 있어요.",
    characterMomentTitle: (name) => `${name}이(가) 새 순간을 게시했어요`,
    characterMomentBody: "팔로우 중인 크리에이터의 캐릭터가 새 글을 올렸어요.",
    autoLikeTitle: "캐릭터가 내 순간을 좋아했어요",
    autoLikeBody: (name) => `${name}이(가) 내 순간을 좋아했어요.`,
    autoReplyTitle: "순간에 새 답글이 있어요",
    autoReplyBody: (name, content, isReply) => isReply ? `${name}이(가) 댓글에 답했어요: “${content}”` : `${name}이(가) 순간에 답했어요: “${content}”`,
  },
  vi: {
    announcementTitle: "Thông báo mới từ Lianlian Shiguang",
    announcementBody: "Đã có thông báo chính thức mới. Nhấn để xem.",
    creatorMomentTitle: (name) => `${name} đã đăng Khoảnh khắc mới`,
    creatorMomentBody: "Một nhà sáng tạo bạn theo dõi vừa có cập nhật mới.",
    characterMomentTitle: (name) => `${name} đã đăng Khoảnh khắc mới`,
    characterMomentBody: "Một nhân vật của nhà sáng tạo bạn theo dõi vừa có cập nhật mới.",
    autoLikeTitle: "Một nhân vật đã thích Khoảnh khắc của bạn",
    autoLikeBody: (name) => `${name} đã thích Khoảnh khắc của bạn.`,
    autoReplyTitle: "Có phản hồi mới trên Khoảnh khắc",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} đã trả lời bình luận của bạn: “${content}”` : `${name} đã trả lời Khoảnh khắc của bạn: “${content}”`,
  },
  id: {
    announcementTitle: "Pengumuman baru dari Lianlian Shiguang",
    announcementBody: "Ada pengumuman resmi baru. Ketuk untuk melihat.",
    creatorMomentTitle: (name) => `${name} memposting Momen baru`,
    creatorMomentBody: "Kreator yang kamu ikuti punya pembaruan baru.",
    characterMomentTitle: (name) => `${name} memposting Momen baru`,
    characterMomentBody: "Karakter dari kreator yang kamu ikuti punya pembaruan baru.",
    autoLikeTitle: "Karakter menyukai Momenmu",
    autoLikeBody: (name) => `${name} menyukai Momenmu.`,
    autoReplyTitle: "Balasan baru di Momenmu",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} membalas komentarmu: “${content}”` : `${name} membalas Momenmu: “${content}”`,
  },
  th: {
    announcementTitle: "ประกาศใหม่จาก Lianlian Shiguang",
    announcementBody: "มีประกาศทางการใหม่ แตะเพื่อดูรายละเอียด",
    creatorMomentTitle: (name) => `${name} โพสต์โมเมนต์ใหม่`,
    creatorMomentBody: "ครีเอเตอร์ที่คุณติดตามมีอัปเดตใหม่",
    characterMomentTitle: (name) => `${name} โพสต์โมเมนต์ใหม่`,
    characterMomentBody: "ตัวละครจากครีเอเตอร์ที่คุณติดตามมีอัปเดตใหม่",
    autoLikeTitle: "ตัวละครกดถูกใจโมเมนต์ของคุณ",
    autoLikeBody: (name) => `${name} ถูกใจโมเมนต์ของคุณ`,
    autoReplyTitle: "มีการตอบกลับใหม่ในโมเมนต์",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} ตอบกลับความคิดเห็นของคุณ: “${content}”` : `${name} ตอบกลับโมเมนต์ของคุณ: “${content}”`,
  },
  ar: {
    announcementTitle: "إعلان جديد من Lianlian Shiguang",
    announcementBody: "تم نشر إعلان رسمي جديد. اضغط لعرضه.",
    creatorMomentTitle: (name) => `نشر ${name} لحظة جديدة`,
    creatorMomentBody: "هناك تحديث جديد من منشئ محتوى تتابعه.",
    characterMomentTitle: (name) => `نشر ${name} لحظة جديدة`,
    characterMomentBody: "هناك تحديث جديد لشخصية من منشئ محتوى تتابعه.",
    autoLikeTitle: "أعجبت شخصية بلحظتك",
    autoLikeBody: (name) => `أعجب ${name} بلحظتك.`,
    autoReplyTitle: "رد جديد على لحظتك",
    autoReplyBody: (name, content, isReply) => isReply ? `رد ${name} على تعليقك: «${content}»` : `رد ${name} على لحظتك: «${content}»`,
  },
  fr: {
    announcementTitle: "Nouvelle annonce de Lianlian Shiguang",
    announcementBody: "Une nouvelle annonce officielle est disponible. Touchez pour la voir.",
    creatorMomentTitle: (name) => `${name} a publié un nouveau Moment`,
    creatorMomentBody: "Un créateur que vous suivez a publié une nouveauté.",
    characterMomentTitle: (name) => `${name} a publié un nouveau Moment`,
    characterMomentBody: "Un personnage d’un créateur que vous suivez a publié une nouveauté.",
    autoLikeTitle: "Un personnage a aimé votre Moment",
    autoLikeBody: (name) => `${name} a aimé votre Moment.`,
    autoReplyTitle: "Nouvelle réponse sur votre Moment",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} a répondu à votre commentaire : « ${content} »` : `${name} a répondu à votre Moment : « ${content} »`,
  },
  ms: {
    announcementTitle: "Pengumuman baharu daripada Lianlian Shiguang",
    announcementBody: "Pengumuman rasmi baharu telah diterbitkan. Ketik untuk melihat.",
    creatorMomentTitle: (name) => `${name} menyiarkan Momen baharu`,
    creatorMomentBody: "Pencipta yang anda ikuti mempunyai kemas kini baharu.",
    characterMomentTitle: (name) => `${name} menyiarkan Momen baharu`,
    characterMomentBody: "Watak daripada pencipta yang anda ikuti mempunyai kemas kini baharu.",
    autoLikeTitle: "Watak menyukai Momen anda",
    autoLikeBody: (name) => `${name} menyukai Momen anda.`,
    autoReplyTitle: "Balasan baharu pada Momen anda",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} membalas komen anda: “${content}”` : `${name} membalas Momen anda: “${content}”`,
  },
  es: {
    announcementTitle: "Nuevo anuncio de Lianlian Shiguang",
    announcementBody: "Hay un nuevo anuncio oficial. Toca para verlo.",
    creatorMomentTitle: (name) => `${name} publicó un nuevo Momento`,
    creatorMomentBody: "Un creador que sigues tiene una nueva publicación.",
    characterMomentTitle: (name) => `${name} publicó un nuevo Momento`,
    characterMomentBody: "Un personaje de un creador que sigues tiene una nueva publicación.",
    autoLikeTitle: "Un personaje indicó que le gusta tu Momento",
    autoLikeBody: (name) => `A ${name} le gustó tu Momento.`,
    autoReplyTitle: "Nueva respuesta en tu Momento",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} respondió a tu comentario: “${content}”` : `${name} respondió a tu Momento: “${content}”`,
  },
  hi: {
    announcementTitle: "Lianlian Shiguang की नई घोषणा",
    announcementBody: "नई आधिकारिक घोषणा उपलब्ध है। देखने के लिए टैप करें।",
    creatorMomentTitle: (name) => `${name} ने नया मोमेंट पोस्ट किया`,
    creatorMomentBody: "जिस क्रिएटर को आप फ़ॉलो करते हैं, उसने नया अपडेट पोस्ट किया है।",
    characterMomentTitle: (name) => `${name} ने नया मोमेंट पोस्ट किया`,
    characterMomentBody: "आपके फ़ॉलो किए गए क्रिएटर के किरदार ने नया अपडेट पोस्ट किया है।",
    autoLikeTitle: "एक किरदार ने आपके मोमेंट को पसंद किया",
    autoLikeBody: (name) => `${name} ने आपके मोमेंट को पसंद किया।`,
    autoReplyTitle: "आपके मोमेंट पर नया जवाब",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} ने आपकी टिप्पणी का जवाब दिया: “${content}”` : `${name} ने आपके मोमेंट का जवाब दिया: “${content}”`,
  },
  pt: {
    announcementTitle: "Novo anúncio do Lianlian Shiguang",
    announcementBody: "Há um novo anúncio oficial. Toque para ver.",
    creatorMomentTitle: (name) => `${name} publicou um novo Momento`,
    creatorMomentBody: "Um criador que você segue tem uma nova publicação.",
    characterMomentTitle: (name) => `${name} publicou um novo Momento`,
    characterMomentBody: "Um personagem de um criador que você segue tem uma nova publicação.",
    autoLikeTitle: "Um personagem curtiu seu Momento",
    autoLikeBody: (name) => `${name} curtiu seu Momento.`,
    autoReplyTitle: "Nova resposta no seu Momento",
    autoReplyBody: (name, content, isReply) => isReply ? `${name} respondeu ao seu comentário: “${content}”` : `${name} respondeu ao seu Momento: “${content}”`,
  },
};

function normalizeNotificationLocale(value) {
  const raw = String(value || "").trim().replace(/-/g, "_");
  const lower = raw.toLowerCase();
  if (lower === "zh_cn" || lower === "zh_hans" || lower.startsWith("zh_hans")) return "zh_Hans";
  if (lower === "zh_tw" || lower === "zh_hant" || lower === "zh_hk" || lower === "zh_mo" || lower.startsWith("zh_hant")) return "zh_Hant";
  const code = lower.split("_")[0];
  return Object.prototype.hasOwnProperty.call(NOTIFICATION_TEXTS, code) ? code : "zh_Hant";
}

async function getUserNotificationLocale(userId) {
  try {
    const snap = await db.collection("users").doc(String(userId)).get();
    if (!snap.exists) return "zh_Hant";
    const data = snap.data() || {};
    return normalizeNotificationLocale(
      data.notificationLocale || data.locale || data.languageCode || data.language || "zh_Hant"
    );
  } catch (_) {
    return "zh_Hant";
  }
}

function getNotificationText(locale, type, args = {}) {
  const t = NOTIFICATION_TEXTS[normalizeNotificationLocale(locale)] || NOTIFICATION_TEXTS.zh_Hant;
  const name = String(args.name || "").trim() || "角色";
  const content = String(args.content || "").trim();
  switch (type) {
    case "announcement": return {title: t.announcementTitle, body: t.announcementBody};
    case "creator_moment": return {title: t.creatorMomentTitle(name), body: t.creatorMomentBody};
    case "character_moment": return {title: t.characterMomentTitle(name), body: t.characterMomentBody};
    case "character_auto_like": return {title: t.autoLikeTitle, body: t.autoLikeBody(name)};
    case "character_auto_reply": return {title: t.autoReplyTitle, body: t.autoReplyBody(name, content, args.isReply === true)};
    default: return {title: "戀戀拾光", body: ""};
  }
}



return {normalizeNotificationLocale, getUserNotificationLocale, getNotificationText};
};
