import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadsControllers {
  Future<List<Map<String, dynamic>>> getAllUsers(String query) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching all users $e');
      return [];
    }
  }
}
