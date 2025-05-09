import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

class AudioController {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _filePath;
  bool _isRecorderInitialized = false;

  Future<void> initRecorder() async {
    await Permission.microphone.request();
    if (await Permission.microphone.isGranted) {
      await _recorder.openRecorder();
      _isRecorderInitialized = true;
    }
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
    _isRecorderInitialized = false;
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) await initRecorder();

    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/${const Uuid().v4()}.aac';

    await _recorder.startRecorder(toFile: _filePath);
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
  }

  Future<void> pauseRecording() async {
    if (_recorder.isRecording) {
      await _recorder.pauseRecorder();
    }
  }

  Future<void> resumeRecording() async {
    if (_recorder.isPaused) {
      await _recorder.resumeRecorder();
    }
  }

  Future<void> retakeRecording() async {
    if (_recorder.isRecording || _recorder.isPaused) {
      await _recorder.stopRecorder();
    }
    _filePath = null;
  }

  Future<String?> uploadRecordingToFirebase() async {
    if (_filePath == null) return null;

    File file = File(_filePath!);
    String fileName = 'audio_${const Uuid().v4()}.aac';
    final ref = FirebaseStorage.instance.ref().child('audios/$fileName');

    await ref.putFile(file);
    String url = await ref.getDownloadURL();

    // Store URL in Firestore
    await FirebaseFirestore.instance.collection('audios').add({'url': url});

    return url;
  }

  Future<String?> fetchRandomAudioUrl() async {
    final snapshot = await FirebaseFirestore.instance.collection('audios').get();
    final docs = snapshot.docs;

    if (docs.isEmpty) return null;

    final randomDoc = docs[Random().nextInt(docs.length)];
    return randomDoc['url'];
  }

  bool get isRecording => _recorder.isRecording;
  bool get isPaused => _recorder.isPaused;
  String? get recordedFilePath => _filePath;
}
