import 'package:flutter/material.dart';

class WeightTrackerPage extends StatefulWidget {
  @override
  _WeightTrackerPageState createState() => _WeightTrackerPageState();
}

class _WeightTrackerPageState extends State<WeightTrackerPage> {
  final _prePregnancyWeightController = TextEditingController();
  final _currentWeightController = TextEditingController();

  String _status = "";
  String _advice = "";
  IconData _statusIcon = Icons.check_circle_outline;
  Color _statusColor = Colors.green;

  // Function to calculate weight gain and provide advice
  void calculateWeightStatus() {
    double prePregnancyWeight = double.tryParse(_prePregnancyWeightController.text) ?? 0.0;
    double currentWeight = double.tryParse(_currentWeightController.text) ?? 0.0;

    if (prePregnancyWeight == 0.0 || currentWeight == 0.0) return;

    double weightGain = currentWeight - prePregnancyWeight;

    setState(() {
      if (weightGain == 0) {
        // If no weight gain
        _status = "ওজন বাড়েনি";
        _advice = "গর্ভাবস্থায় ওজন না বাড়ানো  স্বাভাবিক নয়। দয়া করে চিকিৎসকের পরামর্শ নিন।";
        _statusIcon = Icons.error_outline;
        _statusColor = Colors.red;
      } else if (weightGain < 0) {
        // If weight loss occurs
        _status = "ওজন কমে গেছে";
        _advice = "গর্ভাবস্থায় ওজন কমানো স্বাভাবিক নয়। দয়া করে চিকিৎসকের পরামর্শ নিন।";
        _statusIcon = Icons.error_outline;
        _statusColor = Colors.red;
      } else if (weightGain >= 0 && weightGain <= 10) {
        // Normal weight gain range (typically 10-15 kg for a healthy pregnancy)
        _status = "স্বাভাবিক বৃদ্ধি";
        _advice = "আপনার ওজন বৃদ্ধি সাধারণ এবং স্বাস্থ্যকর। আপনি আপনার গর্ভকালীন সময় ভালভাবে পার করছেন।";
        _statusIcon = Icons.check_circle_outline;
        _statusColor = Colors.green;
      } else if (weightGain > 10 && weightGain <= 15) {
        // Moderate weight gain
        _status = "মধ্যম বৃদ্ধি";
        _advice = "আপনার ওজন বৃদ্ধি স্বাভাবিক সীমার মধ্যে রয়েছে। তবে, নিয়মিত শরীরচর্চা চালিয়ে যেতে হবে।";
        _statusIcon = Icons.warning_amber_rounded;
        _statusColor = Colors.orange;
      } else {
        // Excessive weight gain
        _status = "অতিরিক্ত বৃদ্ধি";
        _advice = "আপনার ওজন বৃদ্ধি বেশি হয়েছে। অতিরিক্ত ওজন গর্ভাবস্থায় ঝুঁকি সৃষ্টি করতে পারে, চিকিৎসকের পরামর্শ নিন।";
        _statusIcon = Icons.error_outline;
        _statusColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "গর্ভাবস্থার ওজন ট্র্যাকার",
          style: TextStyle(fontFamily: 'SiyamRupali'),
        ),
        backgroundColor: Color(0xFF2171B5),  // Primary color for AppBar
      ),
      body: SingleChildScrollView(  // Use SingleChildScrollView to avoid overflow issues
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the Weight Tracker page
            Text(
              "গর্ভধারণের আগে এবং পরের ওজন ট্র্যাক করুন:",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'SiyamRupali', color: Color(0xFF2171B5)),
            ),
            SizedBox(height: 20),

            // Pre-pregnancy weight input field
            Text(
              "প্রসবের আগে আপনার ওজন (কেজি):",
              style: TextStyle(fontSize: 18, fontFamily: 'SiyamRupali'),
            ),
            TextField(
              controller: _prePregnancyWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "আপনার পূর্ববর্তী ওজন দিন",
                labelText: "প্রেগন্যান্সির আগে ওজন",
              ),
            ),
            SizedBox(height: 20),

            // Current weight input field
            Text(
              "বর্তমান ওজন (কেজি):",
              style: TextStyle(fontSize: 18, fontFamily: 'SiyamRupali'),
            ),
            TextField(
              controller: _currentWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "বর্তমান ওজন দিন",
                labelText: "বর্তমান ওজন",
              ),
            ),
            SizedBox(height: 20),

            // Calculate weight status button
            ElevatedButton(
              onPressed: calculateWeightStatus,
              child: Text("ওজন যাচাই করুন"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2171B5),  // Primary button color
                foregroundColor: Colors.white,  // Text color on the button
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Display weight status and advice
            Row(
              children: [
                Icon(
                  _statusIcon,
                  size: 40,
                  color: _statusColor,
                ),
                SizedBox(width: 10),
                Text(
                  "অবস্থা: $_status",
                  style: TextStyle(fontSize: 18, fontFamily: 'SiyamRupali', color: _statusColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "উপদেশ: $_advice",
              style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
            ),
            SizedBox(height: 20),

            // Progress Bar showing weight status visually
            LinearProgressIndicator(
              value: (_currentWeightController.text.isNotEmpty && _prePregnancyWeightController.text.isNotEmpty)
                  ? (_currentWeightController.text.isEmpty ? 0.0 : double.tryParse(_currentWeightController.text)! /
                  double.tryParse(_prePregnancyWeightController.text)!)
                  : 0.0,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ],
        ),
      ),
    );
  }
}
