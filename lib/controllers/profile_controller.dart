import 'package:get/get.dart';
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/models/session_data.dart';
import 'package:offers_awards/services/profile_services.dart';

class ProfileController extends GetxController {
  Rx<SessionData?> userInfo = Rx<SessionData?>(null);

  ProfileController() {
    loadData();
  }

  Future<void> loadData() async {
    userInfo = Rx<SessionData>(await SessionManager.getSessionData());
    update();
  }

  Future<void> updateData(SessionData data) async {
    userInfo.value = data;
    update();
  }

  Future<bool> editProfileInfo({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String country,
    required String area,
    required String birthdate,
    required double latitude,
    required double longitude,
  }) async {
    try {
      var value = await ProfileServices.editInfo(
        name: name,
        phone: phone,
        email: email,
        address: address,
        country: country,
        area: area,
        birthdate: birthdate,
        latitude: latitude,
        longitude: longitude,
      );
      if (value) {
        userInfo.value = SessionData(
            name,
            phone,
            email,
            country,
            area,
            address,
            userInfo.value!.image,
            DateTime.parse(birthdate),
            userInfo.value!.token,
            latitude,
            longitude);
        update();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  void editProfileImage(String image) async {
    userInfo.value = SessionData(
        userInfo.value!.name,
        userInfo.value!.phone,
        userInfo.value!.email,
        userInfo.value!.country,
        userInfo.value!.area,
        userInfo.value!.address,
        image,
        userInfo.value!.birthday,
        userInfo.value!.token,
        userInfo.value!.latitude,
        userInfo.value!.longitude);
    update();
  }
}
