import 'package:flutter/material.dart';
import 'mental_health_checkin.dart';
import 'tips.dart';
import 'breathing.dart';
import 'mood_journal.dart';

class MentalHealthSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'মানসিক স্বাস্থ্য',
          style: TextStyle(fontFamily: 'SiyamRupali', fontSize: 20),
        ),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: Container(
        color: Color(0xFFEFF3FF),
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              context,
              'মুড চেক-ইন',
              'assets/mood.png',
              Color(0xFF2171B5), // Primary blue for all borders
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentalHealthCheckIn()),
              ),
            ),
            _buildFeatureCard(
              context,
              'মেন্টাল হেলথ টিপস',
              'assets/tips.png',
              Color(0xFF2171B5), // Primary blue for all borders
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentalHealthTips()),
              ),
            ),
            _buildFeatureCard(
              context,
              'শ্বাস-প্রশ্বাস ব্যায়াম',
              'assets/breathing.png',
              Color(0xFF2171B5), // Primary blue for all borders
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BreathingExercise()),
              ),
            ),
            _buildFeatureCard(
              context,
              'মানসিক স্বাস্থ্য সম্পর্কিত তথ্য',
              'assets/moodjournal.png',
              Color(0xFF2171B5), // Primary blue for all borders
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentalHealthKnowledge()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String imagePath, Color borderColor, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFBDD7E7).withOpacity(0.3), // Consistent light blue background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderColor, // Now using same border color for all
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFBDD7E7).withOpacity(0.5), // Consistent circle color
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                    fontFamily: 'SiyamRupali',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}