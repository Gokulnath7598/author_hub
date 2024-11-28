
import 'package:flutter/material.dart';

import '../../models/messages_response.dart';

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

  static Message constructMessageObject(Map<String, dynamic> messageJSON) {
    return Message(
      id: messageJSON['id'] as int?,
      content: messageJSON['content'] as String?,
      updated: messageJSON['updated'] as String?,
      isFavourite: (messageJSON['is_favourite'] == 1) as bool?,
      author: Author(
        name: messageJSON['author_name'] as String?,
        photoUrl: messageJSON['author_photoUrl'] as String?,
      ),
    );
  }

  static Map<String, dynamic> constructMessageJSON(Message? message) {
    return <String, Object?>{
      'id': message?.id,
      'content': message?.content,
      'updated': message?.updated,
      'is_favourite': (message?.isFavourite ?? false) ? 1:0,
      'author_name': message?.author?.name,
      'author_photoUrl': message?.author?.photoUrl,
    };
  }

  static MaterialPageRoute<dynamic> pushMethod(Widget value) =>
      MaterialPageRoute<void>(builder: (BuildContext context) => value);

  
}
