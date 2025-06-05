import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class ThreadsControllers {

  final String currentUser;
  ThreadsControllers() : currentUser = FirebaseAuth.instance.currentUser!.uid;



 Future<List<Map<String, dynamic>>> getAllUsers(String query) async {
  try {
    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
    final userSnapshot = await userRef.get();

    // Get the list of IDs already in 'relations'
    final List<dynamic> relations = userSnapshot.data()?['relations'] ?? [];
    final List<String> relatedIds = relations.map((rel) => rel['id'] as String).toList();

    // Query users by name
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();

    // Filter out users who are already in relations OR current user himself
    final filteredUsers = snapshot.docs.where((doc) {
      final userId = doc.id;
      return userId != currentUser && !relatedIds.contains(userId);
    }).map((doc) => doc.data()).toList();

    return filteredUsers;
  } catch (e) {
    print('Error fetching all users: $e');
    return [];
  }
}


  Future<void> createRelation(String otherUserId, )async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
    final requestedUser = FirebaseFirestore.instance.collection('users').doc(otherUserId);

    await userRef.update({
      'relations':FieldValue.arrayUnion([{'id': otherUserId , 'isAccepted': false}])
    });

    await requestedUser.update({
      'proposals':FieldValue.arrayUnion([{'id': currentUser , 'isAccepted': false}])
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
