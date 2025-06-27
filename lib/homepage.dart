import 'package:flutter/material.dart';
import 'colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/welcome_image.png', height: 150),
              SizedBox(height: 20),
              Text(
                "স্বাস্থ্য বন্ধুতে স্বাগতম",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "আপনার স্বাস্থ্য এবং সুস্থতা নিয়ে চিন্তা করছেন? আমাদের অ্যাপ আপনাকে স্বাস্থ্য সম্পর্কিত সব তথ্য, পরামর্শ এবং সেবা সহজেই প্রদান করবে।",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Login Button
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text("লগইন"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Button color
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: Colors.white, // Button text color
                ),
              ),
              SizedBox(height: 20),
              // Register Button
              ElevatedButton(
                onPressed: () {
                  print("Navigating to register"); // Debug
                  Navigator.pushNamed(context, '/registration');
                },
                child: Text("একটি অ্যাকাউন্ট তৈরি করুন"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Button color
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: Colors.white, // Button text color
                ),
              ),
              SizedBox(height: 20),
              // Guest Mode Button - Navigate to Dashboard with guestMode = true
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/dashboard', arguments: {'guestMode': true}),
                child: Text("অফলাইন মোডে প্রবেশ করুন"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Lighter blue button for guest
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: Colors.white, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
