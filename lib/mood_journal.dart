import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MentalHealthKnowledge extends StatelessWidget {
  final List<Map<String, dynamic>> mentalHealthInfo = [
    {
      'title': 'উদ্বেগ এবং দুশ্চিন্তা',
      'description': 'অতিরিক্ত দুশ্চিন্তা, ঘুমের সমস্যা, এবং শারীরিক অস্বস্তি উদ্বেগের লক্ষণ হতে পারে।',
      'whenToSeeProfessional': 'যখন এটি দৈনন্দিন জীবনকে ব্যাহত করে',
      'resourceLink': 'https://www.nimh.nih.gov/health/topics/anxiety-disorders'
    },
    {
      'title': 'ডিপ্রেশন বা বিষণ্ণতা',
      'description': 'দীর্ঘদিন ধরে খারাপ লাগা, আগ্রহ হারানো, এবং শক্তির অভাব বিষণ্ণতার লক্ষণ।',
      'whenToSeeProfessional': 'যখন লক্ষণগুলি ২ সপ্তাহের বেশি স্থায়ী হয়',
      'resourceLink': 'https://www.who.int/news-room/fact-sheets/detail/depression'
    },
    {
      'title': 'মানসিক চাপ',
      'description': 'অতিরিক্ত কাজের চাপ বা পারিবারিক সমস্যার কারণে মানসিক চাপ হতে পারে।',
      'whenToSeeProfessional': 'যখন আপনি নিজে সামলাতে পারছেন না',
      'resourceLink': 'https://www.apa.org/topics/stress'
    },
    {
      'title': 'ঘুমের সমস্যা',
      'description': 'নিয়মিত ঘুম না আসা বা অতিরিক্ত ঘুমানো মানসিক স্বাস্থ্য সমস্যার ইঙ্গিত দিতে পারে।',
      'whenToSeeProfessional': 'যখন এটি এক মাসের বেশি সময় ধরে চলতে থাকে',
      'resourceLink': 'https://www.sleepfoundation.org/mental-health'
    },
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('মানসিক স্বাস্থ্য জ্ঞান', style: TextStyle(fontFamily: 'SiyamRupali')),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: Container(
        color: Color(0xFFEFF3FF),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: mentalHealthInfo.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentalHealthInfo[index]['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2171B5),
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      mentalHealthInfo[index]['description'],
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'কখন পেশাদারের সাহায্য নেবেন:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SiyamRupali',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            mentalHealthInfo[index]['whenToSeeProfessional'],
                            style: TextStyle(
                              fontFamily: 'SiyamRupali',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () => _launchURL(mentalHealthInfo[index]['resourceLink']),
                      child: Text(
                        'আরও জানতে ক্লিক করুন →',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontFamily: 'SiyamRupali',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('জরুরি সহায়তা', style: TextStyle(fontFamily: 'SiyamRupali')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('যদি আপনি বা আপনার পরিচিত কেউ তীব্র মানসিক সংকটে থাকেন:',
                      style: TextStyle(fontFamily: 'SiyamRupali')),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => _launchURL('tel:999'),
                    child: Text('জরুরি নম্বর: ৯৯৯', style: TextStyle(fontFamily: 'SiyamRupali')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ঠিক আছে', style: TextStyle(fontFamily: 'SiyamRupali')),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.emergency),
        backgroundColor: Colors.red,
        tooltip: 'জরুরি সহায়তা',
      ),
    );
  }
}