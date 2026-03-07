import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    final DateFormat formatter = DateFormat('EEE, dd MMM yy hh:mm a');
    return formatter.format(this);
  }

  String toMMMddyyyy() {
    final DateFormat formatter = DateFormat('MMM, dd yyyy');
    return formatter.format(this);
  }

  String readable() {
    return DateFormat('dd MMM, yyyy hh:mm a').format(this);
  }

  String timeOnly() {
    return DateFormat('hh:mm').format(this);
  }

  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
