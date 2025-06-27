import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeekTrackerPage extends StatefulWidget {
  @override
  _WeekTrackerPageState createState() => _WeekTrackerPageState();
}

class _WeekTrackerPageState extends State<WeekTrackerPage> {
  DateTime? lastPeriodDate;
  int? weeksPregnant;
  final _dateController = TextEditingController();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastPeriodDate');
    if (savedDate != null) {
      setState(() {
        lastPeriodDate = DateTime.parse(savedDate);
        _dateController.text = DateFormat.yMd().format(lastPeriodDate!);
        calculateWeeksPregnant();
      });
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    if (lastPeriodDate == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPeriodDate', lastPeriodDate!.toIso8601String());

    setState(() {
      _isSaved = true;
    });

    // Hide the saved message after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSaved = false;
        });
      }
    });
  }

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
      initialDate: lastPeriodDate ?? DateTime.now(),
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
        title: Text("গর্ভাবস্থা সপ্তাহ ট্র্যাকার", style: TextStyle(fontFamily: 'SiyamRupali')),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "আপনার গর্ভাবস্থার সপ্তাহ ট্র্যাক করুন:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'SiyamRupali',
                color: Color(0xFF2171B5),
              ),
            ),
            SizedBox(height: 20),

            // Date input field
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
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),

            // Row for Calculate and Save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Calculate button
                ElevatedButton(
                  onPressed: calculateWeeksPregnant,
                  child: Text("গণনা করুন", style: TextStyle(fontFamily: 'SiyamRupali')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2171B5),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                // Save button
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text("সেভ করুন", style: TextStyle(fontFamily: 'SiyamRupali')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            // Saved confirmation message
            if (_isSaved)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "ডেটা সেভ করা হয়েছে!",
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'SiyamRupali',
                    fontSize: 16,
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Pregnancy information display
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
                    value: (weeksPregnant! / 40),
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2171B5)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "আপনার গর্ভকালীন সপ্তাহ ${weeksPregnant} তম সপ্তাহ চলছে।",
                    style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    getPregnancyAdvice(),
                    style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali', color: Colors.black),
                  ),
                  SizedBox(height: 20),

                  // Sonography image with proper asset reference
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage('assets/Sonography.png'), // Update with your actual image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

            if (weeksPregnant == null || weeksPregnant == 0)
              Text(
                'আপনি গর্ভবতী নন। যদি এ বিষয়ে কোনো সমস্যা থাকে, তাহলে চিকিৎসকের পরামর্শ নিন।',
                style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali', color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}