import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'জরুরী চিকিৎসা সেবা',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'SiyamRupali',
      ),
      home: const LocationTrackerPage(),
    );
  }
}

class LocationTrackerPage extends StatefulWidget {
  const LocationTrackerPage({super.key});

  @override
  State<LocationTrackerPage> createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  double? latitude;
  double? longitude;
  String? address;
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> ambulances = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedDistrict;

  Future<void> loadDataFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/doctor_ambulance.json');
      final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;

      setState(() {
        if (selectedDistrict != null) {
          final districtKey = data.keys.firstWhere(
                (key) => key.toLowerCase().contains(selectedDistrict!.toLowerCase()),
            orElse: () => '',
          );

          if (districtKey.isNotEmpty && data[districtKey] != null) {
            final districtData = data[districtKey] as Map<String, dynamic>;

            doctors = (districtData['doctors'] as List<dynamic>?)?.map((doctor) {
              return {
                'name': doctor['name'] as String? ?? 'ডাক্তার',
                'department': doctor['department'] as String? ?? 'সাধারণ',
                'contact': doctor['contact'] as String? ?? 'N/A',
                'latitude': doctor['latitude'] as double? ?? 0.0,
                'longitude': doctor['longitude'] as double? ?? 0.0,
              };
            }).toList() ?? [];

            ambulances = (districtData['ambulances'] as List<dynamic>?)?.map((ambulance) {
              return {
                'name': ambulance['name'] as String? ?? 'অ্যাম্বুলেন্স',
                'phone_number': ambulance['phone_number'] as String? ?? 'N/A',
                'location': ambulance['location'] as String? ?? 'অজানা',
                'latitude': ambulance['latitude'] as double? ?? 0.0,
                'longitude': ambulance['longitude'] as double? ?? 0.0,
              };
            }).toList() ?? [];
          } else {
            doctors = [];
            ambulances = [];
          }
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'ডেটা লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('লোকেশন সেবা নিষ্ক্রিয় আছে। দয়া করে সক্রিয় করুন।');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('লোকেশন অনুমতি প্রদান করা হয়নি');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('লোকেশন অনুমতি স্থায়ীভাবে বন্ধ করা হয়েছে');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      await _getAddressFromCoordinates(position.latitude, position.longitude);
      await loadDataFromJson();
    } catch (e) {
      setState(() {
        errorMessage = 'লোকেশন পাওয়া যায়নি: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        setState(() {
          address = [
            if (place.street != null) place.street,
            if (place.subLocality != null) place.subLocality,
            if (place.locality != null) place.locality,
            if (place.administrativeArea != null) place.administrativeArea,
            if (place.country != null) place.country,
          ].where((part) => part != null).join(', ');

          if (place.administrativeArea?.toLowerCase().contains('sylhet') == true) {
            selectedDistrict = 'sylhet_sadar';
          } else if (place.administrativeArea?.toLowerCase().contains('moulvibazar') == true) {
            selectedDistrict = 'moulvibazar';
          } else if (place.administrativeArea?.toLowerCase().contains('sunamganj') == true) {
            selectedDistrict = 'sunamganj';
          } else if (place.administrativeArea?.toLowerCase().contains('habiganj') == true) {
            selectedDistrict = 'habiganj';
          } else {
            selectedDistrict = place.administrativeArea?.toLowerCase();
          }
        });
      }
    } catch (e) {
      setState(() => address = 'ঠিকানা পাওয়া যায়নি');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'কল করা সম্ভব হয়নি: $phoneNumber';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'ডেটা লোড হচ্ছে...',
                style: TextStyle(fontSize: 16, fontFamily: 'Siyamrupali'),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'ত্রুটি: $errorMessage',
            style: TextStyle(fontSize: 16, fontFamily: 'Siyamrupali'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'জরুরী চিকিৎসা সেবা',
          style: TextStyle(fontFamily: 'Siyamrupali'),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('বর্তমান অবস্থান'),
            if (address != null)
              _buildInfoCard(
                title: 'আপনার অবস্থান',
                content: address!,
                icon: Icons.location_on,
              ),

            const Divider(thickness: 2, height: 40),

            _buildSectionHeader('নিকটবর্তী ডাক্তার'),
            if (doctors.isEmpty)
              _buildEmptyState('কোন ডাক্তার পাওয়া যায়নি')
            else
              ...doctors.map((doctor) => _buildServiceCard(
                title: doctor['name'],
                subtitle: doctor['department'],
                phone: doctor['contact'],
                icon: Icons.medical_services,
                onTap: () => _makePhoneCall(doctor['contact']),
              )),

            const Divider(thickness: 2, height: 40),

            _buildSectionHeader('নিকটবর্তী অ্যাম্বুলেন্স'),
            if (ambulances.isEmpty)
              _buildEmptyState('কোন অ্যাম্বুলেন্স পাওয়া যায়নি')
            else
              ...ambulances.map((ambulance) => _buildServiceCard(
                title: ambulance['name'],
                subtitle: ambulance['location'],
                phone: ambulance['phone_number'],
                icon: Icons.local_hospital,
                onTap: () => _makePhoneCall(ambulance['phone_number']),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
          fontFamily: 'Siyamrupali',
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blue[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontFamily: 'Siyamrupali',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Siyamrupali',
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

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String phone,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.red[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontFamily: 'Siyamrupali',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Siyamrupali',
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: phone != 'N/A' ? onTap : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[500],
            fontFamily: 'Siyamrupali',
          ),
        ),
      ),
    );
  }
}