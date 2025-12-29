import 'package:flutter/material.dart';
import 'package:pravesh_screen/initialInfo/intro_pages.dart';
import 'package:pravesh_screen/widgets/herder_container.dart';
import 'package:pravesh_screen/widgets/btn_name.dart';
import 'services/auth_service.dart';
import 'auth_gate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _showError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showLoginError(String message) {
    setState(() {
      _errorMessage = message;
      _showError = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showError = false;
        });
      }
    });
  }

  Future<void> _validateLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showLoginError('Please enter ID and password');
      return;
    }

    setState(() {
      _showError = false;
      _isLoading = true;
    });

    try {
      // 🔐 Centralized auth + token storage + credential save
      await AuthService.login(email, password);

      // 🚪 Hand control back to AuthGate
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const IntroPages(),
        ),
        (_) => false,
      );
    } catch (e) {
      _showLoginError('Invalid ID or Password');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        padding: EdgeInsets.only(bottom: screenHeight * 0.035),
        child: Column(
          children: <Widget>[
            const HeaderContainer(text: ''),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: screenWidth * 0.053,
                  right: screenWidth * 0.053,
                  top: screenHeight * 0.035,
                ),
                child: Column(
                  children: <Widget>[
                    _textInput(
                      controller: _emailController,
                      hint: "CRISPR ID",
                      icon: Icons.email,
                    ),
                    _textInput(
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.vpn_key,
                      isPassword: true,
                    ),
                    if (_showError)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: screenHeight * 0.012),
                        padding: EdgeInsets.all(screenWidth * 0.032),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.021),
                        ),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.037,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : ButtonWidget(
                                onClick: _validateLogin,
                                btnText: "LOGIN",
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.012),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.053)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: screenWidth * 0.027),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          label: Text(hint),
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          prefixIconColor: Colors.black,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }
}
