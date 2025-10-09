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
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE - d MMMM yyyy').format(now);
    final String formattedTime = DateFormat('h:mm a').format(now);
    String _statusMessage = 'Checking Location...';
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
      // appBar: AppBar(
      //   toolbarHeight: 140,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             "Hello ${widget.title}!",
      //             style: const TextStyle(
      //               fontWeight: FontWeight.bold,
      //               fontSize: 20,
      //               color: Color(0xE8000000),
      //             ),
      //           ),
      //           SizedBox(height: 2),
      //           const Text(
      //             "Good Day! Let's check your attendance",
      //             style: TextStyle(fontSize: 12),
      //           ),
      //         ],
      //       ),
      //
      //       CircleAvatar(
      //         radius: 20,
      //         backgroundColor: Colors.teal.shade800,
      //         child: const Text(
      //           'B',
      //           style: TextStyle(
      //             fontSize: 14,
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade100, Color(0xFFF8F0E3)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
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
                          "Good Day! Let's check your attendance",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.teal.shade800,
                      child: const Text(
                        'B',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
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
                style: const TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              Text(
                "You're at: \$Location",
                style: const TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
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
                width: 210,
                height: 210,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      color: Colors.teal.shade800,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Check In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              const Text(
                "Available Locations:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // Semi-bold is a modern choice
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),
              geoFences.isEmpty
                  ? const Center(
                      child: Text(
                        "No geofences found.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        itemCount: geoFences.length,
                        itemBuilder: (BuildContext context, int index) {
                          final fence = geoFences[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            dense: true,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(102),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nq36RWSTau36lw-ti2OaGGUQlfMyANebNnOJfzxFvXlUjgc5kuDwr1bOiNy2VY-wGpq4y0HI7ZB38eVaFigzbjfwGLOQObbgtCZf0w-Nvk4WVLlzWUYs2yOvFk_4LQFHoaQhqUZBA=s680-w680-h510-rw',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: Text(
                              fence.name,
                              style: TextStyle(
                                color: Colors.teal.shade900,
                                fontWeight: FontWeight.w500,
                              ),
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
                            color: Colors.teal.withOpacity(0.12),
                            indent: 16,
                            endIndent: 16,
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
