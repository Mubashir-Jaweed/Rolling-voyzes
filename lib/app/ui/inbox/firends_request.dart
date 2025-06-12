import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => FriendRequestsState();
}

class FriendRequestsState extends State<FriendRequests> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(color: Color(0xff011a3a)),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(35),
          Text(
            textAlign: TextAlign.center,
            'Incoming Friend \nRequests',
            style: TextStyle(
              fontSize: 40,
              height: 1,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(20),
        
          Text(
            textAlign: TextAlign.center,
            "Don't see friend requests yet!",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff2e90d0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
