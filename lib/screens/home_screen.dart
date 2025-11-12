import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:verito/models/geofence.dart';
import 'package:verito/screens/mobile_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  String _authStatusMessage = '';
  List<Geofence> geoFences = [];
  String _statusMessage = 'Checking Location...';
  bool _isCheckInEnabled = false;
  Map<String, dynamic>? _currentEmployee;
  bool _isLoading = false;
  Geofence? _currentGeofence;

  @override
  void initState() {
    super.initState();
    _fetchUserFromApi();
    _initLocationFlow();
  }

  bool isInsideGeofence(Position userPosition, Geofence geofence) {
    double distanceBetween = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      geofence.latitude,
      geofence.longitude,
    );

    return distanceBetween <= geofence.radius;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE - d MMMM yyyy').format(now);
    final String formattedTime = DateFormat('h:mm a').format(now);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade200, Color(0xFFF8F0E3)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 72),
              Container(
                margin: EdgeInsets.only(left: 16, right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${_currentEmployee?['Employee_Name'] ?? 'User'}!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 1),
                        const Text(
                          "Ready for a productive day?",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _initLocationFlow,
                          icon: const Icon(Icons.refresh),
                          color: Colors.black.withOpacity(0.7),
                          tooltip: 'Refresh',
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          onPressed: _logOut,
                          icon: Icon(Icons.logout),
                          color: Colors.black.withOpacity(0.7),
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 44,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              Text(
                "📍${_currentGeofence?.name ?? 'Unregistered Location'}",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 24),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.teal.shade700,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.teal.shade900.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
              Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _isCheckInEnabled
                          ? Colors.teal.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isCheckInEnabled ? _checkIn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_outlined,
                        color: Colors.white.withOpacity(0.9),
                        size: 26,
                      ),
                      const SizedBox(width: 6),

                      Text(
                        "Check In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Locations assigned to you:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 8),

              geoFences.isEmpty
                  ? const Center(
                      child: Text(
                        "Available locations will be shown here...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        shrinkWrap: true,
                        itemCount: geoFences.length,
                        itemBuilder: (BuildContext context, int index) {
                          final fence = geoFences[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fence.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.teal.shade900.withOpacity(
                                      0.85,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Lat: ${fence.latitude.toStringAsFixed(4)}, Lon: ${fence.longitude.toStringAsFixed(4)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.teal.shade900.withOpacity(
                                      0.65,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.teal.withOpacity(0.2),
                            // indent: 16,
                            // endIndent: 16,
                          );
                        },
                      ),
                    ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _logOut() {
    FirebaseAuth.instance.signOut();
    print('Logged out manually.');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Logged out successfully.")));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthMobile()),
    );
  }

  void _checkUserGeofences(Position userPosition, List<Geofence> geofences) {
    if (geofences.isEmpty) {
      setState(() {
        _statusMessage = "No geofences assigned to you.";
      });
      return;
    }

    Geofence? foundFence;

    for (var fence in geofences) {
      if (isInsideGeofence(userPosition, fence)) {
        foundFence = fence;
        setState(() => _isCheckInEnabled = true);
        break;
      } else {
        setState(() => _isCheckInEnabled = false);
      }
    }

    setState(() {
      _currentGeofence = foundFence;
      if (foundFence != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "You're in ${foundFence.name} \n Lat: ${foundFence.latitude} \n Lon: ${foundFence.longitude}",
            ),
          ),
        );
        _statusMessage = "You're in ${foundFence.name}";
      } else {
        _statusMessage = "You are not in any location assigned to you.";
        _currentGeofence = null;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("You're not in any GeoFence")));
      }
    });
  }

  Future<void> _fetchUserFromApi() async {
    setState(() => _isLoading = true);
    final userToken = FirebaseAuth.instance.currentUser;
    print('Fetched User Token: $userToken');

    if (userToken == null || userToken.uid.isEmpty) {
      print("User not logged in or phone number is missing from token.");
      if (mounted) {
        setState(() {
          _authStatusMessage = "Could not verify user.";
          _isLoading = false;
        });
      }
      return;
    }

    String rawUid = userToken.uid;
    String? userPhoneNumber;

    print('Logged in user phone: $userPhoneNumber');

    if (rawUid.startsWith("phone_")) {
      userPhoneNumber = rawUid.substring(6);
    } else {
      print("UID does not have the 'phone_' prefix. Using raw UID.");
      userPhoneNumber = rawUid;
    }

    print("Attempting to fetch $userPhoneNumber from API...");

    final url = Uri.parse(
      'http://192.168.10.128:8080/employee?mobile=+$userPhoneNumber',
    );
    print('Calling Api from: $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (!mounted) return;

      print("Response Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> employee = jsonDecode(response.body);
        print("Fetched employee: $employee");
        setState(() {
          _currentEmployee = employee;
          _isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode}");
        if (mounted) {
          setState(() {
            _authStatusMessage = "Server Error: ${response.statusCode}";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("_fetchUserFromApi Error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _initLocationFlow() async {
    bool ready = await checkLocationAndPermission(context);
    setState(() {
      _statusMessage = "Initializing Location Flow...";
    });
    if (!ready) {
      setState(() {
        _statusMessage = "Location check failed. (Location/GPS not enabled)";
      });
      return;
    }

    try {
      LocationSettings settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: settings,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentPosition = position;
        _statusMessage = "Location acquired...";
      });

      final List<Geofence>? fetchedGeofences = await _fetchAssignedGeofences();

      if (fetchedGeofences != null) {
        _checkUserGeofences(position, fetchedGeofences);
      } else {
        setState(() {
          _statusMessage = "Could not load geofence data from server.";
        });
      }

      print("Current Position: ${position.latitude}, ${position.longitude}");
    } on TimeoutException {
      setState(() {
        _statusMessage = 'Error: Location fetch timed out';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error fetching location: ${e.toString()}';
      });
    }
  }

  Future<void> _checkIn() async {
    if (_currentEmployee == null) {
      print("User not logged in or token not found.");
      if (mounted) {
        setState(() {
          _authStatusMessage = "_checkIn error: Could not verify user.";
        });
      }
      return;
    }

    if (_currentGeofence == null) {
      print("Cannot record attendance: Not inside any geofence.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Attendance can only be marked inside a designated area.",
          ),
        ),
      );
      return;
    }

    if (_currentPosition == null) {
      print("Cannot record attendance: Current location is unknown.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not determine your current location."),
        ),
      );
      return;
    }

    print("Attempting to insert user attendance through API...");

    final Map<String, dynamic> attendanceData = {
      'Employee_ID': _currentEmployee!['Employee_ID'],
      'Employee_Name': _currentEmployee!['Employee_Name'],
      'Date_Time': DateTime.now().toIso8601String(),
      'Mobile_no': _currentEmployee!['Mobile_no'],
      'Geofence_Name': _currentGeofence!.name,
      'Coordinates': {
        'lat': _currentPosition!.latitude,
        'lon': _currentPosition!.longitude,
      },
    };

    print('Attendance Data: $attendanceData');

    try {
      final url = Uri.parse('http://192.168.10.128:8080/record-attendance');
      print('Calling Api from: $url');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(attendanceData),
          )
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Attendance recorded successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Attendance with location recorded successfully"),
          ),
        );
        setState(() => _isCheckInEnabled = false);

        Future.delayed(const Duration(seconds: 20), () {
          print('Enabling mark attendance button after 20 seconds...');
          if (mounted) {
            setState(() => _isCheckInEnabled = true);
          }
        });
      } else {
        print('Failed to record attendance: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to record attendance")),
        );
      }
    } catch (e) {
      print("_recordAttendance Error: $e");
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error in _recordAttendance: $e")));
    }
  }

  Future<List<Geofence>?> _fetchAssignedGeofences() async {
    try {
      final url = Uri.parse('http://192.168.10.128:8080/geofences');
      print('Calling Api from: $url');

      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> geofenceData = jsonDecode(response.body);

        final List<Geofence> fetchedGeofences = geofenceData
            .map((item) => Geofence.fromJson(item))
            .toList();

        setState(() {
          geoFences = fetchedGeofences;
        });

        print("Fetched geofences: $fetchedGeofences");
        return fetchedGeofences;
      }
    } catch (e) {
      print("_fetchAssignedGeofences Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching geofences.")),
      );
    }
    return null;
  }

  Future<bool> checkLocationAndPermission(BuildContext context) async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enable Location"),
          content: const Text(
            'Location is turned off. Please enable GPS to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
      return false;
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Permission Needed"),
            content: const Text(
              'This app needs location permission to work. Please allow it.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Retry"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Geolocator.openAppSettings();
                },
                child: const Text("Open App Settings"),
              ),
            ],
          ),
        );
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Permanently Denied"),
          content: const Text(
            'This app needs location permission to work. Please allow it from settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Geolocator.openAppSettings();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
