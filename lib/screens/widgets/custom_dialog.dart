import 'package:flutter/material.dart';

class CustomDialog{
  static errorLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: const Text('حدث خطأ أثناء محاولة استرداد تفاصيل الموقع.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}