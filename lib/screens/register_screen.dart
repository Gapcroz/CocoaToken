import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isStore = false;
  bool _obscurePassword = true;

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

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildErrorMessage() {
    return Selector<RegisterController, String?>(
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: AppTheme.primaryColor)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Image.asset('assets/icons/arrow.png', color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppTheme.screenPadding,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Registrarme',
                            style: AppTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          _buildErrorMessage(),
                          TextFormField(
                            controller: _nameController,
                            style: AppTheme.bodyLarge,
                            decoration: _inputDecoration.copyWith(
                              hintText: 'Ingresa tu nombre',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty == true
                                        ? 'Campo requerido'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            style: AppTheme.bodyLarge,
                            decoration: _inputDecoration.copyWith(
                              hintText: 'Ingresa tu dirección',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty == true
                                        ? 'Campo requerido'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _birthdateController,
                            readOnly: true,
                            style: AppTheme.bodyLarge,
                            decoration: _inputDecoration.copyWith(
                              hintText: 'Ingresa tu fecha de nacimiento',
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty == true
                                        ? 'Campo requerido'
                                        : null,
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                final formattedDate =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                setState(() {
                                  _birthdateController.text = formattedDate;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            style: AppTheme.bodyLarge,
                            decoration: _inputDecoration.copyWith(
                              hintText: 'Ingresa tu email',
                            ),
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return 'Campo requerido';
                              }
                              if (!value!.contains('@')) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            style: AppTheme.bodyLarge,
                            obscureText: _obscurePassword,
                            decoration: _inputDecoration.copyWith(
                              hintText: 'Ingresa tu contraseña',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return 'Campo requerido';
                              }
                              if (value!.length < 6) {
                                return 'Mínimo 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: _isStore,
                                  onChanged: (value) {
                                    setState(() {
                                      _isStore = value ?? false;
                                    });
                                  },
                                  fillColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                  checkColor: AppTheme.accentColor,
                                ),
                              ),
                              Text(
                                'Marca si eres una tienda',
                                style: AppTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Selector<RegisterController, bool>(
                            selector: (_, register) => register.isLoading,
                            builder: (context, isLoading, _) {
                              return ElevatedButton(
                                onPressed: isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          'Registrarme',
                                          style: AppTheme.bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFD9D9D9),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Cancelar',
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (!mounted || _formKey.currentState?.validate() != true) return;

    final registerController = context.read<RegisterController>();
    final success = await registerController.register(
      name: _nameController.text,
      address: _addressController.text,
      birthdate: _birthdateController.text,
      isStore: _isStore,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success && mounted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso! Ahora puedes iniciar sesión.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
}
