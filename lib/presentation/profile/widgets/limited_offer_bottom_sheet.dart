import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LimitedOfferBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2D1B1B), // Dark reddish background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),

          // Title
          const Text(
            'Sınırlı Teklif',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          const Text(
            'Jeton paketini seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),

          const SizedBox(height: 24),

          // Bonuses Section
          const Text(
            'Alacağınız Bonuslar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // Bonus Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBonusItem(
                icon: Icons.diamond,
                title: 'Premium\nHesap',
                color: const Color(0xFFE91E63),
              ),
              _buildBonusItem(
                icon: Icons.cloud,
                title: 'Daha\nFazla Eşleşme',
                color: const Color(0xFFE91E63),
              ),
              _buildBonusItem(
                icon: Icons.arrow_upward,
                title: 'Öne\nÇıkarma',
                color: const Color(0xFFE91E63),
              ),
              _buildBonusItem(
                icon: Icons.favorite,
                title: 'Daha\nFazla Beğeni',
                color: const Color(0xFFE91E63),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Package Selection Title
          const Text(
            'Kilidi açmak için bir jeton paketi seçin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          // Package Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildPackageCard(
                    originalPrice: '200',
                    discountedPrice: '330',
                    currency: 'Jeton',
                    weeklyPrice: '₺99,99',
                    discount: '+10%',
                    color: const Color(0xFFB71C1C),
                    discountColor: const Color(0xFFB71C1C),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPackageCard(
                    originalPrice: '2.000',
                    discountedPrice: '3.375',
                    currency: 'Jeton',
                    weeklyPrice: '₺799,99',
                    discount: '+70%',
                    color: const Color(0xFF7B1FA2),
                    discountColor: const Color(0xFF7B1FA2),
                    isPopular: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPackageCard(
                    originalPrice: '1.000',
                    discountedPrice: '1.350',
                    currency: 'Jeton',
                    weeklyPrice: '₺399,99',
                    discount: '+35%',
                    color: const Color(0xFFB71C1C),
                    discountColor: const Color(0xFFB71C1C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Show All Tokens Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement show all tokens
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Tüm Jetonları Gör',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBonusItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard({
    required String originalPrice,
    required String discountedPrice,
    required String currency,
    required String weeklyPrice,
    required String discount,
    required Color color,
    required Color discountColor,
    bool isPopular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: isPopular ? Border.all(color: Colors.purple, width: 2) : null,
      ),
      child: Column(
        children: [
          // Discount Badge
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isPopular ? Colors.purple : discountColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              discount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Original Price (crossed out)
          Text(
            originalPrice,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
            ),
          ),

          // Discounted Price
          Text(
            discountedPrice,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Currency
          Text(
            currency,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // Weekly Price
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text(
                  weeklyPrice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Başına haftalık',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
