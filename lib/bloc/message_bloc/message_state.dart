part of 'message_bloc.dart';

abstract class MessageState extends ErrorState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessagePaginationLoading extends MessageState {}

class UpdateMessageLoading extends MessageState {}

class MessageError extends MessageState {}

class GetMessagesSuccess extends MessageState {
  GetMessagesSuccess({this.messages, this.updateMessages, this.isDetailsPage = false});

  List<Message>? messages;
  Message? updateMessages;
  bool? isDetailsPage;
}

class SearchMessagesSuccess extends MessageState {
  SearchMessagesSuccess({this.messages, this.updateMessages, this.isDetailsPage = false});

  List<Message>? messages;
  Message? updateMessages;
  bool? isDetailsPage;
}
