import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/chat_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  TextEditingController msgController = TextEditingController();
  bool _isLoading=false;

  _sendMsg() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) {
      CustomSnackBar.showRowSnackBarError(
          "الرجاء الانتظار");
    } else {
      setState(() {
        _isLoading=true;
      });
      var res = await ChatServices().send(message: msgController.text);
      if (res && mounted) {
        _isLoading=false;
        msgController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.padding8,
      ),
      margin: EdgeInsets.only(
        right: Dimensions.padding16,
        left: Dimensions.padding16,
        bottom: Dimensions.padding24,
      ),
      decoration: BoxDecoration(
        borderRadius: Dimensions.borderRadius24,
        border: Border.all(color: AppUI.hintTextColor),
      ),
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset('assets/svg/buttons/send_msg.svg'),
            onPressed: msgController.text.isEmpty ? null : _sendMsg,
          ),
          Expanded(
            child: TextFormField(
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: Dimensions.font14,
              ),
              onChanged: (value) {
                setState(() {});
              },
              controller: msgController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "أدخل رسالة هنا",
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
