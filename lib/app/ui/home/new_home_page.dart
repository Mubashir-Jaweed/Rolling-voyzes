import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/services/auth_services.dart';
import 'package:voyzi/app/services/firestore_services.dart';
import 'package:voyzi/app/ui/inbox/inbox.dart';
import 'package:voyzi/app/ui/local_voyzi/local_voyzi.dart';
import 'package:voyzi/app/ui/widgets/background_border_container.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
import 'package:voyzi/app/utils/constants/app_strings.dart';
import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/helpers/app_utils.dart';
import '../../utils/themes/app_theme.dart';

class HomePage extends GetItHook {
  HomePage({super.key});

  @override
  bool get canDisposeController => false;

  RxInt selectedIndex = 0.obs;
  final RefreshController refreshController = RefreshController();
  RxBool isRefreshing = false.obs;
  RxList<Widget> audioDropAnimations = <Widget>[].obs;

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // List to store download URLs for rolling voyzis
  List<String> rollingAudioUrls = [];

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

  List<AudioPlayer> localAudioPlayers = [];
  List<AudioPlayer> rollingAudioPlayers = [];

  final player = AudioPlayer();

  List<RxBool> isPlaying = [];

  Future<void> localPlay(int index) async {
    try {
      if (localAudioPlayers[index].playing) {
        dev.log("Stop Local $index");
        isPlaying[index].value = false;
        await localAudioPlayers[index].pause();
      } else {
        dev.log("Play Local $index");
        startAudioDropAnimation();

        // Stop all other players
        await stopAllPlayers();

        await localAudioPlayers[index].setAsset(locaLaudioAsset[index]);
        isPlaying[index].value = true;
        await localAudioPlayers[index].play();
      }
    } catch (e) {
      dev.log("Error in localPlay: $e");
      isPlaying[index].value = false;
    }
  }

  Future<void> rollingPlay(int index) async {
    try {
      final rollingIndex = index + localAudioPlayers.length;

      if (rollingAudioPlayers[index].playing) {
        dev.log("Stop Rolling $index");
        isPlaying[rollingIndex].value = false;
        await rollingAudioPlayers[index].pause();
      } else {
        dev.log("Play Rolling $index");
        startAudioDropAnimation();

        // Stop all other players
        await stopAllPlayers();

        if (rollingAudioUrls.isNotEmpty && index < rollingAudioUrls.length) {
          await rollingAudioPlayers[index].setUrl(rollingAudioUrls[index]);
          isPlaying[rollingIndex].value = true;
          await rollingAudioPlayers[index].play();
        } else {
          dev.log("No audio URL available for index $index");
        }
      }
    } catch (e) {
      dev.log("Error in rollingPlay: $e");
      isPlaying[index + localAudioPlayers.length].value = false;
    }
  }

  void initializePlayers() {
    // Initialize with 2 rolling audio players
    for (int i = 0; i < 2; i++) {
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
    for (int i = 0; i < localAudioPlayers.length; i++) {
      localAudioPlayers[i].playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          dev.log("Local audio $i completed");
          isPlaying[i].value = false;
        }
      });
    }

    for (int i = 0; i < rollingAudioPlayers.length; i++) {
      final rollingIndex = i + localAudioPlayers.length;
      rollingAudioPlayers[i].playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          dev.log("Rolling audio $i completed");
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
    fetchRandomPrompt();
    fetchRandomRecordings();
    schedulePromptRefresh();

  }

  var isLoading = true.obs;
  var prompt = ''.obs;
  Timer? _refreshTimer;

  Future<void> fetchRandomPrompt() async {
    try {
      isLoading.value = true;
      final fetchedPrompt = await FirestoreService().getRandomPrompt();
      prompt.value = fetchedPrompt ?? "No prompt found";
    } catch (e) {
      dev.log("Error fetching prompt: $e");
      prompt.value = "Error loading prompt";
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> fetchRandomRecordings() async {
    try {
      final ref = _storage.ref().child('recordings/global');
      final result = await ref.listAll();
      final items = result.items;
      
      if (items.isNotEmpty) {
        items.shuffle();
        final selectedItems = items.take(2).toList();
        
        rollingAudioUrls.clear();
        for (final item in selectedItems) {
          final url = await item.getDownloadURL();
          rollingAudioUrls.add(url);
        }
        
        dev.log('Fetched ${rollingAudioUrls.length} random recordings');
      } else {
        dev.log('No recordings found in Firebase Storage');
        // Fallback to local assets if no recordings found
        rollingAudioUrls = [
          Assets.audio.rollingVoyzi1,
          Assets.audio.rollingVoyzi2,
        ];
      }
    } catch (e) {
      dev.log('Error fetching recordings: $e');
      // Fallback to local assets if error occurs
      rollingAudioUrls = [
        Assets.audio.rollingVoyzi1,
        Assets.audio.rollingVoyzi2,
      ];
    }
  }

  void schedulePromptRefresh() {
    _refreshTimer?.cancel(); // Cancel existing timer if any
    _refreshTimer = Timer.periodic(Duration(hours: 3), (timer) {
      fetchRandomPrompt();
      // fetchRandomRecordings(); 
    });
  }

  void startAudioDropAnimation() {
    final random = Random();
    final appColors = AppColors.of(Get.context!);
    
    audioDropAnimations.clear();
    
    for (int i = 0; i < 3 + random.nextInt(3); i++) {
      final size = 10.0 + random.nextDouble() * 20;
      final left = random.nextDouble() * Get.width * 0.8;
      final duration = 800 + random.nextInt(800);
      
      audioDropAnimations.add(
        Positioned(
          left: left,
          top: -size,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: Get.height + size),
            duration: Duration(milliseconds: duration),
            builder: (context, value, child) {
              // Calculate opacity - ensure it stays between 0.0 and 1.0
              double opacity = 1.0 - (value / (Get.height + size));
              opacity = opacity.clamp(0.0, 1.0);
              
              return Positioned(
                top: value - size,
                left: left,
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.music_note,
                    size: size,
                    color: appColors.audio1TopLeftColor,
                  ),
                ),
              );
            },
            onEnd: () {
              if (i < audioDropAnimations.length) {
                audioDropAnimations.removeAt(i);
              }
            },
          ),
        ),
      );
    }
  }




   @override
  void dispose() {
    _refreshTimer?.cancel();
    for (var player in localAudioPlayers) {
      player.dispose();
    }
    for (var player in rollingAudioPlayers) {
      player.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    final appStyles = AppStyles.of(context);
    return Scaffold(
      backgroundColor: appColors.white,
      body: Padding(
        padding: EdgeInsets.zero,
        child: Obx(() {
          return Stack(
            children: [
              IndexedStack(
                index: selectedIndex.value,
                children: [
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
                              InkWell(
                                onTap: () async {
                                  await AuthService.instance.signOut();
                                  Get.offAllNamed(AppRoutes.login);
                                },
                                child: Icon(Icons.logout, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              isRefreshing.value = true;
                              // await fetchRandomPrompt();
                              await fetchRandomRecordings();
                            },
                            child: ListView(
                              padding: AppEdgeInsets.h16(),
                              children: [
                                SizedBox(
                                  height: 110,
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
                                            foregroundImage:
                                                AssetImage(assets[index]),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.T.rollingVoyzis,
                                        style: appStyles.s20w700White
                                            .copyWith(
                                                color: appColors.black,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      Gap(5),
                                      Text(
                                        prompt.value,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                    imagePath: Assets
                                                        .png.playIcon.path,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                    imagePath: Assets
                                                        .png.playIcon.path,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppStrings.T.localVoyzis,
                                            style: appStyles.s20w700White
                                                .copyWith(
                                              color: appColors.black,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      AppEdgeInsets.all16() -
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        appColors
                                                            .audio2TopLeftColor,
                                                        appColors
                                                            .audio2BottomRightColor,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight,
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
                                                              appColors:
                                                                  appColors,
                                                              onTap: () {
                                                                localPlay(0);
                                                              })
                                                          : ImageView(
                                                              imagePath: Assets
                                                                  .png.playIcon
                                                                  .path,
                                                              height:
                                                                  playIconHeight,
                                                              onTap: () {
                                                                localPlay(0);
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                Gap(10),
                                                Container(
                                                  padding:
                                                      AppEdgeInsets.all16() -
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        appColors
                                                            .audio1TopLeftColor,
                                                        appColors
                                                            .audio1BottomRightColor,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight,
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
                                                              appColors:
                                                                  appColors,
                                                              onTap: () {
                                                                localPlay(1);
                                                              })
                                                          : ImageView(
                                                              imagePath: Assets
                                                                  .png.playIcon
                                                                  .path,
                                                              height:
                                                                  playIconHeight,
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
                      style: appStyles.s26w700White
                          .copyWith(color: appColors.black),
                    ),
                  ),
                ],
              ),
              // Audio drop animations
              ...audioDropAnimations,
            ],
          );
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

class RefreshController {
  void reset() {}
}