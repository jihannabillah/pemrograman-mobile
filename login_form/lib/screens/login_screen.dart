import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../utils/validators.dart';
import '../services/shared_prefs_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  bool _rememberMe = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _autoValidate = false;
  bool _credentialsLoaded = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    // Delay sedikit untuk menghindari konflik dengan keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final credentials = await SharedPrefsService.getSavedCredentials();

      if (mounted) {
        setState(() {
          _rememberMe = credentials['rememberMe'];
          if (_rememberMe &&
              credentials['email'].isNotEmpty &&
              credentials['password'].isNotEmpty) {
            _emailController.text = credentials['email'];
            _passwordController.text = credentials['password'];
          }
          _credentialsLoaded = true;
        });
      }
    } catch (e) {
      print('Error loading credentials: $e');
      if (mounted) {
        setState(() {
          _credentialsLoaded = true;
        });
      }
    }
  }

  Future<void> _handleLogin() async {
    // Hilangkan fokus dari semua field terlebih dahulu
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidate = true);
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi proses login
    await Future.delayed(const Duration(seconds: 2));

    // Debug: Print credentials sebelum disimpan
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    print('Remember Me: $_rememberMe');

    try {
      // Simpan credentials
      await SharedPrefsService.saveLoginCredentials(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      // Verifikasi penyimpanan
      final saved = await SharedPrefsService.getSavedCredentials();
      print('Saved to SharedPreferences:');
      print('- Remember Me: ${saved['rememberMe']}');
      print('- Email: ${saved['email']}');
      print('- Password: ${saved['password']}');

    } catch (e) {
      print('Error saving credentials: $e');
    }

    setState(() => _isLoading = false);

    // Tampilkan snackbar sukses
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login Berhasil!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Data tersimpan: $_rememberMe',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Test Load',
          textColor: Colors.white,
          onPressed: () async {
            // Test loading saved credentials
            final saved = await SharedPrefsService.getSavedCredentials();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Data Tersimpan'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Remember Me: ${saved['rememberMe']}'),
                    Text('Email: ${saved['email']}'),
                    Text('Password: ${saved['password']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await SharedPrefsService.clearCredentials();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data dihapus'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                    child: const Text('Hapus Data'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    if (!_credentialsLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Hilangkan fokus ketika tap di luar text field
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F9FF), Color(0xFFE9EBFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header dengan logo dan judul
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppStyles.borderRadius,
                      boxShadow: [AppStyles.cardShadow],
                    ),
                    child: Column(
                      children: [
                        // Logo/Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_person_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Selamat Datang Kembali',
                          style: AppStyles.heading1.copyWith(
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masuk ke akun Anda untuk melanjutkan',
                          style: AppStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form Login
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppStyles.borderRadius,
                      boxShadow: [AppStyles.cardShadow],
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hintText: 'contoh: jihan@uniska.ac.id',
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _emailFocusNode,
                            validator: Validators.validateEmail,
                            // HANYA autofocus jika tidak ada data tersimpan
                            autofocus: _emailController.text.isEmpty,
                            onFieldSubmitted: (_) {
                              _passwordFocusNode.requestFocus();
                            },
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hintText: 'minimal 6 karakter',
                            obscureText: _obscurePassword,
                            focusNode: _passwordFocusNode,
                            validator: Validators.validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            onFieldSubmitted: (_) {
                              // Submit form saat enter di password field
                              _handleLogin();
                            },
                          ),

                          const SizedBox(height: 16),

                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() => _rememberMe = value!);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      activeColor: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Ingat saya',
                                    style: AppStyles.bodySmall,
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  // Navigasi ke lupa password
                                },
                                child: Text(
                                  'Lupa Password?',
                                  style: AppStyles.linkText,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppStyles.borderRadius,
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Masuk',
                                    style: AppStyles.buttonText,
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 20),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.border,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'atau',
                                  style: AppStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.border,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum punya akun? ',
                                style: AppStyles.bodySmall,
                              ),
                              TextButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  // Navigasi ke halaman registrasi
                                },
                                child: Text(
                                  'Daftar sekarang',
                                  style: AppStyles.linkText.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Debug Info (bisa dihapus saat production)
                          if (_rememberMe) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info, color: AppColors.primary, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Data akan disimpan untuk login berikutnya',
                                      style: AppStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Text(
                    '© 2024 Sistem Informasi UNISKA - Tugas Mobile Programming',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}