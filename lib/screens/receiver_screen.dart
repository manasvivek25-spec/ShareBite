import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
class ReceiverScreen extends StatelessWidget {

  // ✅ Correct function (no @override)
  String getRemainingTime(Timestamp? timestamp, int expiryMinutes) {
    if (timestamp == null) return "Unknown";

    final createdTime = timestamp.toDate();
    final expiryTime = createdTime.add(Duration(minutes: expiryMinutes));
    final now = DateTime.now();

    final diff = expiryTime.difference(now);

    if (diff.isNegative) {
      return "Expired";
    }

    return "${diff.inHours}h ${diff.inMinutes % 60}m left";
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('food_posts')
            .where('status', isEqualTo: 'available')
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No food available"));
          }

          var docs = snapshot.data!.docs;

          // ✅ SINGLE correct smart sort
          docs.sort((a, b) {
            final aTime = a['timestamp'] as Timestamp?;
            final bTime = b['timestamp'] as Timestamp?;

            final aExpiry = aTime?.toDate().add(
              Duration(minutes: a['expiry_minutes'] ?? 0),
            );

            final bExpiry = bTime?.toDate().add(
              Duration(minutes: b['expiry_minutes'] ?? 0),
            );

            if (aExpiry == null || bExpiry == null) return 0;

            int result = aExpiry.compareTo(bExpiry);

            if (result == 0) {
              int aQty = int.tryParse(a['quantity'].toString()) ?? 0;
              int bQty = int.tryParse(b['quantity'].toString()) ?? 0;
              return bQty.compareTo(aQty);
            }

            return result;
          });

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                child: Padding(
                  padding: EdgeInsets.all(12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
  data['food_name'] ?? 'No Name',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2E7D32),
  ),
),

                      SizedBox(height: 5),

                      Text("🍽 Quantity: ${data['quantity'] ?? 'N/A'}"),
                      Text(
  "📍 Location: ${data['location'] ?? 'Unknown'}",
  style: TextStyle(color: Color(0xFF1565C0)),
),
                      TextButton(
  child: Text("View Location"),
  onPressed: () {
    openMap(data['location']);
  },
),
                      Text(
  "⏱ ${getRemainingTime(data['timestamp'], data['expiry_minutes'] ?? 0)}",
  style: TextStyle(
    color: Color(0xFFFBC02D),
    fontWeight: FontWeight.bold,
  ),
),
Text(
  "🚚 Delivery: ${data['delivery_status'] ?? 'Not assigned'}",
  style: TextStyle(color: Colors.orange),
),

Text(
  "👤 Agent: ${data['assigned_agent'] ?? 'Not assigned'}",
),
                      SizedBox(height: 10),

                     Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [

    // ✅ Accept Button
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2E7D32),
      ),
      child: Text(
        "Accept",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('food_posts')
            .doc(data.id)
            ..update({
  'status': 'accepted',
  'delivery_status': 'pending',
  'assigned_agent': 'Agent 1',
});
      },
    ),


    

  ],
),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  void openMap(String location) async {
  final url = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$location",
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw "Could not open map";
  }
}
}