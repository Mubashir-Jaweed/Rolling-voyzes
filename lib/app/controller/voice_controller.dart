import 'dart:async';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:voyzi/app/utils/constants/app_strings.dart';

import '../ui/local_voyzi/local_voyzi.dart';

enum Recording {
  initial,
  isRecording,
  isPaused,
  isResumed,
  isRecorded,
  isAudioPlaying,
  isAudioPaused
}

@i.lazySingleton
@i.injectable
class VoiceRecorderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  VoiceRecorderController() {
    animationController = AnimationController(vsync: this);
  }

  final record = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  Rx<String> selected = Rx(AppStrings.T.local);

  Rx<String?> recordedFilePath = Rx(null);
  String? recordingFilePath;
  late AnimationController animationController;

  RxInt _playbackSecondsElapsed = 0.obs;
  Timer? _playbackTimer;

  int get playbackSecondsElapsed => _playbackSecondsElapsed.value;

  RxInt _secondsElapsed = 0.obs;
  Timer? _timer;

  Rx<Recording> recording = Rx(Recording.initial);

  /// Expose the time as a stream or getter
  int get secondsElapsed => _secondsElapsed.value;

  RxBool isRecording = false.obs;
  RxBool recorded = false.obs;

  changeLocalGlobal({required String text}) {
    selected.value = text;
    log("Selected : ${selected.value}");
  }

  getPath() async {
    recordingFilePath ??= (await getTemporaryDirectory()).path;
  }

  Future<void> startRecording() async {
    await getPath();
    if (await Permission.microphone.request().isGranted) {
      log("Permission granted");
      if (recording.value != Recording.isRecording) {
        final filePath =
            '${recordingFilePath!}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        await record.start(const RecordConfig(), path: filePath);
        recordedFilePath.value = filePath;
        log("Started recording at $filePath");
      }
      isRecording.value = true;
      recorded.value = true;
    } else {
      log("Permission not granted ..");
    }
    recording.value = Recording.isRecording;
    _startTimer();
  }

  Future<void> stopRecording() async {
    try {
      await record.stop();
    } catch (e) {
      log("Error while stopping recording: $e");
    }
    recorded.value = false;
    isRecording.value = false;
    recording.value = Recording.isRecorded;
    log("Path check func ${recordedFilePath.value}");
    _resetTimer();

    await uploadRecordingToFirebase();
  }

Future<void> uploadRecordingToFirebase() async {
  log('uploading to firestorage');
  final filePath = recordedFilePath.value;

  if (filePath == null) {
    log("No recording to upload.");
    return;
  }

  final File file = File(filePath);
  final storageRef = FirebaseStorage.instance.ref();

  // Choose folder based on selected value
  final folder = selected.value == AppStrings.T.local ? "local" : "global";
  log('folder: $folder');

  final fileName = "recordings/$folder/${DateTime.now().millisecondsSinceEpoch}.m4a";
  final uploadRef = storageRef.child(fileName);
  log('upload ref: $uploadRef');

  try {
    // Add metadata with content type
    final metadata = SettableMetadata(
      contentType: 'audio/mp4', // or 'audio/m4a'
    );

    final uploadTask = await uploadRef.putFile(file, metadata);
    log('upload task: $uploadTask');

    final downloadUrl = await uploadTask.ref.getDownloadURL();
    log("✅ Audio uploaded successfully: $downloadUrl");
  } catch (e) {
    log("Upload failed: $e");
  }
}

  Future<void> retakeRecording() async {
    try {
      await record.cancel();
    } catch (e) {
      log('Error while cancel recording: $e');
    }
    isRecording.value = false;
    recorded.value = false;
    recordedFilePath.value = null;
    recordingFilePath = null;
    _stopTimer();
    _resetTimer();
    recording.value = Recording.initial;
  }

  Future<void> playRecording() async {
    log("Path ${recordedFilePath.value}");
    if (recordedFilePath.value != null) {
      recording.value = Recording.isAudioPlaying;

      await audioPlayer.setFilePath(recordedFilePath.value!);
      audioPlayer.play();

      _playbackSecondsElapsed.value = 0;
      audioPlayer.positionStream.listen((position) {
        _playbackSecondsElapsed.value = position.inSeconds;
      });

      audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _resetPlaybackTimer();
          if (recording.value == Recording.isAudioPaused ||
              recording.value == Recording.isAudioPlaying) {
            recording.value = Recording.initial;
            ControlledLottieAnimationController.reset?.call();
            audioPlayer.stop();
            audioPlayer.seek(Duration.zero);
            // audioPlayer.clearAudioSources();
            log("Set to initial after playback complete");
          }
        }
      });
    }
  }

  //
  // retakeRecording() async {
  //   record.cancel();
  //   isRecording.value = false;
  //   recorded.value = false;
  //   recordedFilePath.value = null;
  //   _stopTimer();
  //   _resetTimer();
  //   recording.value = Recording.initial;
  // }
  //
  // // Start Recording
  // Future<void> startRecording() async {
  //   await getPath();
  //   if (await Permission.microphone.request().isGranted) {
  //     log("Permission granted");
  //     isRecording.value = true;
  //     recorded.value = true;
  //     log("recording not ${recording.value}");
  //     if (recording.value != Recording.isRecording) {
  //       final filePath =
  //           '${recordingFilePath!}/${DateTime.now().millisecondsSinceEpoch}.m4a';
  //       await record.start(const RecordConfig(), path: filePath);
  //       log('can Record');
  //       recordedFilePath.value = filePath;
  //       log("Recorded ");
  //     }
  //   } else {
  //     log("Permission not granted ..");
  //   }
  //   recording.value = Recording.isRecording;
  //   _startTimer();
  // }
  //
  // // Stop Recording
  // Future<void> stopRecording() async {
  //   // recordedFilePath.value = (await record.stop());
  //   try {
  //     await record.stop();
  //   } catch (e) {
  //     log("Error while stopping recording: $e");
  //   }
  //   recorded.value = false;
  //   isRecording.value = false;
  //   recording.value = Recording.isRecorded;
  //   log("Path ${recordedFilePath.value}");
  //   record.cancel();
  //   _resetTimer();
  // }

  Future<void> pauseRecording() async {
    await record.pause();
    isRecording.value = false;
    recording.value = Recording.isPaused;
    _stopTimer();
  }

  Future<void> resumeRecording() async {
    await record.resume();
    isRecording.value = true;
    recording.value = Recording.isRecording;
    _startTimer();
  }

  // Play Recording
  // Future<void> playRecording() async {
  //   log("Path ${recordedFilePath.value}");
  //   if (recordedFilePath.value != null) {
  //     recording.value = Recording.isAudioPlaying;
  //
  //     await audioPlayer.setFilePath(recordedFilePath.value!);
  //     audioPlayer.play();
  //
  //     // Listen to position
  //     audioPlayer.positionStream.listen((position) {
  //       _playbackSecondsElapsed.value = position.inSeconds;
  //     });
  //
  //     audioPlayer.playerStateStream.listen((event) {
  //       if (event.processingState == ProcessingState.completed) {
  //         _resetPlaybackTimer();
  //         if (recording.value == Recording.isAudioPaused ||
  //             recording.value == Recording.isAudioPlaying) {
  //           recording.value = Recording.initial;
  //           audioPlayer.clearAudioSources();
  //           log("initial State Set from if");
  //         }
  //         log("initial State");
  //       }
  //     });
  //   }
  // }

  void _resetPlaybackTimer() {
    _playbackSecondsElapsed.value = 0;
  }

  // Pause Playback
  Future<void> pausePlayback() async {
    recording.value = Recording.isAudioPaused;
    await audioPlayer.pause();
    log('TO audio pause');
  }

  // Resume Playback
  Future<void> resumePlayback() async {
    recording.value = Recording.isAudioPlaying;
    await audioPlayer.play();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsElapsed++;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resetTimer() {
    _stopTimer();
    _secondsElapsed = 0.obs;
  }

  // Dispose resources
  void dispose() {
    audioPlayer.dispose();
    record.dispose();
  }
}
