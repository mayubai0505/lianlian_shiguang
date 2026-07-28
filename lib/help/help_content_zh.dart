import 'package:flutter/material.dart';
import '../screens/help_models.dart';

const int helpGuideVersion = 1;

HelpGuideContent buildChineseHelpGuide() {
  return const HelpGuideContent(
    languageCode: 'zh',
    version: helpGuideVersion,
    pageTitle: '遊玩指南',
    welcomeTitle: '歡迎來到《戀戀拾光》',
    welcomeBody:
    '完善拾光檔案與「關於我們」的內容，可以讓角色更加了解你，聊天體驗也會更自然喔！',
    searchHint: '搜尋問題或功能',
    noResultsTitle: '找不到相關問題',
    noResultsBody:
    '可以換一個關鍵字搜尋，或透過「聯絡我們」詢問官方。',
    categories: [
      HelpCategory(
        id: 'getting_started',
        title: '開始遊玩',
        icon: Icons.local_florist_outlined,
        items: [
          HelpItem(
            question:
            '第一次進入遊戲後，建議先做什麼？',
            answer:
            '建議先完成個人檔案設定喔！設定完成後，角色在回覆時才會知道該如何稱呼你，也能更了解你的基本資訊，讓之後的互動更加自然。',
            keywords: [
              '第一次',
              '新手',
              '個人檔案',
              '稱呼',
            ],
          ),
          HelpItem(
            question:
            '要怎麼開始和角色聊天？',
            answer:
            '你可以前往「邂逅」中的每日邂逅，或到探索大廳尋找心儀的角色。進入角色主頁後，點選下方的「開始劇情」或「閒聊」，就可以開始聊天。公開角色可以自由選擇是否加入好友。',
            keywords: [
              '聊天',
              '每日邂逅',
              '探索大廳',
              '開始劇情',
              '閒聊',
            ],
          ),
          HelpItem(
            question:
            '聊天室左下角的雲朵按鈕有哪些功能？',
            answer:
            '點擊聊天室左下角的雲朵按鈕，可以開啟背包、劇情摘要、照片、錄音、拾光檔案與互動玩法等功能。',
            keywords: [
              '雲朵',
              '聊天室',
              '背包',
              '劇情摘要',
              '照片',
              '錄音',
            ],
          ),
          HelpItem(
            question:
            '什麼是「拾光檔案」？',
            answer:
            '拾光檔案就是《戀戀拾光》裡的個人檔案。你可以設定檔案名稱、姓名、身高、外貌、職業、個性與自我介紹。介紹得越詳細，角色就越能了解你，回覆也會更貼近你的設定。',
            keywords: [
              '拾光檔案',
              '姓名',
              '身高',
              '外貌',
              '職業',
              '個性',
              '自我介紹',
            ],
          ),
          HelpItem(
            question:
            '互動玩法目前有哪些？',
            answer:
            '目前互動玩法包含戳戳、送小禮物與發送定位。未來也會持續新增更多互動內容與遊戲玩法。',
            keywords: [
              '互動玩法',
              '戳戳',
              '禮物',
              '定位',
            ],
          ),
          HelpItem(
            question:
            '聊天室右上角的選單有哪些功能？',
            answer:
            '點擊聊天室右上角的三條線，可以使用搜尋對話、專屬回憶與背景、與我相關、關於我們、給他的備忘錄、生理期追蹤與重製記憶等功能。',
            keywords: [
              '三條線',
              '搜尋對話',
              '專屬回憶',
              '與我相關',
              '關於我們',
              '備忘錄',
              '生理期',
              '重製記憶',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'companion',
        title: '生活陪伴',
        icon: Icons.favorite_border_rounded,
        items: [
          HelpItem(
            question:
            '生理期追蹤要怎麼設定？',
            answer:
            '選擇生理期開始與結束的日期後，按下「儲存紀錄」。角色就會知道你的生理期日期，並可能在回覆中加入小小的提醒與關心。',
            keywords: [
              '生理期',
              '月經',
              '日期',
              '提醒',
            ],
          ),
          HelpItem(
            question:
            '「關於我們」的回憶要怎麼新增？',
            answer:
            '「關於我們」裡的回憶需要由玩家手動輸入。儲存後，角色會記得你們之間發生過的重要事情，讓後續互動更有延續感。',
            keywords: [
              '關於我們',
              '回憶',
              '記憶',
            ],
          ),
          HelpItem(
            question:
            '備忘錄怎麼使用？',
            answer:
            '你可以建立備忘事項並設定日期。到了指定日期，角色會提醒你當天的事情，App 也會透過系統通知提醒你。',
            keywords: [
              '備忘錄',
              '日期',
              '通知',
              '提醒',
            ],
          ),
          HelpItem(
            question:
            '備忘錄可以修改或刪除嗎？',
            answer:
            '可以。已建立的備忘錄可以隨時修改或刪除。',
            keywords: [
              '備忘錄',
              '修改',
              '刪除',
            ],
          ),
          HelpItem(
            question:
            'AI 會記得多久以前的內容？',
            answer:
            '不同聊天模式的記憶方式與範圍不完全相同。AI 會根據角色設定、目前模式、近期對話，以及你儲存的回憶與拾光檔案內容生成回覆。若有希望角色長期記得的重要事項，建議加入「關於我們」、專屬回憶或拾光檔案。',
            keywords: [
              '記憶',
              '忘記',
              '長期記憶',
              '聊天模式',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'moments',
        title: '瞬間（朋友圈）',
        icon: Icons.dynamic_feed_outlined,
        items: [
          HelpItem(
            question:
            '「瞬間」是公開朋友圈嗎？',
            answer:
            '是的。瞬間分為「探索」與「專屬」。添加其他玩家為好友後，對方角色的貼文除了會出現在探索，也會出現在專屬內容中。當角色的創作者發文時，你也有機會看到相關貼文。',
            keywords: [
              '瞬間',
              '朋友圈',
              '探索',
              '專屬',
              '好友',
            ],
          ),
          HelpItem(
            question:
            '玩家和角色都可以發文嗎？',
            answer:
            '可以。玩家可以自行發文，角色也可以發文。',
            keywords: [
              '發文',
              '角色發文',
              '玩家發文',
            ],
          ),
          HelpItem(
            question:
            '角色可以預約自動發文嗎？',
            answer:
            '可以。你可以設定每天固定的發文時間，系統會依角色後台設定的個性，自動生成符合角色風格的貼文。',
            keywords: [
              '預約發文',
              '自動發文',
              '發文時間',
            ],
          ),
          HelpItem(
            question:
            '角色自動發文會消耗花花嗎？',
            answer:
            '不會。角色的預約自動發文目前不會消耗任何花花。',
            keywords: [
              '自動發文',
              '花花',
              '點數',
            ],
          ),
          HelpItem(
            question:
            '貼文可以進行哪些互動？',
            answer:
            '貼文支援按讚、留言、分享與儲存。角色的創作者也可以使用該角色的身分回覆玩家，或到其他貼文下留言互動。',
            keywords: [
              '按讚',
              '留言',
              '分享',
              '儲存',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'ai_voice',
        title: 'AI 聊天與語音',
        icon: Icons.graphic_eq_rounded,
        items: [
          HelpItem(
            question:
            '為什麼 AI 每次回答可能不一樣？',
            answer:
            'AI 會根據角色人設、世界觀、前後對話、玩家設定與當下聊天內容即時生成回覆。因此，即使輸入相似的內容，也可能得到不同回答。這是生成式 AI 的特性，也讓每次互動保有變化與驚喜。',
            keywords: [
              'AI回答',
              '回答不同',
              '生成式AI',
            ],
          ),
          HelpItem(
            question:
            '角色為什麼可能顯示離線？',
            answer:
            '角色顯示離線可能是網路連線異常、AI 或雲端服務暫時異常、角色資料尚未完整載入，或角色內容正在重新檢查。可以先重新整理、確認網路，或稍後再試。若持續無法使用，請回報客服並附上角色名稱與畫面截圖。',
            keywords: [
              '離線',
              '無法聊天',
              '網路',
              '雲端',
            ],
          ),
          HelpItem(
            question:
            '聊天紀錄會跨裝置同步嗎？',
            answer:
            '會。只要使用相同帳號登入，聊天紀錄與相關資料就會同步到其他裝置。',
            keywords: [
              '聊天紀錄',
              '換手機',
              '同步',
            ],
          ),
          HelpItem(
            question:
            '可以刪除或重新開始對話嗎？',
            answer:
            '可以。玩家可以刪除對話、重新生成回覆，或使用重製對話與記憶功能。重製前請先確認是否有重要內容需要保留。',
            keywords: [
              '刪除對話',
              '重新生成',
              '重製記憶',
            ],
          ),
          HelpItem(
            question:
            '語音功能在哪裡使用？',
            answer:
            '目前語音功能主要在聊天室中使用。建立角色時，可以輸入希望的聲音描述，系統會協助尋找最符合角色設定的聲音。',
            keywords: [
              '語音',
              '聊天室',
              'Voice Bank',
              '建立角色',
            ],
          ),
          HelpItem(
            question:
            '第一次播放語音為什麼比較慢？',
            answer:
            '第一次播放時，系統需要先為角色生成並載入語音，因此可能需要等待幾秒鐘。生成完成後，再次播放通常會快很多；網路狀況也可能影響載入速度。',
            keywords: [
              '語音很慢',
              '第一次播放',
              '載入',
            ],
          ),
          HelpItem(
            question:
            '語音播放會消耗花花嗎？',
            answer:
            '建立角色時的語音試聽不會消耗花花；語音通話每次會扣除 20 點花花。',
            keywords: [
              '語音',
              '花花',
              '20點',
              '試聽',
            ],
          ),
          HelpItem(
            question:
            '玩家可以替角色更換聲音嗎？',
            answer:
            '可以。角色的創作者可以再次編輯角色並重新選擇合適的聲音。',
            keywords: [
              '更換聲音',
              '修改語音',
            ],
          ),
          HelpItem(
            question:
            '聲音不符合角色時，可以怎麼反映？',
            answer:
            '你可以前往角色主頁，在「時空迴音」留下對角色聲音的看法或建議。每個角色都是創作者投入心力製作的作品，請以尊重、友善的方式提供意見，不要惡意攻擊角色或創作者。',
            keywords: [
              '聲音不符合',
              '時空迴音',
              '建議',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'creator',
        title: '角色創作',
        icon: Icons.palette_outlined,
        items: [
          HelpItem(
            question:
            '要從哪裡建立角色？',
            answer:
            '前往個人主頁後，按下「創建角色」，即可開始建立自己的角色。',
            keywords: [
              '建立角色',
              '創建角色',
              '個人主頁',
            ],
          ),
          HelpItem(
            question:
            '一個帳號可以建立幾個角色？',
            answer:
            '目前沒有角色數量、公開數量或欄位數量限制，歡迎盡情發揮創意與想法。',
            keywords: [
              '角色上限',
              '數量限制',
              '無上限',
            ],
          ),
          HelpItem(
            question:
            '草稿、私人角色與公開角色有什麼不同？',
            answer:
            '草稿是尚未建立完成，或編輯到一半而暫時儲存的角色；私人角色只有創作者本人看得到，適合先測試對話是否符合預期；公開角色則會顯示在公開頁面，所有玩家都可以看見並互動。',
            keywords: [
              '草稿',
              '私人角色',
              '公開角色',
            ],
          ),
          HelpItem(
            question:
            '公開角色送出後會立即上架嗎？',
            answer:
            '會。目前公開角色完成發布後會立即上架，但仍須遵守使用條款與創作者規範。若收到檢舉或發現違規內容，平台可能進行檢查或下架處理。',
            keywords: [
              '立即上架',
              '公開角色',
              '發布',
            ],
          ),
          HelpItem(
            question:
            '公開後還可以編輯角色嗎？',
            answer:
            '可以。公開角色仍可再次編輯，編輯期間角色不會自動下架，並會維持顯示於公開頁面。',
            keywords: [
              '編輯角色',
              '公開後修改',
            ],
          ),
          HelpItem(
            question:
            '可以刪除自己的公開角色嗎？',
            answer:
            '可以，但只有該角色的創作者可以刪除自己建立的角色，其他玩家無法編輯或刪除。',
            keywords: [
              '刪除角色',
              '創作者',
              '親媽',
            ],
          ),
          HelpItem(
            question:
            '角色圖片最多可以上傳幾張？',
            answer:
            '每個角色最多可以上傳 10 張圖片。第一張圖片會作為角色的主要展示圖片，也是其他玩家對角色的第一印象照。',
            keywords: [
              '角色圖片',
              '10張',
              '第一張',
              '封面',
            ],
          ),
          HelpItem(
            question:
            '為什麼第二張以後的照片需要解鎖？',
            answer:
            '第二張以後的專屬照片會依角色設定的好感度逐步解鎖。隨著你和角色的互動增加，就能看到更多專屬照片。',
            keywords: [
              '照片解鎖',
              '好感度',
              '專屬照片',
            ],
          ),
          HelpItem(
            question:
            '標籤要怎麼新增？有數量限制嗎？',
            answer:
            '建立或編輯角色時，可以在角色設定中新增標籤。目前沒有標籤數量限制，但建議選擇真正符合角色個性與設定的標籤，方便其他玩家搜尋。',
            keywords: [
              '標籤',
              '數量限制',
              '搜尋',
            ],
          ),
          HelpItem(
            question:
            '為什麼角色可能無法公開或變成離線？',
            answer:
            '可能原因包括角色資料尚未填寫完整、網路或雲端服務暫時異常，或圖片與文字內容需要調整。請先確認欄位是否完整，並確保內容符合創作者規範；若仍無法使用，請聯絡客服。',
            keywords: [
              '無法公開',
              '離線',
              '欄位不完整',
            ],
          ),
          HelpItem(
            question:
            '可以建立同人或二創角色嗎？',
            answer:
            '可以，但請尊重原作品與權利人的規範，不得冒充官方授權，也不得使用侵害著作權、商標權、肖像權或其他權利的內容。發布前請先閱讀《創作者規範》。',
            keywords: [
              '同人',
              '二創',
              '版權',
              '創作者規範',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'discover',
        title: '搜尋與邂逅',
        icon: Icons.travel_explore_rounded,
        items: [
          HelpItem(
            question:
            '目前可以搜尋哪些內容？',
            answer:
            '目前可以透過角色名稱、創作者名稱與角色標籤等內容尋找角色。',
            keywords: [
              '搜尋',
              '角色名稱',
              '創作者',
              '標籤',
            ],
          ),
          HelpItem(
            question:
            '邂逅裡有哪些分類？',
            answer:
            '目前邂逅包含最新、熱門、標籤與人氣熱榜等分類。',
            keywords: [
              '邂逅',
              '最新',
              '熱門',
              '標籤',
              '人氣熱榜',
            ],
          ),
          HelpItem(
            question:
            '熱門角色是怎麼排序的？',
            answer:
            '熱門角色目前主要依角色的遊玩次數排序。',
            keywords: [
              '熱門',
              '遊玩次數',
              '排序',
            ],
          ),
          HelpItem(
            question:
            '什麼是「閃耀新星」？',
            answer:
            '新建立並公開的角色會出現在「閃耀新星．強檔推薦」區域，讓玩家更容易發現新作品。',
            keywords: [
              '閃耀新星',
              '新角色',
              '推薦',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'account',
        title: '帳號與外觀',
        icon: Icons.person_outline_rounded,
        items: [
          HelpItem(
            question:
            '要從哪裡更換主題顏色？',
            answer:
            '前往個人主頁右上角的設定，即可自訂主題顏色。套用後，App 多數頁面與聊天室介面都會跟著變更。',
            keywords: [
              '主題顏色',
              '設定',
              '聊天室顏色',
            ],
          ),
          HelpItem(
            question:
            '換手機後資料會同步嗎？',
            answer:
            '可以。只要在新裝置使用相同帳號登入，帳號內的資料就會進行同步。',
            keywords: [
              '換手機',
              '新裝置',
              '同步資料',
            ],
          ),
          HelpItem(
            question:
            '不同登入方式可以互通嗎？',
            answer:
            '目前 Apple、Google、Facebook 與 Email 等不同登入方式不會自動互通。請使用原本註冊或登入時使用的相同方式，以免進入不同帳號。',
            keywords: [
              'Apple登入',
              'Google登入',
              'Facebook登入',
              'Email登入',
            ],
          ),
          HelpItem(
            question:
            '可以修改暱稱、頭像與「與我相關」嗎？',
            answer:
            '暱稱與頭像可以修改；目前「與我相關」內容無法由玩家自行編輯。',
            keywords: [
              '暱稱',
              '頭像',
              '與我相關',
            ],
          ),
          HelpItem(
            question:
            '要怎麼刪除帳號？',
            answer:
            '進入個人主頁右上角的設定，往下滑即可找到「刪除帳號」。送出後會有 3 天緩衝期，在緩衝期間重新登入，就會取消帳號刪除。',
            keywords: [
              '刪除帳號',
              '三天',
              '緩衝期',
            ],
          ),
          HelpItem(
            question:
            '刪除帳號後，角色、聊天紀錄與花花會怎麼處理？',
            answer:
            '帳號刪除完成後，公開角色與聊天紀錄也會一併刪除。已購買的花花不會辦理退款，請在刪除帳號前再次確認。',
            keywords: [
              '刪除帳號',
              '公開角色',
              '聊天紀錄',
              '花花',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'points',
        title: '花花與付款',
        icon: Icons.local_florist_rounded,
        items: [
          HelpItem(
            question:
            '花花可以用在哪些功能？',
            answer:
            '花花目前可以使用在 AI 聊天、贈送禮物與語音通話等功能。',
            keywords: [
              '花花',
              '點數',
              '聊天',
              '送禮',
              '語音通話',
            ],
          ),
          HelpItem(
            question:
            '花花會過期嗎？',
            answer:
            '不會。帳號中的花花目前沒有使用期限。',
            keywords: [
              '花花過期',
              '點數期限',
            ],
          ),
          HelpItem(
            question:
            '購買後花花沒有入帳怎麼辦？',
            answer:
            '請前往個人主頁的設定，點選「聯絡我們」，提供購買時間、購買數量與相關畫面；也可以寄信至 lianlianshiguang@gmail.com。官方會盡量在 48 小時內回覆。',
            keywords: [
              '花花沒入帳',
              '購買失敗',
              '48小時',
            ],
          ),
          HelpItem(
            question:
            '花花或虛擬商品可以退款嗎？',
            answer:
            '退款會依購買平台與所在地法規處理。透過 Apple 購買者請依 Apple 的退款流程申請；透過 Google Play 購買者請依 Google Play 的退款規範辦理。',
            keywords: [
              '退款',
              'Apple退款',
              'Google退款',
            ],
          ),
        ],
      ),

      HelpCategory(
        id: 'support',
        title: '客服與回報',
        icon: Icons.support_agent_rounded,
        items: [
          HelpItem(
            question:
            '遇到 Bug 要怎麼回報？',
            answer:
            '請前往設定中的「聯絡我們」，並盡量附上錯誤畫面截圖、裝置型號、發生時間與角色名稱。官方通常會於工作日 3～5 天內回覆。',
            keywords: [
              'Bug',
              '錯誤',
              '回報',
              '截圖',
              '裝置',
            ],
          ),
          HelpItem(
            question:
            '想提出功能建議，可以從哪裡聯絡官方？',
            answer:
            '可以透過設定中的「聯絡我們」，或前往官方 Instagram、Threads 私訊提出建議。',
            keywords: [
              '功能建議',
              '意見',
              'Instagram',
              'Threads',
            ],
          ),
          HelpItem(
            question:
            '要怎麼檢舉違規角色？',
            answer:
            '進入角色卡片後，點擊右上角的選單，即可找到檢舉角色功能。',
            keywords: [
              '檢舉角色',
              '違規角色',
              '右上角',
            ],
          ),
          HelpItem(
            question:
            '官方客服信箱是什麼？',
            answer:
            '官方客服信箱：lianlianshiguang@gmail.com',
            keywords: [
              '客服',
              'Email',
              '信箱',
            ],
          ),
          HelpItem(
            question:
            '官方 Discord 與社群在哪裡？',
            answer:
            '你可以透過 App 內的官方社群入口加入 Discord，或追蹤官方 Instagram 與 Threads，取得最新公告、活動消息與開發進度。',
            keywords: [
              'Discord',
              '社群',
              'Instagram',
              'Threads',
            ],
          ),
        ],
      ),
    ],
  );
}