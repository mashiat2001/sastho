import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // For loading assets

class FirstAidPage extends StatefulWidget {
  @override
  _FirstAidPageState createState() => _FirstAidPageState();
}

class _FirstAidPageState extends State<FirstAidPage> {
  List<Map<String, dynamic>> firstAidProblems = [];
  List<Map<String, dynamic>> filteredProblems = [];

  @override
  void initState() {
    super.initState();
    loadFirstAidData();  // Load first aid problems from the JSON file
  }

  // Function to load and decode the JSON data
  Future<void> loadFirstAidData() async {
    final String response = await rootBundle.loadString('assets/first_aid.json');
    final data = json.decode(response);

    setState(() {
      firstAidProblems = List<Map<String, dynamic>>.from(data['first_aid']);
      filteredProblems = firstAidProblems;  // Show all problems initially
    });
  }

  // Function to filter results based on search query
  void filterSearchResults(String query) {
    setState(() {
      filteredProblems = firstAidProblems
          .where((problem) =>
          problem['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'প্রাথমিক চিকিৎসা',
          style: TextStyle(
            fontFamily: 'SiyamRupali',  // Apply Siyam Rupali font for Bangla text
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                onChanged: (query) => filterSearchResults(query),
                decoration: InputDecoration(
                  hintText: 'অনুসন্ধান করুন...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFF6BAED6), // Secondary color for search bar
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // First Aid Problems List (cards)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // 2 columns for grid
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: filteredProblems.length,
                itemBuilder: (context, index) {
                  return FirstAidCard(
                    title: filteredProblems[index]['title']!,
                    icon: getIconForProblem(filteredProblems[index]['title']!),  // Dynamically set icon
                    onTap: () {
                      // Show steps in a dialog for now (this can be replaced with a detailed page)
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('প্রাথমিক চিকিৎসা: ${filteredProblems[index]['title']}'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('কর্মপদ্ধতি:'),
                                ...List<Widget>.generate(
                                  filteredProblems[index]['steps'].length,
                                      (i) => Text('• ${filteredProblems[index]['steps'][i]}'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to return appropriate icon for each problem
  IconData getIconForProblem(String title) {
    switch (title) {
      case "আগুনে পুড়ে যাওয়া ":
        return Icons.local_fire_department;  // Fire icon for Burns
      case "সাপের কামড় ":
        return Icons.pest_control_rodent;  // Icon representing Snake Bite
      case "কাটা এবং রক্তপাত ":
        return Icons.cut;  // Cut icon for Wounds
      case "জ্বর ":
        return Icons.thermostat;  // Thermometer icon for Fever
      case "ডায়রিয়া ":
        return Icons.local_drink;  // Water icon for Diarrhea
      case "অ্যাস্থমা আক্রমণ ":
        return Icons.airline_seat_recline_normal;  // Airplane seat recline icon for Asthma (breathing assistance)
      case "বৈদ্যুতিক শক ":
        return Icons.electric_car;  // Electric shock icon
      case "ভেঙে যাওয়া হাড় ":
        return Icons.health_and_safety;  // Medical icon for Fracture
      default:
        return Icons.help;  // Default icon for unknown problems
    }
  }
}

class FirstAidCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  FirstAidCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,  // Increased elevation for better shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),  // Rounded corners for the card
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon for the problem
            Icon(
              icon,
              size: 80,  // Larger icon for better visibility
              color: Color(0xFF2171B5), // Primary color for icon
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SiyamRupali',  // Use Siyam Rupali font
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
