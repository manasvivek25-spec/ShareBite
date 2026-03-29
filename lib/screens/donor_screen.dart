import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorScreen extends StatefulWidget {
  @override
  _DonorScreenState createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController foodController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  void submitFood() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance.collection('food_posts').add({
        'food_name': foodController.text,
        'quantity': quantityController.text,
        'location': locationController.text,
        'expiry_minutes': int.parse(expiryController.text),

        'status': 'available',
        'delivery_status': 'none',
        'assigned_agent': '',

        'timestamp': FieldValue.serverTimestamp(),
      });

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
        backgroundColor: Colors.green,
        elevation: 2,
        title: Row(
          children: [
            Logo(size: 30),
            SizedBox(width: 10),
            Text("ShareBite"),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: foodController,
                decoration: InputDecoration(labelText: "Food Name"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter food name";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter quantity";
                  }
                  if (int.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter location";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: expiryController,
                decoration: InputDecoration(labelText: "Expiry (minutes)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter expiry time";
                  }
                  int? val = int.tryParse(value);
                  if (val == null || val <= 0) {
                    return "Enter valid minutes";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: submitFood,
                child: Text("Submit"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}