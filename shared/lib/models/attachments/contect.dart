import 'dart:convert';

import 'package:equatable/equatable.dart';

class Contect extends Equatable {
  const Contect({
    required this.name,
    required this.phones,
    this.addresses,
    this.significantDate,
    this.emails,
    this.org,
  });

  final Name name;
  final List<Phone> phones;
  final List<Address>? addresses;
  final List<SignificantDate>? significantDate;
  final List<Email>? emails;
  final Org? org;

  Contect copyWith({
    List<Address>? addresses,
    List<SignificantDate>? significantDate,
    List<Email>? emails,
    Name? name,
    Org? org,
    List<Phone>? phones,
  }) =>
      Contect(
        addresses: addresses ?? this.addresses,
        significantDate: significantDate ?? this.significantDate,
        emails: emails ?? this.emails,
        name: name ?? this.name,
        org: org ?? this.org,
        phones: phones ?? this.phones,
      );

  factory Contect.fromJson(String str) => Contect.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Contect.fromMap(Map<String, dynamic> json) => Contect(
        addresses: List<Address>.from(
            json["addresses"] ?? [].map((x) => Address.fromMap(x))),
        significantDate: List<SignificantDate>.from(json["significant_date"] ??
            [].map((x) => SignificantDate.fromMap(x))),
        emails:
            List<Email>.from(json["emails"] ?? [].map((x) => Email.fromMap(x))),
        name: Name.fromMap(json["name"]),
        org: Org.fromMap(json["org"]),
        phones:
            List<Phone>.from(json["phones"] ?? [].map((x) => Phone.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name.toMap(),
        "phones": List<dynamic>.from(phones.map((x) => x.toMap())),
        if (addresses != null)
          "addresses": List<dynamic>.from(addresses!.map((x) => x.toMap())),
        if (significantDate != null)
          "significant_date":
              List<dynamic>.from(significantDate!.map((x) => x.toMap())),
        if (emails != null)
          "emails": List<dynamic>.from(emails!.map((x) => x.toMap())),
        if (org != null) "org": org!.toMap(),
      };

  @override
  List<Object?> get props =>
      [name, phones, addresses, significantDate, emails, org];
}

class Address extends Equatable {
  const Address({
    this.city,
    this.country,
    this.countryCode,
    this.state,
    this.street,
    this.type,
    this.zip,
  });

  final String? city;
  final String? country;
  final String? countryCode;
  final String? state;
  final String? street;
  final String? type;
  final String? zip;

  Address copyWith({
    String? city,
    String? country,
    String? countryCode,
    String? state,
    String? street,
    String? type,
    String? zip,
  }) =>
      Address(
        city: city ?? this.city,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
        state: state ?? this.state,
        street: street ?? this.street,
        type: type ?? this.type,
        zip: zip ?? this.zip,
      );

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        countryCode: json["country_code"],
        state: json["state"],
        street: json["street"],
        type: json["type"],
        zip: json["zip"],
      );

  Map<String, dynamic> toMap() => {
        "city": city,
        "country": country,
        "country_code": countryCode,
        "state": state,
        "street": street,
        "type": type,
        "zip": zip,
      };

  @override
  List<Object?> get props =>
      [city, country, countryCode, state, street, type, zip];
}

class Email extends Equatable {
  const Email({
    this.label = 'no_label',
    required this.email,
  });

  final String email;
  final String label;

  Email copyWith({
    String? email,
    String? label,
  }) =>
      Email(
        email: email ?? this.email,
        label: label ?? this.label,
      );

  factory Email.fromJson(String str) => Email.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Email.fromMap(Map<String, dynamic> json) => Email(
        email: json["email"],
        label: json["label"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "label": label,
      };

  @override
  List<Object?> get props => [email, label];
}

class Name extends Equatable {
  Name({
    this.firstName,
    this.lastName,
    this.middleName,
    this.prefix,
    this.suffix,
  });

  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? prefix;
  final String? suffix;

  Name copyWith({
    String? firstName,
    String? lastName,
    String? middleName,
    String? prefix,
    String? suffix,
  }) =>
      Name(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        prefix: prefix ?? this.prefix,
        suffix: suffix ?? this.suffix,
      );

  factory Name.fromJson(String str) => Name.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Name.fromMap(Map<String, dynamic> json) => Name(
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        prefix: json["prefix"],
        suffix: json["suffix"],
      );

  Map<String, dynamic> toMap() => {
        if (firstName != null) "first_name": firstName,
        if (lastName != null) "last_name": lastName,
        if (middleName != null) "middle_name": middleName,
        if (prefix != null) "prefix": prefix,
        if (suffix != null) "suffix": suffix,
      };

  @override
  List<Object?> get props => [firstName, lastName, middleName, prefix, suffix];
}

class Org extends Equatable {
  const Org({
    required this.company,
    this.department,
    this.title,
  });

  final String company;
  final String? department;
  final String? title;

  Org copyWith({
    String? company,
    String? department,
    String? title,
  }) =>
      Org(
        company: company ?? this.company,
        department: department ?? this.department,
        title: title ?? this.title,
      );

  factory Org.fromJson(String str) => Org.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Org.fromMap(Map<String, dynamic> json) => Org(
        company: json["company"],
        department: json["department"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "company": company,
        if (department != null) "department": department,
        if (title != null) "title": title,
      };

  @override
  List<Object?> get props => [company, department, title];
}

class Phone extends Equatable {
  const Phone({
    this.label = 'no_label',
    required this.phone,
    this.appId,
  });

  final String label;
  final String phone;
  final String? appId;

  Phone copyWith({
    String? phone,
    String? appId,
    String? label,
  }) =>
      Phone(
        phone: phone ?? this.phone,
        appId: appId ?? this.appId,
        label: label ?? this.label,
      );

  factory Phone.fromJson(String str) => Phone.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Phone.fromMap(Map<String, dynamic> json) => Phone(
        phone: json["phone"],
        appId: json["app_id"],
        label: json["label"],
      );

  Map<String, dynamic> toMap() => {
        "phone": phone,
        "app_id": appId,
        "label": label,
      };

  @override
  List<Object?> get props => [label, phone, appId];
}

class SignificantDate extends Equatable {
  const SignificantDate({
    this.label = 'no_label',
    required this.date,
  });

  final DateTime date;
  final String label;

  SignificantDate copyWith({
    DateTime? date,
    String? label,
  }) =>
      SignificantDate(
        date: date ?? this.date,
        label: label ?? this.label,
      );

  factory SignificantDate.fromJson(String str) =>
      SignificantDate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SignificantDate.fromMap(Map<String, dynamic> json) => SignificantDate(
        date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
        label: json["label"],
      );

  Map<String, dynamic> toMap() => {
        "date": date.millisecondsSinceEpoch,
        "label": label,
      };

  @override
  List<Object?> get props => [date, label];
}
