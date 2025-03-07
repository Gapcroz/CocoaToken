import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          AppBar(
            backgroundColor: AppTheme.primaryColor,
            title: Text(
              'Tiendas participantes',
              style: AppTheme.titleMedium,
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildStoreCard(
                  context,
                  image: 'assets/stores/store1.svg',
                  name: 'Tienda 1',
                ),
                _buildStoreCard(
                  context,
                  image: 'assets/stores/store2.svg',
                  name: 'Tienda 2',
                ),
                // Agrega más tiendas según necesites
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(
    BuildContext context, {
    required String image,
    required String name,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to store details
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: AppTheme.cardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: AppTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 