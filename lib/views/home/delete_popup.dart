import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';
import 'message_tile.dart';

class DeleteConfirmationPopup extends StatelessWidget {
  const DeleteConfirmationPopup({super.key, required this.onTap, required this.message});
  final void Function() onTap;
  final Message? message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete this author?', style: textTheme.titleLarge),
                getSpace(20.h, 0),
                AuthorBadge(message: message),
                getSpace(24.h, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                        child: Text('Cancel', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
                      ),
                    ),
                    deleteButton(onTap: onTap, isLarge: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
