import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class MentalHealthCheckIn extends StatefulWidget {
  @override
  _MentalHealthCheckInState createState() => _MentalHealthCheckInState();
}

class _MentalHealthCheckInState extends State<MentalHealthCheckIn> {
  String? selectedMood;
  String? selectedEmoji;
  String additionalNotes = '';
  final TextEditingController _notesController = TextEditingController();
  List<Map<String, dynamic>> moodHistory = [];
  late SharedPreferences _prefs;

  final List<Map<String, dynamic>> moodOptions = [
    {'emoji': '😊', 'mood': 'সুখী', 'color': Colors.green},
    {'emoji': '😢', 'mood': 'দুঃখিত', 'color': Colors.blue},
    {'emoji': '😐', 'mood': 'স্বাভাবিক', 'color': Colors.grey},
    {'emoji': '😟', 'mood': 'উদ্বিগ্ন', 'color': Colors.orange},
    {'emoji': '😡', 'mood': 'রাগান্বিত', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = _prefs.getStringList('moodHistory') ?? [];
    setState(() {
      moodHistory = history.map((e) => Map<String, dynamic>.from(json.decode(e))).toList();
    });
  }

  Future<void> _saveMood() async {
    if (selectedMood == null) return;

    final entry = {
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'mood': selectedMood,
      'emoji': selectedEmoji,
      'notes': additionalNotes,
    };

    setState(() {
      moodHistory.insert(0, entry);
    });

    await _prefs.setStringList('moodHistory',
        moodHistory.map((e) => json.encode(e)).toList());
  }

  void _showNotesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('মন্তব্য যোগ করুন'),
        content: TextField(
          controller: _notesController,
          decoration: InputDecoration(hintText: 'আপনার অনুভূতি সম্পর্কে লিখুন...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                additionalNotes = _notesController.text;
              });
              Navigator.pop(context);
              _saveMood();
              _showConfirmation();
            },
            child: Text('সেভ করুন'),
          ),
        ],
      ),
    );
  }

  void _showConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('আপনার মুড সফলভাবে সেভ করা হয়েছে!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3FF),
      appBar: AppBar(
        title: Text('আজকে কেমন অনুভব করছেন?',
            style: TextStyle(fontFamily: 'SiyamRupali')),
        backgroundColor: Color(0xFF2171B5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('আপনার আজকের মুড নির্বাচন করুন',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SiyamRupali')),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: moodOptions.map((mood) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMood = mood['mood'];
                            selectedEmoji = mood['emoji'];
                          });
                          _showNotesDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: mood['color'].withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedMood == mood['mood']
                                  ? mood['color']
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(mood['emoji'], style: TextStyle(fontSize: 30)),
                              SizedBox(height: 5),
                              Text(mood['mood'],
                                  style: TextStyle(
                                      fontFamily: 'SiyamRupali',
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (selectedMood != null) ...[
              Text('আপনার বর্তমান মুড:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SiyamRupali')),
              SizedBox(height: 10),
              Card(
                color: moodOptions.firstWhere(
                        (m) => m['mood'] == selectedMood)['color'].withOpacity(0.1),
                child: ListTile(
                  leading: Text(selectedEmoji!, style: TextStyle(fontSize: 30)),
                  title: Text(selectedMood!,
                      style: TextStyle(
                          fontFamily: 'SiyamRupali',
                          fontWeight: FontWeight.bold)),
                  subtitle: additionalNotes.isNotEmpty
                      ? Text(additionalNotes,
                      style: TextStyle(fontFamily: 'SiyamRupali'))
                      : null,
                ),
              ),
            ],
            SizedBox(height: 20),
            Text('আপনার মুড হিস্ট্রি:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SiyamRupali')),
            SizedBox(height: 10),
            if (moodHistory.isEmpty)
              Padding(
                padding: EdgeInsets.all(16),
                child: Text('কোনো মুড রেকর্ড পাওয়া যায়নি',
                    style: TextStyle(fontFamily: 'SiyamRupali')),
              )
            else
              ...moodHistory.map((entry) => Card(
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Text(entry['emoji'], style: TextStyle(fontSize: 30)),
                  title: Text(entry['date'],
                      style: TextStyle(fontFamily: 'SiyamRupali')),
                  subtitle: Text(entry['mood'],
                      style: TextStyle(fontFamily: 'SiyamRupali')),
                  trailing: entry['notes'] != null && entry['notes'].isNotEmpty
                      ? Icon(Icons.note, color: Colors.grey)
                      : null,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('মুড ডিটেইলস'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('তারিখ: ${entry['date']}'),
                            Text('মুড: ${entry['mood']} ${entry['emoji']}'),
                            if (entry['notes'] != null && entry['notes'].isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('মন্তব্য: ${entry['notes']}'),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('ঠিক আছে'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}