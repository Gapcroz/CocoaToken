import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../layouts/main_layout.dart';

class GoogleExtraDataScreen extends StatefulWidget {
  final int userId;
  const GoogleExtraDataScreen({super.key, required this.userId});

  @override
  State<GoogleExtraDataScreen> createState() => _GoogleExtraDataScreenState();
}

class _GoogleExtraDataScreenState extends State<GoogleExtraDataScreen> {
  final TextEditingController _passwordController = TextEditingController();
  DateTime? _selectedDate;
  bool _isStore = false;
  bool _isLoading = false;
  String? _error;

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    final password = _passwordController.text.trim();
    if (password.length < 6) {
      setState(() => _error = 'La contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (!_isStore && _selectedDate == null) {
      setState(() => _error = 'Debes seleccionar tu fecha de nacimiento');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final url = Uri.parse('${ApiConfig.baseUrl}/complete-google-user');
    final body = {
      'userId': widget.userId,
      'password': password,
      'isStore': _isStore,
      if (!_isStore) 'birthDate': _selectedDate!.toIso8601String(),
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainLayout(),
          ),
        );
      } else {
        setState(
          () => _error = jsonDecode(res.body)['message'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      setState(() => _error = 'Error al conectar con el servidor: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completa tu registro')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _isStore,
              onChanged: (value) => setState(() => _isStore = value),
              title: const Text('¿Eres tienda?'),
            ),
            if (!_isStore)
              ListTile(
                title: const Text('Fecha de nacimiento'),
                subtitle: Text(
                  _selectedDate != null
                      ? _selectedDate!.toLocal().toString().split(' ')[0]
                      : 'No seleccionada',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectBirthDate,
                ),
              ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
