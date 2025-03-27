import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _socialEventController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _activationDateController = TextEditingController();
  final _tokensController = TextEditingController();
  final int _maxLength = 50;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _socialEventController.dispose();
    _expirationDateController.dispose();
    _activationDateController.dispose();
    _tokensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: AppTheme.headerDecoration,
                child: Column(
                  children: [
                    Container(
                      color: AppTheme.primaryColor,
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: AppTheme.headerPadding,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text('Crear cupón', style: AppTheme.titleMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputGroup(
                          label: 'Nombre del cupón',
                          child: _buildTextField(
                            controller: _nameController,
                            hint: '',
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInputGroup(
                          label: 'Descripción',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildTextField(
                                controller: _descriptionController,
                                hint: '',
                                maxLength: _maxLength,
                                showCounter: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${_descriptionController.text.length}/$_maxLength',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInputGroup(
                          label: 'Evento Social',
                          child: _buildTextField(
                            controller: _socialEventController,
                            hint: '',
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInputGroup(
                          label: 'Fecha de expiración',
                          child: _buildTextField(
                            controller: _expirationDateController,
                            readOnly: true,
                            onTap:
                                () => _selectDate(
                                  context,
                                  _expirationDateController,
                                ),
                            hint: '',
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInputGroup(
                          label: 'Tokens Asignados',
                          child: _buildTextField(
                            controller: _tokensController,
                            keyboardType: TextInputType.number,
                            hint: '',
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    int? maxLength,
    bool showCounter = true,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: TextStyle(color: AppTheme.primaryColor),
        onChanged: (value) {
          if (maxLength != null) {
            setState(() {});
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: suffixIcon,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _handleCreateCoupon,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Crear cupón',
              style: AppTheme.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // No permite fechas anteriores a hoy
      lastDate: DateTime(now.year + 2), // Permite hasta 2 años en el futuro
      locale: const Locale('es', ''), // Para mostrar el calendario en español
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor, // Color del día seleccionado
              onPrimary: Colors.white, // Color del texto del día seleccionado
              surface: Colors.white, // Color de fondo del calendario
              onSurface: AppTheme.primaryColor, // Color del texto de los días
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppTheme.primaryColor, // Color de los botones de texto
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Formatear la fecha al estilo "dd/MM/yyyy"
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";

      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  void _handleCreateCoupon() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí iría la lógica para crear el cupón
      debugPrint('Crear cupón');
    }
  }
}
