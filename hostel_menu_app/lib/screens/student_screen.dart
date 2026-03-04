import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  String normalizeMealType(String value) {
    final lower = value.toLowerCase();
    if (lower == "breakfast") return "Breakfast";
    if (lower == "lunch") return "Lunch";
    if (lower == "dinner") return "Dinner";
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Menu")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menus').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No food available"));
          }

          List breakfast = [];
          List lunch = [];
          List dinner = [];

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;

            final Timestamp? createdAt = data['createdAt'];

            if (createdAt != null) {
              final createdTime = createdAt.toDate();
              final now = DateTime.now();

              if (now.difference(createdTime).inHours >= 5) {
                continue;
              }
            }

            final mealType = normalizeMealType(
              (data['mealType'] ?? "").toString(),
            );

            if (mealType == "Breakfast") {
              breakfast.add(data);
            } else if (mealType == "Lunch") {
              lunch.add(data);
            } else if (mealType == "Dinner") {
              dinner.add(data);
            }
          }

          Widget buildSection(String title, List items) {
            if (items.isEmpty) {
              return const SizedBox();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...items.map((data) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: data['imageUrl'] != null
                          ? Image.network(
                              data['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.fastfood);
                              },
                            )
                          : const Icon(Icons.fastfood),
                      title: Text(data['name'] ?? ''),
                    ),
                  );
                }).toList(),
              ],
            );
          }

          return ListView(
            children: [
              buildSection("Breakfast", breakfast),
              buildSection("Lunch", lunch),
              buildSection("Dinner", dinner),
            ],
          );
        },
      ),
    );
  }
}
