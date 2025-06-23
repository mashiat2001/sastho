import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart'; // Import custom AppColors for theme consistency

class HealthJournalPage extends StatefulWidget {
  @override
  _HealthJournalPageState createState() => _HealthJournalPageState();
}

class _HealthJournalPageState extends State<HealthJournalPage> {
  final _controller = TextEditingController();
  List<String> journalEntries = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadJournalEntries(); // Load the saved journal entries
  }

  // Function to load journal entries from SharedPreferences
  void loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      journalEntries = prefs.getStringList('journal_entries') ?? [];
      isDataLoaded = true; // Set to true when data is loaded
    });
  }

  // Function to save journal entries to SharedPreferences
  void saveJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('journal_entries', journalEntries);
  }

  // Add a journal entry and save to SharedPreferences
  void addJournalEntry() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        journalEntries.add(_controller.text);
        _controller.clear();
      });
      saveJournalEntries(); // Save updated entries
    }
  }

  // Clear all journal entries
  void clearAllEntries() {
    setState(() {
      journalEntries.clear();
      saveJournalEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "স্বাস্থ্য জার্নাল",
          style: TextStyle(
            fontFamily: 'SiyamRupali',
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: isDataLoaded
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image at the top
            Image.asset(
              'assets/journal.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // **TextField for entering journal**
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'আজকের অভিজ্ঞতা লিখুন',
                hintText: 'আজ কী অনুভব করেছেন?',
                labelStyle: TextStyle(
                  color: AppColors.primaryColor,
                ),
                hintStyle: TextStyle(
                  color: AppColors.textColor.withOpacity(0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
            ),
            SizedBox(height: 20),

            // **Add Journal Button**
            ElevatedButton(
              onPressed: addJournalEntry,
              child: Text("জার্নাল যুক্ত করুন"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),

            // **Clear All Entries Button**
            ElevatedButton(
              onPressed: clearAllEntries,
              child: Text("সব তথ্য মুছে ফেলুন"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),

            // **Display journal entries in cards**
            Expanded(
              child: ListView.builder(
                itemCount: journalEntries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              color: AppColors.primaryColor,
                              size: 30,
                            ),
                            SizedBox(height: 10),
                            Text(
                              journalEntries[index],
                              style: TextStyle(
                                fontFamily: 'SiyamRupali',
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  journalEntries.removeAt(index);
                                  saveJournalEntries();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
