import 'package:get/get.dart';
import 'package:offers_awards/models/session_data.dart';
import 'package:offers_awards/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static create({
    String? name,
    String? phone,
    String? email,
    String? country,
    String? area,
    String? address,
    String? image,
    DateTime? birthdate,
    String? authToken,
    double? latitude,
    double? longitude,
  }) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("name", name ?? "");
    prefs.setString("phone", phone ?? "");
    prefs.setString("email", email ?? "");
    prefs.setString("country", country ?? "");
    prefs.setString("area", area ?? "");
    prefs.setString("address", address ?? "");
    prefs.setDouble("latitude", latitude ?? 0.0);
    prefs.setDouble("longitude", longitude ?? 0.0);
    prefs.setString("image", image ?? "");
    prefs.setString("birthdate", birthdate == null ? '' : birthdate.toString());
    prefs.setString("token", authToken ?? "");
  }

  static update({
    String? name,
    String? phone,
    String? email,
    String? country,
    String? area,
    String? address,
    String? birthdate,
    String? image,
    double? latitude,
    double? longitude,
  }) async {
    final SharedPreferences prefs = await _prefs;
    if (name != null) {
      await prefs.remove('name');
      prefs.setString("name", name);
    }
    if (phone != null) {
      await prefs.remove('phone');
      prefs.setString("phone", phone);
    }
    if (email != null) {
      await prefs.remove('email');
      prefs.setString("email", email);
    }
    if (country != null) {
      await prefs.remove('country');
      prefs.setString("country", country);
    }
    if (area != null) {
      await prefs.remove('area');
      prefs.setString("area", area);
    }
    if (address != null) {
      await prefs.remove('address');
      prefs.setString("address", address);
    }
    if (image != null) {
      await prefs.remove('image');
      prefs.setString("image", image);
    }
    if (birthdate != null) {
      await prefs.remove('birthdate');
      prefs.setString("birthdate", birthdate);
    }
    if (latitude != null) {
      await prefs.remove('latitude');
      prefs.setDouble("latitude", latitude);
    }
    if (longitude != null) {
      await prefs.remove('longitude');
      prefs.setDouble("longitude", longitude);
    }
  }

  static Future<SessionData> getSessionData() async {
    final SharedPreferences prefs = await _prefs;
    final SessionData sessionData = SessionData(
      prefs.getString('name') ?? "",
      prefs.getString('phone') ?? "",
      prefs.getString('email') ?? "",
      prefs.getString('country') ?? "",
      prefs.getString('area') ?? "",
      prefs.getString('address') ?? "",
      prefs.getString('image') ?? "",
      (prefs.getString('birthdate') != 'null' &&
              prefs.getString('birthdate')!.isNotEmpty)
          ? DateTime.parse(prefs.getString('birthdate')!)
          : DateTime.now(),
      prefs.getString('token') ?? "",
      prefs.getDouble('latitude') ?? 0.0,
      prefs.getDouble('longitude') ?? 0.0,
    );
    return sessionData;
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token') ?? "";
  }

  static Future<String> getImage() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('image') ?? "";
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('image') != null;
  }

  static Future<void> clearSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('name');
    await preferences.remove('phone');
    await preferences.remove('email');
    await preferences.remove('country');
    await preferences.remove('area');
    await preferences.remove('address');
    await preferences.remove('image');
    await preferences.remove('birthdate');
    await preferences.remove('latitude');
    await preferences.remove('longitude');
    await preferences.remove('token');
    await preferences.remove('recent_search');
    await preferences.remove('cart_list');
    Get.offAll(() => const LoginScreen());
  }
}
