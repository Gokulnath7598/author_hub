
import 'package:flutter/material.dart';

class Utils {

  static bool nullOrEmpty(String? text){
    return text == null || text == '';
  }

  static bool nullOrEmptyList(List<dynamic>? list){
    return list == null || list.isEmpty;
  }

  static String yearsAgo(String? dateString) {
    if(nullOrEmpty(dateString)){
      return '';
    }else{
      final DateTime date = DateTime.parse(dateString!);
      final DateTime now = DateTime.now();

      final int differenceInDays = now.difference(date).inDays;
      final int years = differenceInDays ~/ 365;

      return '$years years ago';
    }
  }

  static String getFoundText(List<dynamic>? list) {
    if(nullOrEmptyList(list)){
      return '0 found';
    }else{
      return '${list!.length} ${list.length == 1 ? 'found':'founds'}';
    }
  }

  static Map<String, String> getHeader(String? token) {
    return <String, String>{
      'pageToken': '$token',
    };
  }

  static MaterialPageRoute<dynamic> pushMethod(Widget value) =>
      MaterialPageRoute<void>(builder: (BuildContext context) => value);

}
