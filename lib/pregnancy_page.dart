import 'package:flutter/material.dart';

class MainPregnancyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('গর্ভাবস্থা সম্পর্কিত তথ্য'),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pregnancy Features List (cards)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,  // 2 columns for a nice grid view
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _FeatureCard(
                    title: 'গর্ভাবস্থা সপ্তাহ ট্র্যাকার',
                    icon: Icons.calendar_today,
                    onTap: () {
                      Navigator.pushNamed(context, '/week_tracker');
                    },
                  ),
                  _FeatureCard(
                    title: 'ওজন ট্র্যাকার',
                    icon: Icons.line_weight,
                    onTap: () {
                      Navigator.pushNamed(context, '/weight_tracker');
                    },
                  ),
                  _FeatureCard(
                    title: 'প্রসব প্রস্তুতি',
                    icon: Icons.access_alarm,
                    onTap: () {
                      Navigator.pushNamed(context, '/labor');
                    },
                  ),
                  _FeatureCard(
                    title: 'স্বাস্থ্য জার্নাল',
                    icon: Icons.notes,
                    onTap: () {
                      Navigator.pushNamed(context, '/health_journal');
                    },
                  ),
                  _FeatureCard(
                    title: 'গর্ভাবস্থার মিথ বা সত্য',
                    icon: Icons.help_outline,
                    onTap: () {
                      Navigator.pushNamed(context, '/faq');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Color(0xFF2171B5), // Primary color for icon
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2171B5), // Primary color for text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
