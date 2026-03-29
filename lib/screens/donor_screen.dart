import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorScreen extends StatefulWidget {
  @override
  _DonorScreenState createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final TextEditingController foodController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  void submitFood() async {
    print("STEP 1: Button clicked");

    try {
      // Convert expiry safely
      int expiryMinutes = int.tryParse(expiryController.text) ?? 60;

      await FirebaseFirestore.instance.collection('food_posts').add({
        'food_name': foodController.text,
        'quantity': quantityController.text,
        'location': locationController.text,
        'expiry_minutes': expiryMinutes, 
        'status': 'available',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("STEP 2: Data sent successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Food Submitted!")),
      );

      foodController.clear();
      quantityController.clear();
      locationController.clear();
      expiryController.clear();

    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  elevation: 3,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF2E7D32),
          Color(0xFF1565C0),
        ],
      ),
    ),
  ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: foodController,
              decoration: InputDecoration(labelText: "Food Name"),
            ),

            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: "Quantity"),
            ),

            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),

            TextField(
              controller: expiryController,
              decoration: InputDecoration(
                labelText: "Expiry (minutes)",
              ),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitFood,
              child: Text("Submit"),
            ),

          ],
        ),
      ),
    );
  }
}