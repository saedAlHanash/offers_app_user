import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/screens/category/category_screen.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CategoriesList extends StatefulWidget {
  final List<Category> categories;
  const CategoriesList({Key? key, required this.categories}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.categoriesListHeight,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(Dimensions.padding8),
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Get.put(CategoryController(categoryId: widget.categories[index].id.obs));
                  Get.to(
                    () => CategoryScreen(
                      id: widget.categories[index].id,
                    ),
                  );
                },
                child: Container(
                  height: Dimensions.categoriesListHeight,
                  width: Dimensions.categoriesListWidth,
                  padding: EdgeInsets.all(Dimensions.padding6),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: Dimensions.borderRadius10,
                        child: CustomNetworkImage(
                          imageUrl: widget.categories[index].cover,
                          height: Dimensions.categoriesListHeight,
                          width: Dimensions.categoriesListWidth,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: Dimensions.borderRadius15,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Positioned(
                        top: Dimensions.padding8,
                        right: Dimensions.padding8,
                        child: SvgPicture.network(
                          widget.categories[index].icon,
                          height: Dimensions.icon16,
                          width: Dimensions.icon16,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Positioned(
                        bottom: Dimensions.padding8,
                        right: Dimensions.padding8,
                        child: CustomLightText(
                          text: widget.categories[index].title,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
