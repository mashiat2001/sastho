import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'favorite.dart';
import 'colors.dart';
import 'login.dart'; // Make sure to import your login page
import 'verification.dart';
class Dashboard extends StatefulWidget {
  final bool guestMode;
  const Dashboard({Key? key, required this.guestMode}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String username = '';
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> features = [
    {'title': 'গর্ভাবস্থা সম্পর্কিত তথ্য', 'image': 'assets/pregnancy.png', 'route': '/pregnancy_page', 'isFavorite': false},
    {'title': 'প্রাথমিক চিকিৎসা', 'image': 'assets/first_aid.png', 'route': '/first_aid', 'isFavorite': false},
    {'title': 'মানসিক স্বাস্থ্য', 'image': 'assets/mentalhealth.png', 'route': '/mental_health_page', 'isFavorite': false},
    {'title': 'জরুরী সেবা', 'image': 'assets/emergency.png', 'route': '/emergency', 'isFavorite': false},
    {'title': 'বিএমআই ডায়েট', 'image': 'assets/bmi.png', 'route': '/bmi_page', 'isFavorite': false},
    {'title': 'ঔষধ রিমাইন্ডার', 'image': 'assets/remainder.png', 'route': '/medication', 'isFavorite': false},
  ];

  List<Map<String, dynamic>> filteredFeatures = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref('users');
  late Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    filteredFeatures = List.from(features);
    _authStateChanges = _auth.authStateChanges();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (!widget.guestMode) {
      await _checkAuthState();
      await getUserData();
    } else {
      username = 'অতিথি ব্যবহারকারী';
    }
    setState(() => isLoading = false);
  }

  Future<void> _checkAuthState() async {
    final user = _auth.currentUser;
    if (user == null) {
      // If user is not logged in, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
      return;
    }

    if (!user.emailVerified && !widget.guestMode) {
      // If email is not verified, redirect to verification page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerificationPage()),
        );
      });
    }
  }

  Future<void> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot = await _userRef.child(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          username = data['username'] ?? 'ব্যবহারকারী';
          List<String> userFavorites = List<String>.from(data['favorites'] ?? []);
          for (var feature in features) {
            feature['isFavorite'] = userFavorites.contains(feature['title']);
          }
          filteredFeatures = List.from(features);
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void filterFeatures(String query) {
    setState(() {
      filteredFeatures = features.where((feature) {
        return feature['title'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      final featureTitle = filteredFeatures[index]['title'];
      final mainIndex = features.indexWhere((f) => f['title'] == featureTitle);

      if (mainIndex != -1) {
        features[mainIndex]['isFavorite'] = !features[mainIndex]['isFavorite'];
        filteredFeatures[index]['isFavorite'] = features[mainIndex]['isFavorite'];
      }
    });

    if (!widget.guestMode) {
      final user = _auth.currentUser;
      if (user != null) {
        final updatedFavorites = features
            .where((feature) => feature['isFavorite'])
            .map((feature) => feature['title'])
            .toList();
        _userRef.child(user.uid).update({'favorites': updatedFavorites});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStateChanges,
      builder: (context, snapshot) {
        // Handle auth state changes
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null && !widget.guestMode) {
            // User signed out, redirect to login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            });
          } else if (snapshot.data != null &&
              !snapshot.data!.emailVerified &&
              !widget.guestMode) {
            // Email not verified, redirect to verification
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VerificationPage()),
              );
            });
          }
        }

        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('স্বাস্থ্য সহায়িকা'),
            backgroundColor: AppColors.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
          drawer: _buildAppDrawer(),
          body: _buildMainContent(),
        );
      },
    );
  }

  Widget _buildAppDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.guestMode ? 'অতিথি ব্যবহারকারী' : username),
            accountEmail: null,
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryColor),
            ),
            decoration: const BoxDecoration(color: AppColors.primaryColor),
          ),

          if (widget.guestMode)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'প্রোফাইল দেখতে লগইন করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

          if (!widget.guestMode) ...[
            _buildDrawerTile(
              icon: Icons.person,
              title: 'প্রোফাইল',
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _buildDrawerTile(
              icon: Icons.star,
              title: 'পছন্দসমূহ',
              onTap: _navigateToFavorites,
            ),
            const Divider(),
            _buildDrawerTile(
              icon: Icons.exit_to_app,
              title: 'লগআউট',
              onTap: _handleLogout,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: const TextStyle(color: AppColors.textColor)),
      onTap: onTap,
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'স্বাস্থ্য সেবাসমূহ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: filterFeatures,
              decoration: const InputDecoration(
                hintText: 'খুঁজুন...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: filteredFeatures.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) => _buildFeatureCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(int index) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, filteredFeatures[index]['route']),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  filteredFeatures[index]['image'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                filteredFeatures[index]['title'],
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              IconButton(
                icon: Icon(
                  filteredFeatures[index]['isFavorite'] ? Icons.star : Icons.star_border,
                  color: filteredFeatures[index]['isFavorite'] ? Colors.amber : Colors.grey,
                ),
                onPressed: () => toggleFavorite(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteFeaturesPage(
          favoriteFeatures: features.where((f) => f['isFavorite']).toList(),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}