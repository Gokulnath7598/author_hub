part of 'message_bloc.dart';

abstract class MessageState extends ErrorState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessagePaginationLoading extends MessageState {}

class UpdateMessageLoading extends MessageState {}

class MessageError extends MessageState {}

class GetMessagesSuccess extends MessageState {
  GetMessagesSuccess({this.messages, this.currentMessage, this.searchText});

  List<Message>? messages;
  Message? currentMessage;
  String? searchText;
}

class SearchMessagesSuccess extends MessageState {
  SearchMessagesSuccess({this.messages, this.currentMessage, this.searchText});

  List<Message>? messages;
  Message? currentMessage;
  String? searchText;
}
