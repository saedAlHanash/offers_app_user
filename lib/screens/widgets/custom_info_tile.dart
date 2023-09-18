import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

// ignore: must_be_immutable
class CustomInfoTile extends StatefulWidget {
  final String title;
  final IconData? actionIcon;
  final Function onActionPressed;
  final String fieldIcon;
  bool? switchAction;
  final bool margining;

  CustomInfoTile({
    Key? key,
    required this.title,
    this.actionIcon,
    required this.onActionPressed,
    required this.fieldIcon,
    this.switchAction,
    this.margining = true,
  }) : super(key: key);

  @override
  State<CustomInfoTile> createState() => _CustomInfoTileState();
}

class _CustomInfoTileState extends State<CustomInfoTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.switchAction != null
            ? Dimensions.padding8
            : Dimensions.padding16,
        vertical: widget.switchAction != null ? 0 : Dimensions.padding8,
      ),
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.padding16,
          horizontal: widget.margining ? Dimensions.padding24 : 0.0),
      decoration: BoxDecoration(
        color: AppUI.greyCardColor,
        borderRadius: Dimensions.borderRadius24,
      ),
      child: InkWell(
        onTap: () {
          widget.onActionPressed();
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: SvgPicture.asset(
                widget.fieldIcon,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(
              flex: 5,
            ),
            if (widget.actionIcon != null)
              Icon(
                widget.actionIcon,
                size: 16,
              ),
            if (widget.switchAction != null)
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: widget.switchAction!,
                  onChanged: (bool value) {
                    widget.onActionPressed(value);
                    setState(() {
                      widget.switchAction = value;
                    });
                  },
                  splashRadius: 0.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
