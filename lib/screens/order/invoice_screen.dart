import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/models/order.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/order/components/invoice_item.dart';
import 'package:offers_awards/screens/provider/provider_map_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_icon_text_button.dart';
import 'package:offers_awards/services/order_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class InvoiceScreen extends StatefulWidget {
  final int id;
  final int orderNumber;
  const InvoiceScreen({
    super.key,
    required this.id,
    required this.orderNumber,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late Future<Order> invoice;
  bool isLoading = false;

  @override
  void initState() {
    invoice = OrderServices.getById(widget.id);
    super.initState();
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    invoice = OrderServices.getById(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: "${widget.orderNumber}"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.padding8,
          horizontal: Dimensions.padding24,
        ),
        child: FutureBuilder<Order>(
            future: invoice,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("حالة الطلب"),
                          Text(
                            AppConstant.orderStatus[snapshot.data!.status] ??
                                snapshot.data!.status,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data!.clientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat('yyyy/MM/dd ')
                                    .format(snapshot.data!.date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SvgPicture.asset(
                                AppAssets.calender,
                                height: Dimensions.icon21,
                                width: Dimensions.icon21,
                                fit: BoxFit.scaleDown,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding8,
                      ),
                      child: Row(
                        children: [
                          const Text("عدد المنتجات"),
                          SizedBox(
                            width: Dimensions.padding24,
                          ),
                          Text(
                            "${snapshot.data!.orderItems.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconTextButton(
                      text:
                          "${snapshot.data!.provider.government}/${snapshot.data!.provider.name}",
                      iconPath: AppAssets.activeMarkerIcon,
                      function: () async {
                        Get.to(() => ProviderMapScreen(
                            provider: snapshot.data!.provider));
                      },
                    ),
                    for (OrderItem orderItem in snapshot.data!.orderItems)
                      InvoiceItem(
                        orderItem: orderItem,
                        providerName: snapshot.data!.provider.name,
                      ),
                    if (snapshot.data!.couponCode != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.padding8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("كود الخصم"),
                            SizedBox(
                              width: Dimensions.padding24,
                            ),
                            Text(
                              "${snapshot.data!.couponCode}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (snapshot.data!.couponCode != null) const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("المجموع"),
                          SizedBox(
                            width: Dimensions.padding24,
                          ),
                          Text(
                            '${NumberFormat('#,###').format(snapshot.data!.total)} د.ع',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    if (snapshot.data!.cancelNote != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.borderRadius10,
                          border: Border.all(
                            color: AppUI.hintTextColor,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          Dimensions.padding8,
                        ),
                        child: Text(
                            "رسالة الرفض: \n ${snapshot.data!.cancelNote!}"),
                      ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  isLoading) {
                return const Center(
                  child: SpinKitChasingDots(
                    color: AppUI.primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                return CustomFailed(
                  onRetry: retry,
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_invoice",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
