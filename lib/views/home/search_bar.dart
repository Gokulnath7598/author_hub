import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatefulWidget {

  const CustomSearchBar(
      {super.key, required this.controller, required this.onSearch});
  final TextEditingController controller;
  final void Function() onSearch;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: TextField(
        controller: widget.controller,
        onChanged: (String searchText) {
          fromCancelable(getTranslation(searchText)).then((dynamic value) {
            widget.onSearch();
          });
        },
        style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w400),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Icon(Icons.search, color: Colors.grey, size: 30.sp),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: const BorderSide(
              color: Colors.transparent, // Make the border transparent
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: const BorderSide(
              color: Colors.transparent, // Make the border transparent
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: const BorderSide(
              color: Colors.redAccent, // Make the border transparent
            ),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
