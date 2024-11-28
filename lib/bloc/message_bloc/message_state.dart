part of 'message_bloc.dart';

abstract class MessageState extends ErrorState {}

class MessageInitial extends MessageState {}

// API List
class MessageLoading extends MessageState {}

// List Pagination
class MessagePaginationLoading extends MessageState {}

// Local List
class LocalMessagesLoading extends MessageState {}

// Update List item
class UpdateMessageLoading extends MessageState {}

class MessageError extends MessageState {}

class GetMessagesSuccess extends MessageState {
  GetMessagesSuccess({this.messages});

  List<Message>? messages;
}

class SearchMessagesSuccess extends MessageState {
  SearchMessagesSuccess({this.messages});

  List<Message>? messages;
}

class UpdateMessagesSuccess extends MessageState {
  UpdateMessagesSuccess({this.currentMessage, this.searchText});

  Message? currentMessage;
  String? searchText;
}

class DeleteMessagesSuccess extends MessageState {
  DeleteMessagesSuccess({this.searchText});

  String? searchText;
}
