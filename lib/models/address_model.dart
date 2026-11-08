class AddressModel {
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String country;

  AddressModel({
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'street': street,
      'city': city,
      'country': country,
    };
  }

  String get fullAddress =>
      [street, city, country].where((s) => s.isNotEmpty).join(', ');

  String get fullName =>
      [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
}
