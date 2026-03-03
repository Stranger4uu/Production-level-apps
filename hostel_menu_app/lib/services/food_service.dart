import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFoodItem({
    required String name,
    required String imageUrl,
  }) async {
    await _firestore.collection('food_items').add({
      'name': name,
      'imageUrl': imageUrl,
    });
  }

  Stream<List<FoodItem>> getFoodItems() {
    return _firestore.collection('food_items').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => FoodItem.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> deleteFoodItem(String id) async {
    await _firestore.collection('food_items').doc(id).delete();
  }
}