part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class GetMessages extends MessageEvent {
  GetMessages({this.isInitialSync = false, this.isRefresh = false});

  final bool isInitialSync;
  final bool isRefresh;
}

class SearchMessages extends MessageEvent {
  SearchMessages({required this.searchText});

  final String searchText;
}

class UpdateFavourite extends MessageEvent {
  UpdateFavourite({required this.message});

  final Message? message;
}

class DeleteMessage extends MessageEvent {
  DeleteMessage({required this.message});

  final Message? message;
}
