import 'package:flutter/material.dart';
import 'colors.dart';

class FavoriteFeaturesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteFeatures;
  final Function(String) onFeatureTap;
  final Function(String) onToggleFavorite;

  const FavoriteFeaturesPage({
    Key? key,
    required this.favoriteFeatures,
    required this.onFeatureTap,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পছন্দের তালিকা', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: favoriteFeatures.isEmpty
            ? const Center(
          child: Text(
            'আপনার এখনো কোনো পছন্দের আইটেম নেই',
            style: TextStyle(fontSize: 18, color: AppColors.textColor),
          ),
        )
            : ListView.separated(
          itemCount: favoriteFeatures.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) => _buildFeatureCard(index),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(int index) {
    final feature = favoriteFeatures[index];
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onFeatureTap(feature['route']),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  feature['image'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                feature['title'],
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              IconButton(
                icon: Icon(
                  feature['isFavorite'] ? Icons.star : Icons.star_border,
                  color: feature['isFavorite'] ? Colors.amber : Colors.grey,
                ),
                onPressed: () => onToggleFavorite(feature['title']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}