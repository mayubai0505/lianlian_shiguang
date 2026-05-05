import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
class UserProfilePopup {
  static void show(BuildContext context, {required VoidCallback onSaved}) {
    // ✨ 新增：檔案名稱控制器 (例如：用來命名為「總裁線專用」、「校園線專用」)
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

    // ✨ 多身分系統的狀態變數
    bool isEditingView = false; // 控制目前是在看「列表」還是「編輯中」
    List<Map<String, dynamic>> profiles = []; // 存放所有檔案
    String? activeProfileId; // 目前正在使用的檔案 ID
    String? editingProfileId; // 目前正在編輯的檔案 ID (如果是 null 代表正在新建)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final l10n = AppLocalizations.of(context)!;

        return StatefulBuilder(
            builder: (context, setModalState) {
              // ✨ 魔法對接：去資料庫抓多身分資料
              if (!hasFetched) {
                hasFetched = true;
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
                    final data = doc.data() ?? {};

                    if (data.containsKey('profiles')) {
                      // 🌟 新版：已經有多個檔案了
                      profiles = List<Map<String, dynamic>>.from(data['profiles']);
                      activeProfileId = data['activeProfileId'];
                    } else if (data.containsKey('profile')) {
                      // 🌟 過渡期防護：把玩家舊的「單一名片」無痛轉移成「第一份拾光檔案」
                      final oldProfile = data['profile'];
                      final defaultId = DateTime.now().millisecondsSinceEpoch.toString();
                      profiles = [{
                        'id': defaultId,
                        'profileName': '預設檔案',
                        'height': oldProfile['height'] ?? '',
                        'appearance': oldProfile['appearance'] ?? '',
                        'occupation': oldProfile['occupation'] ?? '',
                        'intro': oldProfile['intro'] ?? '',
                      }];
                      activeProfileId = defaultId;
                    }

                    // 如果沒資料，直接進入「編輯畫面」引導玩家建立第一個
                    if (profiles.isEmpty) {
                      isEditingView = true;
                    }

                    if (context.mounted) {
                      setModalState(() => isLoading = false);
                    }
                  }).catchError((e) {
                    print("讀取舊檔案失敗: $e");
                    if (context.mounted) setModalState(() => isLoading = false);
                  });
                } else {
                  isLoading = false;
                }
              }

              // 儲存邏輯 (更新 Firestore)
              Future<void> saveProfilesToFirestore() async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;
                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  'profiles': profiles,
                  'activeProfileId': activeProfileId,
                  'hasSkippedProfile': true, // 填過了就不再跳彈窗
                }, SetOptions(merge: true));
              }

              return Padding(
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
                              if (profiles.isNotEmpty) // 如果已經有其他檔案，允許返回列表
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => setModalState(() {
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
                          _buildTextField(controller: heightController, label: l10n.charHeightLabel, hint: '例如: 160cm', icon: Icons.height),
                          _buildTextField(controller: appearanceController, label: l10n.charAppearanceLabel, hint: '例如: 黑色長髮、喜歡穿洋裝', icon: Icons.face_retouching_natural),
                          _buildTextField(controller: occupationController, label: l10n.charJobLabel, hint: '例如: 自由畫家', icon: Icons.work_outline),
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
                                if (profileNameController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('請給這個檔案取個名字喔！')));
                                  return;
                                }

                                setModalState(() => isSaving = true);
                                try {
                                  final newProfile = {
                                    'id': editingProfileId ?? DateTime.now().millisecondsSinceEpoch.toString(), // 沒 ID 就產生一個新的
                                    'profileName': profileNameController.text.trim(),
                                    'name': nameController.text.trim(),
                                    'height': heightController.text.trim(),
                                    'appearance': appearanceController.text.trim(),
                                    'occupation': occupationController.text.trim(),
                                    'intro': personalityController.text.trim(),
                                    'updatedAt': FieldValue.serverTimestamp(), // ⚠️ 注意：List 裡不建議放 FieldValue，建議直接存 DateTime.now().toIso8601String()
                                  };

                                  // 修正：存入字串時間，避免 Firestore List 錯誤
                                  newProfile['updatedAt'] = DateTime.now().toIso8601String();

                                  if (editingProfileId != null) {
                                    // 更新現有
                                    final index = profiles.indexWhere((p) => p['id'] == editingProfileId);
                                    if (index != -1) profiles[index] = newProfile;
                                  } else {
                                    // 新增
                                    profiles.add(newProfile);
                                    // 如果是第一個建立的檔案，自動設為啟動
                                    activeProfileId ??= newProfile['id'] as String;
                                  }

                                  await saveProfilesToFirestore();

                                  if (context.mounted) {
                                    setModalState(() {
                                      isEditingView = false; // 儲存完切回列表
                                      isSaving = false;
                                    });
                                    onSaved(); // 通知外部更新
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('儲存失敗 ($e)')));
                                  setModalState(() => isSaving = false);
                                }
                              },
                              child: isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('儲存檔案'),
                            ),
                          )
                        ]
                        // ==========================================
                        // 📂 畫面 B：多身分列表畫面
                        // ==========================================
                        else ...[
                          Text('📜 專屬拾光檔案', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                          const SizedBox(height: 8),
                          Text('選擇你想用來和他互動的身分 (最多 10 個)', style: TextStyle(color: theme.hintColor, fontSize: 13)),
                          const SizedBox(height: 16),

                          // 身分列表
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: profiles.length,
                            itemBuilder: (context, index) {
                              final profile = profiles[index];
                              final isSelected = profile['id'] == activeProfileId;

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
                                    groupValue: activeProfileId,
                                    activeColor: colorScheme.primary,
                                    onChanged: (val) async {
                                      setModalState(() => activeProfileId = val);
                                      await saveProfilesToFirestore(); // 切換時自動儲存
                                      onSaved();
                                    },
                                  ),
                                  title: Text(profile['profileName'] ?? '未命名檔案', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(profile['occupation'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                    onPressed: () {
                                      // 把資料倒進編輯框
                                      editingProfileId = profile['id'];
                                      profileNameController.text = profile['profileName'] ?? '';
                                      nameController.text = profile['name'] ?? '';
                                      heightController.text = profile['height'] ?? '';
                                      appearanceController.text = profile['appearance'] ?? '';
                                      occupationController.text = profile['occupation'] ?? '';
                                      personalityController.text = profile['intro'] ?? '';
                                      setModalState(() => isEditingView = true); // 切換到編輯畫面
                                    },
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          // ➕ 建立新身分按鈕 (限制最多 10 個)
                          if (profiles.length < 10)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('建立新拾光檔案'),
                                onPressed: () {
                                  // 清空控制器準備建立新的
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
                              onPressed: () => Navigator.pop(context),
                              child: const Text('關閉', style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  // _buildTextField 保持不變
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