import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI এবং ডায়েট পরামর্শ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFEFF3FF),
        fontFamily: 'SiyamRupali',
      ),
      home: const BmiDietPage(),
    );
  }
}

class BmiDietPage extends StatefulWidget {
  const BmiDietPage({super.key});

  @override
  State<BmiDietPage> createState() => _BmiDietPageState();
}

class _BmiDietPageState extends State<BmiDietPage> {
  final _weightController = TextEditingController();
  final _feetController = TextEditingController();
  final _inchController = TextEditingController();
  final _ageController = TextEditingController();

  String? _bmiResult = '';
  String? _dietSuggestion = '';
  String? _status = '';
  String? _bmiRange = '';

  void calculateBmi() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    int feet = int.tryParse(_feetController.text) ?? 0;
    int inch = int.tryParse(_inchController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;

    double heightInMeters = ((feet * 12 + inch) * 0.0254);

    if (weight == 0 || heightInMeters == 0) {
      setState(() {
        _bmiResult = 'অসঠিক তথ্য প্রদান করেছেন';
        _dietSuggestion = 'দয়া করে সঠিক ওজন এবং উচ্চতা লিখুন';
        _status = '';
        _bmiRange = '';
      });
      return;
    }

    double bmi = weight / (heightInMeters * heightInMeters);
    String bmiStatus = '';
    String dietSuggestion = '';
    String bmiRange = '';

    if (bmi < 18.5) {
      bmiStatus = 'অধিক কম ওজন';
      bmiRange = '১৮.৫ এর নিচে';
      dietSuggestion = '''
✅ প্রোটিন সমৃদ্ধ খাবার: ডিম, মাছ, মাংস, ডাল
✅ স্বাস্থ্যকর চর্বি: বাদাম, অলিভ অয়েল, অ্যাভোকাডো
✅ দুধ ও দুগ্ধজাত খাবার: পনির, দই
✅ বেশি করে ফল ও শাকসবজি
⏺ দিনে ৫-৬ বার অল্প অল্প করে খান
❌ জাঙ্ক ফুড এড়িয়ে চলুন''';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      bmiStatus = 'স্বাভাবিক ওজন';
      bmiRange = '১৮.৫ - ২৪.৯';
      dietSuggestion = '''
✅ সুষম খাদ্য গ্রহণ করুন
✅ প্রচুর শাকসবজি ও ফলমূল
✅ গোটা শস্য জাতীয় খাবার
✅ পর্যাপ্ত পানি পান করুন
✅ নিয়মিত ব্যায়াম করুন
❌ অতিরিক্ত তেল-চর্বি এড়িয়ে চলুন''';
    } else if (bmi >= 25 && bmi < 29.9) {
      bmiStatus = 'অতিরিক্ত ওজন';
      bmiRange = '২৫ - ২৯.৯';
      dietSuggestion = '''
✅ কম ক্যালোরি যুক্ত খাবার
✅ শাকসবজি ও আঁশযুক্ত খাবার বেশি খান
✅ চিনি ও মিষ্টি কম খান
✅ নিয়মিত ৩০ মিনিট হাঁটুন
✅ ফাস্ট ফুড এড়িয়ে চলুন
⏺ দিনে ৩ বারের বেশি ভারী খাবার না খাওয়া''';
    } else {
      bmiStatus = 'মোটা';
      bmiRange = '৩০ এর উপরে';
      dietSuggestion = '''
✅ কম কার্বোহাইড্রেট যুক্ত খাবার
✅ উচ্চ প্রোটিন সমৃদ্ধ খাবার
✅ প্রচুর শাকসবজি
✅ দিনে ৮-১০ গ্লাস পানি পান করুন
✅ প্রতিদিন ৪৫ মিনিট ব্যায়াম
❌ তেল-চর্বি জাতীয় খাবার সম্পূর্ণ বন্ধ
❌ মিষ্টি ও কোমল পানীয় এড়িয়ে চলুন''';
    }

    setState(() {
      _bmiResult = 'আপনার BMI: ${bmi.toStringAsFixed(2)}';
      _status = bmiStatus;
      _dietSuggestion = dietSuggestion;
      _bmiRange = bmiRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI এবং ডায়েট পরামর্শ',
            style: TextStyle(fontFamily: 'SiyamRupali')),
        backgroundColor: const Color(0xFF2171B5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BMI কি?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'বডি মাস ইনডেক্স (BMI) হলো আপনার ওজন এবং উচ্চতার অনুপাত যা শরীরের চর্বির পরিমাণ নির্দেশ করে। এটি স্বাস্থ্য ঝুঁকি মূল্যায়নের একটি সহজ পদ্ধতি।',
                      style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Section
            _buildInputCard(
              title: 'আপনার তথ্য দিন',
              children: [
                _buildInputField('ওজন (কেজি)', _weightController),
                const SizedBox(height: 10),
                const Text('উচ্চতা',
                    style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali')),
                Row(
                  children: [
                    Expanded(child: _buildInputField('ফুট', _feetController)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInputField('ইঞ্চি', _inchController)),
                  ],
                ),
                const SizedBox(height: 10),
                _buildInputField('বয়স (বছর)', _ageController),
              ],
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: calculateBmi,
                child: const Text("BMI গণনা করুন",
                    style: TextStyle(fontFamily: 'SiyamRupali')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2171B5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Results Section
            if (_bmiResult != null && _bmiResult!.isNotEmpty)
              _buildResultCard(
                title: 'আপনার BMI ফলাফল',
                children: [
                  _buildResultItem('BMI স্কোর', _bmiResult!),
                  _buildResultItem('ওজন অবস্থা', _status!),
                  _buildResultItem('BMI রেঞ্জ', _bmiRange!),

                  const SizedBox(height: 15),
                  const Text(
                    'ডায়েট পরামর্শ:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SiyamRupali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _dietSuggestion!,
                    style: const TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            _buildBmiChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SiyamRupali',
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  Widget _buildResultCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFE3F2FD),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SiyamRupali',
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'SiyamRupali',
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
          ),
        ],
      ),
    );
  }

  Widget _buildBmiChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI চার্ট',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SiyamRupali',
              ),
            ),
            const SizedBox(height: 10),
            _buildBmiCategory('১৮.৫ এর নিচে', 'অধিক কম ওজন', const Color(0xFF42A5F5)),
            _buildBmiCategory('১৮.৫ - ২৪.৯', 'স্বাভাবিক ওজন', const Color(0xFF66BB6A)),
            _buildBmiCategory('২৫ - ২৯.৯', 'অতিরিক্ত ওজন', const Color(0xFFFFA726)),
            _buildBmiCategory('৩০ এর উপরে', 'মোটা', const Color(0xFFEF5350)),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCategory(String range, String category, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$range - $category',
            style: const TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
          ),
        ],
      ),
    );
  }
}