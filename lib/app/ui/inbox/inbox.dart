import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/controller/threads_controller.dart';
import 'package:voyzi/app/my_utils/avatar.dart';
import 'package:voyzi/app/ui/inbox/add_friend.dart';
import 'package:voyzi/app/ui/inbox/firends_request.dart';
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
  RxBool isLoading = false.obs;

  Stream<List<Map<String, dynamic>>> getHomies() async* {
    isLoading.value = true;
    try {
      final homies = await threadsControllers.getHomies();
      yield homies;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
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
                    return NoContactFound();
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

class NoContactFound extends StatefulWidget {
  const NoContactFound({super.key});

  @override
  State<NoContactFound> createState() => _NoContactFoundState();
}

class _NoContactFoundState extends State<NoContactFound> {
  ThreadsControllers threadsControllers = ThreadsControllers();

  Stream<int> getProposalsCount() async* {
    final proposalsCount = await threadsControllers.getProposalsLength();
    yield proposalsCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 280,
            width: 280,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff0d4376),
                ),
                borderRadius: BorderRadius.circular(30),
                color: Color(0xff01102f),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff0c4373).withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.yellowAccent.withOpacity(0.1),
                              blurRadius: 40,
                              offset: Offset(0, 0),
                              blurStyle: BlurStyle.normal)
                        ]),
                    child: Image.asset(
                      Avatar.admin,
                      height: 170,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'paid2obtain',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Gap(4),
                        Text(
                          'listened . 1h ago',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF187DDB),
                          ),
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff011a3a),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF187DDB).withOpacity(0.7),
                              blurRadius: 8,
                              offset: Offset(0, 0),
                            ),
                          ]),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 28,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              InkWell(
                onTap: () {
                  Get.to(()=>AddFriend());
                },
                child: Container(
                  width: 260,
                  margin: EdgeInsets.symmetric(vertical: 30),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff0d4376),
                      ),
                      borderRadius: BorderRadius.circular(15),
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
              ),
              InkWell(
                onTap: () {
                  Get.to(() => FriendRequests());
                },
                child: Container(
                  width: 45,
                  height: 45,
                  margin: EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff0d4376),
                      ),
                      borderRadius: BorderRadius.circular(15),
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
                  child: Stack(
                    children: [
                       Icon(
                        Icons.person_2_rounded,
                        size: 28,
                        color: Colors.white70,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                          child: StreamBuilder(
                        stream: getProposalsCount(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 10,
                              width: 10,
                              decoration: 
                              BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: Text('.'),
                            );
                          } else if (snapshot.data == 0) {
                            return Text('');
                          } else {
                            return Text('');
                          }
                        },
                      ))
                    ],
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
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