import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/store_controller.dart';
import '../models/store.dart';
import '../theme/app_theme.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreController()..loadStores(),
      child: const StoresScreenContent(),
    );
  }
}

class StoresScreenContent extends StatelessWidget {
  const StoresScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<StoreController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.isNotEmpty) {
                  return Center(child: Text('Error: ${controller.error}'));
                }

                return GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children:
                      controller.stores
                          .map((store) => _buildStoreCard(context, store))
                          .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
                Text('Tiendas participantes', style: AppTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, Store store) {
    return Card(
      elevation: 2,
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          store.logo,
                          height: 120,
                          width: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.store,
                              size: 120,
                              color: Colors.white70,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          store.name,
                          style: AppTheme.titleSmall.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: AppTheme.cardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                store.logo,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.store,
                    size: 80,
                    color: AppTheme.greyColor,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 80,
                    width: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                store.name,
                style: AppTheme.titleSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
