import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


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
    final l10n = AppLocalizations.of(context)!;
    switch (error.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.auth_error_wrong_password;
      case 'weak-password':
        return l10n.auth_error_weak_password;
      case 'requires-recent-login':
        return l10n.auth_error_requires_recent_login;
      case 'too-many-requests':
        return l10n.auth_error_too_many_requests;
      case 'network-request-failed':
        return l10n.auth_error_network_failed;
      default:
        return error.message ?? l10n.change_password_failed;
    }
  }

  Future<void> _changePassword() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user == null || email == null || email.trim().isEmpty) {
      _showMessage(l10n.change_password_account_not_found, isError: true);
      return;
    }

    if (!_isPasswordAccount) {
      _showMessage(l10n.change_password_not_password_account, isError: true);
      return;
    }

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (currentPassword == newPassword) {
      _showMessage(l10n.change_password_same_as_current, isError: true);
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
              l10n.change_password_success_title,
              style: GoogleFonts.notoSerifTc(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.change_password_success_message,
              style: GoogleFonts.notoSerifTc(
                height: 1.6,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  l10n.editProfileGotIt,
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
      _showMessage(l10n.change_password_failed, isError: true);
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          l10n.change_password_title,
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
                  l10n.change_password_security_title,
                  style: GoogleFonts.notoSerifTc(
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.change_password_description,
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
                    label: l10n.change_password_current_label,
                    hidden: _hideCurrent,
                    onToggle: () {
                      setState(() => _hideCurrent = !_hideCurrent);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.change_password_current_required;
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
                    label: l10n.change_password_new_label,
                    hidden: _hideNew,
                    onToggle: () {
                      setState(() => _hideNew = !_hideNew);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.change_password_new_required;
                    }
                    if (value.length < 6) {
                      return l10n.change_password_new_min_length;
                    }
                    if (value == _currentPasswordController.text) {
                      return l10n.change_password_same_as_current;
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
                    label: l10n.change_password_confirm_label,
                    hidden: _hideConfirm,
                    onToggle: () {
                      setState(() => _hideConfirm = !_hideConfirm);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.change_password_confirm_required;
                    }
                    if (value != _newPasswordController.text) {
                      return l10n.change_password_mismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.change_password_hint,
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
                        ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      l10n.about_us_edit_confirm,
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