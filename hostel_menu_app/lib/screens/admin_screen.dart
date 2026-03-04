import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_food_screen.dart';

class AdminScreen extends StatefulWidget {
  final String role;

  const AdminScreen({super.key, required this.role});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  String normalizeMealType(String value) {
    final lower = value.toLowerCase();
    if (lower == "breakfast") return "Breakfast";
    if (lower == "lunch") return "Lunch";
    if (lower == "dinner") return "Dinner";
    return "Breakfast";
  }

  Future<void> deleteMenu(String docId) async {
    await FirebaseFirestore.instance
        .collection('menus')
        .doc(docId)
        .delete();
  }

  // UPDATE MENU
  Future<void> updateMenu(String docId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('menus')
        .doc(docId)
        .update(data);
  }

  void showUpdateDialog(String docId, Map<String, dynamic> oldData) {
    final nameController =
        TextEditingController(text: oldData['name']);
    final imageUrlController =
        TextEditingController(text: oldData['imageUrl']);

    String selectedMealType = normalizeMealType(
        (oldData['mealType'] ?? "Breakfast").toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Food"),
              content: SingleChildScrollView(
                child: Column(
                  children: [

                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: "Name"),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedMealType,
                      decoration: const InputDecoration(
                          labelText: "Meal Type"),
                      items: const [
                        DropdownMenuItem(
                            value: "Breakfast",
                            child: Text("Breakfast")),
                        DropdownMenuItem(
                            value: "Lunch",
                            child: Text("Lunch")),
                        DropdownMenuItem(
                            value: "Dinner",
                            child: Text("Dinner")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedMealType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: imageUrlController,
                      decoration:
                          const InputDecoration(labelText: "Image URL"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {

                    // update the food
                    await updateMenu(docId, {
                      "name": nameController.text,
                      "mealType": selectedMealType,
                      "imageUrl": imageUrlController.text,
                      "updatedAt": FieldValue.serverTimestamp(),
                    });

                    // 🔔 send notification trigger
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .add({
                      "title": "Menu Updated",
                      "body": "Today's hostel menu has been updated.",
                      "createdAt": FieldValue.serverTimestamp(),
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final isMainAdmin = widget.role == 'main_admin';
    final isSubAdmin = widget.role == 'sub_admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      floatingActionButton: isMainAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddFoodScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menus')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No items found"),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final item = docs[index];
              final data =
                  item.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: data['imageUrl'] != null
                      ? Image.network(
                          data['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.fastfood),

                  title: Text(data['name'] ?? ''),
                  subtitle: Text(
                      normalizeMealType(
                          (data['mealType'] ?? "").toString())
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      if (isMainAdmin || isSubAdmin)
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.blue),
                          onPressed: () =>
                              showUpdateDialog(item.id, data),
                        ),

                      if (isMainAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () =>
                              deleteMenu(item.id),
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
}