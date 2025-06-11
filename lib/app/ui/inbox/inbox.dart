import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/controller/threads_controller.dart';
import 'package:voyzi/app/ui/inbox/add_friend.dart';
import 'package:voyzi/app/ui/widgets/background_border_container.dart';
import 'package:voyzi/app/utils/constants/app_border_radius.dart';
import 'package:voyzi/app/utils/constants/app_constants.dart';
import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
import 'package:voyzi/app/utils/constants/app_strings.dart';
import 'package:voyzi/app/utils/helpers/app_utils.dart';
import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:voyzi/app/utils/themes/app_theme.dart';

import '../../../gen/assets.gen.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/list_tile.dart';

class Inbox extends GetItHook {
  Inbox({super.key, required this.selectedIndex});

  RxInt selectedIndex;

  @override
  // TODO: implement canDisposeController
  bool get canDisposeController => false;
  ThreadsControllers threadsControllers = ThreadsControllers();
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  RxList<Map<String, dynamic>> searchedUsers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> proposals = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  List<String> names = [
    'Eddie',
    'Talayah',
    'Xtendo',
    'Trey',
    'Eddie',
  ];

  List<String> assets = [
    Assets.png.eddie.path,
    Assets.png.talayah.path,
    Assets.png.xtendo.path,
    Assets.png.trey.path,
    Assets.png.eddie.path,
  ];

  void searchNewUsers(String query) async {
    final results = await threadsControllers.getAllUsers(query);
    searchedUsers.assignAll(results);
    print('..............Fetched ${searchedUsers.length} users');
  }

  void createRelation(Map user) async {
    await threadsControllers.createRelationRequest(
      otherUserId: user['uid'],
      otherUserEmail: user['email'],
      otherUserName: user['name'],
    );
    searchedUsers
        .removeAt(searchedUsers.indexWhere((u) => u['uid'] == user['uid']));

    //snack bar
  }

  Stream<List<Map<String, dynamic>>> getHomies() async* {
    isLoading.value = true;
    try {
      final homies = await threadsControllers.getHomies();
      yield homies;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<Map<String, dynamic>>> getProposals() async* {
    final proposals = await threadsControllers.getProposals();
    yield proposals;
  }

  void handleSearch(String query) async {
    searchQuery.value = query;
    if (query.isNotEmpty) {
      searchNewUsers(query);
    } else {
      searchedUsers.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    final appStyles = AppStyles.of(context);
    return Container(
        decoration: BoxDecoration(color: Color(0xff011a3a)),
        child: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              child: Center(
                  child: Text(
                'All Chats',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              )),
            ),
            Expanded(
              child: StreamBuilder(
                stream: getHomies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('Try again after some time')); // Error state
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [NoContactFound()]);
                  } else {
                    final relations = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: relations.length,
                      itemBuilder: (context, index) {
                        final user = relations[index];
                        return ListTile(
                          title: Text(
                            '${user['name']}',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          subtitle: Text('${user['email']}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 3)),
                            child: Icon(
                              Icons.person_outlined,
                              size: 35,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                              '${!user['isAccepted'] ? ' request pending' : ''}'),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget WaveShapes({required AppColors appColors}) {
    double imgHeight = 20;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ImageView(
            imagePath: Assets.png.waveform2RemovebgPreview.path,
            height: imgHeight,
            color: appColors.blue,
          ),
          ImageView(
            imagePath: Assets.png.waveform3RemovebgPreview.path,
            height: imgHeight,
            color: appColors.blue,
          ),
          ImageView(
            imagePath: Assets.png.waveform4RemovebgPreview.path,
            height: imgHeight,
            color: appColors.blue,
          ),
          ImageView(
            imagePath: Assets.png.waveform3RemovebgPreview.path,
            height: imgHeight,
            color: appColors.blue,
          ),
          ImageView(
            imagePath: Assets.png.waveform4RemovebgPreview.path,
            height: imgHeight,
            color: appColors.blue,
          ),
          // ImageView(
          //   imagePath: Assets.png.waveform5RemovebgPreview.path,
          //   height: imgHeight,
          //   color: appColors.blue,
          // ),
        ],
      ),
    );
  }
}

class NoContactFound extends StatelessWidget {
  const NoContactFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Don't see many chats yet?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Gap(6),
          Text(
            "Add a user Id to connect \n with more people.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 17,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(()=>AddFriend());
            },
            child: Container(
              width: 300,
              margin: EdgeInsets.symmetric(vertical: 30),
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff0d4376),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff02203a),
                        Color(0xff062f54),
                      ]),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff0c4373).withOpacity(0.5),
                      blurRadius: 20,
                      offset: Offset(0, 0),
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(
                    Icons.add,
                    size: 28,
                  ),
                  Text(
                    'ADD FRIEND',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


// Padding(
    //   // padding: AppEdgeInsets.h16(),
    //   padding: EdgeInsets.zero,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Gap(MediaQuery.of(context).padding.top),
    //       Padding(
    //         padding: AppEdgeInsets.h16(),
    //         child: Row(
    //           children: [
    //             ImageView(
    //               imagePath: Assets.png.frame2.path,
    //               width: Constants.appBarHeaderImagesize,
    //               color: appColors.black,
    //               alignment: Alignment.centerLeft,
    //               margin: EdgeInsets.zero,
    //             ),
    //             const Spacer(),
    //             Obx(() {
    //               return selectedIndex.value == 2
    //                   ? Text(
    //                       AppStrings.T.edit,
    //                       style: appStyles.s20w700Black.copyWith(
    //                           letterSpacing: -0.5, fontWeight: FontWeight.w300),
    //                     )
    //                   : SizedBox();
    //             }),
    //             Gap(20)
    //           ],
    //         ),
    //       ),
    //       Gap(10),
    //       Expanded(
    //           child: SingleChildScrollView(
    //         padding: AppEdgeInsets.h16(),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'Threads',
    //               style: appStyles.s26w700Black
    //                   .copyWith(fontSize: 45, height: 1.3),
    //             ),
    //             TextField(
    //               onChanged: (value) {
    //                 handleSearch(value);
    //               },
    //               onSubmitted: (value) {
    //                 handleSearch(value);
    //                 FocusScope.of(context).unfocus();
    //               },
    //               decoration: InputDecoration(
    //                 hintText: 'Find friends',
    //                 prefixIcon: Icon(Icons.search),
    //                 border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(12)),
    //                 contentPadding:
    //                     EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //               ),
    //             ),
    //             Gap(10),
    //             Center(
    //               // proposal
    //               child: StreamBuilder(
    //                 stream: getProposals(),
    //                 builder: (context, snapshot) {
    //                   if (snapshot.hasData &&  snapshot.data!.isNotEmpty) {
    //                   final proposals = snapshot.data!;
    //                     print(
    //                         '/...................................... ${proposals}');
    //                     return Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           'Friends request',
    //                           style: appStyles.s26w700Black.copyWith(
    //                             fontSize: 20,
    //                             height: 1.3,
    //                           ),
    //                         ),
    //                         ListView.builder(
    //                           shrinkWrap: true,
    //                           physics: NeverScrollableScrollPhysics(),
    //                           itemCount: proposals.length,
    //                           itemBuilder: (context, index) {
    //                             final user = proposals[index];
    //                             return ListTile(
    //                               title: Text(
    //                                 '${user['name']}',
    //                                 style: TextStyle(
    //                                     fontSize: 23,
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.black),
    //                               ),
    //                               subtitle: Text('${user['email']}',
    //                                   style: TextStyle(
    //                                       fontSize: 13,
    //                                       fontWeight: FontWeight.bold,
    //                                       color: Colors.grey)),
    //                               leading: Container(
    //                                 decoration: BoxDecoration(
    //                                     borderRadius: BorderRadius.circular(10),
    //                                     border: Border.all(
    //                                         color: Colors.black, width: 3)),
    //                                 child: Icon(
    //                                   Icons.person_outlined,
    //                                   size: 35,
    //                                   color: Colors.black,
    //                                 ),
    //                               ),
    //                               trailing: Row(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 spacing: 5,
    //                                 children: [
    //                                   InkWell(
    //                                     onTap: () {
    //                                       threadsControllers.acceptProposal(
    //                                           otherUserID: user['id']);
    //                                     },
    //                                     child: Container(
    //                                       padding: EdgeInsets.all(5),
    //                                       decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(50),
    //                                         border: Border.all(
    //                                             width: 1.5,
    //                                             color: Colors.black),
    //                                       ),
    //                                       child: Icon(
    //                                         Icons.check,
    //                                         size: 25,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     padding: EdgeInsets.all(5),
    //                                     decoration: BoxDecoration(
    //                                       borderRadius:
    //                                           BorderRadius.circular(50),
    //                                       border: Border.all(
    //                                           width: 1.5, color: Colors.black),
    //                                     ),
    //                                     child: Icon(
    //                                       Icons.close,
    //                                       size: 25,
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                       ],
    //                     );
    //                   } else {
    //                     return SizedBox.shrink();
    //                   }
    //                 },
    //               ),
    //             ),
    //             Gap(10),
    //             Center(
    //               //homies
    //               child: StreamBuilder(
    //                 stream: getHomies(),
    //                 builder: (context, snapshot) {
    //                   if (snapshot.connectionState == ConnectionState.waiting) {
    //                     return CircularProgressIndicator(); // Loading state
    //                   } else if (snapshot.hasError) {
    //                     return Text('Error: ${snapshot.error}'); // Error state
    //                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //                     return Text('No contact found'); // Empty state
    //                   } else {
    //                     // Data loaded successfully
    //                     final relations = snapshot.data!;
    //                     return ListView.builder(
    //                       shrinkWrap: true,
    //                       physics: NeverScrollableScrollPhysics(),
    //                       itemCount: relations.length,
    //                       itemBuilder: (context, index) {
    //                         final user = relations[index];
    //                         return ListTile(
    //                           title: Text(
    //                             '${user['name']}',
    //                             style: TextStyle(
    //                                 fontSize: 23,
    //                                 fontWeight: FontWeight.bold,
    //                                 color: Colors.black),
    //                           ),
    //                           subtitle: Text('${user['email']}',
    //                               style: TextStyle(
    //                                   fontSize: 13,
    //                                   fontWeight: FontWeight.bold,
    //                                   color: Colors.grey)),
    //                           leading: Container(
    //                             decoration: BoxDecoration(
    //                                 borderRadius: BorderRadius.circular(10),
    //                                 border: Border.all(
    //                                     color: Colors.black, width: 3)),
    //                             child: Icon(
    //                               Icons.person_outlined,
    //                               size: 35,
    //                               color: Colors.black,
    //                             ),
    //                           ),
    //                           trailing: Text(
    //                               '${!user['isAccepted'] ? ' request pending' : ''}'),
    //                         );
    //                       },
    //                     );
    //                   }
    //                 },
    //               ),
    //             ),
    //             Gap(10),
    //             Obx(() {
    //               return searchedUsers.isEmpty
    //                   ? SizedBox.shrink()
    //                   : Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           'Add new friends',
    //                           style: appStyles.s26w700Black.copyWith(
    //                             fontSize: 20,
    //                             height: 1.3,
    //                           ),
    //                         ),
    //                         ListView.builder(
    //                           itemCount: searchedUsers.length,
    //                           shrinkWrap: true,
    //                           physics: NeverScrollableScrollPhysics(),
    //                           itemBuilder: (ctx, index) {
    //                             final user = searchedUsers[index];
    //                             final currUser = user['uid'] ==
    //                                 threadsControllers.currentUser;
    //                             return ListTile(
    //                                 title: Text(
    //                                   '${user['name']} ${currUser ? '(you)' : ''}',
    //                                   style: TextStyle(
    //                                       fontSize: 23,
    //                                       fontWeight: FontWeight.bold,
    //                                       color: Colors.black),
    //                                 ),
    //                                 subtitle: Text('${user['email']}',
    //                                     style: TextStyle(
    //                                         fontSize: 13,
    //                                         fontWeight: FontWeight.bold,
    //                                         color: Colors.grey)),
    //                                 leading: Container(
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                           BorderRadius.circular(10),
    //                                       border: Border.all(
    //                                           color: Colors.black, width: 3)),
    //                                   child: Icon(
    //                                     Icons.person_outlined,
    //                                     size: 35,
    //                                     color: Colors.black,
    //                                   ),
    //                                 ),
    //                                 trailing: !currUser
    //                                     ? IconButton(
    //                                         onPressed: () {
    //                                           createRelation(user);
    //                                         },
    //                                         icon: Icon(
    //                                           Icons.person_add,
    //                                           size: 30,
    //                                         ),
    //                                       )
    //                                     : SizedBox.shrink());
    //                           },
    //                         ),
    //                       ],
    //                     );
    //             }),
    //           ],
    //         ),
    //       ))
    //     ],
    //   ),
    // );