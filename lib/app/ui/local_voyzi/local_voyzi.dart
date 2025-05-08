import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:voyzi/app/ui/widgets/background_border_container.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/app/utils/constants/app_strings.dart';
import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';

import '../../../gen/assets.gen.dart';
import '../../controller/voice_controller.dart';
import '../../utils/constants/app_border_radius.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_edge_insets.dart';
import '../../utils/themes/app_theme.dart';

class ControlledLottieAnimationController {
  static late void Function()? play;
  static late void Function()? pause;
  static late void Function()? reset;

  ControlledLottieAnimationController();
}

class LocalVoyzi extends GetItHook<VoiceRecorderController> {
  LocalVoyzi({super.key, required this.selectedIndex, required this.stopAllPlayers});

  final ControlledLottieAnimationController lottiePlayPauseController =
      ControlledLottieAnimationController();

  final RxInt selectedIndex;
  final Function() stopAllPlayers;
  late ControlledLottieAnimationController lottieController =
      ControlledLottieAnimationController();

  @override
  bool get canDisposeController => false;

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    final appStyles = AppStyles.of(context);
    return LayoutBuilder(builder: (context, constraint) {
      return Padding(
        padding: AppEdgeInsets.h16(),
        child: Column(
          children: [
            Gap(MediaQuery.of(context).padding.top),
            Row(
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
                              letterSpacing: -0.5, fontWeight: FontWeight.w300),
                        )
                      : SizedBox();
                }),
                Gap(20),
              ],
            ),
            Gap(15),
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraint.maxHeight -
                          MediaQuery.of(context).padding.top -
                          60),
                  child: IntrinsicHeight(
                    child: Obx(() {
                      log("From OBX ${controller.recording.value}");
                      return Column(
                        children: [
                          borderContainer(
                            borderColor: Color(0xffE8F1FC),
                            child: Row(
                              children: [
                                Transform.translate(
                                  offset: Offset(-7, 0),
                                  child: ImageView(
                                    imagePath: Assets.png.dice.path,
                                    height: 58,
                                  ),
                                ),
                                Gap(5),
                                Expanded(
                                    child: Text(
                                  AppStrings.T
                                      .whatsTheMostOutOfPocketThingThatsHappened2You,
                                  style: appStyles.s20w700Black.copyWith(
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ))
                              ],
                            ),
                            givepadding: false,
                            appColors: appColors,
                            colors: [
                              Color(0xffF9FBFE),
                              Color(0xffF9FBFE),
                            ],
                          ),
                          Gap(15),
                          borderContainer(
                            givepadding: false,
                            borderColor: Color(0xffE8F1FC),
                            padding: AppEdgeInsets.all14(),
                            radius: 30,
                            child: Row(
                              children: [
                                Gap(10),
                                Obx(() => Text(
                                  controller.selected.value,
                                  style: appStyles.s24w700Black
                                      .copyWith(fontWeight: FontWeight.w400),
                                )),
                                const Spacer(),
                                Builder(builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDropDownMenu(
                                          context,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          '',
                                          borderRadius: AppBorderRadius.all(
                                              Radius.circular(25)),
                                          [
                                            PopupMenuItem(
                                              onTap: () {
                                                controller.changeLocalGlobal(
                                                    text: AppStrings.T.local);
                                              },
                                              value: AppStrings.T.local,
                                              child: Text(
                                                '   ${AppStrings.T.local}',
                                                style: appStyles.s18w400Black,
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              enabled: false,
                                              height: 5,
                                              child: Container(
                                                height: 1,
                                                color: Color(0xffE8F1FC),
                                              ),
                                            ),
                                            PopupMenuItem(
                                                value: 'turt',
                                                onTap: () {
                                                  controller.changeLocalGlobal(
                                                      text:
                                                          AppStrings.T.global);
                                                },
                                                child: Text(
                                                  '   ${AppStrings.T.global}',
                                                  style: appStyles.s18w400Black,
                                                )),
                                          ],
                                          borderColor: Color(0xffE8F1FC),
                                          shadowColor: appColors.transparent);
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: appColors.black,
                                      size: 30,
                                    ),
                                  );
                                })
                              ],
                            ),
                            appColors: appColors,
                            colors: [
                              appColors.white,
                              appColors.white,
                            ],
                          ),
                          Gap(10),
                          const Spacer(),
                          Obx(() => Text(
                            controller.recording.value ==
                                        Recording.isRecording ||
                                    controller.recording.value ==
                                        Recording.isPaused ||
                                    controller.recording.value ==
                                        Recording.isResumed
                                ? formatTime(controller.secondsElapsed.value)
                                : formatTime(controller.playbackSecondsElapsed.value),
                            style: appStyles.s24w700Black
                                .copyWith(fontWeight: FontWeight.w400),
                          )),
                          ControlledLottieAnimation(
                            lottiePath: Assets.animation.pulsingAnimation,
                            controller: controller.animationController,
                            child: Transform.translate(
                              offset: Offset(1, -1),
                              child: GestureDetector(
                                onTap: () {
                                  stopAllPlayers();
                                  log("Controller ${controller.recording.value}");
                                  if (controller.recording.value ==
                                      Recording.initial) {
                                    ControlledLottieAnimationController.play
                                        ?.call();
                                    controller.startRecording();
                                  }
                                  if (controller.recording.value ==
                                      Recording.isRecorded) {
                                    log("REcorded Play");
                                    controller.playRecording();
                                    ControlledLottieAnimationController.play
                                        ?.call();
                                  } else if (controller.recording.value ==
                                      Recording.isAudioPlaying) {
                                    ControlledLottieAnimationController.pause
                                        ?.call();
                                    controller.pausePlayback();
                                  } else if (controller.recording.value ==
                                      Recording.isAudioPaused) {
                                    ControlledLottieAnimationController.play
                                        ?.call();
                                    controller.resumePlayback();
                                  } else if (controller.recording.value ==
                                          Recording.isRecording ||
                                      controller.recording.value ==
                                          Recording.isPaused) {
                                    controller.stopRecording();
                                    ControlledLottieAnimationController.reset
                                        ?.call();
                                  } else {
                                    log("Problem is ${controller.recording.value}");
                                  }
                                },
                                child: Container(
                                  padding: AppEdgeInsets.all(radius: 20),
                                  child: Container(
                                    height: 220,
                                    padding: AppEdgeInsets.all(radius: 40),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffBF71F9),
                                          Color(0xff469AFE),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: controller.recording.value ==
                                                Recording.initial ||
                                            controller.recording.value ==
                                                Recording.isRecording ||
                                            controller.recording.value ==
                                                Recording.isPaused
                                        ? ImageView(
                                            imagePath:
                                                Assets.png.microphone.path,
                                            color: appColors.white,
                                            margin: EdgeInsets.zero,
                                          )
                                        : Icon(
                                            controller.recording.value ==
                                                    Recording.isAudioPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: 90,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Gap(10),
                          Obx(() {
                            if (controller.recording.value == Recording.isRecording ||
                                controller.recording.value == Recording.isPaused ||
                                controller.recording.value == Recording.isResumed) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.recording.value ==
                                          Recording.isPaused) {
                                        controller.resumeRecording();
                                        ControlledLottieAnimationController.play
                                            ?.call();
                                      } else {
                                        ControlledLottieAnimationController.pause
                                            ?.call();
                                        controller.pauseRecording();
                                      }
                                    },
                                    child: buttons(
                                      appStyles: appStyles,
                                      color1: Color(0xffD171ED),
                                      color2: Color(0xff9466EC),
                                      text: controller.recording.value == Recording.isPaused
                                          ? AppStrings.T.resume
                                          : AppStrings.T.pause,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ControlledLottieAnimationController.reset
                                          ?.call();
                                      controller.retakeRecording();
                                    },
                                    child: buttons(
                                      appStyles: appStyles,
                                      color1: Color(0xff4490FA),
                                      color2: Color(0xff4490FA),
                                      text: AppStrings.T.retake,
                                    ),
                                  ),
                                ],
                              );
                            } else if (controller.recording.value == Recording.isRecorded) {
                              return GestureDetector(
                                onTap: () async {
                                  final url = await controller.uploadRecording();
                                  if (url != null) {
                                    Get.snackbar('Success', 'Recording uploaded successfully');
                                  }
                                },
                                child: buttons(
                                  appStyles: appStyles,
                                  color1: Color(0xff4CAF50),
                                  color2: Color(0xff2E7D32),
                                  text: 'Upload',
                                ),
                              );
                            }
                            return SizedBox();
                          }),
                          Gap(15),
                          Text(
                            "${AppStrings.T.upTo} 1 ${AppStrings.T.minute}",
                            style: appStyles.s20w700Black.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff2C5484),
                            ),
                          ),
                          Gap(5),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buttons({
    required AppStyles appStyles,
    required Color color1,
    required Color color2,
    required String text,
  }) {
    return Container(
      padding: AppEdgeInsets.all16() + EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: AppBorderRadius.all(Radius.circular(40))),
      child: Text(
        text,
        style: appStyles.s20w700White.copyWith(),
      ),
    );
  }

  static showDropDownMenu<T>(
    BuildContext context,
    T initialValue,
    List<PopupMenuEntry<String>> items, {
    double? height,
    double? width,
    Color? bgColor,
    required Color borderColor,
    required Color shadowColor,
    BorderRadiusGeometry? borderRadius,
  }) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final PopupMenuPosition popupMenuPosition = PopupMenuPosition.under;
    Offset offset;
    switch (popupMenuPosition) {
      case PopupMenuPosition.over:
        offset = Offset(0.0, button.size.height + 8);
      case PopupMenuPosition.under:
        offset = Offset(0.0, button.size.height) + Offset.zero;
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      elevation: 5,
      shadowColor: shadowColor,
      color: bgColor ?? Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppBorderRadius.all14(),
          side: BorderSide(color: borderColor)),
      constraints: BoxConstraints.tightFor(width: width, height: height),
      useRootNavigator: true,
      initialValue: initialValue,
      items: items,
    );
  }
}

class ControlledLottieAnimation extends StatefulWidget {
  final String lottiePath;
  final Widget child;
  final AnimationController controller;

  const ControlledLottieAnimation({
    Key? key,
    required this.lottiePath,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  _ControlledLottieAnimationState createState() =>
      _ControlledLottieAnimationState();
}

class _ControlledLottieAnimationState extends State<ControlledLottieAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  BoxConstraints constraints = BoxConstraints(minHeight: 220, maxHeight: 320);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    ControlledLottieAnimationController.play = () {
      _controller.repeat();
    };
    ControlledLottieAnimationController.pause = () {
      _controller.stop();
    };
    ControlledLottieAnimationController.reset = () {
      _controller.reset();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: constraints,
          child: Lottie.asset(
            widget.lottiePath,
            height: 300,
            alignment: Alignment.center,
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
            },
            fit: BoxFit.cover,
          ),
        ),
        widget.child,
      ],
    );
  }
}