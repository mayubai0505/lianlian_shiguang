import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';
//拾光檔案
class UserProfilePopup {
  /// 保留原本呼叫介面，chat_page.dart 不需要改呼叫方式。
  /// 但實際呈現已從 BottomSheet 改成獨立頁面。
  static Future<void> show(
      BuildContext context, {
        required String roomId,
        required String characterId,
        required VoidCallback onSaved,
      }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _UserProfilePage(
          roomId: roomId,
          characterId: characterId,
          onSaved: onSaved,
        ),
      ),
    );
  }
}

class _UserProfilePage extends StatefulWidget {
  const _UserProfilePage({
    required this.roomId,
    required this.characterId,
    required this.onSaved,
  });

  final String roomId;

  /// 暫時保留參數，避免既有 chat_page 呼叫介面改動。
  /// 身分清單現在已不再依 characterId 過濾。
  final String characterId;
  final VoidCallback onSaved;

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<_UserProfilePage> {
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _appearanceController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;
  bool _isEditingView = false;

  List<Map<String, dynamic>> _profiles = [];
  String? _currentRoomProfileId;
  String? _editingProfileId;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _nameController.dispose();
    _heightController.dispose();
    _appearanceController.dispose();
    _occupationController.dispose();
    _personalityController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data() ?? <String, dynamic>{};

      List<Map<String, dynamic>> loadedProfiles = [];

      bool needsProfileMigration = false;

      if (data.containsKey('profiles')) {
        loadedProfiles = List<Map<String, dynamic>>.from(data['profiles'])
            .map((profile) {
          final normalized = Map<String, dynamic>.from(profile);

          // 舊版是以 characterId 區隔角色專屬身分。
          // 新版改為全帳號共用，因此移除舊的角色歸屬欄位。
          if (normalized.containsKey('characterId')) {
            normalized.remove('characterId');
            needsProfileMigration = true;
          }

          return normalized;
        }).toList();
      } else if (data.containsKey('profile')) {
        // 舊版單一名片相容：轉入全帳號共用 profiles。
        final oldProfile = Map<String, dynamic>.from(data['profile'] ?? {});
        final defaultId = DateTime.now().millisecondsSinceEpoch.toString();
        loadedProfiles = [
          {
            'id': defaultId,
            'profileName': '預設檔案',
            'name': data['nickname'] ?? '',
            'height': oldProfile['height'] ?? '',
            'appearance': oldProfile['appearance'] ?? '',
            'occupation': oldProfile['occupation'] ?? '',
            'intro': oldProfile['intro'] ?? '',
          },
        ];
        needsProfileMigration = true;
      }

      // 安全遷移：
      // 1. 不刪除任何既有身分，避免舊玩家資料遺失。
      // 2. 若舊版累積超過 10 份，全部先保留，但禁止再建立新檔案。
      // 3. 之後任何新增/編輯儲存，都只使用全帳號共用 schema。
      if (needsProfileMigration) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'profiles': loadedProfiles,
          'profileSchemaVersion': 2,
        }, SetOptions(merge: true));
      }

      String? selectedId;
      if (data.containsKey('roomProfiles')) {
        final roomProfiles = Map<String, dynamic>.from(data['roomProfiles']);
        selectedId = roomProfiles[widget.roomId]?.toString();
      }

      if (!mounted) return;
      setState(() {
        _profiles = loadedProfiles;
        _currentRoomProfileId = selectedId;
        _isLoading = false;
        // 全帳號完全沒有檔案時，直接引導建立第一份。
        _isEditingView = loadedProfiles.isEmpty;
      });
    } catch (e) {
      debugPrint('讀取拾光檔案失敗: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startCreate() {
    _editingProfileId = null;
    _profileNameController.clear();
    _nameController.clear();
    _heightController.clear();
    _appearanceController.clear();
    _occupationController.clear();
    _personalityController.clear();
    setState(() => _isEditingView = true);
  }

  void _startEdit(Map<String, dynamic> profile) {
    _editingProfileId = profile['id']?.toString();
    _profileNameController.text = profile['profileName'] ?? '';
    _nameController.text = profile['name'] ?? '';
    _heightController.text = profile['height'] ?? '';
    _appearanceController.text = profile['appearance'] ?? '';
    _occupationController.text = profile['occupation'] ?? '';
    _personalityController.text = profile['intro'] ?? '';
    setState(() => _isEditingView = true);
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;

    if (_profileNameController.text.trim().isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.profileNameEmptyWarning,
        isError: true,
      );
      return;
    }

    if (_editingProfileId == null && _profiles.length >= 10) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final newProfile = <String, dynamic>{
        'id': _editingProfileId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        // 不再寫入 characterId：拾光檔案改為所有角色共用。
        'profileName': _profileNameController.text.trim(),
        'name': _nameController.text.trim(),
        'height': _heightController.text.trim(),
        'appearance': _appearanceController.text.trim(),
        'occupation': _occupationController.text.trim(),
        'intro': _personalityController.text.trim(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final selectedProfileId = newProfile['id'] as String;
      final updatedProfiles = _profiles
          .map((p) => Map<String, dynamic>.from(p))
          .toList();

      if (_editingProfileId != null) {
        final index = updatedProfiles
            .indexWhere((p) => p['id']?.toString() == _editingProfileId);
        if (index != -1) {
          updatedProfiles[index] = newProfile;
        }
      } else {
        updatedProfiles.add(newProfile);
      }

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      await userRef.set({
        'profiles': updatedProfiles,
        'profileSchemaVersion': 2,
        'hasHandledProfileIntro': true,
        'hasSkippedProfile': true,
      }, SetOptions(merge: true));

      // 儲存/建立後，沿用原本行為：當前聊天室直接套用這份身分。
      try {
        await userRef.update({
          'roomProfiles.${widget.roomId}': selectedProfileId,
        });
      } catch (_) {
        await userRef.set({
          'roomProfiles': {widget.roomId: selectedProfileId},
        }, SetOptions(merge: true));
      }

      if (!mounted) return;
      setState(() {
        _profiles = updatedProfiles;
        _currentRoomProfileId = selectedProfileId;
        _editingProfileId = null;
        _isEditingView = false; // 儲存後回到拾光檔案列表頁
        _isSaving = false;
      });

      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ToastUtils.showCenterToast(
        context,
        l10n.profileSaveError(e.toString()),
        isError: true,
      );
    }
  }

  Future<void> _selectProfile(String profileId) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isSaving) return;

    // 再次點擊目前已選中的檔案 = 取消套用個人檔案
    final bool isDeselecting = _currentRoomProfileId == profileId;
    final String? previousProfileId = _currentRoomProfileId;

    setState(() {
      _currentRoomProfileId = isDeselecting ? null : profileId;
      _isSaving = true;
    });

    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      if (isDeselecting) {
        // 取消時移除目前聊天室的 profile 綁定，
        // 不刪除 profile 本身，之後仍可再次選取。
        await userDoc.update({
          'roomProfiles.${widget.roomId}': FieldValue.delete(),
        });
      } else {
        try {
          await userDoc.update({
            'roomProfiles.${widget.roomId}': profileId,
          });
        } catch (_) {
          await userDoc.set({
            'roomProfiles': {widget.roomId: profileId},
          }, SetOptions(merge: true));
        }
      }

      if (!mounted) return;
      setState(() => _isSaving = false);
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;

      // 儲存失敗就還原畫面上的原始選取狀態
      setState(() {
        _currentRoomProfileId = previousProfileId;
        _isSaving = false;
      });

      ToastUtils.showCenterToast(
        context,
        l10n.profileSwitchError(e.toString()),
        isError: true,
      );
    }
  }

  Future<void> _fillLater() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'hasHandledProfileIntro': true,
          'hasSkippedProfile': true,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('❌ 記錄拾光檔案稍後填寫失敗：$e');
      }
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_isSaving,
      onPopInvoked: (didPop) {
        if (didPop) return;
        ToastUtils.showCenterToast(
          context,
          l10n.pleaseWait,
          isError: false,
        );
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            _isEditingView
                ? (_editingProfileId == null
                ? l10n.createNewProfileTitle
                : l10n.editProfileTitle)
                : l10n.exclusiveProfileTitle,
            style: GoogleFonts.notoSerifTc(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _isSaving
                ? null
                : () {
              if (_isEditingView && _profiles.isNotEmpty) {
                setState(() {
                  _editingProfileId = null;
                  _isEditingView = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -16,
              right: -26,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.10,
                  child: Image.asset(
                    'assets/images/contact/contact_top_right_botanical.png',
                    width: 190,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primary.withValues(alpha: 0.7),
                ),
              )
            else if (_isEditingView)
              _buildEditPage(context)
            else
              _buildListPage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildListPage(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 48),
      children: [
        Text(
          l10n.profileSelectionDescription,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerifTc(
            fontSize: 14,
            height: 1.7,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
          ),
        ),
        const SizedBox(height: 24),
        ..._profiles.map((profile) {
          final profileId = profile['id']?.toString() ?? '';
          final isSelected = profileId == _currentRoomProfileId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProfileCard(
              context: context,
              profile: profile,
              isSelected: isSelected,
              onTap: () => _selectProfile(profileId),
              onEdit: () => _startEdit(profile),
            ),
          );
        }),
        if (_profiles.length < 10) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: _isSaving ? null : _startCreate,
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                backgroundColor: primary.withValues(alpha: 0.025),
                side: BorderSide(
                  color: primary.withValues(alpha: 0.30),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                '＋  ${l10n.createNewProfileButton}',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Center(
          child: Text(
            '${_profiles.length} / 10',
            style: GoogleFonts.notoSerifTc(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard({
    required BuildContext context,
    required Map<String, dynamic> profile,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onEdit,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    final name = (profile['name'] ?? '').toString().trim();
    final occupation = (profile['occupation'] ?? '').toString().trim();
    final intro = (profile['intro'] ?? '').toString().trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _isSaving ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withValues(alpha: 0.055)
                : theme.colorScheme.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? primary.withValues(alpha: 0.42)
                  : primary.withValues(alpha: 0.10),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: isSelected ? 0.055 : 0.025),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.24),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: theme.colorScheme.onPrimary,
                )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile['profileName'] ?? l10n.unnamedProfile,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.90),
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.09),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (name.isNotEmpty || occupation.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        [name, occupation]
                            .where((e) => e.isNotEmpty)
                            .join('  ·  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.60),
                        ),
                      ),
                    ],
                    if (intro.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        intro,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13,
                          height: 1.55,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.48),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.edit_btn,
                onPressed: _isSaving ? null : onEdit,
                icon: Icon(
                  Icons.edit_outlined,
                  size: 21,
                  color: primary.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditPage(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        18,
        24,
        MediaQuery.of(context).viewInsets.bottom + 42,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileEditDescription,
            style: GoogleFonts.notoSerifTc(
              fontSize: 14,
              height: 1.7,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
            ),
          ),
          const SizedBox(height: 26),
          _buildFieldLabel(context, l10n.profileNameLabel),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _profileNameController,
            hint: l10n.profileNameHint,
          ),
          const SizedBox(height: 28),
          _buildSectionTitle(context, '基本資料'),
          const SizedBox(height: 20),
          _buildFieldLabel(context, l10n.profileNicknameLabel),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _nameController,
            hint: l10n.profileNicknameHint,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(context, l10n.profileHeightLabel),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _heightController,
            hint: l10n.profileHeightHint,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(context, l10n.profileAppearanceLabel),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _appearanceController,
            hint: l10n.profileAppearanceHint,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(context, l10n.profileOccupationLabel),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _occupationController,
            hint: l10n.profileOccupationHint,
          ),
          const SizedBox(height: 30),
          _buildSectionTitle(context, '關於這個我'),
          const SizedBox(height: 20),
          _buildFieldLabel(context, l10n.profileIntroLabel),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _personalityController,
            hint: l10n.profileIntroHint,
            maxLines: 5,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _isSaving ? null : _saveProfile,
              style: FilledButton.styleFrom(
                backgroundColor: primary.withValues(alpha: 0.12),
                foregroundColor: primary,
                disabledBackgroundColor: primary.withValues(alpha: 0.06),
                disabledForegroundColor: primary.withValues(alpha: 0.35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: primary.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
              ),
              child: _isSaving
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primary,
                ),
              )
                  : Text(
                l10n.saveProfileButton,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_profiles.isEmpty) ...[
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: _isSaving ? null : _fillLater,
                child: Text(
                  l10n.fillLaterButton,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        '—— $title ——',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSerifTc(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: GoogleFonts.notoSerifTc(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.74),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.notoSerifTc(
        fontSize: 15,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.86),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.notoSerifTc(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.32),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface.withValues(alpha: 0.82),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 15 : 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: primary.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: primary.withValues(alpha: 0.52),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
