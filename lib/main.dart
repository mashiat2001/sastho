import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:health_buddy/faq.dart';
import 'package:health_buddy/health_journal.dart';
import 'package:health_buddy/labor.dart';
import 'package:health_buddy/week_tracker.dart';
import 'package:health_buddy/weight_tracker.dart';

// Import all pages
import 'homepage.dart';
import 'login.dart';
import 'dashboard.dart';
import 'first_aid.dart';
import 'pregnancy_page.dart';
import 'emergency.dart';
import 'bmi_page.dart';
import 'medication.dart';
import 'registration.dart';
import 'profilepage.dart';
import 'verification.dart';
import 'mental_health_page.dart';
import 'mental_health_checkin.dart';
import 'breathing.dart';
import 'mood_journal.dart';
import 'tips.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Configure Database
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);

  // Initialize Notifications
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );

  runApp(HealthBuddyApp());
}

class HealthBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'স্বাস্থ্য বন্ধু',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SiyamRupali',
      ),
      home: AuthWrapper(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(),
        '/dashboard': (context) => Dashboard(guestMode: false),
        '/profile': (context) => ProfilePage(),
        '/verification': (context) => VerificationPage(),
        '/first_aid': (context) => FirstAidPage(),
        '/pregnancy_page': (context) => MainPregnancyPage(),
        '/emergency': (context) => LocationTrackerPage(),
        '/bmi_page': (context) => BmiDietPage(),
        '/medication': (context) => MedicationReminderPage(),
        '/mental_health_page': (context) => MentalHealthSection(),
        '/mental_health_checkin': (context) => MentalHealthCheckIn(),
        '/breathing': (context) => BreathingExercise(),
        '/mood_journal': (context) => MentalHealthKnowledge(),
        '/tips': (context) => MentalHealthTips(),
        '/weight_tracker':(context) => WeightTrackerPage(),
        '/faq':(context) => PregnancyFAQPage(),
        '/week_tracker': (context) => WeekTrackerPage(),
        '/health_journal':(context) => HealthJournalPage(),
        '/labor':(context) =>  LaborPreparationPage(),

      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( // Listen to Firebase Authentication stream
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            return HomePage();  // If no user is logged in, show the HomePage
          }

          if (!user.emailVerified) {
            return VerificationPage();  // If the user hasn't verified their email, show verification page
          }

          return Dashboard(guestMode: false);  // If the user is logged in and email verified, show Dashboard
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),  // Loading state while checking auth
        );
      },
    );
  }
}
