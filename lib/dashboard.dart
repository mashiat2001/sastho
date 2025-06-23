import 'package:flutter/material.dart';
import 'first_aid.dart';  // Import First Aid Page

class Dashboard extends StatefulWidget {
  final bool guestMode;

  Dashboard({this.guestMode = false});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List of features (titles and images)
  List<Map<String, String>> features = [
    {
      'title': 'গর্ভাবস্থা সম্পর্কিত তথ্য',
      'image': 'assets/pregnancy.png',
      'route': '/pregnancy_page',  // Route for Pregnancy Page
    },
    {
      'title': 'প্রাথমিক চিকিৎসা',
      'image': 'assets/first_aid.png',
      'route': '/firstAid',  // Route for First Aid Page
    },
    {
      'title': 'ব্যায়াম',
      'image': 'assets/excersise.png',
      'route': '/exercise',  // Route for Exercise Page
    },
    {
      'title': 'মানসিক স্বাস্থ্য',
      'image': 'assets/mentalhealth.png',
      'route': '/mentalHealth',  // Route for Mental Health Page
    },
    {
      'title': 'জরুরী চিকিৎসা সেবা',
      'image': 'assets/emergency.png',
      'route': '/emergency',  // Route for Emergency Doctor Page
    },
    {
      'title': 'বিএমআই এর উপর ভিত্তি করে ডায়েট',
      'image': 'assets/bmi.png',
      'route': '/bmi_page',  // Route for BMI Page
    },
    {
      'title': 'ঔষধ রিমাইন্ডার',  // Added Bangla title for medication reminder
      'image': 'assets/remainder.png',  // Add appropriate image
      'route': '/medication',
    },
  ];

  List<Map<String, String>> filteredFeatures = [];

  @override
  void initState() {
    super.initState();
    filteredFeatures = features; // Initially, show all features
  }

  // Function to filter features based on search query
  void filterSearchResults(String query) {
    setState(() {
      filteredFeatures = features
          .where((feature) =>
          feature['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.guestMode ? Text('আপনার স্বাস্থ্য সহায়ক কেন্দ্র') : Text('ড্যাশবোর্ড'),
        backgroundColor: Color(0xFF2171B5), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  fillColor: Color(0xFF6BAED6), // Secondary color for search bar background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Title of the Dashboard, Centered
            Center(
              child: Text(
                'আমাদের সেবা',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2171B5), // Primary color
                ),
              ),
            ),
            SizedBox(height: 20),

            // Features List (filtered using ListView)
            Expanded(
              child: ListView.builder(
                itemCount: filteredFeatures.length,
                itemBuilder: (context, index) {
                  return FeatureButton(
                    title: filteredFeatures[index]['title']!,
                    imagePath: filteredFeatures[index]['image']!,
                    onTap: () {
                      // Navigate to the respective feature page using routes
                      Navigator.pushNamed(context, filteredFeatures[index]['route']!);
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
}

class FeatureButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  FeatureButton({required this.title, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature Image with a perfect fit
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 150, // Set the height of the image container
                width: double.infinity, // Set the width to fill the container
                child: Image.asset(
                  imagePath, // Display the correct image
                  fit: BoxFit.cover, // Ensures the image is responsive
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2171B5), // Primary color for text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
