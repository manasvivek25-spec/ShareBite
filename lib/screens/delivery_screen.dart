import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryScreen extends StatelessWidget {

  // 🔥 Safe priority function
  int getPriority(Timestamp? timestamp, int expiry) {
    if (timestamp == null) return 999999;

    final created = timestamp.toDate();
    final expiryTime = created.add(Duration(minutes: expiry));
    final diff = expiryTime.difference(DateTime.now()).inMinutes;

    return diff;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Delivery"),
          backgroundColor: Colors.green,
          bottom: TabBar(
            tabs: [
              Tab(text: "Active"),
              Tab(text: "History"),
            ],
          ),
        ),

        body: TabBarView(
          children: [

            // 🔥 ACTIVE TASKS
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('food_posts')
                  .where('delivery_status', whereIn: ['pending', 'picked'])
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No active deliveries"));
                }

                var docs = snapshot.data!.docs;

                // 🔥 Safe sorting
                docs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;

                  final aTime = aData['timestamp'] as Timestamp?;
                  final bTime = bData['timestamp'] as Timestamp?;

                  int aPriority =
                      getPriority(aTime, aData['expiry_minutes'] ?? 0);
                  int bPriority =
                      getPriority(bTime, bData['expiry_minutes'] ?? 0);

                  return aPriority.compareTo(bPriority);
                });

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {

                    var doc = docs[index];
                    var data = doc.data() as Map<String, dynamic>;

                    String status =
                        data['delivery_status'] ?? 'unknown';
                    String agent =
                        data['assigned_agent'] ?? 'Not assigned';

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(data['food_name'] ?? 'No Name'),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("📍 ${data['location'] ?? 'Unknown'}"),
                            Text("👤 $agent"),
                            Text("Status: $status"),
                          ],
                        ),

                        trailing: status == 'pending'
                            ? ElevatedButton(
                                child: Text("Pick"),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('food_posts')
                                      .doc(doc.id)
                                      .update({
                                    'delivery_status': 'picked',
                                  });
                                },
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: Text("Delivered"),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('food_posts')
                                      .doc(doc.id)
                                      .update({
                                    'delivery_status': 'delivered',
                                  });
                                },
                              ),
                      ),
                    );
                  },
                );
              },
            ),

            // 🔥 HISTORY TAB
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('food_posts')
                  .where('delivery_status', isEqualTo: 'delivered')
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No completed deliveries"));
                }

                var docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {

                    var data =
                        docs[index].data() as Map<String, dynamic>;

                    String agent =
                        data['assigned_agent'] ?? 'Unknown';

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(data['food_name'] ?? 'No Name'),
                        subtitle: Text("Delivered by $agent"),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}