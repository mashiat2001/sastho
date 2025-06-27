import 'dart:async';
import 'package:flutter/material.dart';

class BreathingExercise extends StatefulWidget {
  @override
  _BreathingExerciseState createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with TickerProviderStateMixin {
  String phase = 'শ্বাস নিন';
  int remainingSeconds = 4;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  int _cycleCount = 0;
  bool _isExerciseRunning = false;

  final Map<String, Color> phaseColors = {
    'শ্বাস নিন': Colors.blue,
    'ধরে রাখুন': Colors.green,
    'শ্বাস ছাড়ুন': Colors.orange,
  };

  final Map<String, int> phaseDurations = {
    'শ্বাস নিন': 4,
    'ধরে রাখুন': 7,
    'শ্বাস ছাড়ুন': 8,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: phaseDurations[phase]!),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startExercise() {
    setState(() {
      _isExerciseRunning = true;
      _cycleCount = 0;
    });
    _controller.forward();
    _nextPhase();
  }

  void _stopExercise() {
    _timer?.cancel();
    _controller.stop();
    setState(() {
      _isExerciseRunning = false;
      phase = 'শ্বাস নিন';
      remainingSeconds = phaseDurations[phase]!;
    });
  }

  void _nextPhase() {
    _timer?.cancel();
    _controller.stop();

    setState(() {
      if (phase == 'শ্বাস নিন') {
        phase = 'ধরে রাখুন';
      } else if (phase == 'ধরে রাখুন') {
        phase = 'শ্বাস ছাড়ুন';
      } else {
        phase = 'শ্বাস নিন';
        _cycleCount++;
      }
      remainingSeconds = phaseDurations[phase]!;
    });

    _controller.duration = Duration(seconds: phaseDurations[phase]!);
    _controller.forward(from: 0);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 1) {
        setState(() => remainingSeconds--);
      } else {
        _nextPhase();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("শ্বাস-প্রশ্বাসের ব্যায়াম",
            style: TextStyle(fontFamily: 'SiyamRupali')),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 150,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      height: 250, // Fixed container height
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Center(
                            child: Container(
                              width: 200 * _animation.value,
                              height: 200 * _animation.value,
                              decoration: BoxDecoration(
                                color: phaseColors[phase]!.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: phaseColors[phase]!,
                                  width: 4,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      phase,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: phaseColors[phase],
                                        fontFamily: 'SiyamRupali',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '$remainingSeconds সেকেন্ড',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: 'SiyamRupali',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'চক্র: $_cycleCount',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isExerciseRunning)
                          ElevatedButton(
                            onPressed: _startExercise,
                            child: Text('শুরু করুন',
                                style: TextStyle(fontFamily: 'SiyamRupali')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2171B5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: _stopExercise,
                            child: Text('বন্ধ করুন',
                                style: TextStyle(fontFamily: 'SiyamRupali')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('নির্দেশনা:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'SiyamRupali')),
                            SizedBox(height: 10),
                            Text('১. ৪ সেকেন্ড শ্বাস নিন\n২. ৭ সেকেন্ড ধরে রাখুন\n৩. ৮ সেকেন্ড শ্বাস ছাড়ুন',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'SiyamRupali'),
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}