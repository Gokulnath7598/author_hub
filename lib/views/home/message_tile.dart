import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/utils.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';
import 'delete_popup.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.message, required this.onFavourite, required this.onDelete, required this.onTap});
  final Message? message;
  final void Function() onFavourite;
  final void Function() onDelete;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[100]!),
              borderRadius:
              BorderRadius.circular(20.r)),
          margin: EdgeInsets.symmetric(
              horizontal: 10.w, vertical: 5.h),
          padding: EdgeInsets.symmetric(
              horizontal: 15.w, vertical: 10.h),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AuthorBadge(message: message),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: onFavourite,
                      child: favouriteAsset(isFavourite: message?.isFavourite)
                  ),
                  getSpace(0, 10.w),
                  deleteButton(onTap:(){
                    showDialog<Widget>(
                      context: context,
                      barrierDismissible: true, // Make the dialog non-dismissible
                      barrierColor:
                      Colors.black.withOpacity(0.5), // Set the background color to semi-transparent black
                      builder: (BuildContext context) {
                        return DeleteConfirmationPopup(
                          message: message,
                            onTap: onDelete
                        );
                      },
                    );
                  },)
                ],
              )
            ],
          )),
    );
  }
}


class AuthorBadge extends StatelessWidget {
  const AuthorBadge({super.key, required this.message});
  final Message? message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        profilePic(size: 50.h, url: message?.author?.photoUrl),
        getSpace(0, 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  message?.author
                      ?.name ??
                      '',
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text(
                  Utils.yearsAgo(
                      message?.updated),
                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400)),
            ],
          ),
        ),],
    );
  }
}
