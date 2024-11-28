import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_services/message_service.dart';
import '../../core/base_bloc/base_bloc.dart';
import '../../core/db_helper.dart';
import '../../core/preference_client/preference_client.dart';
import '../../core/utils/utils.dart';
import '../../models/messages_response.dart';
import '../../views/global_widgets/toast_helper.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends BaseBloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial());

  final MessageService messageService = MessageService();

  GetMessagesSuccess getMessagesSuccess = GetMessagesSuccess();
  SearchMessagesSuccess searchMessagesSuccess = SearchMessagesSuccess();

  FutureOr<void> _getMessages(
      GetMessages event, Emitter<MessageState> emit) async {

      emit((event.isInitialSync || event.isRefresh) ? MessageLoading():MessagePaginationLoading());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = await PreferencesClient(prefs: prefs).getPageToken();
      Map<String, String>? queryToAPI;

      bool dataAvailable = false;
      if(event.isInitialSync){
        final List<Message> existingMessages = await MessageDBHelper.getAllMessages();
        dataAvailable = !Utils.nullOrEmptyList(existingMessages);
      }else{
        if(!event.isRefresh && !Utils.nullOrEmpty(token)){
          queryToAPI = Utils.getHeader(token);
        }
      }

      if(event.isRefresh || !(event.isInitialSync && dataAvailable)){
        final List<Message> existingMessages = await MessageDBHelper.getAllMessages();
        dataAvailable = !Utils.nullOrEmptyList(existingMessages);

        final MessageResponse? authorResponse = await messageService.getMessages(queryToAPI: queryToAPI);

        PreferencesClient(prefs: prefs).setUserPageToken(token: authorResponse?.pageToken);

        // clearing the DB Date
        if(event.isInitialSync || event.isRefresh){
          MessageDBHelper.clearAllMessages();
        }
        // inserting the data to DB
        MessageDBHelper.syncMessages(authorResponse?.messages ?? <Message>[]);
      }

      // fetching the data from DB
      final List<Message> messages = await MessageDBHelper.getAllMessages();

      emit(getMessagesSuccess..messages = messages);
  }

  FutureOr<void> _searchMessages(
      SearchMessages event, Emitter<MessageState> emit) async {
      emit(MessageLoading());

      // searching the data from DB
      final List<Message> messages = await MessageDBHelper.searchItemsByName(event.searchText);

      emit(searchMessagesSuccess..messages = messages);
  }

  FutureOr<void> _updateFavourite(
      UpdateFavourite event, Emitter<MessageState> emit) async {
      emit(UpdateMessageLoading());

      // update the data from DB
      await MessageDBHelper.updateFavourite(message: event.message);

      final List<Message> messages = await MessageDBHelper.getAllMessages();

      emit(getMessagesSuccess..messages = messages);
  }

  FutureOr<void> _deleteMessage(
      DeleteMessage event, Emitter<MessageState> emit) async {
      emit(UpdateMessageLoading());

      // delete the data from DB
      await MessageDBHelper.deleteMessage(message: event.message);

      final List<Message> messages = await MessageDBHelper.getAllMessages();

      emit(getMessagesSuccess..messages = messages);
  }

  @override
  Future<void> eventHandlerMethod(MessageEvent event, Emitter<MessageState> emit) async {
    switch (event.runtimeType) {
      case const (GetMessages):
        return _getMessages(event as GetMessages, emit);
      case const (SearchMessages):
        return _searchMessages(event as SearchMessages, emit);
      case const (UpdateFavourite):
        return _updateFavourite(event as UpdateFavourite, emit);
      case const (DeleteMessage):
        return _deleteMessage(event as DeleteMessage, emit);
    }
  }

  @override
  MessageState getErrorState() {
    return MessageError();
  }
}

Future<void> onAuthBlocChange(
    {required BuildContext context,
    required MessageState state}) async {
  switch (state.runtimeType) {
    case const (MessageError):
      final MessageError currentState = state as MessageError;
      if (context.mounted) {
        ToastHelper.failureToast(
            context: context,
            message: '${currentState.errorCode} : ${currentState.errorMsg}');
      }
  }
}
