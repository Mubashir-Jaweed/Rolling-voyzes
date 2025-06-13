import 'package:flutter/material.dart';

class RelationCard extends StatelessWidget {
  const RelationCard({super.key, required this.user});

  final Map user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${user['avatar']} '
      ),
    );
  }
}