import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import '../layouts/main_layout.dart';
import '../screens/register_screen.dart';
import '../widgets/dynamic_form.dart';
import '../models/form_field_config.dart';
import '../mixins/form_controller_mixin.dart';
import '../config/api_config.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormControllerMixin {
  final _formKey = GlobalKey<FormState>();
  bool _hasPrecached = false;

  final ButtonStyle _whiteButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    side: const BorderSide(color: Colors.white),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );

  @override
  void initState() {
    super.initState();
    getController('email').clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPrecached) {
      _precacheImages();
      _hasPrecached = true;
    }
  }

  Future<void> _precacheImages() async {
    await precacheImage(const AssetImage('assets/icons/google.png'), context);
  }

  Future<void> _handleLogin() async {
    if (!mounted || _formKey.currentState?.validate() != true) return;

    final authController = context.read<AuthController>();
    final success = await authController.login(
      getController('email').text,
      getController('password').text,
    );

    if (success && mounted) {
      await Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainLayout()));
    }
  }

  void _handlePasswordRecovery() {
    Navigator.pushNamed(context, '/password-recovery');
  }

  void _handleRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Cancelado

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();

      if (idToken != null) {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/google-login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'idToken': idToken}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];
          final user = data['user'];

          // Aquí puedes almacenar el token y user en SharedPreferences
          debugPrint("Google login OK. Token del backend: $token");
          debugPrint("Usuario logueado: ${user['name']}");
          // Actualiza tu AuthService/AuthController aquí si lo necesitas
        } else {
          debugPrint('Error desde backend: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error en Google Sign-In: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: AppTheme.primaryColor)),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: AppTheme.screenPadding.left,
                  right: AppTheme.screenPadding.right,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Iniciar Sesión',
                      style: AppTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    DynamicForm(
                      formKey: _formKey,
                      fields: [
                        FormFieldConfig(
                          label: 'Email',
                          hint: 'Ingresa tu email',
                          controller: getController('email'),
                          labelPosition: LabelPosition.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu email';
                            }
                            if (!value.contains('@')) {
                              return 'Ingresa un email válido';
                            }
                            return null;
                          },
                        ),
                        FormFieldConfig(
                          label: 'Contraseña',
                          hint: 'Ingresa tu contraseña',
                          controller: getController('password'),
                          obscureText: true,
                          labelPosition: LabelPosition.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ],
                      submitButtonText: 'Iniciar Sesión',
                      onSubmit: _handleLogin,
                      isLoading: context.watch<AuthController>().isLoading,
                      errorMessage: context.watch<AuthController>().error,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _handlePasswordRecovery,
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildDivider(),
                    const SizedBox(height: 25),
                    _buildRegisterButton(),
                    const SizedBox(height: 16),
                    _buildGoogleButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white, thickness: 2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('¿eres nuevo?', style: AppTheme.bodyLarge),
        ),
        const Expanded(child: Divider(color: Colors.white, thickness: 2)),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return OutlinedButton(
      onPressed: _handleRegistration,
      style: _whiteButtonStyle,
      child: Text(
        'Registrarme',
        style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentColor),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton.icon(
      onPressed: _handleGoogleSignIn,
      icon: Image.asset('assets/icons/google.png', width: 24, height: 24),
      label: Text(
        'Registrarte con Google',
        style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentColor),
      ),
      style: _whiteButtonStyle,
    );
  }
}
