import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../bloc/message_bloc/message_bloc.dart';
import '../../core/utils/utils.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';
import 'empty_screen.dart';
import 'message_tile.dart';
import 'search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MessageBloc messageBloc;
  final TextEditingController _searchController = TextEditingController();

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

    return BlocBuilder<MessageBloc, MessageState>(
      builder: (BuildContext context, MessageState state) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: LazyLoadScrollView(
                  onEndOfPage: () {
                    if (!(state is MessageLoading ||
                        state is MessagePaginationLoading)) {
                      messageBloc
                          .add(GetMessages(searchText: _searchController.text));
                    }
                  },
                  child: RefreshIndicator(
                    edgeOffset: 150,
                    onRefresh: () async {
                      messageBloc.add(GetMessages(isRefresh: true));
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        CustomSearchBar(
                            controller: _searchController,
                            onSearch: () {
                              messageBloc.add(SearchMessages(
                                  searchText: _searchController.text));
                            }),
                        if (state is MessageLoading)
                          const LoadingScreen()
                        else
                          Utils.nullOrEmptyList(
                                  Utils.nullOrEmpty(_searchController.text)
                                      ? messageBloc.getMessagesSuccess.messages
                                      : messageBloc
                                          .searchMessagesSuccess.messages)
                              ? EmptyScreen(
                                  text: Utils.nullOrEmpty(
                                          _searchController.text)
                                      ? 'No Authors Available now, Please Try after sometime'
                                      : 'No Authors Available')
                              : Column(
                                  children: [
                                    if (Utils.nullOrEmpty(
                                        _searchController.text))
                                      emptyBox()
                                    else
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Search Result', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
                                            Text(
                                                Utils.getFoundText(messageBloc.searchMessagesSuccess.messages), style: textTheme.headlineMedium
                                                ?.copyWith(color: Colors
                                                    .redAccent))
                                          ],
                                        ),
                                      ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Utils.nullOrEmpty(
                                                _searchController.text)
                                            ? messageBloc.getMessagesSuccess
                                                .messages?.length
                                            : messageBloc.searchMessagesSuccess
                                                .messages?.length,
                                        itemBuilder:
                                            (BuildContext ctx, int index) {
                                          final List<Message>? messages =
                                              Utils.nullOrEmpty(
                                                      _searchController.text)
                                                  ? messageBloc
                                                      .getMessagesSuccess
                                                      .messages
                                                  : messageBloc
                                                      .searchMessagesSuccess
                                                      .messages;
                                          return MessageTile(
                                              message: messages?[index],
                                              onFavourite: () {
                                                messageBloc.add(UpdateFavourite(
                                                    message: messages?[index],
                                                    searchText:
                                                        _searchController
                                                            .text));
                                              },
                                              onDelete: () {
                                                Navigator.pop(context);
                                                messageBloc.add(DeleteMessage(
                                                    message: messages?[index],
                                                    searchText:
                                                        _searchController
                                                            .text));
                                              });
                                        }),
                                  ],
                                ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state is MessagePaginationLoading ||
                state is UpdateMessageLoading)
              loaderWidget(context)
            else
              emptyBox(),
          ],
        );
      },
    );
  }
}
