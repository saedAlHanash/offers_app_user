import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/services/category_services.dart';

class CategoryController extends GetxController {
  RxInt categoryId;

  RxList<Category> subCategories = <Category>[].obs;
  RxList<Offer> offers = <Offer>[].obs;
  RxList<Provider> providers = <Provider>[].obs;
  RxInt selectedSubCategoryId = 0.obs;
  Rx<String?> sort = ''.obs;
  RxString query = 'vouchers'.obs; //providers
  RxList items = [].obs;
  RxInt page = 1.obs;
  RxInt totalOffsets = 1.obs;
  RxInt count = 0.obs;
  RxBool isLoading = false.obs;

  CategoryController({required this.categoryId});

  Future<CategoryDetails> fetchCategory(int id) async {
    debugPrint('from fetchCategory');
    isLoading.value = true;
    Future<CategoryDetails> categoryData =
        CategoryServices.fetchById(id);
    categoryData.then((value) {
      page = 1.obs;
      subCategories.value = value.subCategories;
      selectedSubCategoryId.value = value.subCategories.first.id;
      totalOffsets.value = value.totalOffsets;
      count.value = value.count;
      items.value = value.items;
      offers.value = value.items.map((map) => Offer.fromJson(map)).toList();
    });
    categoryId.value=id;
    isLoading.value = false;
    return categoryData;
  }

  void changeSubCategory(int subCategoryId) {
    selectedSubCategoryId.value = subCategoryId;
    debugPrint('change subCategoryId $subCategoryId ');
    fetchItems();
  }

  void changeSort(String sortValue) {
    sort.value = sortValue;
    debugPrint('change sortValue $sortValue ');
    fetchItems();
  }

  void changeTab(String queryValue) {
    if (query.value != queryValue) {
      query.value = queryValue;
      debugPrint('change queryValue $queryValue ');

      fetchItems();
    }
  }

  Future<bool> nextPage() async {
    page.value++;
    debugPrint("next page $page");
    var response = CategoryServices.fetchItems(
      id: categoryId.value,
      sectionId: selectedSubCategoryId.value,
      sort: sort.value,
      query: query.value,
      page: page.value,
    );
    var result = await response;
    items.value = result.items;
    totalOffsets.value = result.totalOffsets;
    count.value = result.count;
    if (query.value == 'vouchers') {
      var res = result.items.map((map) => Offer.fromJson(map)).toList();
      offers.addAll(res);
    } else {
      var res = result.items.map((map) => Provider.fromJson(map)).toList();
      providers.addAll(res);
    }
    return result.items.isNotEmpty;
  }

  Future<void> fetchItems() async {
    debugPrint('from fetchItems');
    page = 1.obs;
    try {
      isLoading.value = true;
      var response = await CategoryServices.fetchItems(
        id: categoryId.value,
        sectionId: selectedSubCategoryId.value,
        sort: sort.value,
        query: query.value,
        page: page.value,
      );
      items.value = response.items;
      totalOffsets.value = response.totalOffsets;
      count.value = response.count;
      if (query.value == 'vouchers') {
        offers.value =
            response.items.map((map) => Offer.fromJson(map)).toList();
      } else {
        providers.value =
            response.items.map((map) => Provider.fromJson(map)).toList();
      }
      isLoading.value = false;
    } catch (e) {
      // handle error
    }
  }
  @override
  void onClose() {
    print("wee");
    subCategories.clear();
    offers.clear();
    providers.clear();
    selectedSubCategoryId.value = 0;
    sort.value = '';
    query.value = 'vouchers';
    items.clear();
    page.value = 1;
    totalOffsets.value = 1;
    count.value = 0;
    isLoading.value = false;

    super.onClose();
  }
}
