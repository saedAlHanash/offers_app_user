import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/cart_controller.dart';
import 'package:offers_awards/controllers/place_controller.dart';
import 'package:offers_awards/models/place.dart';
import 'package:offers_awards/screens/auth/select_location_screen.dart';
import 'package:offers_awards/screens/cart/components/place_dialog.dart';
import 'package:offers_awards/screens/cart/components/places_list.dart';
import 'package:offers_awards/screens/cart/components/session_location_dialog.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/empty_screen.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_icon_text_button.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/services/order_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ConfirmAddressScreen extends StatefulWidget {
  final String coupon;

  const ConfirmAddressScreen({Key? key, required this.coupon})
      : super(key: key);

  @override
  State<ConfirmAddressScreen> createState() => _ConfirmAddressScreenState();
}

class _ConfirmAddressScreenState extends State<ConfirmAddressScreen> {
  final PlaceController _placeController = Get.put(PlaceController());
  final TextEditingController _userInfoController = TextEditingController();

  bool enableEdit = false;
  final FocusNode _focusNode = FocusNode();

  late CartController cartController;
  bool isLoading = false;

  bool _isOrdering = false;

  @override
  void initState() {
    cartController = Get.find<CartController>();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'تأكيد العنوان',
      ),
      body: FutureBuilder<List<Place>>(
          future: _placeController.fetchPlaces(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Obx(() {
                _userInfoController.text =
                    '${_placeController.userInfo.value.country} ${_placeController.userInfo.value.area} ${_placeController.userInfo.value.address}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding16,
                      ),
                      child: const Text(
                        'يجب عليك اختيار موقعك الحالي لتجنب المشاكل ويمكنك تغيير الموقع',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomTitleText(title: 'الحالي'),
                        InkWell(
                            onTap: () {
                              SessionLocationDialog.edit(
                                  context: context,
                                  userInfo: _placeController.userInfo.value);
                            },
                            child: const CustomTitleText(title: 'تعديل')),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _placeController.select(null);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Dimensions.padding16),
                        decoration: _placeController.selectedPlace.value == null
                            ? BoxDecoration(
                                borderRadius: Dimensions.borderRadius24,
                                border: Border.all(
                                  color: AppUI.primaryColor,
                                  width: 2,
                                ),
                                // color: AppUI.redMap.shade50,
                              )
                            : null,
                        child: TextFormField(
                          enabled: false,
                          controller: _userInfoController,
                          style: const TextStyle(
                            color: AppUI.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration:
                              CustomInputDecoration.build('اسم المنطقة'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding16,
                      ),
                      child: const CustomTitleText(title: 'إضافة عنوان جديد'),
                    ),
                    CustomIconTextButton(
                      text: ' التسجيل بواسطة GPS',
                      iconPath: AppAssets.activeLocation,
                      function: () async {
                        final hasPermission =
                            await CustomizeLocation.handleLocationPermission();
                        if (hasPermission) {
                          final result =
                              await Get.to(() => const SelectLocationScreen());
                          if (result != null &&
                              result is Map<String, String> &&
                              context.mounted) {
                            PlaceDialog.create(
                                context: context, result: result);
                          }
                        }
                      },
                    ),
                    const PlacesList(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.padding24),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isOrdering) {
                            CustomSnackBar.showRowSnackBarError(
                                "الرجاء الانتظار");
                          } else {
                            setState(() {
                              _isOrdering = true;
                            });
                            OrderServices.create(
                              carts: cartController.getItems,
                              copoun: widget.coupon,
                              place: _placeController.selectedPlace.value ??
                                  Place(
                                    id: 0,
                                    longitude: _placeController
                                        .userInfo.value.longitude,
                                    latitude: _placeController
                                        .userInfo.value.latitude,
                                    location:
                                        '${_placeController.userInfo.value.country} ${_placeController.userInfo.value.area} ${_placeController.userInfo.value.address}',
                                    label: '',
                                  ),
                            ).then((value) {
                              if (value) {
                                cartController.clear();
                                Get.to(
                                  () => EmptyScreen(
                                    svgPath: AppAssets.done,
                                    isDone: true,
                                    title: 'تم الشراء بنجاح',
                                    buttonText: 'متابعة',
                                    buttonFunction: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage(),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              setState(() {
                                _isOrdering = false;
                              });
                            });
                          }
                        },
                        child: const Text(
                          "متابعة",
                        ),
                      ),
                    ),
                    if (_isOrdering)
                      const SpinKitThreeBounce(
                        color: AppUI.primaryColor,
                      ),
                    const SizedBox(
                      height: kBottomNavigationBarHeight,
                    ),
                  ],
                );
              });
            } else if (snapshot.connectionState == ConnectionState.waiting ||
                isLoading) {
              return const Center(
                child: SpinKitChasingDots(
                  color: AppUI.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return CustomFailed(
                onRetry: () {
                  setState(() {
                    isLoading = true;
                  });
                  _placeController.retry().then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
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
          heroTag: "support_chat_place",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
