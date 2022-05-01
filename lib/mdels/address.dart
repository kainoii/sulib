import 'dart:convert';

import 'package:flutter/animation.dart';

class Address {
  final String firstName;
  final String lastName;
  final String phone;
  final String addressNumber;
  final String? building;
  final String? moo;
  final String? soi;
  final String? street;
  final String district;
  final String subDistrict;
  final String province;
  final String zipCode;
  bool isDefault;

  Address(
    {
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.addressNumber,
    this.building,
    this.moo,
    this.soi,
    this.street,
    required this.district,
    required this.subDistrict,
    required this.province,
    required this.zipCode,
    this.isDefault = false
    }
  );

  String getName() {
    return "$firstName $lastName";
  }

  String getAddressSummary() {
    String address = "";
    address = address + addressNumber;
    if (moo != null) {
      address = address + " หมู่ที่" + moo!;
    }
    if (soi != null) {
      address = address + " ซอย" + soi!;
    }
    if (street != null) {
      address = address + " ถนน" + street!;
    }
    address = address + "\n ตำบล" + subDistrict;
    address = address + " อำเภอ" + district;
    address = address + "\n จังหวัด" + province;
    address = address + " " + zipCode;

    return address;
  }

  String copyAddressSummary() {
    String address = "";
    address = address + "$firstName $lastName";
    address = address + "\n เบอร์โทร $phone";
    if (building != null) {
      address = address + "$building ";
    }
    address = address + addressNumber;
    if (moo != null) {
      address = address + " หมู่ที่" + moo!;
    }
    if (soi != null) {
      address = address + " ซอย" + soi!;
    }
    if (street != null) {
      address = address + " ถนน" + street!;
    }
    address = address + " ตำบล" + subDistrict;
    address = address + " อำเภอ" + district;
    address = address + " จังหวัด" + province;
    address = address + " " + zipCode;
    return address;
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'building': building,
      'addressNumber': addressNumber,
      'moo': moo,
      'soi': soi,
      'street': street,
      'subDistrict': subDistrict,
      'district': district,
      'province': province,
      'zipCode': zipCode,
      'isDefault': isDefault
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
        firstName: (map['firstName'] != null) ? map['firstName'] : '',
        lastName: (map['lastName'] != null) ? map['lastName'] : '',
        phone: (map['phone'] != null) ? map['phone'] : '',
        building: map['building'],
        addressNumber: (map['addressNumber'] != null) ? map['addressNumber'] : '',
        moo: map['moo'],
        soi: map['soi'],
        street: map['street'],
        district: (map['district'] != null) ? map['district'] : '',
        subDistrict: (map['subDistrict'] != null) ? map['subDistrict'] : '',
        province: (map['province'] != null) ? map['province'] : '',
        zipCode: (map['zipCode'] != null) ? map['zipCode'] : '',
        isDefault: (map['isDefault'] != null) ? map['isDefault'] : false
    );
  }

  Address copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? building,
    String? addressNumber,
    String? moo,
    String? soi,
    String? street,
    String? subDistrict,
    String? district,
    String? province,
    String? zipCode,
    bool? isDefault
  }){
    return Address(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      building: building ?? this.building,
      addressNumber: addressNumber ?? this.addressNumber,
      moo: moo ?? this.moo,
      soi: soi ?? this.soi,
      street: street ?? this.street,
      district: district ?? this.district,
      subDistrict: subDistrict ?? this.subDistrict,
      province: province ?? this.province,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));

}