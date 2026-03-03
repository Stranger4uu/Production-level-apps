import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  Widget buildSection(String title, List docs) {
    if (docs.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        ...docs.map((data) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: ListTile(
              leading: Image.network(
                data['imageUrl'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(data['name']),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Menu"),
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

          final breakfast = docs
              .where((d) => d['mealType'] == 'breakfast')
              .toList();

          final lunch =
          docs.where((d) => d['mealType'] == 'lunch').toList();

          final dinner =
          docs.where((d) => d['mealType'] == 'dinner').toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                buildSection("Breakfast", breakfast),
                buildSection("Lunch", lunch),
                buildSection("Dinner", dinner),
              ],
            ),
          );
        },
      ),
    );
  }
}