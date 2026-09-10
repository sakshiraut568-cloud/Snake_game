import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.goldCoin),
                    const SizedBox(width: 8),
                    Text('${gameProvider.coins}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          final skins = gameProvider.availableSkins;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: skins.length,
            itemBuilder: (context, index) {
              final skin = skins[index];
              final isPurchased = gameProvider.purchasedSkins.contains(skin.id);
              final isEquipped = gameProvider.selectedSkinId == skin.id;

              return Card(
                color: isEquipped ? AppColors.primaryGreen.withOpacity(0.2) : Colors.white10,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isEquipped ? const BorderSide(color: AppColors.primaryGreen, width: 2) : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: skin.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.catching_pokemon, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(skin.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            if (!isPurchased)
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on, color: AppColors.goldCoin, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${skin.price}', style: const TextStyle(color: AppColors.goldCoin)),
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (isEquipped)
                        const Chip(label: Text('Equipped'), backgroundColor: AppColors.primaryGreen, labelStyle: TextStyle(color: Colors.white))
                      else if (isPurchased)
                        ElevatedButton(
                          onPressed: () => gameProvider.equipSkin(skin.id),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryBlue),
                          child: const Text('Equip', style: TextStyle(color: Colors.white)),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            bool success = await gameProvider.buySkin(skin);
                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough coins!')));
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                          child: const Text('Buy', style: TextStyle(color: Colors.white)),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
