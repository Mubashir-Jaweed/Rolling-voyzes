import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/services/auth_service.dart';
import 'package:voyzi/app/ui/inbox/inbox.dart';
import 'package:voyzi/app/ui/local_voyzi/local_voyzi.dart';
import 'package:voyzi/app/ui/widgets/background_border_container.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
import 'package:voyzi/app/utils/constants/app_strings.dart';
import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/helpers/app_utils.dart';
import '../../utils/themes/app_theme.dart';

class HomePage extends GetItHook {
  HomePage({super.key});

  @override
  // TODO: implement canDisposeController
  bool get canDisposeController => false;

  RxInt selectedIndex = 0.obs;

  Future<void> stopAllPlayers() async {
    for (var player in localAudioPlayers) {
      if (player.playing) {
        await player.stop();
      }
    }
    for (var player in rollingAudioPlayers) {
      if (player.playing) {
        await player.stop();
      }
    }

    // Set all `isPlaying` flags to false
    for (var playingFlag in isPlaying) {
      playingFlag.value = false;
    }
  }

  List<String> names = [
    'Eddie',
    'Talayah',
    'Xtendo',
    'Trey',
    'Tony',
  ];

  List<String> assets = [
    Assets.png.eddie.path,
    Assets.png.talayah.path,
    Assets.png.xtendo.path,
    Assets.png.trey.path,
    Assets.png.tony.path,
  ];

  List<String> locaLaudioAsset = [
    Assets.audio.localVoyzi1,
    Assets.audio.localVoyzi2,
  ];

  List<String> rollingLaudioAsset = [
    Assets.audio.rollingVoyzi1,
    Assets.audio.rollingVoyzi2,
  ];

  List<AudioPlayer> localAudioPlayers = [];
  List<AudioPlayer> rollingAudioPlayers = [];

  final player = AudioPlayer();

  List<RxBool> isPlaying = [];

  Future<void> localPlay(int index) async {
    // If already playing → pause
    if (localAudioPlayers[index].playing) {
      log("Stop Local $index");
      isPlaying[index].value = false;
      await localAudioPlayers[index].pause();
    } else {
      log("Play Local $index");

      // Pause all rolling players
      for (int i = 0; i < rollingAudioPlayers.length; i++) {
        await rollingAudioPlayers[i].pause();
        isPlaying[i + localAudioPlayers.length].value = false;
      }

      // Pause other local players
      for (int i = 0; i < localAudioPlayers.length; i++) {
        if (i != index) {
          await localAudioPlayers[i].pause();
          isPlaying[i].value = false;
        }
      }

      await localAudioPlayers[index].setAsset(locaLaudioAsset[index]);
      isPlaying[index].value = true;
      await localAudioPlayers[index].play();
    }
  }

  Future<void> rollingPlay(int index) async {
    final rollingIndex = index + localAudioPlayers.length;

    if (rollingAudioPlayers[index].playing) {
      log("Stop Rolling $index");
      isPlaying[rollingIndex].value = false;
      await rollingAudioPlayers[index].pause();
    } else {
      log("Play Rolling $index");

      // Pause all local players
      for (int i = 0; i < localAudioPlayers.length; i++) {
        await localAudioPlayers[i].pause();
        isPlaying[i].value = false;
      }

      // Pause other rolling players
      for (int i = 0; i < rollingAudioPlayers.length; i++) {
        if (i != index) {
          await rollingAudioPlayers[i].pause();
          isPlaying[i + localAudioPlayers.length].value = false;
        }
      }

      await rollingAudioPlayers[index].setAsset(rollingLaudioAsset[index]);
      isPlaying[rollingIndex].value = true;
      await rollingAudioPlayers[index].play();
    }
  }

  void initializePlayers() {
    for (int i = 0; i < rollingLaudioAsset.length; i++) {
      rollingAudioPlayers.add(AudioPlayer());
      isPlaying.add(false.obs);
    }

    for (int i = 0; i < locaLaudioAsset.length; i++) {
      localAudioPlayers.add(AudioPlayer());
      isPlaying.add(false.obs);
    }
  }

  double playIconHeight = 40;

  void setupCompletionListeners() {
    // Local players
    for (int i = 0; i < localAudioPlayers.length; i++) {
      localAudioPlayers[i].playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          log("Local audio $i completed");
          isPlaying[i].value = false;
        }
      });
    }

    // Rolling players
    for (int i = 0; i < rollingAudioPlayers.length; i++) {
      final rollingIndex = i + localAudioPlayers.length;
      rollingAudioPlayers[i].playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          log("Rolling audio $i completed");
          isPlaying[rollingIndex].value = false;
        }
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializePlayers();
    setupCompletionListeners();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    final appStyles = AppStyles.of(context);
    return Scaffold(
      backgroundColor: appColors.white,
      // appBar: AppBar(
      //   backgroundColor: appColors.white,
      //   surfaceTintColor: appColors.white,
      //   centerTitle: false,
      //   leading: null,
      //   actions: [
      //     Obx(() {
      //       return selectedIndex.value == 2
      //           ? Text(
      //               AppStrings.T.edit,
      //               style: appStyles.s20w700Black.copyWith(
      //                   letterSpacing: -0.5, fontWeight: FontWeight.w300),
      //             )
      //           : SizedBox();
      //     }),
      //     Gap(20)
      //   ],
      //   title: ImageView(
      //     imagePath: Assets.png.frame2.path,
      //     width: 110,
      //     color: appColors.black,
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Obx(() {
          return IndexedStack(index: selectedIndex.value, children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Gap(MediaQuery.of(context).padding.top),
                  Padding(
                    padding: AppEdgeInsets.h16(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageView(
                          imagePath: Assets.png.frame2.path,
                          width: Constants.appBarHeaderImagesize,
                          color: appColors.black,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.zero,
                        ),
                        Obx(() {
                          return selectedIndex.value == 2
                              ? Text(
                                  AppStrings.T.edit,
                                  style: appStyles.s20w700Black.copyWith(
                                      letterSpacing: -0.5,
                                      fontWeight: FontWeight.w300),
                                )
                              : SizedBox();
                        }),
                        // Gap(20),
                        InkWell(
                          onTap: () {
                             AuthService().signOut();
                          },
                          child: Icon(Icons.logout, color: Colors.black,)),
                      ],
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: ListView(
                      padding: AppEdgeInsets.h16(),
                      children: [
                        SizedBox(
                          height: 105,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: 5,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, i) => Gap(15),
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    foregroundImage: AssetImage(assets[index]),
                                  ),
                                  Gap(7),
                                  Text(
                                    names[index],
                                    style: appStyles.s18w400Text
                                        .copyWith(color: appColors.black),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Gap(18),
                        borderContainer(
                          padding: AppEdgeInsets.all16(),
                          boxShadow: Utils.boxShadow,
                          colors: [
                            appColors.normalWhiteGradientColor,
                            appColors.normalBlueGradientColor,
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppStrings.T.rollingVoyzis,
                                    style: appStyles.s20w700White.copyWith(
                                        color: appColors.black,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  ImageView(
                                    imagePath: Assets.png.dice.path,
                                    height: 50,
                                  )
                                ],
                              ),
                              Gap(5),
                              Text(
                                AppStrings
                                    .T.whatsAMomentYouKnewYouFkdUpInstantly,
                                style: appStyles.s18w400Text.copyWith(
                                  color: appColors.black,
                                  height: 1.2,
                                  fontSize: 20,
                                ),
                              ),
                              Gap(15),
                              Container(
                                padding: AppEdgeInsets.all16() +
                                    EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      appColors.audio1TopLeftColor,
                                      appColors.audio1BottomRightColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Gap(10),
                                    WaveShapes(appColors: appColors),
                                    Gap(10),
                                    isPlaying[2].value
                                        ? pauseButton(
                                            appColors: appColors,
                                            onTap: () {
                                              rollingPlay(0);
                                            })
                                        : ImageView(
                                            imagePath: Assets.png.playIcon.path,
                                            height: playIconHeight,
                                            onTap: () {
                                              rollingPlay(0);
                                            },
                                          ),
                                  ],
                                ),
                              ),
                              Gap(10),
                              Container(
                                padding: AppEdgeInsets.all16() +
                                    EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      appColors.audio2TopLeftColor,
                                      appColors.audio2BottomRightColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Gap(10),
                                    WaveShapes(appColors: appColors),
                                    Gap(10),
                                    isPlaying[3].value
                                        ? pauseButton(
                                            appColors: appColors,
                                            onTap: () {
                                              rollingPlay(1);
                                            })
                                        : ImageView(
                                            imagePath: Assets.png.playIcon.path,
                                            height: playIconHeight,
                                            onTap: () {
                                              rollingPlay(1);
                                            },
                                          ),
                                  ],
                                ),
                              ),
                              Gap(5),
                            ],
                          ),
                          appColors: appColors,
                        ),
                        Gap(18),
                        borderContainer(
                          boxShadow: Utils.boxShadow,
                          colors: [
                            appColors.normalWhiteGradientColor,
                            appColors.normalBlueGradientColor,
                          ],
                          padding: AppEdgeInsets.all16() -
                              const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Gap(10),
                                  Text(
                                    AppStrings.T.localVoyzis,
                                    style: appStyles.s20w700White.copyWith(
                                      color: appColors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Gap(10),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: AppEdgeInsets.all16() -
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              colors: [
                                                appColors.audio2TopLeftColor,
                                                appColors
                                                    .audio2BottomRightColor,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Gap(10),
                                              smallWaveShapes(
                                                  appColors: appColors),
                                              Gap(15),
                                              isPlaying[0].value
                                                  ? pauseButton(
                                                      appColors: appColors,
                                                      onTap: () {
                                                        localPlay(0);
                                                      })
                                                  : ImageView(
                                                      imagePath: Assets
                                                          .png.playIcon.path,
                                                      height: playIconHeight,
                                                      onTap: () {
                                                        localPlay(0);
                                                      },
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Gap(10),
                                        Container(
                                          padding: AppEdgeInsets.all16() -
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              colors: [
                                                appColors.audio1TopLeftColor,
                                                appColors
                                                    .audio1BottomRightColor,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Gap(10),
                                              smallWaveShapes(
                                                  appColors: appColors),
                                              Gap(15),
                                              isPlaying[1].value
                                                  ? pauseButton(
                                                      appColors: appColors,
                                                      onTap: () {
                                                        localPlay(1);
                                                      })
                                                  : ImageView(
                                                      imagePath: Assets
                                                          .png.playIcon.path,
                                                      height: playIconHeight,
                                                      onTap: () {
                                                        localPlay(1);
                                                      },
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ImageView(
                                      imagePath: Assets.png.map.path,
                                      fit: BoxFit.contain,
                                      margin: AppEdgeInsets.all4(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          appColors: appColors,
                        ),
                        Gap(18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LocalVoyzi(
              selectedIndex: selectedIndex,
              stopAllPlayers: stopAllPlayers,
            ),
            Inbox(
              selectedIndex: selectedIndex,
            ),
            Center(
              child: Text(
                'Profile',
                style: appStyles.s26w700White.copyWith(color: appColors.black),
              ),
            ),
          ]);
        }),
      ),
      bottomNavigationBar: Container(
        padding: AppEdgeInsets.all18() +
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: appColors.white,
          border: Border(
            top: BorderSide(
              color: appColors.white,
            ),
          ),
        ),
        child: Obx(() {
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    selectedIndex.value = 0;
                  },
                  child: Image.asset(
                    (selectedIndex.value == 0)
                        ? Assets.png.homeSelected.path
                        : Assets.png.home.path,
                    height: 24,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    selectedIndex.value = 1;
                  },
                  child: Image.asset(
                    (selectedIndex.value == 1)
                        ? Assets.png.a22.path
                        : Assets.png.a2.path,
                    height: 24,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    selectedIndex.value = 2;
                  },
                  child: Image.asset(
                    (selectedIndex.value == 2)
                        ? Assets.png.selectedMsg.path
                        : Assets.png.msg.path,
                    height: 24,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    selectedIndex.value = 3;
                  },
                  child: Image.asset(
                    (selectedIndex.value == 3)
                        ? Assets.png.selectedProfile.path
                        : Assets.png.profile.path,
                    height: 24,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget pauseButton(
      {required AppColors appColors, required Function() onTap}) {
    double waveHeight = 40;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: appColors.veryDarkBlue,
            shape: BoxShape.circle,
          ),
          height: waveHeight,
          width: waveHeight,
          child: Icon(Icons.pause)),
    );
  }

  Widget WaveShapes({required AppColors appColors}) {
    return Expanded(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ImageView(
              imagePath: Assets.png.waveform2RemovebgPreview.path,
              height: 40,
              color: appColors.white,
            ),
            ImageView(
              imagePath: Assets.png.waveform3RemovebgPreview.path,
              height: 40,
              color: appColors.white,
            ),
            ImageView(
              imagePath: Assets.png.waveform4RemovebgPreview.path,
              height: 40,
              color: appColors.white,
            ),
            ImageView(
              imagePath: Assets.png.waveform5RemovebgPreview.path,
              height: 40,
              color: appColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget smallWaveShapes({required AppColors appColors}) {
    return Expanded(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ImageView(
              imagePath: Assets.png.waveform2RemovebgPreview.path,
              height: 40,
              width: 40,
              color: appColors.white,
            ),
            ImageView(
              imagePath: Assets.png.waveform3RemovebgPreview.path,
              height: 40,
              width: 45,
              color: appColors.white,
            ),
            ImageView(
              imagePath: Assets.png.waveform3RemovebgPreview.path,
              height: 40,
              width: 30,
              color: appColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
