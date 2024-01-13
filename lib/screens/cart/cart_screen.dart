import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/controllers/cart_controller.dart';
import 'package:offers_awards/screens/cart/components/cart_item.dart';
import 'package:offers_awards/screens/cart/confirm_address_screen.dart';
import 'package:offers_awards/screens/empty_screen.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/search/custom_search_delegate.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/order_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController couponController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'السلة',
        isBack: false,
      ),
      minPadding: true,
      body: GetBuilder<CartController>(builder: (cartController) {
        var cartList = cartController.getItems;
        if (cartList.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int index = 0; index < cartList.length; index++)
                GestureDetector(
                  onTap: () {
                    Get.to(() => OfferDetailsScreen(id: cartList[index].id));
                  },
                  child: CartWidget(
                    cartItem: cartList[index],
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.padding8,
                  horizontal: Dimensions.padding16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "المجموع",
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(cartController.totalAmount)} ${AppConstant.currency[cartController.currency] ?? cartController.currency}',
                      style: const TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.padding16,
                ),
                child: const Divider(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  // bottom: Dimensions.padding16,
                  right: Dimensions.padding16,
                  left: Dimensions.padding16,
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: couponController,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.font14),
                          decoration: const InputDecoration(
                            hintText: "ادخل كود الخصم",
                            hintStyle: TextStyle(color: AppUI.hintTextColor),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء ادخال كود الخصم";
                            }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_isLoading) {
                            CustomSnackBar.showRowSnackBarError(
                                "الرجاء الانتظار");
                          } else {
                            FocusScope.of(context).unfocus();
                            // Validate the form
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              OrderServices.checkCoupon(
                                      couponController.text,
                                      cartList.first.offer.provider.id,
                                      cartController.totalAmount)
                                  .then((value) {
                                if (value != null) {
                                  cartController.couponPriceF(value['amount'],value['price']);
                                } else {
                                  couponController.clear();
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.padding16,
                            vertical: Dimensions.padding8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: Dimensions.borderRadius10,
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppUI.gradient2Color,
                                  AppUI.gradient1Color,
                                ]),
                          ),
                          child: const Text(
                            "تطبيق",
                            style: TextStyle(
                              fontSize: Dimensions.font12,
                              color: AppUI.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.padding16,
                ),
                child: const Divider(),
              ),
              if (_isLoading)
                const SpinKitThreeBounce(
                  color: AppUI.primaryColor,
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.padding8,
                  horizontal: Dimensions.padding16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "إجمالي المبلغ المطلوب",
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(cartController.couponPrice ?? cartController.totalAmount)} ${AppConstant.currency[cartController.currency] ?? cartController.currency}',
                      style: const TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.padding24),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => ConfirmAddressScreen(
                        coupon: couponController.text,
                      ),
                    );
                  },
                  child: const Text(
                    "متابعة الشراء",
                  ),
                ),
              ),
              const SizedBox(
                height: kBottomNavigationBarHeight * 1.5,
              )
            ],
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height -
                (2 * kBottomNavigationBarHeight),
            child: EmptyScreen(
              svgPath: AppAssets.eCart,
              title: 'عذراً لا يوجد أي عروض في السلة',
              buttonText: 'ابحث عن العروض',
              buttonFunction: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
            ),
          );
        }
      }),
    );
  }
}
