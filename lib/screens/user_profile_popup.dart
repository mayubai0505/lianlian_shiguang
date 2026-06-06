import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';
class UserProfilePopup {
  // ✨ 總裁級升級：正式引入 roomId 與 characterId 雙鑰匙架構！
  static void show(
      BuildContext context, {
        required String roomId,        // 🔑 鑰匙 A：當前房間 ID（用來綁定獨立記憶體）
        required String characterId,   // 🔑 鑰匙 B：當前角色 ID（用來隔離專屬衣櫥）
        required VoidCallback onSaved, // 儲存成功後的回呼
      }) {
    // 檔案欄位控制器
    final profileNameController = TextEditingController();
    final nameController = TextEditingController();
    final heightController = TextEditingController();
    final appearanceController = TextEditingController();
    final occupationController = TextEditingController();
    final personalityController = TextEditingController();

    // 追蹤狀態
    bool isSaving = false;
    bool isLoading = true;
    bool hasFetched = false;

    // 多身分系統的狀態變數
    bool isEditingView = false; // 控制目前是在看「列表」還是「編輯中」
    List<Map<String, dynamic>> profiles = []; // 存放全宇宙所有的檔案
    String? currentRoomProfileId; // 當前房間綁定的檔案 ID
    String? editingProfileId; // 目前正在編輯的檔案 ID (為 null 代表新建)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        // 💡 請確保本地化資源呼叫名稱與你專案相符
        // final l10n = AppLocalizations.of(context)!;

        return StatefulBuilder(
            builder: (context, setModalState) {
              // ✨ 魔法對接：去資料庫撈取資料
              if (!hasFetched) {
                hasFetched = true;
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
                    final data = doc.data() ?? {};

                    // 1. 讀取共用衣服總匯
                    if (data.containsKey('profiles')) {
                      profiles = List<Map<String, dynamic>>.from(data['profiles']);
                    } else if (data.containsKey('profile')) {
                      // 過渡期舊名片無痛轉移
                      final oldProfile = data['profile'];
                      final defaultId = DateTime.now().millisecondsSinceEpoch.toString();
                      profiles = [{
                        'id': defaultId,
                        'characterId': characterId, // 舊資料自動歸給當前男主
                        'profileName': '預設檔案',
                        'name': data['nickname'] ?? '',
                        'height': oldProfile['height'] ?? '',
                        'appearance': oldProfile['appearance'] ?? '',
                        'occupation': oldProfile['occupation'] ?? '',
                        'intro': oldProfile['intro'] ?? '',
                      }];
                    }

                    // 2. 讀取「房間記憶體」：只抓當前這個房間套用了哪個身分
                    if (data.containsKey('roomProfiles')) {
                      final roomProfiles = data['roomProfiles'] as Map<String, dynamic>;
                      currentRoomProfileId = roomProfiles[roomId];
                    }

                    // 🌟 總裁級守門員先驗：即時過濾出只屬於「當前角色」的身分清單
                    final characterSpecificProfiles = profiles
                        .where((p) => p['characterId'] == characterId)
                        .toList();

                    // 如果這個角色連一個專屬身分都沒有，直接跳進編輯頁面引導建立第一個！
                    if (characterSpecificProfiles.isEmpty) {
                      isEditingView = true;
                    }

                    if (context.mounted) {
                      setModalState(() => isLoading = false);
                    }
                  }).catchError((e) {
                    debugPrint("讀取舊檔案失敗: $e");
                    if (context.mounted) setModalState(() => isLoading = false);
                  });
                } else {
                  isLoading = false;
                }
              }

              // ==========================================
              // 🛡️ 總裁級守門員：在每次 build 渲染前，重新過濾當前角色的專屬身分！
              // ==========================================
              final characterSpecificProfiles = profiles
                  .where((p) => p['characterId'] == characterId)
                  .toList();

              // ==========================================
              // 🛡️ 總裁級結界：PopScope 物理防禦
              // ==========================================
              return PopScope(
                // ✨ 核心魔法：當 isSaving 為 true 時，禁止系統退出 (canPop = false)
                canPop: !isSaving,
                onPopInvoked: (didPop) {
                  if (didPop) return; // 如果已經成功退出就不理會
                  // 當玩家試圖在存檔時強制退出，給予溫柔的提示
                  // ToastUtils.showCenterToast(
                  //   context,
                  //   '資料正在宇宙間傳輸，請稍候喔！',
                  //   customIcon: Icons.hourglass_top,
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('請稍候')),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
                    )
                        : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40, height: 4,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                            ),
                          ),

                          // ==========================================
                          // 🎭 畫面 A：編輯 / 新增檔案畫面
                          // ==========================================
                          if (isEditingView) ...[
                            Row(
                              children: [
                                // 只有當這個角色有其他檔案時，才允許按返回鍵回到列表
                                if (characterSpecificProfiles.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: isSaving ? null : () => setModalState(() {
                                      isEditingView = false;
                                    }),
                                  ),
                                Expanded(
                                  child: Text(
                                      editingProfileId == null ? '📜 建立新拾光檔案' : '✏️ 編輯拾光檔案',
                                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('建立不同的人設，在平行的時空裡讓他認識不一樣的妳！', style: TextStyle(color: theme.hintColor, fontSize: 13)),
                            const SizedBox(height: 24),

                            _buildTextField(
                              controller: profileNameController,
                              label: '檔案名稱 (僅自己可見)',
                              hint: '例如: 校園學妹設定、霸道女總裁',
                              icon: Icons.bookmark_border,
                            ),
                            _buildTextField(
                                controller: nameController,
                                label: '姓名 / 稱呼',
                                hint: '例如: 小櫻、李總',
                                icon: Icons.person_outline
                            ),
                            // 若有 l10n 請自行替換回 l10n.charHeightLabel 等
                            _buildTextField(controller: heightController, label: '身高', hint: '例如: 160cm', icon: Icons.height),
                            _buildTextField(controller: appearanceController, label: '外貌', hint: '例如: 黑色長髮、喜歡穿洋裝', icon: Icons.face_retouching_natural),
                            _buildTextField(controller: occupationController, label: '職業', hint: '例如: 自由畫家', icon: Icons.work_outline),
                            _buildTextField(controller: personalityController, label: '個性與自我介紹', hint: '例如：個性有點迷糊，喜歡吃甜食...', icon: Icons.assignment_ind_outlined, maxLines: 3),

                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: isSaving ? null : () async {
                                  // 1. 基本防呆
                                  if (profileNameController.text.trim().isEmpty) {
                                    // ToastUtils.showCenterToast(
                                    //   context,
                                    //   '請給這個檔案取個名字喔！',
                                    //   customIcon: Icons.edit_note_rounded,
                                    //   isError: true,
                                    // );
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('請給這個檔案取個名字喔！')));
                                    return;
                                  }

                                  // 2. 開始讀取狀態，觸發 PopScope 防護
                                  setModalState(() => isSaving = true);

                                  try {
                                    final newProfile = {
                                      'id': editingProfileId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                                      'characterId': characterId,
                                      'profileName': profileNameController.text.trim(),
                                      'name': nameController.text.trim(),
                                      'height': heightController.text.trim(),
                                      'appearance': appearanceController.text.trim(),
                                      'occupation': occupationController.text.trim(),
                                      'intro': personalityController.text.trim(),
                                      'updatedAt': DateTime.now().toIso8601String(),
                                    };

                                    String selectedProfileId = newProfile['id'] as String;

                                    // 3. 更新本地列表
                                    if (editingProfileId != null) {
                                      final index = profiles.indexWhere((p) => p['id'] == editingProfileId);
                                      if (index != -1) profiles[index] = newProfile;
                                    } else {
                                      profiles.add(newProfile);
                                    }

                                    // 4. Firebase 儲存 (關鍵：這裡可能會等待很久)
                                    final user = FirebaseAuth.instance.currentUser!;
                                    // 1. 取得使用者參考
                                    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

// 2. 執行資料合併儲存 (更新個人檔案列表)
                                    await userRef.set({
                                      'profiles': profiles,
                                      'hasSkippedProfile': true,
                                    }, SetOptions(merge: true));

// 3. 執行指標更新 (使用 update 來精準寫入房間對應，這是最不會出錯的寫法)
                                    await userRef.update({
                                      'roomProfiles.$roomId': selectedProfileId,
                                    });

                                    // 🌟 核心防護：執行 UI 更新前，檢查頁面是否還在
                                    if (!context.mounted) return;

                                    setModalState(() {
                                      isEditingView = false;
                                      isSaving = false;
                                    });

                                    onSaved(); // 觸發成功後的操作

                                  } catch (e) {
                                    // 🌟 核心防護：發生錯誤時，同樣檢查頁面是否還在
                                    if (!context.mounted) return;

                                    // ToastUtils.showCenterToast(context, '儲存失敗: $e', isError: true);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('儲存失敗: $e')));
                                    setModalState(() => isSaving = false);
                                  }
                                },
                                child: isSaving
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Text('儲存檔案'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: TextButton(
                                // 🔒 UI 防禦：存檔中禁用「稍後填寫」按鈕
                                onPressed: isSaving ? null : () {
                                  Navigator.pop(context); // 優雅轉身，觸發稍後填寫的虛擬原始名片邏輯
                                },
                                child: Text('稍後填寫', style: TextStyle(color: isSaving ? Colors.grey.shade300 : Colors.grey)),
                              ),
                            ),
                          ]

                          // ==========================================
                          // 📂 畫面 B：多身分列表畫面 (已注入角色專屬過濾防禦)
                          // ==========================================
                          else ...[
                            Text('📜 專屬拾光檔案', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                            const SizedBox(height: 8),
                            Text('選擇你想用來和他互動的身分 (同角色共用清單，最多 10 個)', style: TextStyle(color: theme.hintColor, fontSize: 13)),
                            const SizedBox(height: 16),

                            // 身分列表：全面換用經過「男主過濾」後的 characterSpecificProfiles 跑渲染！
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: characterSpecificProfiles.length,
                              itemBuilder: (context, index) {
                                final profile = characterSpecificProfiles[index];
                                // 💡 根據當前房間記憶體中的 ID 來判定是否勾選
                                final isSelected = profile['id'] == currentRoomProfileId;

                                return Card(
                                  elevation: isSelected ? 2 : 0,
                                  color: isSelected ? colorScheme.primaryContainer.withOpacity(0.3) : theme.cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: isSelected ? colorScheme.primary : Colors.grey.shade300),
                                  ),
                                  child: ListTile(
                                    leading: Radio<String>(
                                      value: profile['id'],
                                      groupValue: currentRoomProfileId,
                                      activeColor: colorScheme.primary,
                                      onChanged: isSaving ? null : (val) async {
                                        if (val == null) return;
                                        final user = FirebaseAuth.instance.currentUser;
                                        if (user == null) return; // 再補個防呆，確保使用者沒登出
                                        setModalState(() {
                                          currentRoomProfileId = val;
                                          isSaving = true;
                                        });

                                        try {
                                          final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

                                          // ✨ 總裁級精準更新：使用 update 搭配點表示法！
                                          // 這樣保證只會更新當前房間的指標，絕對不會動到其他房間，也不會動到外層的 profile 列表。
                                          try {
                                            await userDoc.update({
                                              'roomProfiles.$roomId': val,
                                            });
                                          } catch (_) {
                                            // 🛡️ 防呆：如果這個使用者是全新的，連 roomProfiles 字典都還沒有，
                                            // update 會報錯，這時我們才用 set 來幫他初始化第一筆字典資料。
                                            await userDoc.set({
                                              'roomProfiles': { roomId: val }
                                            }, SetOptions(merge: true));
                                          }

                                          if (context.mounted) {
                                            setModalState(() => isSaving = false);
                                            onSaved();
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            setModalState(() => isSaving = false);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('切換失敗: $e')));
                                          }
                                        }
                                      },
                                    ),
                                    title: Text(profile['profileName'] ?? '未命名檔案', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(profile['occupation'] ?? '尚未填寫職業', maxLines: 1, overflow: TextOverflow.ellipsis),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                      onPressed: isSaving ? null : () {
                                        // 倒填資料進入控制器準備編輯
                                        editingProfileId = profile['id'];
                                        profileNameController.text = profile['profileName'] ?? '';
                                        nameController.text = profile['name'] ?? '';
                                        heightController.text = profile['height'] ?? '';
                                        appearanceController.text = profile['appearance'] ?? '';
                                        occupationController.text = profile['occupation'] ?? '';
                                        personalityController.text = profile['intro'] ?? '';
                                        setModalState(() => isEditingView = true); // 切入編輯
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),
                            // ➕ 建立新身分按鈕：基於全域 profiles 長度判定上限
                            if (profiles.length < 10)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text('建立新拾光檔案'),
                                  onPressed: isSaving ? null : () {
                                    editingProfileId = null;
                                    profileNameController.clear();
                                    nameController.clear();
                                    heightController.clear();
                                    appearanceController.clear();
                                    occupationController.clear();
                                    personalityController.clear();
                                    setModalState(() => isEditingView = true);
                                  },
                                ),
                              ),

                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                // 🔒 UI 防禦：存檔中禁用「關閉」按鈕
                                onPressed: isSaving ? null : () => Navigator.pop(context),
                                child: Text('關閉', style: TextStyle(color: isSaving ? Colors.grey.shade300 : Colors.grey)),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  // 封裝輸入框，維持美觀不變
  static Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20),
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}