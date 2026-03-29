import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import 'donor_screen.dart';
import 'receiver_screen.dart';
import 'delivery_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Logo(size: 30),
            SizedBox(width: 10),
            Text("ShareBite"),
          ],
        ),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔥 LOGO + TITLE
              Logo(size: 80),
              SizedBox(height: 10),

              Text(
                "ShareBite",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Share food, save lives",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Choose Your Role",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              // 🔥 FIRST ROW (Donor + Receiver)
              Row(
                children: [

                  // 🍱 DONOR
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DonorScreen()),
                        );
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("🍱", style: TextStyle(fontSize: 50)),
                              SizedBox(height: 10),
                              Text(
                                "Donor",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🤝 RECEIVER
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReceiverScreen()),
                        );
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("🤝", style: TextStyle(fontSize: 50)),
                              SizedBox(height: 10),
                              Text(
                                "Receiver",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              // 🔥 SECOND ROW (Delivery centered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DeliveryScreen()),
                        );
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("🚚", style: TextStyle(fontSize: 50)),
                              SizedBox(height: 10),
                              Text(
                                "Delivery",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}