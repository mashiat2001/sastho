import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart'; // Import colors

class MedicationReminderPage extends StatefulWidget {
  @override
  _MedicationReminderPageState createState() => _MedicationReminderPageState();
}

class _MedicationReminderPageState extends State<MedicationReminderPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadSavedReminder();
  }

  // Load saved reminder from SharedPreferences
  Future<void> _loadSavedReminder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hour = prefs.getInt('medication_hour');
      final minute = prefs.getInt('medication_minute');

      if (hour != null && minute != null) {
        setState(() {
          _selectedTime = TimeOfDay(hour: hour, minute: minute);
          _nameController.text = prefs.getString('medication_name') ?? '';
          _dosageController.text = prefs.getString('medication_dosage') ?? '';
        });
      }
    } catch (e) {
      print('Error loading saved reminder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ঔষধের রিমাইন্ডার', style: TextStyle(fontFamily: 'SiyamRupali')),
        backgroundColor: AppColors.primaryColor,  // App primary color for the AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Add the image at the top
            Image.asset(
              'assets/notification_image.png', // Ensure the image is in your 'assets' folder
              height: 150, // Set the height to medium size
              width: double.infinity, // Make the image width full screen
              fit: BoxFit.cover, // Ensure the image covers the container proportionally
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: TextStyle(fontFamily: 'SiyamRupali'),
              decoration: InputDecoration(
                labelText: 'ঔষধের নাম',
                labelStyle: TextStyle(fontFamily: 'SiyamRupali'),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.backgroundColor,  // Match the background color
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dosageController,
              style: TextStyle(fontFamily: 'SiyamRupali'),
              decoration: InputDecoration(
                labelText: 'ডোজ',
                labelStyle: TextStyle(fontFamily: 'SiyamRupali'),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.backgroundColor,  // Match the background color
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 0),
                backgroundColor: AppColors.primaryColor,  // Use primary color for button
              ),
              onPressed: _pickTime,
              child: Text(
                'সময় নির্বাচন করুন',
                style: TextStyle(fontFamily: 'SiyamRupali', color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            if (_selectedTime != null) ...[
              Text(
                'নির্বাচিত সময়: ${_selectedTime!.format(context)}',
                style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
              ),
              SizedBox(height: 30),
            ],
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 0),
                backgroundColor: AppColors.buttonColor,  // Use button color
              ),
              onPressed: _setReminder,
              child: Text(
                'রিমাইন্ডার সেট করুন',
                style: TextStyle(fontFamily: 'SiyamRupali', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pick time for reminder
  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  // Set the medication reminder
  Future<void> _setReminder() async {
    if (!_validateInputs()) return;

    final name = _nameController.text;
    final dosage = _dosageController.text;

    try {
      await _saveReminder(name, dosage, _selectedTime!);
      await _scheduleNotification(name, dosage, _selectedTime!);
      _showSnackBar('রিমাইন্ডার সেট করা হয়েছে!');
    } catch (e) {
      _showSnackBar('রিমাইন্ডার সেট করতে সমস্যা হয়েছে: $e');
      print('Error setting reminder: $e');
    }
  }

  // Validate inputs before setting reminder
  bool _validateInputs() {
    if (_selectedTime == null) {
      _showSnackBar('দয়া করে একটি সময় নির্বাচন করুন');
      return false;
    }
    if (_nameController.text.isEmpty) {
      _showSnackBar('দয়া করে ঔষধের নাম লিখুন');
      return false;
    }
    if (_dosageController.text.isEmpty) {
      _showSnackBar('দয়া করে ডোজ লিখুন');
      return false;
    }
    return true;
  }

  // Save reminder in SharedPreferences
  Future<void> _saveReminder(String name, String dosage, TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('medication_name', name);
    await prefs.setString('medication_dosage', dosage);
    await prefs.setInt('medication_hour', time.hour);
    await prefs.setInt('medication_minute', time.minute);
  }

  // Schedule the notification
  Future<void> _scheduleNotification(
      String name, String dosage, TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // If the time has already passed, schedule for the next day
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    print("Scheduled Time: $scheduledTime");

    // First cancel any existing notification with the same ID
    await AwesomeNotifications().cancel(1);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1, // Fixed ID to prevent duplicates
        channelKey: 'scheduled',  // Correct channel key for scheduled notifications
        title: 'ঔষধের সময় হয়েছে',
        body: '$name ($dosage) নিন',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        repeats: false,  // Single-time notification (non-repeating)
      ),
    );
  }

  // Show SnackBar for feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}
