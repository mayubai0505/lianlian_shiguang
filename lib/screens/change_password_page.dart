import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isPasswordAccount {
    final user = FirebaseAuth.instance.currentUser;
    return user?.providerData.any((p) => p.providerId == 'password') == true;
  }

  String _friendlyError(FirebaseAuthException error) {
    switch (error.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return '目前密碼不正確，請再確認一次。';
      case 'weak-password':
        return '新密碼強度不足，請至少輸入 6 個字元。';
      case 'requires-recent-login':
        return '登入狀態已過期，請重新登入後再更改密碼。';
      case 'too-many-requests':
        return '嘗試次數過多，請稍後再試。';
      case 'network-request-failed':
        return '目前網路連線不穩定，請稍後再試。';
      default:
        return error.message ?? '更改密碼失敗，請稍後再試。';
    }
  }

  Future<void> _changePassword() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user == null || email == null || email.trim().isEmpty) {
      _showMessage('找不到目前登入帳號，請重新登入後再試。', isError: true);
      return;
    }

    if (!_isPasswordAccount) {
      _showMessage('此帳號不是使用 Email 密碼登入，無法在此變更密碼。', isError: true);
      return;
    }

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (currentPassword == newPassword) {
      _showMessage('新密碼不能與目前密碼相同。', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      if (!mounted) return;

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);
          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: Text(
              '密碼已更新',
              style: GoogleFonts.notoSerifTc(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              '新的密碼已經設定完成，下次登入請使用新密碼。',
              style: GoogleFonts.notoSerifTc(
                height: 1.6,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  '知道了',
                  style: GoogleFonts.notoSerifTc(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showMessage(_friendlyError(error), isError: true);
    } catch (_) {
      if (!mounted) return;
      _showMessage('更改密碼失敗，請稍後再試。', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            style: GoogleFonts.notoSerifTc(),
          ),
          backgroundColor:
          isError ? Colors.redAccent : theme.colorScheme.primary,
        ),
      );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required bool hidden,
    required VoidCallback onToggle,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.notoSerifTc(),
      filled: true,
      fillColor: theme.colorScheme.surface.withValues(alpha: 0.82),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          hidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 21,
          color: theme.colorScheme.primary.withValues(alpha: 0.72),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.72),
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          '更改密碼',
          style: GoogleFonts.notoSerifTc(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: onSurface,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 42),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '帳號安全',
                  style: GoogleFonts.notoSerifTc(
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '請先輸入目前密碼完成身分驗證，再設定新的登入密碼。',
                  style: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.58),
                    fontSize: 13,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _hideCurrent,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.notoSerifTc(),
                  decoration: _fieldDecoration(
                    label: '目前密碼',
                    hidden: _hideCurrent,
                    onToggle: () {
                      setState(() => _hideCurrent = !_hideCurrent);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入目前密碼';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _hideNew,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.notoSerifTc(),
                  decoration: _fieldDecoration(
                    label: '新密碼',
                    hidden: _hideNew,
                    onToggle: () {
                      setState(() => _hideNew = !_hideNew);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入新密碼';
                    }
                    if (value.length < 6) {
                      return '新密碼至少需要 6 個字元';
                    }
                    if (value == _currentPasswordController.text) {
                      return '新密碼不能與目前密碼相同';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirm,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _changePassword(),
                  style: GoogleFonts.notoSerifTc(),
                  decoration: _fieldDecoration(
                    label: '確認新密碼',
                    hidden: _hideConfirm,
                    onToggle: () {
                      setState(() => _hideConfirm = !_hideConfirm);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請再次輸入新密碼';
                    }
                    if (value != _newPasswordController.text) {
                      return '兩次輸入的新密碼不一致';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  '密碼至少 6 個字元。更改完成後，其他裝置下次重新登入時需使用新密碼。',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12,
                    height: 1.55,
                    color: onSurface.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _changePassword,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      '確認更改',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}