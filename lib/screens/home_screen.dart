import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verito/models/geofence.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _statusMessage = 'Checking Location...';
  bool _isCheckInEnabled = true;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE - d MMMM yyyy').format(now);
    final String formattedTime = DateFormat('h:mm a').format(now);
    List<Geofence> geoFences = [
      Geofence(
        id: "1",
        name: "Car Parking",
        latitude: 15.175448,
        longitude: 73.949296,
        radius: 10,
      ),
      Geofence(
        id: "2",
        name: "Slide Pool",
        latitude: 15.175858,
        longitude: 73.948252,
        radius: 10,
      ),
      Geofence(
        id: "3",
        name: "Splash Bar",
        latitude: 15.175573,
        longitude: 73.948259,
        radius: 10,
      ),
      Geofence(
        id: "4",
        name: "Restaurant",
        latitude: 15.175269,
        longitude: 73.948058,
        radius: 10,
      ),
      Geofence(
        id: "5",
        name: "Time Office",
        latitude: 15.175058,
        longitude: 73.947809,
        radius: 10,
      ),
    ];

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
                          "Hello ${widget.title}!",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xE8000000),
                          ),
                        ),
                        SizedBox(height: 1),
                        const Text(
                          "Ready for a productive day?",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _statusMessage = "Enabled button...";
                          _isCheckInEnabled = true;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      color: Colors.black.withOpacity(0.7),
                      tooltip: 'Refresh',
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
                "You're at: \$Location",
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

              SizedBox(height: 32),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 2,
                    colors: [Colors.grey.shade300, Colors.white70],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFD6D6D6),
                      offset: const Offset(0, 4),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isCheckInEnabled
                      ? () {
                          setState(() {
                            _statusMessage = "Checked in for today!";
                            _isCheckInEnabled = false;
                          });
                        }
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_outlined,
                        color: Colors.teal.shade800,
                        size: 48,
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Check In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),

              Text(
                "Locations assigned to you:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  fence.name,
                                  style: TextStyle(
                                    color: Colors.teal.shade900.withOpacity(0.85),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  " - Lat: ${fence.latitude.toStringAsFixed(4)}, Lon: ${fence.longitude.toStringAsFixed(4)}",
                                  style: TextStyle(
                                    color: Colors.teal.shade900.withOpacity(0.65),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            // subtitle: Text(
                            //   "Lat: ${fence.latitude.toStringAsFixed(4)}, Lon: ${fence.longitude.toStringAsFixed(4)}",
                            //   style: TextStyle(
                            //     color: Colors.black.withOpacity(0.6),
                            //     fontSize: 12,
                            //   ),
                            // ),
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
}
