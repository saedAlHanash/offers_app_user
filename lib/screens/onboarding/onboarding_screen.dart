import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/auth/login_screen.dart';
import 'package:offers_awards/screens/onboarding/components/onboarding_item.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPageIndex = _controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView.builder(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppConstant.screens.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppConstant.screens[index].image),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.padding16,
                vertical: Dimensions.padding8,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: _currentPageIndex > 0 &&
                        _currentPageIndex < AppConstant.screens.length
                    ? AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      )
                    : AppBar(
                        backgroundColor: Colors.transparent,
                      ),
                body: OnBoardingItem(
                  currentPageIndex: _currentPageIndex,
                  index: index,
                ),
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.all(
                    Dimensions.padding16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPageIndex < AppConstant.screens.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.ease,
                        );
                      } else {
                        Get.off(() => const LoginScreen());
                      }
                    },
                    child: const Text('متابعة'),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
