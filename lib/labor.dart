import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaborPreparationPage extends StatefulWidget {
  @override
  _LaborPreparationPageState createState() => _LaborPreparationPageState();
}

class _LaborPreparationPageState extends State<LaborPreparationPage> {
  List<String> preparationItems = [];
  List<bool> itemChecked = [];
  final TextEditingController _newItemController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  @override
  void dispose() {
    _newItemController.dispose();
    super.dispose();
  }

  // Load checklist from SharedPreferences
  Future<void> _loadChecklist() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList('preparationItems') ?? [
      'হাসপাতালের ব্যাগ প্রস্তুত করুন',
      'জরুরি অবস্থার জন্য রক্তের ব্যবস্থা করুন',
      'ডাক্তার বা হাসপাতাল নির্বাচন করুন',
      'প্রসব পরিকল্পনা প্রস্তুত করুন',
      'অ্যাম্বুলেন্স নম্বর সংরক্ষণ করুন'
    ];

    final savedChecks = prefs.getStringList('itemChecked') ??
        List.filled(savedItems.length, 'false');

    setState(() {
      preparationItems = savedItems;
      itemChecked = savedChecks.map((e) => e == 'true').toList();
      _isLoading = false;
    });
  }

  // Save checklist to SharedPreferences
  Future<void> _saveChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('preparationItems', preparationItems);
    await prefs.setStringList('itemChecked',
        itemChecked.map((e) => e.toString()).toList());
  }

  // Add new item to checklist
  void _addNewItem() {
    if (_newItemController.text.trim().isEmpty) return;

    setState(() {
      preparationItems.add(_newItemController.text.trim());
      itemChecked.add(false);
      _newItemController.clear();
    });
    _saveChecklist();
  }

  // Remove item from checklist
  void _removeItem(int index) {
    setState(() {
      preparationItems.removeAt(index);
      itemChecked.removeAt(index);
    });
    _saveChecklist();
  }

  // Calculate progress
  double get laborProgress {
    if (preparationItems.isEmpty) return 0;
    int checkedCount = itemChecked.where((item) => item).length;
    return checkedCount / preparationItems.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'প্রসব প্রস্তুতি',
          style: TextStyle(fontFamily: 'SiyamRupali', fontSize: 20),
        ),
        backgroundColor: Color(0xFF2171B5),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                itemChecked = List.filled(preparationItems.length, false);
              });
              _saveChecklist();
            },
            tooltip: 'রিসেট করুন',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/checklist.png',
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Add new item section
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newItemController,
                        decoration: InputDecoration(
                          labelText: 'নতুন আইটেম যোগ করুন',
                          hintText: 'আপনার কাস্টম প্রস্তুতি লিখুন',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'SiyamRupali'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Color(0xFF2171B5)),
                      onPressed: _addNewItem,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'প্রসবের জন্য প্রস্তুতির চেকলিস্ট:',
              style: TextStyle(fontFamily: 'SiyamRupali', fontSize: 18),
            ),
            SizedBox(height: 10),

            // Checklist items
            Column(
              children: List.generate(preparationItems.length, (index) {
                return Dismissible(
                  key: Key('$index-${preparationItems[index]}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _removeItem(index),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF2171B5),
                        size: 30,
                      ),
                      title: Text(
                        preparationItems[index],
                        style: TextStyle(
                          fontFamily: 'SiyamRupali',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Checkbox(
                        value: itemChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            itemChecked[index] = value!;
                          });
                          _saveChecklist();
                        },
                        activeColor: Color(0xFF2171B5),
                        checkColor: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 20),
            Text(
              'আপনি ${((laborProgress * 100).toInt()).toString()}% প্রস্তুত',
              style: TextStyle(fontFamily: 'SiyamRupali', fontSize: 16),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: laborProgress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2171B5)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}