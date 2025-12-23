import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_textfield.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _handleLogin() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Isi username dan password!'), backgroundColor: AppColors.error),
      );
      return;
    }

    if (_userController.text == "jihan" && _passController.text == "12345") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username atau Password Salah!'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_apk.png', 
                height: 120, 
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.account_balance, size: 100, color: AppColors.primary);
                }
              ), 
              SizedBox(height: 20),
              Text(
                'Culture Explorer', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
              ),
              SizedBox(height: 40),
              
              // --- DISESUAIKAN DENGAN WIDGET KAMU ---
              CustomTextField(
                controller: _userController,
                labelText: 'Username', // Nama parameter di widget kamu
                hintText: 'Masukkan username', // Nama parameter di widget kamu
                prefixIcon: Icons.person, // Memanfaatkan fitur widget kamu
                isRequired: true,
              ),
              
              SizedBox(height: 20),
              
              CustomTextField(
                controller: _passController,
                labelText: 'Password',
                hintText: 'Masukkan password',
                prefixIcon: Icons.lock,
                obscureText: true, // Fitur sensor password
                isRequired: true,
              ),
              
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    'LOGIN', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}