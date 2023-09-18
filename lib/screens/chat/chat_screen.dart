import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:offers_awards/models/chat.dart';
import 'package:offers_awards/screens/chat/components/messages_list.dart';
import 'package:offers_awards/screens/chat/components/new_message.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/services/chat_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<Chat>> messages;
  bool isLoading = false;

  @override
  void initState() {
    messages = ChatServices().fetch();
    super.initState();
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    messages = ChatServices().fetch();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        title: "الدعم",
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: const CircleAvatar(
              backgroundImage: AssetImage(AppAssets.logo1),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: (MediaQuery.of(context).size.height -
                        kBottomNavigationBarHeight -
                        MediaQuery.of(context).padding.top) *
                    0.75,
                child: FutureBuilder<List<Chat>>(
                    future: messages,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          isLoading) {
                        return const Center(
                          child: SpinKitChasingDots(
                            color: AppUI.primaryColor,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return MessagesList(
                            messages: snapshot.data!,
                          );
                        } else {
                          return Lottie.asset(
                            AppAssets.emptyMsg,
                            fit: BoxFit.fitWidth,
                            repeat: false,
                          );
                        }
                      } else if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                        return CustomFailed(
                          onRetry: retry,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
              ),
            ),
            const NewMessages(),
          ],
        ),
      ),
    );
  }
}
