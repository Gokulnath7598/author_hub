
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

  static Map<String, String> getHeader(String? token) {
    return <String, String>{
      // 'Content-Type': 'application/json',
      'pageToken': '$token',
    };
  }

}
