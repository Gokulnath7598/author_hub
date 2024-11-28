import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../app_config.dart';
import '../../bloc/message_bloc/message_bloc.dart';
import '../../core/app_assets.dart';
import '../../core/utils/utils.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MessageBloc messageBloc;
  final TextEditingController _searchController = TextEditingController();
  CancelableOperation<dynamic>? cancellableOperation;

  Future<dynamic> fromCancelable(Future<dynamic> future) async {
    cancellableOperation?.cancel();
    cancellableOperation =
        CancelableOperation<dynamic>.fromFuture(future, onCancel: () {
      debugPrint('API Call Cancelled');
    });
    return cancellableOperation?.value;
  }

  Future<dynamic> getTranslation(String value) async {
    return Future<dynamic>.delayed(const Duration(milliseconds: 1000), () {
      return value;
    });
  }

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
        return Scaffold(
          body: SafeArea(
            child: LazyLoadScrollView(
              onEndOfPage: () {
                if (!(state is MessageLoading ||
                        state is MessagePaginationLoading)) {
                  messageBloc.add(GetMessages());
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  messageBloc.add(GetMessages(isRefresh: true));
                },
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (String searchText) {
                          fromCancelable(getTranslation(searchText))
                              .then((dynamic value) {
                            messageBloc
                                .add(SearchMessages(searchText: searchText));
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          suffixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: const BorderSide(
                              color: Colors
                                  .transparent, // Make the border transparent
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: const BorderSide(
                              color: Colors
                                  .transparent, // Make the border transparent
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: const BorderSide(
                              color: Colors
                                  .redAccent, // Make the border transparent
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    if (state is MessageLoading)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (BuildContext ctx, int index) =>
                              ListTile(
                                title: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20.r)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          child: Container(
                                              color: Colors.black12,
                                              width: 50.h,
                                              height: 50.h),
                                        ),
                                        getSpace(0, 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  color: Colors.black12,
                                                  height: 15.h),
                                              getSpace(5.h, 0),
                                              Container(
                                                  color: Colors.black12,
                                                  height: 10.h)
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ))
                    else
                      Utils.nullOrEmptyList(
                              Utils.nullOrEmpty(_searchController.text)
                                  ? messageBloc.getMessagesSuccess.messages
                                  : messageBloc.searchMessagesSuccess.messages)
                          ? ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40.w, vertical: 120.h),
                                  child: const Text(
                                    'No Authors Available now, Please Try after sometime',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  Utils.nullOrEmpty(_searchController.text)
                                      ? messageBloc
                                          .getMessagesSuccess.messages?.length
                                      : messageBloc.searchMessagesSuccess.messages
                                          ?.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                final List<Message>? messages =
                                    Utils.nullOrEmpty(_searchController.text)
                                        ? messageBloc.getMessagesSuccess.messages
                                        : messageBloc
                                            .searchMessagesSuccess.messages;
                                return Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20.r)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          child: Image.network(
                                              Utils.nullOrEmpty(messages?[index]
                                                      .author
                                                      ?.photoUrl)
                                                  ? 'https://picsum.photos/200'
                                                  : '${AppConfig.shared.scheme}://${AppConfig.shared.host}/${messages?[index].author?.photoUrl}',
                                              height: 50.h,
                                              width: 50.h),
                                        ),
                                        getSpace(0, 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  messages?[index]
                                                          .author
                                                          ?.name ??
                                                      '',
                                                  style: textTheme.bodyLarge),
                                              Text(
                                                  Utils.yearsAgo(
                                                      messages?[index].updated),
                                                  style: textTheme.bodySmall),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: (){
                                                messageBloc.add(UpdateFavourite(message: messages?[index]));
                                              },
                                              child: SvgPicture.asset(AppAssets.heart,
                                                  color: (messages?[index].isFavourite ?? false) ? Colors.redAccent:Colors.black12),
                                            ),
                                            getSpace(0, 10.w),
                                            GestureDetector(
                                              onTap:(){
                                                messageBloc.add(DeleteMessage(message: messages?[index]));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    border: Border.all(
                                                        color: Colors.redAccent,
                                                        width: 2.sp)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.h,
                                                      horizontal: 6.w),
                                                  child: Text('Delete',
                                                      style: textTheme.bodySmall
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .redAccent)),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ));
                              }),
                    if (state is MessagePaginationLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Text('Fetching data',
                            textAlign: TextAlign.center),
                      )
                    else
                      emptyBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
