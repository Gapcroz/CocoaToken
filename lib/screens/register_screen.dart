import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../controllers/register_controller.dart';
import '../widgets/dynamic_form.dart';
import '../models/form_field_config.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                        DynamicForm(
                          formKey: _formKey,
                          fields: [
                            FormFieldConfig(
                              label: 'Nombre',
                              hint: 'Ingresa tu nombre',
                              controller: _nameController,
                              labelPosition: LabelPosition.outside,
                              validator:
                                  (value) =>
                                      value?.isEmpty == true
                                          ? 'Campo requerido'
                                          : null,
                            ),
                            FormFieldConfig(
                              label: 'Dirección',
                              hint: 'Ingresa tu dirección',
                              controller: _addressController,
                              labelPosition: LabelPosition.outside,
                              validator:
                                  (value) =>
                                      value?.isEmpty == true
                                          ? 'Campo requerido'
                                          : null,
                            ),
                            FormFieldConfig(
                              label: 'Fecha de Nacimiento',
                              hint: 'Ingresa tu fecha de nacimiento',
                              controller: _birthdateController,
                              labelPosition: LabelPosition.outside,
                              validator:
                                  (value) =>
                                      value?.isEmpty == true
                                          ? 'Campo requerido'
                                          : null,
                            ),
                            FormFieldConfig(
                              label: 'Email',
                              hint: 'Ingresa tu email',
                              controller: _emailController,
                              labelPosition: LabelPosition.outside,
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
                            FormFieldConfig(
                              label: 'Contraseña',
                              hint: 'Ingresa tu contraseña',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              labelPosition: LabelPosition.outside,
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
                          ],
                          submitButtonText: 'Registrarme',
                          onSubmit: _handleRegister,
                          isLoading:
                              context.watch<RegisterController>().isLoading,
                          errorMessage:
                              context.watch<RegisterController>().error,
                          additionalContent: Row(
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
