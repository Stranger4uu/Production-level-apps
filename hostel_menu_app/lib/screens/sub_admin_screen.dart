import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubAdminScreen extends StatelessWidget {
  const SubAdminScreen({super.key});

  void updateMeal(BuildContext context, String id, String type) async {
    await FirebaseFirestore.instance
        .collection('menus')
        .doc(id)
        .update({'mealType': type});

    Navigator.pop(context);
  }

  void showDialogBox(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Meal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Breakfast"),
              onTap: () => updateMeal(context, id, 'breakfast'),
            ),
            ListTile(
              title: const Text("Lunch"),
              onTap: () => updateMeal(context, id, 'lunch'),
            ),
            ListTile(
              title: const Text("Dinner"),
              onTap: () => updateMeal(context, id, 'dinner'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Admin Panel"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menus')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    data['imageUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(data['name']),
                  subtitle: Text(
                      "Current: ${data['mealType'] ?? 'Not Assigned'}"),
                  onTap: () => showDialogBox(context, data.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}