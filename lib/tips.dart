import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'colors.dart';
class MentalHealthTips extends StatefulWidget {
  @override
  _MentalHealthTipsState createState() => _MentalHealthTipsState();
}

class _MentalHealthTipsState extends State<MentalHealthTips> {
  final List<String> tips = [
    "গভীর শ্বাস নিন এবং ধীরে ধীরে শ্বাস ছাড়ুন।",
    "প্রতিদিন ১০ মিনিট হাঁটার চেষ্টা করুন।",
    "নতুন কিছু শিখুন এবং আপনার মন শান্ত রাখুন।",
    "পর্যাপ্ত পরিমাণে পানি পান করুন।",
    "প্রতিদিন ৭-৮ ঘন্টা ঘুমানোর চেষ্টা করুন।",
    "প্রিয়জনের সাথে সময় কাটান।",
    "ধ্যান বা মেডিটেশন করুন।",
    "ইতিবাচক চিন্তা করুন।",
  ];

  String _currentTip = "";
  bool _isFavorite = false;
  DateTime? _lastTipDate;
  int _lastTipIndex = 0;
  late SharedPreferences _prefs;
  Map<int, bool> _favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final lastDate = _prefs.getString('lastTipDate');
    setState(() {
      _lastTipDate = lastDate != null ? DateTime.parse(lastDate) : DateTime.now();
      _lastTipIndex = _prefs.getInt('lastTipIndex') ?? 0;

      // Load all favorite statuses
      for (int i = 0; i < tips.length; i++) {
        _favoriteStatus[i] = _prefs.getBool('isFavorite_$i') ?? false;
      }

      _isFavorite = _favoriteStatus[_lastTipIndex] ?? false;
      _updateDailyTip();
    });
  }

  void _updateDailyTip() {
    final today = DateTime.now();
    if (_lastTipDate == null || !DateUtils.isSameDay(_lastTipDate, today)) {
      // New day - show new tip
      setState(() {
        _lastTipIndex = (DateTime.now().day + DateTime.now().month) % tips.length;
        _lastTipDate = today;
        _currentTip = tips[_lastTipIndex];
        _isFavorite = _favoriteStatus[_lastTipIndex] ?? false;
      });
      _saveData();
    } else {
      // Same day - show last tip
      setState(() {
        _currentTip = tips[_lastTipIndex];
      });
    }
  }

  Future<void> _saveData() async {
    await _prefs.setString('lastTipDate', _lastTipDate!.toIso8601String());
    await _prefs.setInt('lastTipIndex', _lastTipIndex);
    // Save all favorite statuses
    for (int i = 0; i < tips.length; i++) {
      await _prefs.setBool('isFavorite_$i', _favoriteStatus[i] ?? false);
    }
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
      _favoriteStatus[_lastTipIndex] = _isFavorite;
    });
    await _prefs.setBool('isFavorite_$_lastTipIndex', _isFavorite);
  }

  void _shareTip(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('টিপটি শেয়ার করা হয়েছে'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "মানসিক স্বাস্থ্য টিপস",
          style: TextStyle(
            fontFamily: 'SiyamRupali',
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Daily Tip Card
            Card(
              elevation: 5,
              color: AppColors.accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'আজকের টিপ',
                          style: TextStyle(
                            fontFamily: 'SiyamRupali',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                            fontFamily: 'SiyamRupali',
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      _currentTip.isEmpty ? tips[0] : _currentTip,
                      style: TextStyle(
                        fontFamily: 'SiyamRupali',
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.share),
                          color: AppColors.primaryColor,
                          onPressed: () => _shareTip(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // All Tips Section
            Text(
              'সমস্ত টিপস',
              style: TextStyle(
                fontFamily: 'SiyamRupali',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tips.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: index == _lastTipIndex ? AppColors.accentColor : Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(
                      tips[index],
                      style: TextStyle(
                        fontFamily: 'SiyamRupali',
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: _favoriteStatus[index] ?? false ? Colors.red : Colors.grey[300],
                      ),
                      onPressed: () async {
                        setState(() {
                          _favoriteStatus[index] = !(_favoriteStatus[index] ?? false);
                          if (index == _lastTipIndex) {
                            _isFavorite = _favoriteStatus[index]!;
                          }
                        });
                        await _prefs.setBool('isFavorite_$index', _favoriteStatus[index]!);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            _lastTipIndex = (_lastTipIndex + 1) % tips.length;
            _lastTipDate = DateTime.now();
            _currentTip = tips[_lastTipIndex];
            _isFavorite = _favoriteStatus[_lastTipIndex] ?? false;
          });
          _saveData();
        },
        tooltip: 'পরবর্তী টিপ',
      ),
    );
  }
}