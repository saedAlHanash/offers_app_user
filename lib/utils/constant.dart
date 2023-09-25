import 'package:offers_awards/models/onboard.dart';
import 'package:offers_awards/utils/app_assets.dart';

class AppConstant {
  static const int resendCodeTimes = 3;
  static const Map<int, String> resendTimesMsg = {
    1: "تم إرسال الكود! إذا لزم الأمر ، يمكننا إعادة إرسال رمز لمرتين إضافيتين.",
    2: "تم إعادة إرسال الكود! إذا لزم الأمر ، يمكننا إعادة إرسال رمز لمرة إضافيه.",
    3: "تم إعادة إرسال الرمز للمرة الاخيرة!",
  };
  static List<Map<String, String>> sortFields = [
    {'title': 'أحدث العروض', 'value': 'new'},
    {'title': 'الأكثر مبيعاً', 'value': 'most_sold '},
    {'title': 'السعر من الأقل إلى الأعلى', 'value': 'min'},
    {'title': 'السعر من الأعلى إلى الأقل', 'value': 'max'},
  ];

  static const Map<String, String> offerType = {
    "delivery": "دليفري",
    "store": "فرع",
    "store_and_delivery": "فرع و دليفري"
  };

  static const Map<String, String> offerFilter = {
    "hot": "أقوى العروض",
    "most_sold": "الأكثر مبيعاً",
    "new": "العروض الجديدة",
  };
  static const Map<String, String> orderStatus = {
    "pending": "تحت المراجعة",
    "accepted": "تم التوصيل",
    "canceled": "تم الرفض",
  };

  static const Map<String, String> notificationType = {
    "new": "العروض الجديدة",
    "hot": "أقوى العروض",
    "order": "تم الغاء الطلب",
    'other': "",
  };

  static const Map<String, String> currency= {
    "IQD": " د.ع",
    "USD": "\$",
  };

  static List<Onboard> screens = [
    Onboard(
      title: 'مرحباَ\nفي عروض وجوائز',
      subtitle: 'ابحث عن اقرب العروض لك',
      image: AppAssets.onBoarding1,
    ),
    Onboard(
      title: '!سهولة تتبع طلبك',
      subtitle: 'تابع مكان ومراحل طلبك بسهولة',
      image: AppAssets.onBoarding2,
    ),
    Onboard(
      title: 'التوصيل\nمن الباب للباب',
      subtitle: 'التوصيل في جميع انحاء العراق',
      image: AppAssets.onBoarding3,
    ),
  ];

  static const String recentSearch = "recent_search";
  static const String cartList = "cart_list";
}

class FormValidator {
  static const int resendCodeCount = 5;
  static int pinLength = 6;
  static int passwordLength = 6;
  static RegExp emailValidationRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp phoneValidationRegExp = RegExp(
      r'^\+?\d{1,3}[-.\s]?\(?\d{1,3}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}$');
  static const String emailNullError = "يرجى إدخال البريد الإلكتروني";
  static const String invalidEmailError = "يرجى إدخال بريد إلكتروني صحيح";
  static const String phoneNullError = "يرجى إدخال رقم الهاتف";
  static const String invalidPhoneError = "يرجى إدخال رقم هاتف صحيح";
  static const String nameNullError = "يرجى إدخال الاسم";
  static const String countryNullError = "يرجى إدخال المحافظة";
  static const String areaNullError = "يرجى إدخال اسم المنطقة";
  static const String homeNullError = "يرجى إدخال عنوان المنزل";
  static const String codeNullError = "يرجى ملئ رمز التحقق كاملاً";
  static const String passNullError = "يرجى إدخال كلمة المرور";
  static const String oldPassNullError = "يرجى إدخال كلمة المرور القديمة";
  static const String newPassNullError = "يرجى إدخال كلمة المرور الجديدة";
  static const String newCNewPassNullError = "يرجى تأكيد كلمة المرور الجديدة";
  static const String newCPassNullError = "يرجى تأكيد كلمة المرور";
  static const String oldMatchNewError = "يرجى تغيير كلمة المرور";
  static const String shortPassError = "يرجى ادخال كلمة مرور من 6 محارف";
  static const String matchPassError = "كلمات المرور غير متطابقة";
}
