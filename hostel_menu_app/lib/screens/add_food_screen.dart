import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {

  final nameController = TextEditingController();
  final imageUrlController = TextEditingController();

  String selectedMealType = "Breakfast";

  Future<void> addFood() async {

    if (nameController.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('menus')
        .add({
      "name": nameController.text,
      "mealType": selectedMealType,
      "imageUrl": imageUrlController.text,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: "Food Name"),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedMealType,
              decoration:
                  const InputDecoration(labelText: "Meal Type"),
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

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addFood,
              child: const Text("Add Food"),
            ),
          ],
        ),
      ),
    );
  }
}