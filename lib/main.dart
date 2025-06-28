import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

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
import 'faq.dart';
import 'health_journal.dart';
import 'week_tracker.dart';
import 'weight_tracker.dart';
import 'labor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);

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
       '/dashboard': (context) {
         final args = ModalRoute
             .of(context)
             ?.settings
             .arguments;
         final guestMode = args is Map
             ? args['guestMode'] as bool? ?? false
             : false;
         return Dashboard(guestMode: guestMode);
       },
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
        '/weight_tracker': (context) => WeightTrackerPage(),
        '/faq': (context) => PregnancyFAQPage(),
        '/week_tracker': (context) => WeekTrackerPage(),
        '/health_journal': (context) => HealthJournalPage(),
        '/labor': (context) => LaborPreparationPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            return HomePage();
          }

          if (!user.emailVerified) {
            return VerificationPage();
          }

          return Dashboard(guestMode: false);
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}