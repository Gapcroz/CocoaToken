import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../controllers/register_controller.dart';
import '../models/form_field_config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _birthdateFieldKey = GlobalKey<FormFieldState<String>>();
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
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildFormField(
                                config: FormFieldConfig(
                                  label: 'Nombre',
                                  hint: 'Ingresa tu nombre',
                                  controller: _nameController,
                                  labelPosition: LabelPosition.none,
                                  validator:
                                      (value) =>
                                          value?.isEmpty == true
                                              ? 'Campo requerido'
                                              : null,
                                ),
                              ),
                              _buildFormField(
                                config: FormFieldConfig(
                                  label: 'Dirección',
                                  hint: 'Ingresa tu dirección',
                                  controller: _addressController,
                                  labelPosition: LabelPosition.none,
                                  validator:
                                      (value) =>
                                          value?.isEmpty == true
                                              ? 'Campo requerido'
                                              : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.3,
                                      child: Checkbox(
                                        value: _isStore,
                                        onChanged: (value) {
                                          setState(() {
                                            _isStore = value ?? false;
                                            if (_isStore) {
                                              _birthdateController.clear();
                                              _birthdateFieldKey.currentState
                                                  ?.reset();
                                            }
                                          });
                                        },
                                        fillColor: WidgetStateProperty.all(
                                          Colors.white,
                                        ),
                                        checkColor: AppTheme.accentColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isStore = !_isStore;
                                          if (_isStore) {
                                            _birthdateController.clear();
                                            _birthdateFieldKey.currentState
                                                ?.reset();
                                          }
                                        });
                                      },
                                      child: Text(
                                        'Soy tienda',
                                        style: AppTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: TextFormField(
                                  key: _birthdateFieldKey,
                                  controller: _birthdateController,
                                  readOnly: true,
                                  enabled: !_isStore,
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Selecciona tu fecha de nacimiento',
                                    hintStyle: TextStyle(
                                      color:
                                          !_isStore
                                              ? Colors.white70
                                              : Colors.white38,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color:
                                          !_isStore
                                              ? Colors.white70
                                              : Colors.white38,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor:
                                        !_isStore
                                            ? const Color(0xFF2A2F3D)
                                            : Colors.grey.shade700,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          !_isStore && value?.isEmpty == true
                                              ? 'Campo requerido'
                                              : null,
                                  onTap: !_isStore ? _selectDate : null,
                                ),
                              ),
                              _buildFormField(
                                config: FormFieldConfig(
                                  label: 'Email',
                                  hint: 'Ingresa tu email',
                                  controller: _emailController,
                                  labelPosition: LabelPosition.none,
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
                              ),
                              _buildFormField(
                                config: FormFieldConfig(
                                  label: 'Contraseña',
                                  hint: 'Ingresa tu contraseña',
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  labelPosition: LabelPosition.none,
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
                              ),
                              if (context.watch<RegisterController>().error !=
                                  null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    context.watch<RegisterController>().error!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              _buildSubmitButton(),
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

  Widget _buildFormField({Key? key, required FormFieldConfig config}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        key: key,
        controller: config.controller,
        style: AppTheme.bodyLarge.copyWith(color: Colors.white),
        validator: config.validator,
        obscureText: config.obscureText,
        enabled: config.enabled,
        decoration: InputDecoration(
          labelText:
              config.labelPosition == LabelPosition.inside
                  ? config.label
                  : null,
          hintText: config.hint,
          hintStyle: TextStyle(
            color: config.enabled ? Colors.white70 : Colors.white38,
          ),
          suffixIcon: config.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor:
              config.enabled ? const Color(0xFF2A2F3D) : Colors.grey.shade700,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isLoading = context.watch<RegisterController>().isLoading;
    return ElevatedButton(
      onPressed: isLoading ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child:
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                'Registrarme',
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
    );
  }

  Future<void> _handleRegister() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!mounted || !isValid) return;

    final registerController = context.read<RegisterController>();
    final success = await registerController.register(
      name: _nameController.text,
      address: _addressController.text,
      birthdate: _isStore ? '' : _birthdateController.text,
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

  Future<void> _selectDate() async {
    final DateTime today = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(
      today.year - 18,
      today.month,
      today.day,
    );
    final DateTime firstSelectableDate = DateTime(
      today.year - 100,
      today.month,
      today.day,
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: firstSelectableDate,
      lastDate: eighteenYearsAgo,
      locale: const Locale('es', 'ES'),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 50));

      if (!mounted) return;

      setState(() {
        _birthdateController.text = formattedDate;
      });
    }
  }
}
