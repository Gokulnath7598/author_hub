class MessageResponse {

  MessageResponse({this.pageToken, this.messages});

  MessageResponse.fromJson(Map<String, dynamic> json) {
    pageToken = json['pageToken'] as String?;
    messages = (json['messages'] as List<dynamic>).map((dynamic e) => Message.fromJson(e as Map<String, dynamic>)).toList();
  }
  int? count;
  String? pageToken;
  List<Message>? messages;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageToken'] = pageToken;
    if (messages != null) {
      data['messages'] = messages?.map((Message v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {

  Message({this.content, this.updated, this.id, this.author, this.isFavourite});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    content = json['content'] as String?;
    updated = json['updated'] as String?;
    isFavourite = json['is_favourite'] as bool?;
    author = Author.fromJson(json['author'] as Map<String, dynamic>);
  }
  int? id;
  String? content;
  String? updated;
  Author? author;
  bool? isFavourite;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['updated'] = updated;
    data['is_favourite'] = isFavourite;
    if (author != null) {
      data['author'] = author?.toJson();
    }
    return data;
  }
}

class Author {

  Author({this.name, this.photoUrl});

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    photoUrl = json['photoUrl'] as String?;
  }
  String? name;
  String? photoUrl;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['photoUrl'] = photoUrl;
    return data;
  }
}
