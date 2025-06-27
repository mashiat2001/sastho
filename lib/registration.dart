import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'verification.dart';
import 'colors.dart';
import 'dart:async';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      _showError('সব তথ্য পূরণ করুন');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create user account
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .timeout(Duration(seconds: 15));

      // 2. Immediately navigate to verification page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerificationPage()),
      );

      // 3. Complete other operations in background
      await _completeRegistration(userCredential.user!);

    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } on TimeoutException {
      _showError('সময় শেষ হয়েছে। দয়া করে আবার চেষ্টা করুন');
    } catch (e) {
      _showError('ত্রুটি হয়েছে: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _completeRegistration(User user) async {
    try {
      await Future.wait([
        user.updateDisplayName(_usernameController.text.trim()),
        user.sendEmailVerification(),
        FirebaseDatabase.instance.ref('users/${user.uid}').set({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'emailVerified': false,
          'createdAt': ServerValue.timestamp,
        }),
      ]);
    } catch (e) {
      debugPrint('Background operations error: $e');
      // Delete user if registration fails
      await user.delete();
      await FirebaseDatabase.instance.ref('users/${user.uid}').remove();
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message = 'রেজিস্ট্রেশন ব্যর্থ হয়েছে';
    if (e.code == 'weak-password') {
      message = 'পাসওয়ার্ড অন্তত ৬ অক্ষর প্রয়োজন';
    } else if (e.code == 'email-already-in-use') {
      message = 'এই ইমেইল ইতিমধ্যে ব্যবহার করা হয়েছে';
    }
    _showError(message);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('নতুন অ্যাকাউন্ট', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'ব্যবহারকারীর নাম',
                prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'ইমেইল',
                prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'পাসওয়ার্ড',
                prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'রেজিস্টার করুন',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // White text for better visibility
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text(
                'ইতিমধ্যে অ্যাকাউন্ট আছে? লগইন করুন',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}