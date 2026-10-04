from pathlib import Path
import json

L10N_DIR = Path("lib/l10n")

translations = {
    "zh_Hant": {
        "chat_mode_resonance": "共鳴",
        "chat_mode_gemini_cost": "每日前 10 次免費，之後 1 點",
        "chat_mode_gemini_desc": "適合輕鬆聊天與日常陪伴。",
        "chat_mode_story_cost": "5 點",
        "chat_mode_immersive_cost": "7 點",
        "chat_mode_resonance_cost": "10 點",
        "chat_mode_resonance_desc": "更細膩地延伸情緒、關係張力與角色反應。",
        "chat_mode_gemini_cost_short": "1花",
        "chat_mode_story_cost_short": "5花",
        "chat_mode_immersive_cost_short": "7花",
        "chat_mode_resonance_cost_short": "10花",
    },

    "zh_Hans": {
        "chat_mode_resonance": "共鸣",
        "chat_mode_gemini_cost": "每天前 10 次免费，之后 1 点",
        "chat_mode_gemini_desc": "适合轻松聊天与日常陪伴。",
        "chat_mode_story_cost": "5 点",
        "chat_mode_immersive_cost": "7 点",
        "chat_mode_resonance_cost": "10 点",
        "chat_mode_resonance_desc": "更细腻地延伸情绪、关系张力与角色反应。",
        "chat_mode_gemini_cost_short": "1朵花",
        "chat_mode_story_cost_short": "5朵花",
        "chat_mode_immersive_cost_short": "7朵花",
        "chat_mode_resonance_cost_short": "10朵花",
    },

    "en": {
        "chat_mode_resonance": "Resonance",
        "chat_mode_gemini_cost": "First 10 per day free, then 1 point",
        "chat_mode_gemini_desc": "Best for casual chats and everyday companionship.",
        "chat_mode_story_cost": "5 points",
        "chat_mode_immersive_cost": "7 points",
        "chat_mode_resonance_cost": "10 points",
        "chat_mode_resonance_desc": "Extends emotions, relationship tension, and character reactions with greater nuance.",
        "chat_mode_gemini_cost_short": "1 Flower",
        "chat_mode_story_cost_short": "5 Flowers",
        "chat_mode_immersive_cost_short": "7 Flowers",
        "chat_mode_resonance_cost_short": "10 Flowers",
    },

    "ja": {
        "chat_mode_resonance": "共鳴",
        "chat_mode_gemini_cost": "1日最初の10回は無料、その後1ポイント",
        "chat_mode_gemini_desc": "気軽な会話や日常の寄り添いにおすすめ。",
        "chat_mode_story_cost": "5ポイント",
        "chat_mode_immersive_cost": "7ポイント",
        "chat_mode_resonance_cost": "10ポイント",
        "chat_mode_resonance_desc": "感情や関係性の緊張感、キャラクターの反応をより繊細に広げます。",
        "chat_mode_gemini_cost_short": "花1個",
        "chat_mode_story_cost_short": "花5個",
        "chat_mode_immersive_cost_short": "花7個",
        "chat_mode_resonance_cost_short": "花10個",
    },

    "ko": {
        "chat_mode_resonance": "공명",
        "chat_mode_gemini_cost": "하루 첫 10회 무료, 이후 1포인트",
        "chat_mode_gemini_desc": "가벼운 대화와 일상적인 동행에 적합해요.",
        "chat_mode_story_cost": "5포인트",
        "chat_mode_immersive_cost": "7포인트",
        "chat_mode_resonance_cost": "10포인트",
        "chat_mode_resonance_desc": "감정, 관계의 긴장감, 캐릭터 반응을 더 섬세하게 확장해요.",
        "chat_mode_gemini_cost_short": "꽃 1개",
        "chat_mode_story_cost_short": "꽃 5개",
        "chat_mode_immersive_cost_short": "꽃 7개",
        "chat_mode_resonance_cost_short": "꽃 10개",
    },

    "vi": {
        "chat_mode_resonance": "Cộng hưởng",
        "chat_mode_gemini_cost": "10 lượt đầu mỗi ngày miễn phí, sau đó 1 điểm",
        "chat_mode_gemini_desc": "Phù hợp cho trò chuyện nhẹ nhàng và đồng hành hằng ngày.",
        "chat_mode_story_cost": "5 điểm",
        "chat_mode_immersive_cost": "7 điểm",
        "chat_mode_resonance_cost": "10 điểm",
        "chat_mode_resonance_desc": "Mở rộng cảm xúc, căng thẳng trong mối quan hệ và phản ứng nhân vật tinh tế hơn.",
        "chat_mode_gemini_cost_short": "1 Hoa",
        "chat_mode_story_cost_short": "5 Hoa",
        "chat_mode_immersive_cost_short": "7 Hoa",
        "chat_mode_resonance_cost_short": "10 Hoa",
    },

    "id": {
        "chat_mode_resonance": "Resonansi",
        "chat_mode_gemini_cost": "10 kali pertama per hari gratis, lalu 1 poin",
        "chat_mode_gemini_desc": "Cocok untuk obrolan santai dan pendampingan sehari-hari.",
        "chat_mode_story_cost": "5 poin",
        "chat_mode_immersive_cost": "7 poin",
        "chat_mode_resonance_cost": "10 poin",
        "chat_mode_resonance_desc": "Mengembangkan emosi, ketegangan hubungan, dan reaksi karakter dengan lebih halus.",
        "chat_mode_gemini_cost_short": "1 Bunga",
        "chat_mode_story_cost_short": "5 Bunga",
        "chat_mode_immersive_cost_short": "7 Bunga",
        "chat_mode_resonance_cost_short": "10 Bunga",
    },

    "th": {
        "chat_mode_resonance": "การสั่นพ้อง",
        "chat_mode_gemini_cost": "10 ครั้งแรกต่อวันฟรี จากนั้น 1 แต้ม",
        "chat_mode_gemini_desc": "เหมาะสำหรับคุยสบาย ๆ และการอยู่เป็นเพื่อนในชีวิตประจำวัน",
        "chat_mode_story_cost": "5 แต้ม",
        "chat_mode_immersive_cost": "7 แต้ม",
        "chat_mode_resonance_cost": "10 แต้ม",
        "chat_mode_resonance_desc": "ขยายอารมณ์ ความตึงเครียดของความสัมพันธ์ และปฏิกิริยาของตัวละครได้ละเอียดขึ้น",
        "chat_mode_gemini_cost_short": "1 ดอก",
        "chat_mode_story_cost_short": "5 ดอก",
        "chat_mode_immersive_cost_short": "7 ดอก",
        "chat_mode_resonance_cost_short": "10 ดอก",
    },

    "fr": {
        "chat_mode_resonance": "Résonance",
        "chat_mode_gemini_cost": "Les 10 premières fois par jour sont gratuites, puis 1 point",
        "chat_mode_gemini_desc": "Idéal pour des échanges légers et une présence au quotidien.",
        "chat_mode_story_cost": "5 points",
        "chat_mode_immersive_cost": "7 points",
        "chat_mode_resonance_cost": "10 points",
        "chat_mode_resonance_desc": "Développe plus finement les émotions, la tension relationnelle et les réactions du personnage.",
        "chat_mode_gemini_cost_short": "1 fleur",
        "chat_mode_story_cost_short": "5 fleurs",
        "chat_mode_immersive_cost_short": "7 fleurs",
        "chat_mode_resonance_cost_short": "10 fleurs",
    },

    "es": {
        "chat_mode_resonance": "Resonancia",
        "chat_mode_gemini_cost": "Las primeras 10 veces al día son gratis, luego 1 punto",
        "chat_mode_gemini_desc": "Ideal para conversaciones relajadas y compañía diaria.",
        "chat_mode_story_cost": "5 puntos",
        "chat_mode_immersive_cost": "7 puntos",
        "chat_mode_resonance_cost": "10 puntos",
        "chat_mode_resonance_desc": "Desarrolla con más matices las emociones, la tensión de la relación y las reacciones del personaje.",
        "chat_mode_gemini_cost_short": "1 flor",
        "chat_mode_story_cost_short": "5 flores",
        "chat_mode_immersive_cost_short": "7 flores",
        "chat_mode_resonance_cost_short": "10 flores",
    },

    "pt": {
        "chat_mode_resonance": "Ressonância",
        "chat_mode_gemini_cost": "As primeiras 10 vezes por dia são grátis, depois 1 ponto",
        "chat_mode_gemini_desc": "Ideal para conversas leves e companhia no dia a dia.",
        "chat_mode_story_cost": "5 pontos",
        "chat_mode_immersive_cost": "7 pontos",
        "chat_mode_resonance_cost": "10 pontos",
        "chat_mode_resonance_desc": "Aprofunda com mais nuance as emoções, a tensão do relacionamento e as reações do personagem.",
        "chat_mode_gemini_cost_short": "1 flor",
        "chat_mode_story_cost_short": "5 flores",
        "chat_mode_immersive_cost_short": "7 flores",
        "chat_mode_resonance_cost_short": "10 flores",
    },

    "ms": {
        "chat_mode_resonance": "Resonans",
        "chat_mode_gemini_cost": "10 kali pertama setiap hari percuma, kemudian 1 mata",
        "chat_mode_gemini_desc": "Sesuai untuk sembang santai dan teman harian.",
        "chat_mode_story_cost": "5 mata",
        "chat_mode_immersive_cost": "7 mata",
        "chat_mode_resonance_cost": "10 mata",
        "chat_mode_resonance_desc": "Mengembangkan emosi, ketegangan hubungan dan reaksi watak dengan lebih halus.",
        "chat_mode_gemini_cost_short": "1 Bunga",
        "chat_mode_story_cost_short": "5 Bunga",
        "chat_mode_immersive_cost_short": "7 Bunga",
        "chat_mode_resonance_cost_short": "10 Bunga",
    },

    "hi": {
        "chat_mode_resonance": "अनुनाद",
        "chat_mode_gemini_cost": "हर दिन पहली 10 बार मुफ्त, उसके बाद 1 अंक",
        "chat_mode_gemini_desc": "हल्की-फुल्की बातचीत और रोज़मर्रा के साथ के लिए उपयुक्त।",
        "chat_mode_story_cost": "5 अंक",
        "chat_mode_immersive_cost": "7 अंक",
        "chat_mode_resonance_cost": "10 अंक",
        "chat_mode_resonance_desc": "भावनाओं, रिश्ते के तनाव और किरदार की प्रतिक्रियाओं को अधिक बारीकी से आगे बढ़ाता है।",
        "chat_mode_gemini_cost_short": "1 फूल",
        "chat_mode_story_cost_short": "5 फूल",
        "chat_mode_immersive_cost_short": "7 फूल",
        "chat_mode_resonance_cost_short": "10 फूल",
    },

    "ar": {
        "chat_mode_resonance": "التناغم",
        "chat_mode_gemini_cost": "أول 10 مرات يوميًا مجانًا، ثم نقطة واحدة",
        "chat_mode_gemini_desc": "مناسب للدردشة الخفيفة والرفقة اليومية.",
        "chat_mode_story_cost": "5 نقاط",
        "chat_mode_immersive_cost": "7 نقاط",
        "chat_mode_resonance_cost": "10 نقاط",
        "chat_mode_resonance_desc": "يوسّع المشاعر وتوتر العلاقة وردود فعل الشخصية بدقة أكبر.",
        "chat_mode_gemini_cost_short": "زهرة 1",
        "chat_mode_story_cost_short": "5 زهور",
        "chat_mode_immersive_cost_short": "7 زهور",
        "chat_mode_resonance_cost_short": "10 زهور",
    },
}

def locale_for(path, data):
    locale = str(data.get("@@locale", "")).replace("-", "_")

    if not locale and path.stem.startswith("app_"):
        locale = path.stem[4:].replace("-", "_")

    low = locale.lower()

    if low in {"zh_tw", "zh_hk", "zh_mo", "zh_hant", "zh"}:
        return "zh_Hant"

    if low in {"zh_cn", "zh_sg", "zh_hans"}:
        return "zh_Hans"

    if path.name in {"app.arb", "app_zh.arb"}:
        return "zh_Hant"

    return locale.split("_")[0].lower()


for path in sorted(L10N_DIR.glob("*.arb")):
    data = json.loads(path.read_text(encoding="utf-8"))
    locale = locale_for(path, data)

    values = translations.get(locale)

    if values is None:
        print(f"SKIP: {path.name} ({locale})")
        continue

    data.update(values)

    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    json.loads(path.read_text(encoding="utf-8"))

    print(f"OK: {path.name} -> {locale}")

print("\nDONE")