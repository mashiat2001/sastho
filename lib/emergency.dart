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
        scaffoldBackgroundColor: Color(0xFFEFF3FF),
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
  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> ambulances = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedArea;

  Future<void> loadDataFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/doctor_ambulance.json');
      final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;

      // Determine which area's data to show
      String areaKey = 'default';
      if (selectedArea != null) {
        if (selectedArea!.toLowerCase().contains('kamalbazar')) {
          areaKey = 'kamalbazar';
        } else if (selectedArea!.toLowerCase().contains('sylhet')) {
          areaKey = 'sylhet';
        } else if (selectedArea!.toLowerCase().contains('moulvibazar')) {
          areaKey = 'moulvibazar';
        } else if (selectedArea!.toLowerCase().contains('sunamganj')) {
          areaKey = 'sunamganj';
        } else if (selectedArea!.toLowerCase().contains('habiganj')) {
          areaKey = 'habiganj';
        }
      }

      setState(() {
        hospitals = (data[areaKey]?['hospitals'] as List<dynamic>?)?.map((hospital) {
          return {
            'name': hospital['name'] as String? ?? 'হাসপাতাল',
            'address': hospital['address'] as String? ?? 'ঠিকানা জানা নেই',
            'contact': hospital['contact'] as String? ?? 'N/A',
            'latitude': hospital['latitude'] as double? ?? 0.0,
            'longitude': hospital['longitude'] as double? ?? 0.0,
          };
        }).toList() ?? [];

        ambulances = (data[areaKey]?['ambulances'] as List<dynamic>?)?.map((ambulance) {
          return {
            'name': ambulance['name'] as String? ?? 'অ্যাম্বুলেন্স',
            'phone_number': ambulance['phone_number'] as String? ?? 'N/A',
            'location': ambulance['location'] as String? ?? 'অজানা',
            'latitude': ambulance['latitude'] as double? ?? 0.0,
            'longitude': ambulance['longitude'] as double? ?? 0.0,
          };
        }).toList() ?? [];
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

          // Special case for Kamalbazar
          if (place.subLocality?.toLowerCase().contains('kamalbazar') == true ||
              place.locality?.toLowerCase().contains('kamalbazar') == true) {
            selectedArea = 'kamalbazar';
          } else {
            selectedArea = place.administrativeArea;
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
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2171B5)),
              ),
              SizedBox(height: 20),
              Text(
                'আপনার অবস্থান খুঁজে বের করা হচ্ছে...',
                style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
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
            style: TextStyle(fontSize: 16, fontFamily: 'SiyamRupali'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'জরুরী চিকিৎসা সেবা',
          style: TextStyle(fontFamily: 'SiyamRupali'),
        ),
        backgroundColor: Color(0xFF2171B5),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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

            Divider(thickness: 2, height: 40),

            _buildSectionHeader('নিকটবর্তী হাসপাতাল'),
            if (hospitals.isEmpty)
              _buildEmptyState('কোন হাসপাতাল পাওয়া যায়নি')
            else
              ...hospitals.map((hospital) => _buildServiceCard(
                title: hospital['name'],
                subtitle: hospital['address'],
                phone: hospital['contact'],
                icon: Icons.local_hospital,
                onTap: () => _makePhoneCall(hospital['contact']),
              )),

            Divider(thickness: 2, height: 40),

            _buildSectionHeader('নিকটবর্তী অ্যাম্বুলেন্স'),
            if (ambulances.isEmpty)
              _buildEmptyState('কোন অ্যাম্বুলেন্স পাওয়া যায়নি')
            else
              ...ambulances.map((ambulance) => _buildServiceCard(
                title: ambulance['name'],
                subtitle: ambulance['location'],
                phone: ambulance['phone_number'],
                icon: Icons.airport_shuttle,
                onTap: () => _makePhoneCall(ambulance['phone_number']),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2171B5),
          fontFamily: 'SiyamRupali',
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
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Color(0xFF2171B5)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'SiyamRupali',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String phone,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: phone != 'N/A' ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Color(0xFF2171B5)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                  ],
                ),
              ),
              if (phone != 'N/A')
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.green),
                  onPressed: onTap,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontFamily: 'SiyamRupali',
          ),
        ),
      ),
    );
  }
}