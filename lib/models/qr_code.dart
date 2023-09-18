import 'package:offers_awards/models/offer.dart';

class QrCode{
  final Offer offer;
  final String qrCode;
  final String code;

  QrCode(this.offer, this.qrCode, this.code);

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      Offer.fromJson(json['offer']),
      json['qrCode'].toString(),
      json['code'].toString(),
    );
  }
}