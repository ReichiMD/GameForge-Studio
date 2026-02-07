import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoginScreen extends StatefulWidget {
  final Function(String username, String githubToken) onLogin;

  const LoginScreen({
    super.key,
    required this.onLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _githubTokenController = TextEditingController();
  bool _showToken = false;
  String _error = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _githubTokenController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final githubToken = _githubTokenController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _error = 'Bitte gib deinen Namen ein';
      });
      return;
    }

    if (githubToken.isEmpty) {
      setState(() {
        _error = 'Bitte gib dein GitHub Token ein';
      });
      return;
    }

    setState(() {
      _error = '';
    });

    widget.onLogin(username, githubToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxxl),

              // Brand Section
              _buildBrandSection(),

              const SizedBox(height: AppSpacing.xxxl),

              // Login Form
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      children: [
        const Text(
          '⚒️',
          style: TextStyle(fontSize: 72),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'GameForge',
          style: TextStyle(
            fontSize: AppTypography.xxxl,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const Text(
          'Studio',
          style: TextStyle(
            fontSize: AppTypography.xl,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Deine Minecraft Werkstatt',
          style: TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    final bool isValid = _usernameController.text.trim().isNotEmpty &&
        _githubTokenController.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username Input
        _buildInputGroup(
          label: '👤 Benutzername',
          controller: _usernameController,
          placeholder: 'z.B. ReichiMD',
          onChanged: (value) {
            setState(() {
              _error = '';
            });
          },
        ),

        const SizedBox(height: AppSpacing.lg),

        // GitHub Token Input
        _buildTokenInputGroup(),

        const SizedBox(height: AppSpacing.lg),

        // Error Message
        if (_error.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              border: Border.all(color: AppColors.error),
            ),
            child: Text(
              '⚠️ $_error',
              style: const TextStyle(
                fontSize: AppTypography.sm,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Login Button
        const SizedBox(height: AppSpacing.md),
        _buildLoginButton(isValid),
      ],
    );
  }

  Widget _buildInputGroup({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool obscureText = false,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.lg),
          ),
        ),
      ],
    );
  }

  Widget _buildTokenInputGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🔑 GitHub Token',
              style: TextStyle(
                fontSize: AppTypography.md,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showToken = !_showToken;
                });
              },
              child: Text(
                _showToken ? '🙈 Verbergen' : '👁️ Zeigen',
                style: const TextStyle(
                  fontSize: AppTypography.sm,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _githubTokenController,
          obscureText: !_showToken,
          onChanged: (value) {
            setState(() {
              _error = '';
            });
          },
          style: const TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: 'ghp_xxxxxxxxxxxx',
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.lg),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Damit bekommst du Zugriff auf deine Repositories',
          style: TextStyle(
            fontSize: AppTypography.xs,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isValid) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isValid ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.text,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🚀',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              'Anmelden',
              style: TextStyle(
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
