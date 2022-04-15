class Address {
  final String addressNumber;
  final String? building;
  final String? moo;
  final String? soi;
  final String? street;
  final String district;
  final String subDistrict;
  final String province;
  final String zipCode;

  Address(
    {
    required this.addressNumber,
    this.building,
    this.moo,
    this.soi,
    this.street,
    required this.district,
    required this.subDistrict,
    required this.province,
    required this.zipCode
    }
  );


}