import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {

  final nameController = TextEditingController();
  final imageController = TextEditingController();

  bool isLoading = false;

  Future<void> saveFood() async {
    if (nameController.text.trim().isEmpty ||
        imageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields required")),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection('menus').add({
      'name': nameController.text.trim(),
      'imageUrl': imageController.text.trim(),
      'mealType': null,
      'createdAt': Timestamp.now(),
    });

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Food")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Food Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: isLoading ? null : saveFood,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}