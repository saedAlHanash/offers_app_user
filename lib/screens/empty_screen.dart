import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/utils/dimensions.dart';

class EmptyScreen extends StatefulWidget {
  final String svgPath;
  final String title;
  final String buttonText;
  final Function() buttonFunction;
  final bool isDone;

  const EmptyScreen({
    super.key,
    required this.svgPath,
    required this.title,
    required this.buttonText,
    required this.buttonFunction,
    this.isDone = false,
  });

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.isDone)
              ScaleTransition(
                scale: animation,
                child: SvgPicture.asset(
                  widget.svgPath,
                  fit: BoxFit.scaleDown,
                ),
              ),
            if (!widget.isDone)
              SvgPicture.asset(
                widget.svgPath,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            Padding(
              padding: EdgeInsets.all(Dimensions.padding24),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize:
                      widget.isDone ? Dimensions.font24 : Dimensions.font16,
                  fontWeight:
                      widget.isDone ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.padding24,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.buttonFunction,
                  child: Text(
                    widget.buttonText,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.padding24,
              ),
              child: const SizedBox(
                height: kBottomNavigationBarHeight,
              ),
            )
          ],
        ),
      ),
    );
  }
}
