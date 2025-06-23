import 'package:flutter/material.dart';

class LaborPreparationPage extends StatefulWidget {
  @override
  _LaborPreparationPageState createState() => _LaborPreparationPageState();
}

class _LaborPreparationPageState extends State<LaborPreparationPage> {
  // The labor preparation checklist items
  List<String> preparationItems = [
    'হাসপাতালের ব্যাগ প্রস্তুত করুন',
    'জরুরি অবস্থার জন্য রক্তের ব্যবস্থা করুন',
    'ডাক্তার বা হাসপাতাল নির্বাচন করুন',
    'প্রসব পরিকল্পনা প্রস্তুত করুন',
    'অ্যাম্বুলেন্স নম্বর সংরক্ষণ করুন'
  ];

  // Boolean values to track if an item is checked
  List<bool> itemChecked = [false, false, false, false, false];

  // Calculate the progress based on the number of checked items
  double get laborProgress {
    int checkedCount = itemChecked.where((item) => item).length;
    return checkedCount / preparationItems.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'প্রসব প্রস্তুতি',
          style: TextStyle(
            fontFamily: 'SiyamRupali',
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top of the page
            Image.asset(
              'assets/checklist.png', // Add your checklist image here
              width: double.infinity,
              height: 120, // Adjust as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Title for the checklist
            Text(
              'প্রসবের জন্য প্রস্তুতির চেকলিস্ট:',
              style: TextStyle(
                fontFamily: 'SiyamRupali',
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),

            // Checklist items with checkboxes
            Column(
              children: List.generate(preparationItems.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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

            // Displaying labor progress as a percentage
            Text(
              'আপনি ${((laborProgress * 100).toInt()).toString()}% প্রস্তুত',
              style: TextStyle(fontFamily: 'SiyamRupali', fontSize: 16),
            ),
            SizedBox(height: 20),

            // Progress bar based on the number of checked items
            LinearProgressIndicator(
              value: laborProgress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2171B5)),
            ),
          ],
        ),
      ),
    );
  }
}
