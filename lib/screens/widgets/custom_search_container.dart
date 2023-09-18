import 'package:flutter/material.dart';
import 'package:offers_awards/screens/search/custom_search_delegate.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomSearchContainer extends StatelessWidget {
  final bool isWhite;

  const CustomSearchContainer({super.key, this.isWhite = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(context: context, delegate: CustomSearchDelegate());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.padding4,
          // horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        margin: EdgeInsets.only(
          top: isWhite ? Dimensions.padding16 : 0,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
          color: isWhite ? Colors.transparent : AppUI.greyCardColor,
          borderRadius: Dimensions.borderRadius50,
          border: Border.all(color: AppUI.secondaryColor )
        ),
        child:  Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Icon(Icons.search,color: isWhite ?  AppUI.secondaryColor : AppUI.textColor,),
            const Spacer(),
            Text(
              "ابحث عن العروض",
              style: TextStyle(
                color: isWhite ?  AppUI.secondaryColor : AppUI.textColor,
                fontSize: Dimensions.font14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
