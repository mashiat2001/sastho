import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To format date

class WeekTrackerPage extends StatefulWidget {
  @override
  _WeekTrackerPageState createState() => _WeekTrackerPageState();
}

class _WeekTrackerPageState extends State<WeekTrackerPage> {
  DateTime? lastPeriodDate;
  int? weeksPregnant;
  final _dateController = TextEditingController();

  // Function to calculate weeks pregnant based on last period date
  void calculateWeeksPregnant() {
    if (lastPeriodDate != null) {
      final today = DateTime.now();
      final difference = today.difference(lastPeriodDate!);
      setState(() {
        weeksPregnant = (difference.inDays / 7).round();
      });
    }
  }

  // Date Picker function to select the last period date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != lastPeriodDate) {
      setState(() {
        lastPeriodDate = picked;
        _dateController.text = DateFormat.yMd().format(lastPeriodDate!);
      });
      calculateWeeksPregnant();
    }
  }

  // Function to generate pregnancy advice based on weeks pregnant
  String getPregnancyAdvice() {
    if (weeksPregnant == null || weeksPregnant == 0) {
      return 'আপনি গর্ভবতী নন। যদি এ বিষয়ে কোনো সমস্যা থাকে, তাহলে চিকিৎসকের পরামর্শ নিন।';
    } else if (weeksPregnant! <= 12) {
      return 'আপনি প্রথম ত্রৈমাসিকে আছেন। এই সময়ে গর্ভের প্রথম গুরুত্বপূর্ণ অঙ্গগুলি তৈরি হয়।';
    } else if (weeksPregnant! <= 27) {
      return 'আপনি দ্বিতীয় ত্রৈমাসিকে আছেন। এই সময়ে শিশুর বৃদ্ধি শুরু হয় এবং শরীরে পরিবর্তন ঘটে।';
    } else {
      return 'আপনি তৃতীয় ত্রৈমাসিকে আছেন। প্রসবের প্রস্তুতি শুরু হয়ে গেছে, এবং আপনাকে অনেক প্রস্তুতি নিতে হবে।';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("গর্ভাবস্থা সপ্তাহ ট্র্যাকার"),
        backgroundColor: Color(0xFF2171B5),  // Primary color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with a more descriptive header
            Text(
              "আপনার গর্ভাবস্থার সপ্তাহ ট্র্যাক করুন:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'SiyamRupali', color: Color(0xFF2171B5)),
            ),
            SizedBox(height: 20),

            // TextField for entering last period date
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "আপনার শেষ পিরিয়ডের তারিখ দিন",
                hintText: "দিনটি নির্বাচন করুন",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Displaying weeks pregnant if calculated
            if (weeksPregnant != null && weeksPregnant! > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "আপনি ${weeksPregnant} সপ্তাহ গর্ভবতী।",
                    style: TextStyle(fontSize: 20, fontFamily: 'SiyamRupali'),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (weeksPregnant! / 40),  // Assuming 40 weeks of pregnancy
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2171B5)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "আপনার গর্ভকালীন সপ্তাহ ${weeksPregnant} তম সপ্তাহ চলছে।",
                    style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
                  ),
                  SizedBox(height: 20),

                  // Add more details about the current pregnancy stage
                  Text(
                    getPregnancyAdvice(),
                    style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali', color: Colors.black),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            // If no pregnancy (user is not pregnant)
            if (weeksPregnant == null || weeksPregnant == 0)
              Text(
                'আপনি গর্ভবতী নন। যদি এ বিষয়ে কোনো সমস্যা থাকে, তাহলে চিকিৎসকের পরামর্শ নিন।',
                style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali', color: Colors.red),
              ),
            // Sonography image to represent the pregnancy (use the same image for all weeks)
            if (weeksPregnant != null)
              Image.asset(
                'assets/Sonography.png', // Your image here
                height: 200,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
