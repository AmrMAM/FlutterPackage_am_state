import 'dart:io';

extension AmToString on String {
  /// to convert a string to boolean;
  /// Returns [true] if the Lower Case of this variable == 'true';
  bool toBool() {
    return this.trim().toLowerCase() == 'true';
  }
}

extension AmToDateTime on DateTime {
  /// Returns the DateTime in this format [2022/05/15];
  String amDateFormatYYMMDD() {
    final _dte = this;
    final _mnth = _dte.month <= 9 ? '0${_dte.month}' : '${_dte.month}';
    final _day = _dte.day <= 9 ? '0${_dte.day}' : '${_dte.day}';

    return '${_dte.year}/$_mnth/$_day';
  }

  /// Returns the DateTime in this format [05:30:56];
  String amTimeFormatHHMMSS() {
    final _hh = this.hour <= 9 ? '0${this.hour}' : '${this.hour}';
    final _mm = this.minute <= 9 ? '0${this.minute}' : '${this.minute}';
    final _ss = this.second <= 9 ? '0${this.second}' : '${this.second}';

    return '$_hh:$_mm:$_ss';
  }

  /// Returns the DateTime in this format [05:30 am];
  String amTimeFormatHHMMPMam() {
    bool isPM = this.hour >= 12;
    int hour = isPM ? this.hour - 12 : this.hour;
    hour = hour == 0 ? 12 : hour;

    final _hh = hour <= 9 ? '0$hour' : '$hour';
    final _mm = this.minute <= 9 ? '0${this.minute}' : '${this.minute}';
    // final _ss = this.second <= 9 ? '0${this.second}' : '${this.second}';

    return '$_hh:$_mm ${isPM ? 'PM' : 'AM'}';
  }
}

extension AmToDuration on Duration {
  /// converts the [Duration] into [String] in details
  String convertToString() {
    // Get the years, months, days, hours, minutes, and seconds from the duration.
    int years = this.inDays ~/ 365;
    int months = (this.inDays % 365) ~/ 30;
    int days = (this.inDays % 365) % 30;
    int hours = this.inHours % 24;
    int minutes = this.inMinutes % 60;
    int seconds = this.inSeconds % 60;

    // Create a string to display the duration.
    String durationString = '';
    if (years > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += '$years years';
    }
    if (months > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' $months months';
    }
    if (days > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' $days days';
    }
    if (hours > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' $hours hours';
    }
    if (minutes > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' $minutes minutes';
    }
    if (seconds > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' $seconds seconds';
    }

    // Return the duration string.
    return durationString;
  }

  // ---------------------------------------------------------------------------

  /// Converts the [Duration] into shorted format [String]
  String convertToWatchString() {
    // Get the years, months, days, hours, minutes, and seconds from the duration.
    int years = this.inDays ~/ 365;
    int months = (this.inDays % 365) ~/ 30;
    int days = (this.inDays % 365) % 30;
    int hours = this.inHours % 24;
    int minutes = this.inMinutes % 60;
    int seconds = this.inSeconds % 60;

    // Create a string to display the duration.
    String durationString = '';
    if (years > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' ${years}y';
    }
    if (months > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' ${months}m';
    }
    if (days > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' ${days}d';
    }
    if (hours > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' ${hours}h';
    }
    if (minutes > 0) {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' ${minutes <= 9 ? '0$minutes' : minutes}';
    } else {
      if (durationString.isNotEmpty) durationString += ',';
      durationString += ' 00';
    }
    if (seconds > 0) {
      if (durationString.isNotEmpty) durationString += ':';
      durationString += '${seconds <= 9 ? '0$seconds' : seconds}';
    } else {
      if (durationString.isNotEmpty) durationString += ':';
      durationString += '00';
    }

    // Return the duration string.
    return durationString;
  }
}

extension AmToFile on File {
  /// Returns only the filename
  String get getFileName {
    return path.replaceAll("/", ":").replaceAll("\\", ":").split(":").last;
  }

  /// Returns only the file extension
  String get getFileExtension {
    final fname = getFileName;
    if (fname.contains(".")) {
      return fname.split(".").last;
    }
    return "";
  }
}

extension AmToList<T> on List<T> {
  /// Splits the [List<T>] into [List<List<T>>] using delimiter of type [List<T>]
  /// same idea as the string split
  List<List<T>> splitList(List<T> delimiter) {
    final source = this;
    var data = <List<T>>[];
    var dataIndexes = <int>[0];
    var slen = source.length;
    var dlen = delimiter.length;
    int seek = 0;
    var delReg = List<bool>.filled(dlen, false);
    // var idealDelReg = List<bool>.filled(dlen, true);

    if (slen == 0 || dlen == 0 || dlen >= slen) {
      data.add(source);
      return data;
    }

    while ((seek < slen)) {
      for (int idel = 0; idel < dlen; idel++) {
        // var t = Array.IndexOf<T>(source, delimiter[idel], seek);
        var t = source.indexOf(delimiter[idel], seek);
        if (t > -1) {
          delReg[idel] = true;
          seek = t + 1;
          if (seek == slen) {
            break;
          }
        } else {
          delReg[idel] = false;
          break;
        }
      }

      if (delReg.every((element) => element)) {
        dataIndexes.add(seek);
        if (seek < slen) continue;
      }
      break;
    }
    dataIndexes.add(slen - 1);

    int prevIndex = 0;
    int index = 0;
    int currentArrayLength = 1;
    for (int si = 1; si < dataIndexes.length; si++) {
      prevIndex = index;
      index = dataIndexes[si];
      currentArrayLength = si == 0 || si == dataIndexes.length - 1
          ? 0
          : index - dlen - prevIndex;
      currentArrayLength = si == dataIndexes.length - 1
          ? index - prevIndex + 1
          : currentArrayLength;

      List cArray = List.filled(currentArrayLength, null);
      //List.filled(currentArrayLength, );
      List.copyRange(
          cArray, 0, source, prevIndex, prevIndex + currentArrayLength);
      // Array.Copy(source, prevIndex, cArray, 0, currentArrayLength);
      data.add(cArray.map((e) => e as T).toList());
    }

    return data;
  }
}
