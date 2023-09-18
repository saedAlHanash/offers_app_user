import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomLoadMore extends StatefulWidget {
  final Widget body;
  final RefreshController refreshController;
  final Function getData;
  final int total;
  final int length;

  const CustomLoadMore({
    Key? key,
    required this.body,
    required this.refreshController,
    required this.getData,
    required this.total,
    required this.length,
  }) : super(key: key);

  @override
  State<CustomLoadMore> createState() => _CustomLoadMoreState();
}

class _CustomLoadMoreState extends State<CustomLoadMore> {
  @override
  SmartRefresher build(BuildContext context) {
    return SmartRefresher(
      controller: widget.refreshController,
      enablePullUp: true,
      enablePullDown: false,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.failed) {
            body = const Text("لم نتمكن من عرض البيانات");
          } else if (mode == LoadStatus.loading) {
            body = const SpinKitThreeBounce(
              color: AppUI.primaryColor,
            );
          } else if (mode == LoadStatus.noMore) {
            body = const Text(
              "لا يوجد المزيد من البيانات ",
            );
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("اسحب لعرض المزيد من البيانات");
          } else {
            body = const Text(
              "اسحب لتحميل المزيد",
            );
          }
          return SizedBox(
            height: kBottomNavigationBarHeight,
            child: Center(
              child: body,
            ),
          );
        },
      ),
      onLoading: () async {
        if (widget.total > widget.length) {
          final result = await widget.getData();
          if (result) {
            widget.refreshController.loadComplete();
          } else {
            widget.refreshController.loadFailed();
          }
        } else {
          widget.refreshController.loadNoData();
        }
      },
      child: widget.body,
    );
  }
}
