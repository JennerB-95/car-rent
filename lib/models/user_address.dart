part of 'user.dart';

class UserAddress {
  String street;
  String city;
  String province;
  String country;
  String postalCode;

  UserAddress({
    this.street,
    this.city,
    this.province,
    this.country,
    this.postalCode,
  });

  UserAddress copyWith({
    String street,
    String city,
    String province,
    String country,
    String postalCode,
  }) =>
      UserAddress(
        street: street ?? this.street,
        city: city ?? this.city,
        province: province ?? this.province,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
      );

  UserAddress.fromJson(Map<String, dynamic> data) {
    street = data["street"];
    city = data["city"];
    province = data["province"];
    country = (data["country"]?.isEmpty ?? true) ? null : data["country"];
    postalCode = data["postal"];
  }

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "province": province,
        "country": country,
        "postal": postalCode,
      };
}
