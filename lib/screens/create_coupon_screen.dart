import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../controllers/coupon_controller.dart';
import '../models/coupon_model.dart';
import '../models/coupon_status.dart';
import 'package:intl/intl.dart';

class CreateCouponScreen extends StatefulWidget {
  final CouponModel? existingCoupon;

  const CreateCouponScreen({super.key, this.existingCoupon});

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingCoupon != null) {
      _nameController.text = widget.existingCoupon!.name;
      _descriptionController.text = widget.existingCoupon!.description;
      _tokensController.text = widget.existingCoupon!.tokensRequired.toString();
      _expirationDateController.text = DateFormat('dd/MM/yyyy').format(widget.existingCoupon!.expirationDate);
    }
  }

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
                  padding: AppTheme.headerPadding.copyWith(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Image.asset(
                          'assets/icons/arrow.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.existingCoupon != null
                            ? 'Editar cupón'
                            : 'Crear cupón',
                        style: AppTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Container(
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(35, 35, 35, 0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputGroup(
                                  label: 'Nombre del cupón',
                                  child: _buildTextField(
                                    controller: _nameController,
                                    hint: '',
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildInputGroup(
                                  label: 'Descripción',
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _buildTextField(
                                        controller: _descriptionController,
                                        hint: '',
                                        maxLength: _maxLength,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
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
                                const SizedBox(height: 15),
                                _buildInputGroup(
                                  label: 'Evento Social',
                                  child: _buildTextField(
                                    controller: _socialEventController,
                                    hint: '',
                                  ),
                                ),
                                const SizedBox(height: 15),
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
                                const SizedBox(height: 15),
                                _buildInputGroup(
                                  label: 'Tokens Asignados',
                                  child: _buildTextField(
                                    controller: _tokensController,
                                    keyboardType: TextInputType.number,
                                    hint: '',
                                  ),
                                ),
                                const SizedBox(height: 19),
                                _buildButtons(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    int? maxLength,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleCreateCoupon,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      widget.existingCoupon != null
                          ? 'Guardar edición'
                          : 'Crear cupón',
                      style: AppTheme.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[200],
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

  Future<void> _handleCreateCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final coupon = CouponModel(
        id: widget.existingCoupon?.id ?? '',
        name: _nameController.text,
        description: _descriptionController.text,
        tokensRequired: int.parse(_tokensController.text),
        expirationDate: _parseDate(_expirationDateController.text),
        status: widget.existingCoupon?.status ?? CouponStatus.available,
      );

      debugPrint(
        '${widget.existingCoupon != null ? 'Actualizando' : 'Creando'} cupón: ${coupon.toJson()}',
      );

      final couponController = Provider.of<CouponController>(
        context,
        listen: false,
      );

      if (widget.existingCoupon != null) {
        await couponController.updateCoupon(coupon);
        debugPrint('Cupón actualizado exitosamente');
      } else {
        await couponController.createCoupon(coupon);
        debugPrint('Cupón creado exitosamente');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingCoupon != null
                ? 'Cupón actualizado exitosamente'
                : 'Cupón creado exitosamente',
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      debugPrint(
        'Error al ${widget.existingCoupon != null ? 'actualizar' : 'crear'} cupón: $e',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al ${widget.existingCoupon != null ? 'actualizar' : 'crear'} cupón: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return DateTime.now();
  }
}
