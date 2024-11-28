import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_config.dart';
import '../../bloc/message_bloc/message_bloc.dart';
import '../../core/utils/utils.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';

class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage(
      {super.key, required this.message, required this.searchText});

  final Message? message;
  final String? searchText;

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  late final MessageBloc messageBloc;

  @override
  void initState() {
    messageBloc = BlocProvider.of<MessageBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      messageBloc.stream.listen((MessageState state) =>
          (mounted ? onAuthBlocChange(context: context, state: state) : null));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.redAccent,
            ),
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: Text('Details',
                style: textTheme.titleLarge?.copyWith(fontSize: 22.sp)),
            actions: [
              GestureDetector(
                onTap: () {
                  messageBloc.add(UpdateFavourite(
                      message: widget.message,
                      searchText: widget.searchText,
                      isDetailsPage: true));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child:
                      favouriteAsset(isFavourite: widget.message?.isFavourite),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                getSpace(20.h, 0),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500.r),
                    // Set the border radius
                    child: Image.network(
                      Utils.nullOrEmpty(widget.message?.author?.photoUrl)
                          ? 'https://picsum.photos/200'
                          : '${AppConfig.shared.scheme}://${AppConfig.shared.host}/${widget.message?.author?.photoUrl}',
                      height: 250.h,
                      width: 250.h,
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ),
                getSpace(20.h, 0),
                Text(widget.message?.author?.name ?? '',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(fontSize: 22.sp)),
                getSpace(20.h, 0),
                Text(widget.message?.content ?? '',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium),
              ],
            ),
          ),
        ),
        BlocBuilder<MessageBloc, MessageState>(
            builder: (BuildContext context, MessageState state) {
          if (state is MessagePaginationLoading ||
              state is UpdateMessageLoading) {
            return loaderWidget(context);
          } else {
            return emptyBox();
          }
        })
      ],
    );
  }
}
