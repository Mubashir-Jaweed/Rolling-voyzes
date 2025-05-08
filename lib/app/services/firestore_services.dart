import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> getRandomPrompt() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('prompts').get();

      if (querySnapshot.docs.isEmpty) return null;

      final List<String> prompts = querySnapshot.docs
          .map((doc) => doc['prompt'] as String)
          .toList();

      final randomIndex = Random().nextInt(prompts.length);
      return prompts[randomIndex];
    } catch (e) {
      print('Error fetching random prompt: $e');
      return null;
    }
  }
}
