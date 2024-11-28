import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/message_bloc/message_bloc.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';

class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage({super.key});

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  late MessageBloc messageBloc;
  Message? currentMessage;

  @override
  void initState() {
    messageBloc = BlocProvider.of<MessageBloc>(context);
    currentMessage = messageBloc.updateMessagesSuccess.currentMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocListener<MessageBloc, MessageState>(
        listener: (BuildContext context, MessageState state) {
          if (state is UpdateMessagesSuccess) {
            setState(() {
              currentMessage = state.currentMessage;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.redAccent,
            ),
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: Text('Details',
                style: textTheme.titleLarge?.copyWith(fontSize: 22.sp)),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  messageBloc.add(UpdateFavourite(
                      message: currentMessage,
                      searchText:
                          messageBloc.updateMessagesSuccess.searchText));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child:
                      favouriteAsset(isFavourite: currentMessage?.isFavourite),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: <Widget>[
                getSpace(20.h, 0),
                profilePic(size: 250.h, url: currentMessage?.author?.photoUrl),
                getSpace(20.h, 0),
                Text(currentMessage?.author?.name ?? '',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(fontSize: 22.sp)),
                getSpace(20.h, 0),
                Text(currentMessage?.content ?? '',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium),
              ],
            ),
          ),
        ));
  }
}
