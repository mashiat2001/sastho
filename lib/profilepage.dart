import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bioController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = true;
  User? _user;
  DatabaseReference? _userRef;
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        _userRef = FirebaseDatabase.instance.ref('users/${_user!.uid}');
        final snapshot = await _userRef!.once();

        if (snapshot.snapshot.exists) {
          final data = snapshot.snapshot.value as Map;
          _bioController.text = data['bio'] ?? '';
          favorites = List<String>.from(data['favorites'] ?? []);
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveBio() async {
    if (_userRef == null) return;

    try {
      await _userRef!.update({'bio': _bioController.text});
      setState(() => _isEditing = false);
    } catch (e) {
      debugPrint('Error saving bio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('সংরক্ষণ করতে ব্যর্থ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('প্রোফাইল'),
          backgroundColor: AppColors.primaryColor,
        ),
        body: const Center(
          child: Text(
            'প্রোফাইল দেখতে লগইন করুন',
            style: TextStyle(fontSize: 18, color: AppColors.textColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রোফাইল', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_isEditing) {
                await _saveBio();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.accentColor,
                  child: Icon(Icons.person, size: 60, color: AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _user!.displayName ?? 'নাম নেই',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                _user!.email ?? 'ইমেইল নেই',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: Card(
                  elevation: 2,
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'ব্যক্তিগত তথ্য',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _isEditing
                            ? TextField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                            labelText: 'আপনার সম্পর্কে লিখুন',
                            labelStyle: TextStyle(color: AppColors.textColor),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        )
                            : Text(
                          _bioController.text.isNotEmpty
                              ? _bioController.text
                              : 'কোনো তথ্য দেওয়া হয়নি',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: Card(
                  elevation: 2,
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'পছন্দের স্বাস্থ্য সেবাসমূহ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (favorites.isNotEmpty)
                          ...favorites.map((feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '• $feature',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textColor,
                              ),
                            ),
                          ))
                        else
                          const Text(
                            'কোনো পছন্দের আইটেম নেই',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }
}