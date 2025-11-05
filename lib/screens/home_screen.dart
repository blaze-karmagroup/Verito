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
            colors: [
              Color(0xFF0D052B), // Very dark, deep space purple
              Color(0xFF231A54),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80),
              Container(
                margin: EdgeInsets.only(left: 16, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${widget.title}!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Ready for a productive day?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
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
                      color: Colors.white.withOpacity(0.9),
                      tooltip: 'Refresh',
                    ),
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundColor: const Color(0xFFE91E63),
                    //   child: const Text(
                    //     'B',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 44,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                "You're at: \$Location",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.8),
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
                      color: Colors.grey.withOpacity(0.05),
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
                      color: Color(0xFF0D052B).withOpacity(0.8),
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
                          color: Color(0xFF0D052B).withOpacity(0.8),
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
                  boxShadow: _isCheckInEnabled
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE91E63).withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(5, 5),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            offset: const Offset(-5, -5),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                ),
                child: ElevatedButton(
                  onPressed: _isCheckInEnabled
                      ? () {
                          setState(() {
                            _statusMessage = "Checking In...";
                            _isCheckInEnabled = false;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    backgroundColor: _isCheckInEnabled
                        ? const Color(0xFFE91E63)
                        : Colors.grey.shade800.withOpacity(0.5),
                    disabledBackgroundColor: Colors.grey.shade800.withOpacity(
                      0.5,
                    ),
                    elevation: 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_outlined,
                        color: _isCheckInEnabled
                            ? Colors.white
                            : Colors.grey.shade500,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Check In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // Change text color based on state
                          color: _isCheckInEnabled
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey.shade500,
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
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),

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
                        color: Colors.white.withOpacity(0.65),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
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
                                    color: Color(0xFF0D052B).withOpacity(0.85),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  " - Lat: ${fence.latitude.toStringAsFixed(4)}, Lon: ${fence.longitude.toStringAsFixed(4)}",
                                  style: TextStyle(
                                    color: Color(0xFF0D052B).withOpacity(0.65),
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
                            color: const Color(0xFF0D052B).withOpacity(0.2),
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
