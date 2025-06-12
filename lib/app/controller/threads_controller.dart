import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class ThreadsControllers {
  final String currentUser;
  ThreadsControllers() : currentUser = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getAllUsers(String query) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser);
      final userSnapshot = await userRef.get();

      // Get the list of IDs already in 'relations'
      final List<dynamic> relations = userSnapshot.data()?['relations'] ?? [];
      final List<String> relatedIds =
          relations.map((rel) => rel['id'] as String).toList();

      // Query users by name
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uniqueId', isGreaterThanOrEqualTo: query)
          .where('uniqueId', isLessThan: query + 'z')
          .get();

      // Filter out users who are already in relations OR current user himself
      final filteredUsers = snapshot.docs
          .where((doc) {
            final userId = doc.id;
            return userId != currentUser && !relatedIds.contains(userId);
          })
          .map((doc) => doc.data())
          .toList();

      return filteredUsers;
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
    }
  }

  Future<void> createRelationRequest({
    required String otherUserUniqueName,
  }) async {
    if(otherUserUniqueName.isEmpty){
      print('Invalid user id');
      return;
    }

    final dedicatedUser = await FirebaseFirestore.instance.collection('users').where('uniqueId', isEqualTo: otherUserUniqueName).limit(1).get();
    if(dedicatedUser.docs.isEmpty){
      print('User not found!');
      return;
    }
    final dedicatedUserDocs = dedicatedUser.docs.first;


    final userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser);
    final requestedUserRef =
        FirebaseFirestore.instance.collection('users').doc(dedicatedUserDocs.id);

    // First fetch the requested user's data
    final requestedUserDoc = await requestedUserRef.get();
    if (!requestedUserDoc.exists) {
      print('user not found!');
      return;
    }
    final requestedUserData =
        requestedUserDoc.data()!; 

    await userRef.update({
      'relations': FieldValue.arrayUnion([
        {
          'id': requestedUserData['uid'],
          'isAccepted': false
        }
      ])
    });
    await requestedUserRef.update({
      'proposals': FieldValue.arrayUnion([
        {
          'id': currentUser,
          'isAccepted': false
        }
      ])
    });
    print('request sent');
  }

  Future<void> acceptProposal({required String otherUserID}) async {
    try {
      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser);
      final otherUserRef =
          FirebaseFirestore.instance.collection('users').doc(otherUserID);

      final currentUserRefSnapshot = await currentUserRef.get();
      final otherUserRefSnapshot = await otherUserRef.get();

      if (!currentUserRefSnapshot.exists || !otherUserRefSnapshot.exists) {
        throw Exception("User documents not found");
      }

      final currentUserData =
          currentUserRefSnapshot.data() as Map<String, dynamic>;
      final otherUserData = otherUserRefSnapshot.data() as Map<String, dynamic>;

      // Explicitly cast the lists and handle null cases
      final List<dynamic> proposalsDynamic = currentUserData['proposals'] ?? [];
      final List<Map<String, dynamic>> proposals =
          proposalsDynamic.whereType<Map<String, dynamic>>().toList();

      final List<dynamic> relationsDynamic = otherUserData['relations'] ?? [];
      final List<Map<String, dynamic>> otherUserRelations =
          relationsDynamic.whereType<Map<String, dynamic>>().toList();

      // Find the proposal and relation
      final targetedProposal = proposals.firstWhere(
        (proposal) => proposal['id'] == otherUserID,
        orElse: () => throw Exception("Proposal not found"),
      );

      final targetedRelation = otherUserRelations.firstWhere(
        (relation) => relation['id'] == currentUser,
        orElse: () => throw Exception("Relation not found"),
      );

      // Prepare updated data
      final updatedOtherUserRelation = {
        'id': targetedRelation['id'],
        'name': targetedRelation['name'],
        'email': targetedRelation['email'],
        'isAccepted': true,
      };

      final newRelation = {
        'id': targetedProposal['id'],
        'name': targetedProposal['name'],
        'email': targetedProposal['email'],
        'isAccepted': true,
      };

      // Batch write for atomic updates
      final batch = FirebaseFirestore.instance.batch();

      batch.update(currentUserRef, {
        'relations': FieldValue.arrayUnion([newRelation]),
        'proposals': FieldValue.arrayRemove([targetedProposal]),
      });

      batch.update(otherUserRef, {
        'relations': FieldValue.arrayUnion([updatedOtherUserRelation]),
      });
      batch.update(otherUserRef, {
        'relations': FieldValue.arrayRemove([targetedRelation]),
      });

      await batch.commit();
    } catch (e) {
      print('Error accepting proposal: $e');
      rethrow;
    }
  }

  // Future<void> acceptProposal({required String otherUserID}) async {
  //   final currentUserRef =
  //       FirebaseFirestore.instance.collection('users').doc(currentUser);
  //   final otherUserRef =
  //       FirebaseFirestore.instance.collection('users').doc(otherUserID);

  //   final currentUserRefSnapshot = await currentUserRef.get();
  //   final otherUserRefSnapshot = await otherUserRef.get();

  //   final currentUserData = currentUserRefSnapshot.data();
  //   final otherUserData = otherUserRefSnapshot.data();

  //   final List<Map> proposals = currentUserData?['proposals'] ?? [];
  //   Map<dynamic, dynamic> targetedProposal =
  //       proposals.firstWhere((proposal) => proposal['id'] == otherUserID);
  //   //  final targetedProposalIndex = proposals.indexWhere((proposal)=>proposal['id'] == otherUserID);

  //   final List<Map> otherUserRelations = otherUserData?['relations'] ?? [];
  //   Map<dynamic, dynamic> targetedRelation = otherUserRelations
  //       .firstWhere((relation) => relation['id'] == currentUser);

  //   final updatedOtherUserRelation = {
  //     'id': targetedRelation['id'],
  //     'name': targetedRelation['name'],
  //     'email': targetedRelation['email'],
  //     'isAccepted': true,
  //   };

  //   await currentUserRef.update({
  //     'relations': FieldValue.arrayUnion([
  //       {
  //         'id': targetedProposal['id'],
  //         'name': targetedProposal['name'],
  //         'email': targetedProposal['email'],
  //         'isAccepted': true,
  //       }
  //     ])
  //   });
  //   await currentUserRef.update({
  //     'proposals': FieldValue.arrayRemove([targetedProposal])
  //   });

  //   await otherUserRef.update({
  //     'relations': FieldValue.arrayRemove([targetedRelation])
  //   });
  //   await otherUserRef.update({
  //     'relations': FieldValue.arrayUnion([updatedOtherUserRelation])
  //   });
  // }

  Future<List<Map<String, dynamic>>> getHomies() async {
    final homies = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();
    if (homies.exists) {
      final data = homies.data();
      final List<dynamic> relations = data?['relations'] ?? [];
      return List<Map<String, dynamic>>.from(relations);
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProposals() async {
    final homies = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();
    if (homies.exists) {
      final data = homies.data();
      final List<dynamic> relations = data?['proposals'] ?? [];
      return List<Map<String, dynamic>>.from(relations);
    } else {
      return [];
    }
  }
  Future<int> getProposalsLength() async {
    final homies = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();
    if (homies.exists) {
      final data = homies.data();
      final List<dynamic> relations = data?['proposals'] ?? [];
      return  relations.length;
    } else {
      return 0;
    }
  }
}
