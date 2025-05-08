import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

enum Recording {
  initial,
  isRecording,
  isPaused,
  isResumed,
  isRecorded,
  isAudioPlaying,
  isAudioPaused
}

class VoiceRecorderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Record audioRecorder = Record();
  final AudioPlayer audioPlayer = AudioPlayer();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Uuid uuid = const Uuid();

  late AnimationController animationController;
  Rx<Recording> recording = Recording.initial.obs;
  RxString recordedFilePath = ''.obs;
  RxInt secondsElapsed = 0.obs;
  RxInt playbackSecondsElapsed = 0.obs;
  Timer? _recordingTimer;
  Timer? _playbackTimer;
  Rx<String> selected = Rx('local');

  @override
  void onInit() {
    animationController = AnimationController(vsync: this);
    super.onInit();
  }

  Future<void> startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      try {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/${uuid.v4()}.m4a';
        
        await audioRecorder.start(
          path: path,
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );
        
        recordedFilePath.value = path;
        recording.value = Recording.isRecording;
        secondsElapsed.value = 0;
        
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          secondsElapsed.value++;
        });
      } catch (e) {
        log('Recording error: $e');
        Get.snackbar('Error', 'Failed to start recording');
      }
    } else {
      Get.snackbar('Permission Required', 'Microphone access is needed');
    }
  }

  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    final path = await audioRecorder.stop();
    if (path != null) {
      recordedFilePath.value = path;
      recording.value = Recording.isRecorded;
    } else {
      recording.value = Recording.initial;
    }
  }

  Future<void> pauseRecording() async {
    await audioRecorder.pause();
    _recordingTimer?.cancel();
    recording.value = Recording.isPaused;
  }

  Future<void> resumeRecording() async {
    await audioRecorder.resume();
    recording.value = Recording.isRecording;
    
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      secondsElapsed.value++;
    });
  }

  Future<void> playRecording() async {
    if (recordedFilePath.value.isEmpty) return;
    
    try {
      await audioPlayer.setFilePath(recordedFilePath.value);
      recording.value = Recording.isAudioPlaying;
      
      audioPlayer.play();
      
      playbackSecondsElapsed.value = 0;
      _playbackTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        playbackSecondsElapsed.value = audioPlayer.position.inSeconds;
      });
      
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          stopPlayback();
        }
      });
    } catch (e) {
      log('Playback error: $e');
      Get.snackbar('Error', 'Failed to play recording');
    }
  }

  Future<void> pausePlayback() async {
    await audioPlayer.pause();
    _playbackTimer?.cancel();
    recording.value = Recording.isAudioPaused;
  }

  Future<void> resumePlayback() async {
    await audioPlayer.play();
    recording.value = Recording.isAudioPlaying;
    
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      playbackSecondsElapsed.value = audioPlayer.position.inSeconds;
    });
  }

  Future<void> stopPlayback() async {
    _playbackTimer?.cancel();
    await audioPlayer.stop();
    recording.value = Recording.isRecorded;
    playbackSecondsElapsed.value = 0;
  }

  Future<void> retakeRecording() async {
    await audioRecorder.stop();
    await audioPlayer.stop();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    
    final file = File(recordedFilePath.value);
    if (await file.exists()) {
      await file.delete();
    }
    
    recordedFilePath.value = '';
    secondsElapsed.value = 0;
    playbackSecondsElapsed.value = 0;
    recording.value = Recording.initial;
  }

  Future<String?> uploadRecording() async {
    if (recordedFilePath.value.isEmpty) return null;
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'Not authenticated');
        return null;
      }
      
      final file = File(recordedFilePath.value);
      final fileName = basename(file.path);
      final storagePath = 'recordings/${user.uid}/$fileName';
      
      final uploadTask = storage.ref().child(storagePath).putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      log('Upload error: $e');
      Get.snackbar('Error', 'Failed to upload recording');
      return null;
    }
  }

  void changeLocalGlobal({required String text}) {
    selected.value = text;
    log("Selected : ${selected.value}");
  }

  @override
  void onClose() {
    audioRecorder.dispose();
    audioPlayer.dispose();
    animationController.dispose();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    super.onClose();
  }
}