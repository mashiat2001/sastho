import 'package:flutter/material.dart';
import 'colors.dart';

class FavoriteFeaturesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteFeatures;

  const FavoriteFeaturesPage({Key? key, required this.favoriteFeatures}) : super(key: key);

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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigation would be handled by the parent widget
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  favoriteFeatures[index]['image'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                favoriteFeatures[index]['title'],
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              IconButton(
                icon: Icon(
                  favoriteFeatures[index]['isFavorite'] ? Icons.star : Icons.star_border,
                  color: favoriteFeatures[index]['isFavorite'] ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  // Favorite toggle would be handled by the parent widget
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}