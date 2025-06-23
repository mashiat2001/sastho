import 'package:flutter/material.dart';

class PregnancyFAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "গর্ভবতী অবস্থায় হাঁটা উচিত?",
      "answer": "হাঁটা গর্ভবতী মহিলাদের জন্য উপকারী। এটি স্বাস্থ্যকর এবং ওজন কমাতে সাহায্য করে। হাঁটার ফলে রক্ত সঞ্চালন বৃদ্ধি পায় এবং হৃৎস্পন্দন উন্নত হয়। তবে, অতিরিক্ত পরিশ্রম না করে প্রতিদিন কমপক্ষে ৩০ মিনিট হাঁটলে ভাল।"
    },
    {
      "question": "গর্ভাবস্থায় মাংস খাওয়া উচিত?",
      "answer": "হ্যাঁ, তবে সবসময় সঠিকভাবে রান্না করা উচিত। গর্ভাবস্থায় মাংস খাওয়া শরীরের জন্য প্রয়োজনীয় প্রোটিন এবং লোহা সরবরাহ করতে সহায়ক। তবে, কোন ধরনের মাংস খাচ্ছেন তা সতর্কতার সাথে নির্বাচিত করুন, কারণ অপরিষ্কার বা অর্ধ-রান্না মাংস থেকে সংক্রমণ হতে পারে।"
    },
    {
      "question": "গর্ভাবস্থায় ঠাণ্ডা পানীয় খাওয়া উচিত?",
      "answer": "থাণ্ডা পানীয় গর্ভবতী মহিলাদের জন্য ক্ষতিকর নয়, তবে অতিরিক্ত ঠাণ্ডা পানীয় এড়ানো উচিত। ঠাণ্ডা পানীয় গর্ভবতী মহিলাদের জন্য কিছুটা অস্বস্তি সৃষ্টি করতে পারে এবং পেটের সমস্যা সৃষ্টি করতে পারে। সুস্থ থাকতে বেশি পরিমাণে পানি, তাজা ফলের রস বা লেবু পানি খাওয়া উচিত।"
    },
    {
      "question": "গর্ভাবস্থায় সিগারেট এবং মদ খাওয়া উচিত?",
      "answer": "গর্ভাবস্থায় সিগারেট এবং মদ খাওয়া একদমই উচিত নয়। এইসব দ্রব্য সন্তানের উপর ক্ষতিকর প্রভাব ফেলতে পারে এবং গর্ভাবস্থার সময় শ্বাস প্রশ্বাসের সমস্যা, জন্মগত ত্রুটি এবং প্রিম্যাচিউর জন্মের ঝুঁকি বাড়ায়।"
    },
    {
      "question": "গর্ভাবস্থায় শাকসবজি খাওয়া উচিত?",
      "answer": "হ্যাঁ, শাকসবজি গর্ভবতী মহিলাদের জন্য অত্যন্ত উপকারী। এগুলি ভিটামিন, খনিজ, ফাইবার এবং অ্যান্টিঅক্সিডেন্টে পূর্ণ যা গর্ভাবস্থায় আপনার এবং শিশুর জন্য সহায়ক। তবে, সব শাকসবজি ভালোভাবে পরিষ্কার করতে হবে এবং বেশি পরিমাণে খেতে হবে।"
    },
    {
      "question": "গর্ভাবস্থায় নিয়মিত স্বাস্থ্য পরীক্ষা করানো উচিত?",
      "answer": "হ্যাঁ, গর্ভাবস্থায় নিয়মিত স্বাস্থ্য পরীক্ষা অত্যন্ত জরুরি। এটি গর্ভাবস্থার যে কোনও জটিলতা বা সমস্যা সনাক্ত করতে সাহায্য করে এবং আপনার ও শিশুর স্বাস্থ্য নিশ্চিত করে। গর্ভবতী মহিলাদের জন্য গাইনোকোলজিস্ট এবং প্রাথমিক স্বাস্থ্য পরীক্ষা অত্যন্ত গুরুত্বপূর্ণ।"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "গর্ভাবস্থার মিথ বা সত্য",
          style: TextStyle(
            fontFamily: 'SiyamRupali',
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return FAQCard(
              question: faqs[index]['question']!,
              answer: faqs[index]['answer']!,
            );
          },
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;

  FAQCard({required this.question, required this.answer, this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'SiyamRupali',
            color: Color(0xFF2171B5), // Primary color for title
          ),
        ),
        leading: Icon(
          Icons.help_outline,
          color: Color(0xFF2171B5),  // Icon color matching the primary color
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'SiyamRupali',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
