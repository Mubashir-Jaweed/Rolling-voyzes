import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class ThreadsControllers {

  final String currentUser;
  ThreadsControllers() : currentUser = FirebaseAuth.instance.currentUser!.uid;



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

  Future<void> createRelation(String otherUserId ,String otherUserName)async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);

    await userRef.update({
      'relations':FieldValue.arrayUnion([{'name':otherUserName, 'id': otherUserId , 'isAccepted': false}])
    });
   }

  Future<List<Map<String,dynamic>>> getHomies()async{
    final homies = await FirebaseFirestore.instance.collection('users').doc(currentUser).get();
    if (homies.exists) {
    final data = homies.data();
    final List<dynamic> relations = data?['relations'] ?? [];
    return List<Map<String, dynamic>>.from(relations);
  } else {
    return [];
  }
  }
}
