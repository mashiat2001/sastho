import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class FirstAidPage extends StatefulWidget {
  @override
  _FirstAidPageState createState() => _FirstAidPageState();
}

class _FirstAidPageState extends State<FirstAidPage> {
  List<Map<String, dynamic>> firstAidProblems = [];
  List<Map<String, dynamic>> filteredProblems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFirstAidData();
  }

  Future<void> loadFirstAidData() async {
    final String response = await rootBundle.loadString('assets/first_aid.json');
    final data = json.decode(response);

    setState(() {
      firstAidProblems = List<Map<String, dynamic>>.from(data['first_aid']);
      filteredProblems = firstAidProblems;
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredProblems = firstAidProblems
          .where((problem) =>
          problem['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _launchYouTubeVideo(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ভিডিও খুলতে পারছি না')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'প্রাথমিক চিকিৎসা',
          style: TextStyle(
            fontFamily: 'SiyamRupali',
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
            TextField(
              controller: _searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: 'খুজুন...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // First Aid Grid
            Expanded(
              child: filteredProblems.isEmpty
                  ? Center(
                child: Text(
                  'কোন ফলাফল পাওয়া যায়নি',
                  style: TextStyle(fontFamily: 'SiyamRupali'),
                ),
              )
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                ),
                itemCount: filteredProblems.length,
                itemBuilder: (context, index) {
                  final problem = filteredProblems[index];
                  return FirstAidCard(
                    title: problem['title'],
                    steps: problem['steps'],
                    youtubeLink: problem['youtube_link'],
                    icon: getIconForProblem(problem['title']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIconForProblem(String title) {
    switch (title) {
      case "আগুনে পুড়ে যাওয়া":
        return Icons.local_fire_department;
      case "সাপের কামড়":
        return Icons.pest_control_rodent;
      case "কাটা এবং রক্তপাত":
        return Icons.cut;
      case "জ্বর":
        return Icons.thermostat;
      case "ডায়রিয়া":
        return Icons.water_drop;
      case "অ্যাস্থমা আক্রমণ":
        return Icons.air;
      case "বৈদ্যুতিক শক":
        return Icons.electric_bolt;
      case "ভেঙে যাওয়া হাড়":
        return Icons.personal_injury;
      default:
        return Icons.medical_services;
    }
  }
}

class FirstAidCard extends StatelessWidget {
  final String title;
  final List<dynamic> steps;
  final String? youtubeLink;
  final IconData icon;

  const FirstAidCard({
    required this.title,
    required this.steps,
    this.youtubeLink,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontFamily: 'SiyamRupali'),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'কর্মপদ্ধতি:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                    SizedBox(height: 10),
                    ...steps.map((step) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '• $step',
                        style: TextStyle(fontFamily: 'SiyamRupali'),
                      ),
                    )).toList(),
                    if (youtubeLink != null) ...[
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.play_arrow, color: Colors.white),
                        label: Text(
                          'ভিডিও দেখুন',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SiyamRupali',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          if (await canLaunchUrl(Uri.parse(youtubeLink!))) {
                            await launchUrl(
                              Uri.parse(youtubeLink!),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'বন্ধ করুন',
                    style: TextStyle(fontFamily: 'SiyamRupali'),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF2171B5)),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SiyamRupali',
                ),
              ),
            ),
            if (youtubeLink != null)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_collection, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      'ভিডিও আছে',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}