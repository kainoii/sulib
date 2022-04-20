class Address {
  final String id;
  final String firstName;
  final String lastname;
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
    required this.id,
    required this.firstName,
    required this.lastname,
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
    return "$firstName $lastname";
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

}