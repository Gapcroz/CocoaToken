import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryColor,
      width: double.infinity,
      height: double.infinity,
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
              // Login title
              Text(
                'Iniciar Sesión',
                style: AppTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Email input field
              TextField(
                style: AppTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              // Password input field
              TextField(
                style: AppTheme.bodyLarge,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              // Login button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Iniciar Sesión',
                  style: AppTheme.bodyLarge,
                ),
              ),
              // Forgot password link
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Implement password recovery
                },
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
              // New user section divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white, thickness: 2)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '¿eres nuevo?',
                        style: AppTheme.bodyLarge,
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white, thickness: 2)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Registration buttons section
              OutlinedButton(
                onPressed: () {
                  // TODO: Implement registration
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Registrarme',
                  style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentColor),
                ),
              ),
              const SizedBox(height: 16),
              // Google sign-in button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement Google sign-in
                },
                icon: Image.asset(
                  'assets/icons/google.png',
                  width: 24,
                  height: 24,
                ),
                label: Text(
                  'Registrarte con Google',
                  style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentColor),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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