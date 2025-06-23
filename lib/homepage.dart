import 'package:flutter/material.dart';
import 'dashboard.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome Image
              Image.asset('assets/welcome_image.png', height: 150), // Replace with your own image
              SizedBox(height: 20),

              // Welcome Text in Bangla
              Text(
                "স্বাস্থ্য বন্ধুতে স্বাগতম",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2171B5), // Primary color
                ),
              ),
              SizedBox(height: 10),

              // Updated Description Text in Bangla
              Text(
                "আপনার স্বাস্থ্য এবং সুস্থতা নিয়ে চিন্তা করছেন? আমাদের অ্যাপ আপনাকে স্বাস্থ্য সম্পর্কিত সব তথ্য, পরামর্শ এবং সেবা সহজেই প্রদান করবে।",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6BAED6), // Secondary color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Login Button (same styling as other buttons)
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login page using named route
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("লগইন"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2171B5), // Primary color for the button
                  foregroundColor: Colors.white, // Text color on the button
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80), // Adjusted padding for Login button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 18), // Adjusted font size for consistency
                ),
              ),
              SizedBox(height: 20),

              // Register Button in Bangla (same styling as the login button, but smaller)
              ElevatedButton(
                onPressed: () {
                  // Navigate to Register page
                  Navigator.pushNamed(context, '/register');
                },
                child: Text("একটি অ্যাকাউন্ট তৈরি করুন"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2171B5), // Same primary color
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70), // Reduced padding for Register button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 16), // Smaller font size for Register button
                ),
              ),
              SizedBox(height: 20),

              // Offline Mode Button (same styling as other buttons, but smaller)
              ElevatedButton(
                onPressed: () {
                  // Navigate to Offline Mode page (was Guest Mode)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashboard(guestMode: true),
                    ),
                  );
                },
                child: Text("অফলাইন মোডে প্রবেশ করুন"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2171B5), // Same primary color
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70), // Reduced padding for Offline button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 16), // Smaller font size for Offline Mode button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
