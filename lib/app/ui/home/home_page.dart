// import 'dart:developer';
//
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
//
// import 'package:just_audio/just_audio.dart';
// import 'package:voyzi/app/ui/widgets/background_border_container.dart';
// import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
// import 'package:voyzi/app/ui/widgets/list_tile.dart';
// import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
// import 'package:voyzi/app/utils/constants/app_strings.dart';
// import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';
//
// import '../../../gen/assets.gen.dart';
// import '../../utils/themes/app_theme.dart';
//
// class HomePage extends GetItHook {
//   HomePage({super.key});
//
//   @override
//   // TODO: implement canDisposeController
//   bool get canDisposeController => false;
//
//   double waveHeight = 50;
//
//   RxInt selectedIndex = 0.obs;
//
//   List<String> names = [
//     'Emily',
//     'Mike',
//     'Joseph',
//     'Sarah',
//   ];
//   List<String> assets = [
//     Assets.png.p1.path,
//     Assets.png.p2.path,
//     Assets.png.p3.path,
//   ];
//   List<String> audioAsset = [
//     'assets/audio/audio1.m4a',
//     'assets/audio/audio2.m4a',
//     'assets/audio/audio3.m4a',
//   ];
//
//   List<AudioPlayer> audioPlayers = [];
//
//   final player = AudioPlayer();
//
//   List<RxBool> isPlaying = [];
//
//   Future<void> togglePlay(int index) async {
//     if (audioPlayers[index].playing) {
//       log("Stop");
//       isPlaying[index].value = false;
//       await audioPlayers[index].pause();
//     } else {
//       log("Play");
//
//       await audioPlayers[index].setAsset(audioAsset[index]);
//
//       // Pause other players
//       for (int i = 0; i < audioPlayers.length; i++) {
//         if (i != index) {
//           audioPlayers[i].pause();
//           isPlaying[i].value = false;
//         }
//       }
//
//       isPlaying[index].value = true;
//
//       await audioPlayers[index].play();
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     audioPlayers = List.generate(3, (i) => AudioPlayer());
//     isPlaying = List.generate(3, (i) => false.obs);
//     for (var val in audioPlayers) {
//       val.playerStateStream.listen((val2) {
//         final processingState = val2.processingState;
//         if (processingState == ProcessingState.completed) {
//           log("Complete automatic");
//           // Audio finished playing
//           int tmp = audioPlayers.indexOf(val);
//           isPlaying[tmp].value = false;
//         }
//       });
//       // val.onPlayerComplete.listen((val2) {
//       //   int tmp = audioPlayers.indexOf(val);
//       //   isPlaying[tmp].value = false;
//       // });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final appColors = AppColors.of(context);
//     final appStyles = AppStyles.of(context);
//     return Scaffold(
//       backgroundColor: appColors.backGroundColor,
//       appBar: AppBar(
//         backgroundColor: appColors.backGroundColor,
//         surfaceTintColor: Colors.transparent,
//         centerTitle: false,
//         title: ImageView(
//           imagePath: Assets.png.header.path,
//           width: 130,
//         ),
//         // customAppBar(
//         //   context: context,
//         //   appStyles: appStyles,
//         //   appColors: appColors,
//         // ),
//       ),
//       body: Padding(
//         padding:
//             AppEdgeInsets.all20() - const EdgeInsets.only(bottom: 20, top: 10),
//         child: Obx(() {
//           return IndexedStack(index: selectedIndex.value, children: [
//             ListView(
//               padding: EdgeInsets.only(bottom: 16),
//               children: [
//                 borderContainer(
//                     padding: AppEdgeInsets.all14(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppStrings.T.sendAVoyzi,
//                           style: appStyles.s20w700White.copyWith(
//                               color: appColors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         Gap(15),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Row(
//                                   children: [
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 30,
//                                           foregroundImage:
//                                               AssetImage(Assets.png.p1.path),
//                                         ),
//                                         Gap(5),
//                                         Text(
//                                           'Sarah',
//                                           style: appStyles.s18w400Text.copyWith(
//                                             fontSize: 14,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     Gap(10),
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 30,
//                                           foregroundImage:
//                                               AssetImage(Assets.png.p2.path),
//                                         ),
//                                         Gap(5),
//                                         Text(
//                                           'Emily',
//                                           style: appStyles.s18w400Text.copyWith(
//                                             fontSize: 14,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     Gap(10),
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 30,
//                                           foregroundImage:
//                                               AssetImage(Assets.png.p3.path),
//                                         ),
//                                         Gap(5),
//                                         Text(
//                                           'Alex',
//                                           style: appStyles.s18w400Text
//                                               .copyWith(fontSize: 14),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // const Spacer(),
//                             Transform.translate(
//                               offset: Offset(0, -10),
//                               child: Image.asset(
//                                 Assets.png.microphone.path,
//                                 height: 80,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     appColors: appColors),
//                 Gap(18),
//                 borderContainer(
//                   padding: AppEdgeInsets.all14(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${AppStrings.T.votdPromptsFlip} ${AppStrings.T.voicesRefreshDropYoursBeforeItResets}",
//                         style: appStyles.s20w700White.copyWith(
//                             color: appColors.white,
//                             height: 1.1,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       Gap(15),
//
//                       IntrinsicHeight(
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   /// function
//                                   togglePlay(0);
//                                 },
//                                 child: borderContainer(
//                                     child: Column(
//                                       children: [
//                                         isPlaying[0].value
//                                             ? pauseButton(appColors: appColors)
//                                             : Image.asset(
//                                                 Assets.png.waveCard.path,
//                                                 height: waveHeight,
//                                               ),
//                                         Gap(15),
//                                         Text(
//                                           AppStrings.T.whileWalkingAtSdsu,
//                                           style:
//                                               appStyles.s16w400White.copyWith(
//                                             fontSize: 14,
//                                             color: appColors.textColor,
//                                             height: 1.1,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ],
//                                     ),
//                                     padding: AppEdgeInsets.all12(),
//                                     appColors: appColors),
//                               ),
//                             ),
//                             Gap(10),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   /// function
//                                   togglePlay(1);
//                                 },
//                                 child: borderContainer(
//                                     padding: AppEdgeInsets.all12(),
//                                     child: Column(
//                                       children: [
//                                         isPlaying[1].value
//                                             ? pauseButton(appColors: appColors)
//                                             : Image.asset(
//                                                 Assets.png.waveCard.path,
//                                                 height: waveHeight,
//                                               ),
//                                         Gap(15),
//                                         Text(
//                                           AppStrings.T.inLineAtTacoBellAt2am,
//                                           style:
//                                               appStyles.s16w400White.copyWith(
//                                             fontSize: 14,
//                                             color: appColors.textColor,
//                                             height: 1.1,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         )
//                                       ],
//                                     ),
//                                     appColors: appColors),
//                               ),
//                             ),
//                             Gap(10),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   /// function
//                                   togglePlay(2);
//                                 },
//                                 child: borderContainer(
//                                     padding: AppEdgeInsets.all12(),
//                                     child: Column(
//                                       children: [
//                                         isPlaying[2].value
//                                             ? pauseButton(appColors: appColors)
//                                             : Image.asset(
//                                                 Assets.png.waveCard.path,
//                                                 height: waveHeight,
//                                               ),
//                                         Gap(15),
//                                         Text(
//                                           AppStrings.T.onARooftopInDowntownLa,
//                                           style:
//                                               appStyles.s16w400White.copyWith(
//                                             fontSize: 14,
//                                             height: 1.1,
//                                             color: appColors.textColor,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         )
//                                       ],
//                                     ),
//                                     appColors: appColors),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                           ],
//                         ),
//                       ),
//                       Gap(15),
//                       Text(
//                         AppStrings.T.whatsAMomentYouKnewYouFkdUpInstantly
//                             .toLowerCase(),
//                         style: appStyles.s20w700White.copyWith(
//                             color: appColors.white,
//                             fontSize: 22,
//                             height: 1.1,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       Gap(5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: appColors.primaryColor,
//                               ),
//                               onPressed: () {},
//                               child: Text(
//                                 AppStrings.T.yourTurn,
//                                 style: appStyles.s20w700White
//                                     .copyWith(fontWeight: FontWeight.w500),
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                   appColors: appColors,
//                 ),
//                 Gap(18),
//                 ListView.separated(
//                   itemCount: 3,
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   physics: const NeverScrollableScrollPhysics(),
//                   separatorBuilder: (context, i) => Gap(12),
//                   itemBuilder: (context, index) {
//                     return borderContainer(
//                       appColors: appColors,
//                       padding: AppEdgeInsets.all8(),
//                       child: replyTile(
//                         imagePath: assets[index],
//                         name: names[index],
//                         minute: index.toString(),
//                         appStyles: appStyles,
//                         appColors: appColors,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             Center(
//               child: Text(
//                 'Page Name',
//                 style: appStyles.s26w700White,
//               ),
//             ),
//             Center(
//               child: Text(
//                 'Message',
//                 style: appStyles.s26w700White,
//               ),
//             ),
//             Center(
//               child: Text(
//                 'Profile',
//                 style: appStyles.s26w700White,
//               ),
//             ),
//           ]);
//         }),
//       ),
//       bottomNavigationBar: Container(
//         padding: AppEdgeInsets.all18() +
//             EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//         decoration: BoxDecoration(
//           color: Color(0xff0B0B0D),
//           border: Border(
//             top: BorderSide(
//               color: appColors.borderColor,
//             ),
//           ),
//         ),
//         child: Obx(() {
//           return Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     selectedIndex.value = 0;
//                   },
//                   child: Image.asset(
//                     (selectedIndex.value == 0)
//                         ? Assets.png.homeSelected.path
//                         : Assets.png.home.path,
//                     height: 24,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     selectedIndex.value = 1;
//                   },
//                   child: Image.asset(
//                     (selectedIndex.value == 1)
//                         ? Assets.png.a22.path
//                         : Assets.png.a2.path,
//                     height: 24,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     selectedIndex.value = 2;
//                   },
//                   child: Image.asset(
//                     (selectedIndex.value == 2)
//                         ? Assets.png.selectedMsg.path
//                         : Assets.png.msg.path,
//                     height: 24,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     selectedIndex.value = 3;
//                   },
//                   child: Image.asset(
//                     (selectedIndex.value == 3)
//                         ? Assets.png.selectedProfile.path
//                         : Assets.png.profile.path,
//                     height: 24,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget pauseButton({required AppColors appColors}) {
//     return Container(
//         decoration: BoxDecoration(
//           color: appColors.blue,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         height: waveHeight,
//         width: waveHeight,
//         child: Icon(Icons.pause));
//   }
// }
