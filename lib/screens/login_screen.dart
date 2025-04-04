import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import '../layouts/main_layout.dart';
import '../screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasPrecached = false; // Para evitar múltiples precacheos

  // Memoizamos los estilos que se usan repetidamente
  final _inputDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.grey[400]),
    filled: true,
    fillColor: Colors.white.withAlpha(25),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  final ButtonStyle _whiteButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    side: const BorderSide(color: Colors.white),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );

  @override
  void initState() {
    super.initState();
    _emailController.clear();
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!mounted || _formKey.currentState?.validate() != true) return;

    final authController = context.read<AuthController>();
    final success = await authController.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      // Usar pushReplacement en lugar de pushAndRemoveUntil si es posible
      await Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainLayout()));
    }
  }

  void _handlePasswordRecovery() {
    // Implementar recuperación de contraseña
    Navigator.pushNamed(context, '/password-recovery');
  }

  void _handleRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _handleGoogleSignIn() {
    // Implementar inicio de sesión con Google
    debugPrint('Google Sign In pressed');
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Iniciar Sesión',
                        style: AppTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      _buildErrorMessage(),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 24),
                      _buildLoginButton(),
                      const SizedBox(height: 16),
                      _buildForgotPasswordButton(),
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
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Selector<AuthController, String?>(
      selector: (_, auth) => auth.error,
      builder: (context, error, _) {
        if (error != null) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: AppTheme.bodyLarge,
      decoration: _inputDecoration.copyWith(hintText: 'Ingresa tu email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu email';
        }
        if (!value.contains('@')) {
          return 'Ingresa un email válido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: AppTheme.bodyLarge,
      obscureText: true,
      decoration: _inputDecoration.copyWith(hintText: 'Ingresa tu contraseña'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu contraseña';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return Selector<AuthController, bool>(
      selector: (_, auth) => auth.isLoading,
      builder: (context, isLoading, _) {
        return ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child:
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Iniciar Sesión', style: AppTheme.bodyLarge),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: _handlePasswordRecovery,
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
      child: Text('¿Olvidaste tu contraseña?', style: AppTheme.bodyMedium),
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
