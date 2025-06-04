import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/controller/threads_controller.dart';
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
    return Padding(
      // padding: AppEdgeInsets.h16(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(MediaQuery.of(context).padding.top),
          Padding(
            padding: AppEdgeInsets.h16(),
            child: Row(
              children: [
                ImageView(
                  imagePath: Assets.png.frame2.path,
                  width: Constants.appBarHeaderImagesize,
                  color: appColors.black,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.zero,
                ),
                const Spacer(),
                Obx(() {
                  return selectedIndex.value == 2
                      ? Text(
                          AppStrings.T.edit,
                          style: appStyles.s20w700Black.copyWith(
                              letterSpacing: -0.5, fontWeight: FontWeight.w300),
                        )
                      : SizedBox();
                }),
                Gap(20)
              ],
            ),
          ),
          Gap(10),
          Expanded(
              child: SingleChildScrollView(
            padding: AppEdgeInsets.h16(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Threads',
                  style: appStyles.s26w700Black
                      .copyWith(fontSize: 45, height: 1.3),
                ),
                TextField(
                  onChanged: (value) {
                    handleSearch(value);
                  },
                  onSubmitted: (value) {
                    handleSearch(value);
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Find friends',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                Gap(10),

                // Text(
                //   AppStrings.T.seeIfYouveBeenHeardOrHaveReplies,
                //   style:
                //       appStyles.s18w400Black.copyWith(color: Color(0xff325C87)),
                // ),
                // Gap(13),
                // Text(
                //   AppStrings.T.markAllAsHeard,
                //   style: appStyles.s20w700Black.copyWith(
                //       color: appColors.blue, fontWeight: FontWeight.w600),
                // ),
                // Gap(8),
                // borderContainer(
                //   radius: 15,
                //   // padding: AppEdgeInsets.all16(),
                //   boxShadow: Utils.boxShadow,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       ImageView(
                //         imagePath:
                //             Assets.png.a1Way2richGroupchatRemovebgPreview.path,
                //         height: 50,
                //         alignment: Alignment.center,
                //         margin: EdgeInsets.zero,
                //       ),

                //       /// My code
                //       // Container(
                //       //   padding: AppEdgeInsets.all14(),
                //       //   decoration: BoxDecoration(
                //       //     color: Color(0xff9DC5FF),
                //       //     borderRadius: AppBorderRadius.all16(),
                //       //   ),
                //       //   child: Text(
                //       //     'W2',
                //       //     style: appStyles.s16w400Black
                //       //         .copyWith(fontWeight: FontWeight.w600),
                //       //   ),
                //       // ),
                //       Gap(15),
                //       Expanded(
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'way2Rich',
                //               style: appStyles.s22w700Black
                //                   .copyWith(fontWeight: FontWeight.w600),
                //             ),
                //             Gap(5),
                //             IntrinsicWidth(
                //                 child: WaveShapes(appColors: appColors)),
                //           ],
                //         ),
                //       ),
                //       Text(
                //         '4m',
                //         style: appStyles.s16w400Black
                //             .copyWith(color: Color(0xff395B84)),
                //         // ),
                //       )
                //     ],
                //   ),
                //   appColors: appColors,
                //   colors: [
                //     appColors.white,
                //     Color(0xffE4EFFF),
                //   ],
                // ),
                // Gap(12),
                // borderContainer(
                //   radius: 15,
                //   padding: AppEdgeInsets.all16(),
                //   boxShadow: Utils.boxShadow,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       ImageView(
                //         imagePath:
                //             Assets.png.a2PlotsGroupchatRemovebgPreview.path,
                //         height: 50,
                //         alignment: Alignment.center,
                //         margin: EdgeInsets.zero,
                //       ),

                //       /// My code
                //       // Container(
                //       //   padding: AppEdgeInsets.all14(),
                //       //   decoration: BoxDecoration(
                //       //     color: Color(0xffA5B8FF),
                //       //     borderRadius: AppBorderRadius.all16(),
                //       //   ),
                //       //   child: Container(
                //       //     decoration: BoxDecoration(
                //       //       color: Color(0xff6F63CE),
                //       //       borderRadius:
                //       //           AppBorderRadius.all(Radius.circular(4)),
                //       //     ),
                //       //     child: Text(
                //       //       '       ',
                //       //       style: appStyles.s16w400Black
                //       //           .copyWith(fontWeight: FontWeight.w600),
                //       //     ),
                //       //   ),
                //       // ),
                //       Gap(15),
                //       Expanded(
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'plots',
                //               style: appStyles.s22w700Black
                //                   .copyWith(fontWeight: FontWeight.w500),
                //             ),
                //             Gap(5),
                //             IntrinsicWidth(
                //                 child: WaveShapes(appColors: appColors)),
                //           ],
                //         ),
                //       ),
                //       Text(
                //         '22m',
                //         style: appStyles.s16w400Black
                //             .copyWith(color: Color(0xff395B84)),
                //       )
                //     ],
                //   ),
                //   appColors: appColors,
                //   colors: [
                //     appColors.white,
                //     Color(0xffE2E8FF),
                //   ],
                // ),
                // Gap(12),
                // borderContainer(
                //   radius: 15,
                //   padding: AppEdgeInsets.all16(),
                //   boxShadow: Utils.boxShadow,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       ImageView(
                //         imagePath: Assets
                //             .png.a3EconProjectGroupchatRemovebgPreview.path,
                //         height: 50,
                //         alignment: Alignment.center,
                //         margin: EdgeInsets.zero,
                //       ),

                //       /// My Code
                //       // Stack(
                //       //   alignment: Alignment.center,
                //       //   clipBehavior: Clip.none,
                //       //   children: [
                //       //     Container(
                //       //       padding: AppEdgeInsets.all14(),
                //       //       decoration: BoxDecoration(
                //       //         color: Color(0xff94C8FF),
                //       //         borderRadius: AppBorderRadius.all16(),
                //       //       ),
                //       //       child: Text(
                //       //         '       ',
                //       //         style: appStyles.s16w400Black
                //       //             .copyWith(fontWeight: FontWeight.w600),
                //       //       ),
                //       //     ),
                //       //     ImageView(
                //       //       imagePath: Assets.png.pipe.path,
                //       //       height: 40,
                //       //       color: appColors.blue,
                //       //     ),
                //       //   ],
                //       // ),
                //       Gap(15),
                //       Expanded(
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'econ project',
                //               style: appStyles.s22w700Black
                //                   .copyWith(fontWeight: FontWeight.w500),
                //             ),
                //             Gap(5),
                //             IntrinsicWidth(
                //                 child: WaveShapes(appColors: appColors)),
                //           ],
                //         ),
                //       ),
                //       Text(
                //         '45m',
                //         style: appStyles.s16w400Black
                //             .copyWith(color: Color(0xff395B84)),
                //       )
                //     ],
                //   ),
                //   appColors: appColors,
                //   colors: [
                //     appColors.white,
                //     Color(0xffE4EFFF),
                //   ],
                // ),
                // Gap(10),

                Gap(10),

                Obx(() {
                  return searchedUsers.isEmpty
                      ? SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add new friends',
                              style: appStyles.s26w700Black.copyWith(
                                fontSize: 20,
                                height: 1.3,
                              ),
                            ),
                            ListView.builder(
                              itemCount: searchedUsers.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                final user = searchedUsers[index];
                                return ListTile(
                                  title: Text(
                                    user['name'],
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(user['email'],
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey)),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black, width: 3)),
                                    child: Icon(
                                      Icons.person_outlined,
                                      size: 35,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.person_add,size: 30,)),
                                
                                );
                              },
                            ),
                          ],
                        );
                }),
              ],
            ),
          ))
        ],
      ),
    );
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

// Widget inboxTile({required AppColors appColors,required List<Color> colors,required AppStyles appStyles}) {
//   return borderContainer(
//     radius: 15,
//     givepadding: false,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: AppEdgeInsets.all14(),
//           decoration: BoxDecoration(
//             color: Color(0xff9DC5FF),
//             borderRadius: AppBorderRadius.all16(),
//           ),
//           child: Text(
//             'W2',
//             style:
//                 appStyles.s16w400Black.copyWith(fontWeight: FontWeight.w600),
//           ),
//         ),
//         Gap(10),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'way2Rich',
//               style: appStyles.s22w700Black
//                   .copyWith(fontWeight: FontWeight.w500),
//             ),
//             Gap(5),
//             WaveShapes(appColors: appColors),
//           ],
//         ),
//         const Spacer(),
//         Text(
//           '4m',
//           style: appStyles.s16w400Black.copyWith(color: Color(0xff395B84)),
//           // ),
//         )
//       ],
//     ),
//     appColors: appColors,
//     colors: colors,
//   );
// }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:voyzi/app/ui/widgets/background_border_container.dart';
// import 'package:voyzi/app/utils/constants/app_border_radius.dart';
// import 'package:voyzi/app/utils/constants/app_constants.dart';
// import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
// import 'package:voyzi/app/utils/constants/app_strings.dart';
// import 'package:voyzi/app/utils/helpers/app_utils.dart';
// import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';
// import 'package:voyzi/app/utils/themes/app_theme.dart';

// import '../../../gen/assets.gen.dart';
// import '../widgets/custom_image_view.dart';
// import '../widgets/list_tile.dart';

// class Inbox extends GetItHook {
//   Inbox({super.key, required this.selectedIndex});

//   RxInt selectedIndex;

//   @override
//   // TODO: implement canDisposeController
//   bool get canDisposeController => false;

//   List<String> names = [
//     'Eddie',
//     'Talayah',
//     'Xtendo',
//     'Trey',
//     'Eddie',
//   ];

//   List<String> assets = [
//     Assets.png.eddie.path,
//     Assets.png.talayah.path,
//     Assets.png.xtendo.path,
//     Assets.png.trey.path,
//     Assets.png.eddie.path,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final appColors = AppColors.of(context);
//     final appStyles = AppStyles.of(context);
//     return Padding(
//       // padding: AppEdgeInsets.h16(),
//       padding: EdgeInsets.zero,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Gap(MediaQuery.of(context).padding.top),
//           Padding(
//             padding: AppEdgeInsets.h16(),
//             child: Row(
//               children: [
//                 ImageView(
//                   imagePath: Assets.png.frame2.path,
//                   width: Constants.appBarHeaderImagesize,
//                   color: appColors.black,
//                   alignment: Alignment.centerLeft,
//                   margin: EdgeInsets.zero,
//                 ),
//                 const Spacer(),
//                 Obx(() {
//                   return selectedIndex.value == 2
//                       ? Text(
//                           AppStrings.T.edit,
//                           style: appStyles.s20w700Black.copyWith(
//                               letterSpacing: -0.5, fontWeight: FontWeight.w300),
//                         )
//                       : SizedBox();
//                 }),
//                 Gap(20)
//               ],
//             ),
//           ),
//           Gap(10),
//           Expanded(
//               child: SingleChildScrollView(
//             padding: AppEdgeInsets.h16(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   AppStrings.T.inbox,
//                   style: appStyles.s26w700Black
//                       .copyWith(fontSize: 45, height: 1.3),
//                 ),
//                 Text(
//                   AppStrings.T.seeIfYouveBeenHeardOrHaveReplies,
//                   style:
//                       appStyles.s18w400Black.copyWith(color: Color(0xff325C87)),
//                 ),
//                 Gap(13),
//                 Text(
//                   AppStrings.T.markAllAsHeard,
//                   style: appStyles.s20w700Black.copyWith(
//                       color: appColors.blue, fontWeight: FontWeight.w600),
//                 ),
//                 Gap(8),
//                 borderContainer(
//                   radius: 15,
//                   // padding: AppEdgeInsets.all16(),
//                   boxShadow: Utils.boxShadow,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ImageView(
//                         imagePath:
//                             Assets.png.a1Way2richGroupchatRemovebgPreview.path,
//                         height: 50,
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.zero,
//                       ),

//                       /// My code
//                       // Container(
//                       //   padding: AppEdgeInsets.all14(),
//                       //   decoration: BoxDecoration(
//                       //     color: Color(0xff9DC5FF),
//                       //     borderRadius: AppBorderRadius.all16(),
//                       //   ),
//                       //   child: Text(
//                       //     'W2',
//                       //     style: appStyles.s16w400Black
//                       //         .copyWith(fontWeight: FontWeight.w600),
//                       //   ),
//                       // ),
//                       Gap(15),
//                       Expanded(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'way2Rich',
//                               style: appStyles.s22w700Black
//                                   .copyWith(fontWeight: FontWeight.w600),
//                             ),
//                             Gap(5),
//                             IntrinsicWidth(
//                                 child: WaveShapes(appColors: appColors)),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         '4m',
//                         style: appStyles.s16w400Black
//                             .copyWith(color: Color(0xff395B84)),
//                         // ),
//                       )
//                     ],
//                   ),
//                   appColors: appColors,
//                   colors: [
//                     appColors.white,
//                     Color(0xffE4EFFF),
//                   ],
//                 ),
//                 Gap(12),
//                 borderContainer(
//                   radius: 15,
//                   padding: AppEdgeInsets.all16(),
//                   boxShadow: Utils.boxShadow,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ImageView(
//                         imagePath:
//                             Assets.png.a2PlotsGroupchatRemovebgPreview.path,
//                         height: 50,
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.zero,
//                       ),

//                       /// My code
//                       // Container(
//                       //   padding: AppEdgeInsets.all14(),
//                       //   decoration: BoxDecoration(
//                       //     color: Color(0xffA5B8FF),
//                       //     borderRadius: AppBorderRadius.all16(),
//                       //   ),
//                       //   child: Container(
//                       //     decoration: BoxDecoration(
//                       //       color: Color(0xff6F63CE),
//                       //       borderRadius:
//                       //           AppBorderRadius.all(Radius.circular(4)),
//                       //     ),
//                       //     child: Text(
//                       //       '       ',
//                       //       style: appStyles.s16w400Black
//                       //           .copyWith(fontWeight: FontWeight.w600),
//                       //     ),
//                       //   ),
//                       // ),
//                       Gap(15),
//                       Expanded(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'plots',
//                               style: appStyles.s22w700Black
//                                   .copyWith(fontWeight: FontWeight.w500),
//                             ),
//                             Gap(5),
//                             IntrinsicWidth(
//                                 child: WaveShapes(appColors: appColors)),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         '22m',
//                         style: appStyles.s16w400Black
//                             .copyWith(color: Color(0xff395B84)),
//                       )
//                     ],
//                   ),
//                   appColors: appColors,
//                   colors: [
//                     appColors.white,
//                     Color(0xffE2E8FF),
//                   ],
//                 ),
//                 Gap(12),
//                 borderContainer(
//                   radius: 15,
//                   padding: AppEdgeInsets.all16(),
//                   boxShadow: Utils.boxShadow,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ImageView(
//                         imagePath: Assets
//                             .png.a3EconProjectGroupchatRemovebgPreview.path,
//                         height: 50,
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.zero,
//                       ),

//                       /// My Code
//                       // Stack(
//                       //   alignment: Alignment.center,
//                       //   clipBehavior: Clip.none,
//                       //   children: [
//                       //     Container(
//                       //       padding: AppEdgeInsets.all14(),
//                       //       decoration: BoxDecoration(
//                       //         color: Color(0xff94C8FF),
//                       //         borderRadius: AppBorderRadius.all16(),
//                       //       ),
//                       //       child: Text(
//                       //         '       ',
//                       //         style: appStyles.s16w400Black
//                       //             .copyWith(fontWeight: FontWeight.w600),
//                       //       ),
//                       //     ),
//                       //     ImageView(
//                       //       imagePath: Assets.png.pipe.path,
//                       //       height: 40,
//                       //       color: appColors.blue,
//                       //     ),
//                       //   ],
//                       // ),
//                       Gap(15),
//                       Expanded(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'econ project',
//                               style: appStyles.s22w700Black
//                                   .copyWith(fontWeight: FontWeight.w500),
//                             ),
//                             Gap(5),
//                             IntrinsicWidth(
//                                 child: WaveShapes(appColors: appColors)),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         '45m',
//                         style: appStyles.s16w400Black
//                             .copyWith(color: Color(0xff395B84)),
//                       )
//                     ],
//                   ),
//                   appColors: appColors,
//                   colors: [
//                     appColors.white,
//                     Color(0xffE4EFFF),
//                   ],
//                 ),
//                 Gap(10),
//                 ListView.builder(
//                   itemCount: 4,
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return replyTile(
//                       imagePath: assets[index],
//                       name: names[index],
//                       minute: index.toString(),
//                       appStyles: appStyles,
//                       appColors: appColors,
//                     );
//                   },
//                 ),
//                 Gap(10),
//               ],
//             ),
//           ))
//         ],
//       ),
//     );
//   }

//   Widget WaveShapes({required AppColors appColors}) {
//     double imgHeight = 20;
//     return SingleChildScrollView(
//       physics: NeverScrollableScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           ImageView(
//             imagePath: Assets.png.waveform2RemovebgPreview.path,
//             height: imgHeight,
//             color: appColors.blue,
//           ),
//           ImageView(
//             imagePath: Assets.png.waveform3RemovebgPreview.path,
//             height: imgHeight,
//             color: appColors.blue,
//           ),
//           ImageView(
//             imagePath: Assets.png.waveform4RemovebgPreview.path,
//             height: imgHeight,
//             color: appColors.blue,
//           ),
//           ImageView(
//             imagePath: Assets.png.waveform3RemovebgPreview.path,
//             height: imgHeight,
//             color: appColors.blue,
//           ),
//           ImageView(
//             imagePath: Assets.png.waveform4RemovebgPreview.path,
//             height: imgHeight,
//             color: appColors.blue,
//           ),
//           // ImageView(
//           //   imagePath: Assets.png.waveform5RemovebgPreview.path,
//           //   height: imgHeight,
//           //   color: appColors.blue,
//           // ),
//         ],
//       ),
//     );
//   }

// // Widget inboxTile({required AppColors appColors,required List<Color> colors,required AppStyles appStyles}) {
// //   return borderContainer(
// //     radius: 15,
// //     givepadding: false,
// //     child: Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           padding: AppEdgeInsets.all14(),
// //           decoration: BoxDecoration(
// //             color: Color(0xff9DC5FF),
// //             borderRadius: AppBorderRadius.all16(),
// //           ),
// //           child: Text(
// //             'W2',
// //             style:
// //                 appStyles.s16w400Black.copyWith(fontWeight: FontWeight.w600),
// //           ),
// //         ),
// //         Gap(10),
// //         Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'way2Rich',
// //               style: appStyles.s22w700Black
// //                   .copyWith(fontWeight: FontWeight.w500),
// //             ),
// //             Gap(5),
// //             WaveShapes(appColors: appColors),
// //           ],
// //         ),
// //         const Spacer(),
// //         Text(
// //           '4m',
// //           style: appStyles.s16w400Black.copyWith(color: Color(0xff395B84)),
// //           // ),
// //         )
// //       ],
// //     ),
// //     appColors: appColors,
// //     colors: colors,
// //   );
// // }
// }
