// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voyzi/app/utils/helpers/logger.dart';

/// extension for [String]
extension StringX on String {
  bool get hasEmoji => RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
      ).hasMatch(this);

  String get capitalized => this[0].toUpperCase() + substring(1);

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String get removeMobileFormatter =>
      replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').trim();

  Uri? get uri => Uri.tryParse(this);
  // Future<void> launchURL({bool isExternal = false}) async {
  //   final encodedURL = Uri.encodeFull(this);

  //   var newURL = encodedURL;

  //   if (!newURL.isValidNetworkURL) {
  //     newURL = 'http://$encodedURL';
  //   }

  //   try {
  //     await launchUrlString(
  //       newURL,
  //       mode: isExternal
  //           ? LaunchMode.externalApplication
  //           : LaunchMode.inAppWebView,
  //     );
  //   } on Exception catch (ex) {
  //     'Something went wrong $ex'.logD;
  //   }
  // }

  bool get isValidNetworkURL =>
      (uri?.hasAbsolutePath ?? false) ||
      (uri?.scheme.startsWith('http') ?? false);

  DateTime? formatDateTimeToLocalDate({
    String inFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS",
    String outFormat = 'MM/dd/yy HH:mm',
  }) {
    try {
      final dateTime = DateFormat(inFormat).parse(this, true);
      return dateTime.toLocal();
    } catch (error) {
      '$error'.log;
    }
    return null;
  }

  /// Returns a String without white space at all
  /// "hello world" // helloworld
  String get removeAllWhiteSpace => replaceAll(RegExp(r'\s+\b|\b\s'), '');

  String get upperCamelCase {
    final out = StringBuffer();
    final parts = split('_');
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        out.write(part.capitalized);
      }
    }
    return out.toString();
  }

  /// Returns a copy of this with [other] inserted starting at [index].
  ///
  /// Example:
  /// ```dart
  /// 'word'.insert('s', 0); // 'sword'
  /// 'word'.insert('ke', 3); // 'worked'
  /// 'word'.insert('y', 4); // 'wordy'
  /// ```
  String insert(String other, int index) => (StringBuffer()
        ..write(substring(0, index))
        ..write(other)
        ..write(substring(index)))
      .toString();

  TimeOfDay? get stringToTimeOfDay {
    final format = RegExp(r'^(\d+):(\d+)(?:\s*(AM|PM))?$');
    final match = format.firstMatch(this);

    if (match != null) {
      var hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final period = match.group(3);

      if (period != null && period.toUpperCase() == 'PM' && hours < 12) {
        hours += 12;
      } else if (period != null &&
          period.toUpperCase() == 'AM' &&
          hours == 12) {
        hours = 0;
      }

      return TimeOfDay(hour: hours, minute: minutes);
    } else {
      return null;
    }
  }
}
