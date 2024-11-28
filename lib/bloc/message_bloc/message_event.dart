part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class GetMessages extends MessageEvent {
  GetMessages({this.isInitialSync = false, this.isRefresh = false, this.searchText});

  final bool isInitialSync;
  final bool isRefresh;
  final String? searchText;
}

class SearchMessages extends MessageEvent {
  SearchMessages({required this.searchText});

  final String searchText;
}

class UpdateFavourite extends MessageEvent {
  UpdateFavourite({required this.message, this.searchText, this.isDetailsPage = false});

  final Message? message;
  final String? searchText;
  final bool isDetailsPage;
}

class DeleteMessage extends MessageEvent {
  DeleteMessage({required this.message, this.searchText});

  final Message? message;
  final String? searchText;
}
