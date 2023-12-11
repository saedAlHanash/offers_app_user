import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/term.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/services/app_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<List<Term>> about;
  bool isLoading = false;

  @override
  void initState() {
    about = AppServices.fetchAbout();
    super.initState();
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    about = AppServices.fetchAbout();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        title: 'اعرف اكتر',
      ),
      body: FutureBuilder<List<Term>>(
          future: about,
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
              return ListView.builder(
                  padding: EdgeInsets.all(
                    Dimensions.padding24,
                  ),
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.padding24,
                          ),
                          child: Text(
                            snapshot.requireData[index].label,
                            style: const TextStyle(
                              fontSize: Dimensions.font18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          snapshot.requireData[index].value,
                          style: const TextStyle(
                            fontSize: Dimensions.font16,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return CustomFailed(
                onRetry: retry,
              );
            }

            return const SizedBox.shrink();
          }),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_about",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
