import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SubCategoriesList extends StatefulWidget {
  final List<Category> subCategoryList;

  const SubCategoriesList({Key? key, required this.subCategoryList})
      : super(key: key);

  @override
  State<SubCategoriesList> createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<SubCategoriesList> {
  late CategoryController _categoryController;
  late int selected;

  @override
  void initState() {
    _categoryController = Get.find<CategoryController>();
    selected = _categoryController.selectedSubCategoryId.value;
    super.initState();
  }

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
            itemCount: widget.subCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected = widget.subCategoryList[index].id;
                    _categoryController
                        .changeSubCategory(widget.subCategoryList[index].id);
                  });
                },
                child: Container(
                  height: Dimensions.categoriesListHeight,
                  width: Dimensions.categoriesListHeight,
                  padding: EdgeInsets.all(Dimensions.padding8),
                  decoration:selected==widget.subCategoryList[index].id? BoxDecoration(
                    borderRadius: Dimensions.borderRadius15,
                    border: Border.all(
                      color: AppUI.primaryColor,
                    ),
                    // color: AppUI.redMap.shade50,
                  ):null,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: Dimensions.borderRadius10,
                        child: CustomNetworkImage(
                          imageUrl: widget.subCategoryList[index].cover,
                          height: Dimensions.categoriesListHeight,
                          width: Dimensions.categoriesListHeight,
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
                          widget.subCategoryList[index].icon,
                          height: Dimensions.icon21,
                          width: Dimensions.icon21,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Positioned(
                        bottom: Dimensions.padding8,
                        right: Dimensions.padding8,
                        child: CustomLightText(
                          text: widget.subCategoryList[index].title,
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
