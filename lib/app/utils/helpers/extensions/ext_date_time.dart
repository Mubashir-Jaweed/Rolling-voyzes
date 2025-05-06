// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _k_MMM_DD_yyyy = DateFormat('MMM DD, yyyy');

final _k_MMMM_yyyy = DateFormat('MMMM, yyyy');
final _k_dd_MM_yyyy = DateFormat('dd-MM-yyyy');

/// Extension on [DateTime] class
extension DateTimeX on DateTime {
  /// to check if date is today
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// to check if date is today
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  /// to check if date is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  /// Set Time of day
  DateTime setTimeOfDay(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  /// Time of dat from date time
  TimeOfDay get time => TimeOfDay.fromDateTime(this);

  /// get chat separator date string from date e.g Mon,6 May
  String get chatSeparatorDate {
    if (isToday()) {
      return 'Today';
    } else if (isYesterday()) {
      return 'Yesterday';
    } else {
      return DateFormat('EE, d MMM yyyy').format(this);
    }
  }

  /// get full date time string from date e.g 23/10/2023, 09:32:00 PM
  String get fullDateTime => DateFormat('dd/MM/yyyy, hh:mm:ss aa').format(this);

  String timeAgoSinceDate({bool numericDates = true}) {
    final date = this;
    final date2 = DateTime.now().toLocal();
    final difference = date2.difference(date);

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inSeconds <= 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes <= 1) {
      return numericDates ? '1 minute ago' : 'A minute ago';
    } else if (difference.inMinutes <= 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours <= 1) {
      return numericDates ? '1 hour ago' : 'An hour ago';
    } else if (difference.inHours <= 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 1) {
      return numericDates ? '1 day ago' : 'Yesterday';
    } else if (difference.inDays <= 6) {
      return '${difference.inDays} days ago';
    } else if ((difference.inDays / 7).ceil() <= 1) {
      return numericDates ? '1 week ago' : 'Last week';
    } else if ((difference.inDays / 7).ceil() <= 4) {
      return '${(difference.inDays / 7).ceil()} weeks ago';
    } else if ((difference.inDays / 30).ceil() <= 1) {
      return numericDates ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 30).ceil() <= 30) {
      return '${(difference.inDays / 30).ceil()} months ago';
    } else if ((difference.inDays / 365).ceil() <= 1) {
      return numericDates ? '1 year ago' : 'Last year';
    }
    return '${(difference.inDays / 365).floor()} years ago';
  }

  String get MMDDYYYY {
    return _k_MMM_DD_yyyy.format(this);
  }

  String get MMMMyyyy {
    return _k_MMMM_yyyy.format(this);
  }

  String get ddMMyyyy {
    return _k_dd_MM_yyyy.format(this);
  }
}
