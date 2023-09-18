import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool minPadding;

  const CustomScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.minPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(Dimensions.padding8),
        color: AppUI.secondaryColor,
        child: Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.padding16,
                horizontal:
                    minPadding ? Dimensions.padding4 : Dimensions.padding16,
              ),
              child: body,
            ),
          ),
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
