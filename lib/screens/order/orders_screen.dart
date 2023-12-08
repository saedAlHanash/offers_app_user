import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/models/order.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/empty_screen.dart';
import 'package:offers_awards/screens/order/components/order_item.dart';
import 'package:offers_awards/screens/search/custom_search_delegate.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/services/order_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Order>> orders;

  @override
  void initState() {
    orders = OrderServices.fetch();
    super.initState();
  }

  bool isLoading = false;

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    orders = OrderServices.fetch();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        title: 'طلباتي',
      ),
      // minPadding: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.padding8,
          horizontal: Dimensions.padding8,
        ),
        child: FutureBuilder<List<Order>>(
            future: orders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.requireData.isEmpty) {
                  return EmptyScreen(
                    svgPath: AppAssets.eOrder,
                    title: 'عذراً لا يوجد أي طلبات',
                    buttonText: 'ابحث عن العروض',
                    buttonFunction: () {
                      showSearch(
                          context: context, delegate: CustomSearchDelegate());
                    },
                  );
                } else {
                  return ListView.builder(
                    // shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.padding16,
                      horizontal: Dimensions.padding4,
                    ),
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.requireData.length,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('HH:mm yyyy/MM/dd ')
                              .format(snapshot.requireData[index].date),
                          style: const TextStyle(fontSize: Dimensions.font16),
                          // textDirection: TextDirection.rtl,
                        ),
                        OrderItemWidget(
                          order: snapshot.requireData[index],
                        ),
                      ],
                    ),
                  );
                }
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
          heroTag: "support_chat_orders",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
