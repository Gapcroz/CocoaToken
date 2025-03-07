import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          AppBar(
            backgroundColor: AppTheme.primaryColor,
            title: Text(
              'Cupones',
              style: AppTheme.titleMedium,
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Contenido de cupones'),
            ),
          ),
        ],
      ),
    );
  }
} 