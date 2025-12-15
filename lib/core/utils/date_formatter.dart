import 'package:intl/intl.dart';

String formatPublishedDate(DateTime dateTime) {
  try {
    
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}

String formatPublishedDateFromString(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);

    
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  } catch (e) {
    return dateString;
  }
}

String formatDateOnly(DateTime dateTime) {
  try {
    return DateFormat('dd MMM yyyy').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}

String formatDateOnlyFromString(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(dateTime);
  } catch (e) {
    return dateString;
  }
}

String formatRelativeDate(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} hari yang lalu';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} jam yang lalu';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} menit yang lalu';
  } else {
    return 'Baru saja';
  }
}