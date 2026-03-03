import 'package:cloud_firestore/cloud_firestore.dart';

class MenuService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> updateMenuWithIds({
    required List<String> breakfast,
    required List<String> lunch,
    required List<String> dinner,
  }) async {
    await _firestore.collection('menu').doc('today').set({
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot> getTodayMenu() {
    return _firestore
        .collection('menu')
        .doc('today')
        .snapshots();
  }

  Future<void> deleteMenu() async {
    await _firestore.collection('menu').doc('today').delete();
  }
}