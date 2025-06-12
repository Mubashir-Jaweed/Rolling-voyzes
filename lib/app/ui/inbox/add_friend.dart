import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:voyzi/app/controller/threads_controller.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController _searchController = TextEditingController();
    ThreadsControllers threadsControllers = ThreadsControllers();


void addFriendRequest()async {
  final query = _searchController.text;
  await threadsControllers.createRelationRequest(otherUserUniqueName: query);
}

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
            'Add Friend',
            style: TextStyle(
              fontSize: 40,
              height: 1,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF283752),
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        filled: false,
                        hintText: 'Enter user ID',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    addFriendRequest();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Color(0xff0148a5),
                      border: Border.all(
                        color: Color(0xFF125cb1),
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF125cb1).withOpacity(0.9),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Gap(20),
          Text(
            textAlign: TextAlign.center,
            'Share your ID. Add theirs.\n Keep the convo alive',
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
