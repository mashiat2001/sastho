import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your custom pages here
import 'homepage.dart';  // Your custom HomePage
import 'loginpage.dart';  // Your custom LoginPage
import 'dashboard.dart';  // Your custom Dashboard Page
import 'first_aid.dart';  // Import the First Aid Page (Prathimic Chikitsa)
import 'pregnancy_page.dart';  // Import the Pregnancy Page (Main Pregnancy Page)
import 'weight_tracker.dart'; // Weight Tracker Page
import 'week_tracker.dart';   // Week Tracker Page
import 'faq.dart';  // FAQ Page (Myths and Facts)
import 'labor.dart'; // Labor Preparation Page
import 'health_journal.dart'; // Health Journal Page
import 'emergency.dart'; // Emergency (Location Tracker Page)
import 'bmi_page.dart';  // BMI Page
import 'medication.dart'; // Medication Reminder Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon', // Default icon for notifications
    [
      NotificationChannel(
        channelKey: 'scheduled',  // Make sure the channel key is 'scheduled'
        channelName: 'Medication Notifications',
        channelDescription: 'Channel for medication reminder notifications',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'স্বাস্থ্য বন্ধু',  // App title in Bangla
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,  // White background
        fontFamily: 'SiyamRupali',  // Use SiyamRupali font globally
      ),
      initialRoute: '/',  // Set the initial route
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => Dashboard(guestMode: true),
        '/firstAid': (context) => FirstAidPage(),
        '/pregnancy_page': (context) => MainPregnancyPage(),
        '/week_tracker': (context) => WeekTrackerPage(),
        '/weight_tracker': (context) => WeightTrackerPage(),
        '/pregnancy_faq': (context) => PregnancyFAQPage(),
        '/labor_preparation': (context) => LaborPreparationPage(),
        '/health_journal': (context) => HealthJournalPage(),
        '/emergency': (context) => LocationTrackerPage(),
        '/bmi_page': (context) => BmiDietPage(),
        '/medication': (context) => MedicationReminderPage(),  // Medication reminder route
      },
    );
  }
}
