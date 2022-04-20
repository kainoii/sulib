import 'package:flutter/material.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/utility/my_dialog.dart';

class AddressForm extends StatefulWidget {

  final Address? addressUser;

  const AddressForm({
    Key? key,
    this.addressUser
  }) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState(addressUser: addressUser);
}

class _AddressFormState extends State<AddressForm>{

  final formKey = GlobalKey<FormState>();
  late TextEditingController controllerFirstName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerPhone;
  late TextEditingController controllerBuilding;
  late TextEditingController controllerAddressNumber;
  late TextEditingController controllerMoo ;
  late TextEditingController controllerSoi;
  late TextEditingController controllerStreet;
  late TextEditingController controllerSubDistrict;
  late TextEditingController controllerDistrict;
  late TextEditingController controllerProvince;
  late TextEditingController controllerZipCode;

  List<FocusNode> focusNode = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  final Address? addressUser;

  _AddressFormState({required this.addressUser});

  bool isSetDefault = true;


  @override
  void initState() {
    for (int i = 0; i < focusNode.length; i++) {
      focusNode[i].addListener(() {
        print("focus ${i} : ${focusNode[i].hasFocus}");
      });
    }
    super.initState();
    setAddressForm();
  }

  setAddressForm() {
    if (addressUser != null) {
      controllerFirstName = TextEditingController(text: addressUser!.firstName);
      controllerLastName = TextEditingController(text: addressUser!.lastname);
      controllerPhone = TextEditingController(text: addressUser!.phone);
      controllerBuilding = TextEditingController(text: addressUser!.building);
      controllerAddressNumber = TextEditingController(text: addressUser!.addressNumber);
      controllerMoo = TextEditingController(text: addressUser!.moo);
      controllerSoi = TextEditingController(text: addressUser!.soi);
      controllerStreet = TextEditingController(text: addressUser!.street);
      controllerSubDistrict = TextEditingController(text: addressUser!.subDistrict);
      controllerDistrict = TextEditingController(text: addressUser!.district);
      controllerProvince = TextEditingController(text: addressUser!.province);
      controllerZipCode = TextEditingController(text: addressUser!.zipCode);
    } else {
      controllerFirstName = TextEditingController();
      controllerLastName = TextEditingController();
      controllerPhone = TextEditingController();
      controllerBuilding = TextEditingController();
      controllerAddressNumber = TextEditingController();
      controllerMoo = TextEditingController();
      controllerSoi = TextEditingController();
      controllerStreet = TextEditingController();
      controllerSubDistrict = TextEditingController();
      controllerDistrict = TextEditingController();
      controllerProvince = TextEditingController();
      controllerZipCode = TextEditingController();
    }
  }

  @override
  void dispose() {
    controllerFirstName.dispose();
    controllerLastName.dispose();
    controllerPhone.dispose();
    controllerAddressNumber.dispose();
    controllerBuilding.dispose();
    controllerMoo.dispose();
    controllerSoi.dispose();
    controllerStreet.dispose();
    controllerSubDistrict.dispose();
    controllerDistrict.dispose();
    controllerProvince.dispose();
    controllerZipCode.dispose();
    for (var focus in focusNode) {
      focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดสถานที่จัดส่ง'),
        backgroundColor: MyContant.primary,
      ),
      body: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: buildBodyFormAddress()
        ),
      ),
    );
  }

  Widget buildBodyFormAddress() {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 16,),
        buildTitle(),
        buildForm(),
        const SizedBox(height: 32,),
      ],
    );
  }

  Widget buildTitle() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Text(
      'รายละเอียดที่อยู่จัดส่ง',
      style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget buildForm()=> Form(
    key: formKey,
    child: Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerFirstName,
                  focusNode: focusNode[0],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[0]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'ชื่อ :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "ชื่อจริง",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* กรุณากรอกชื่อ";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).requestFocus(focusNode[1]);
                  },
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerLastName,
                  focusNode: focusNode[1],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[1]),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide:
                      BorderSide(color: Color(0xffB87878), width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "นามสกุล :",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hintText: "นามสกุล",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* กรุณากรอกนามสกุล";
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[2]);
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: controllerPhone,
              focusNode: focusNode[2],
              onTap: () =>
                  FocusScope.of(context).requestFocus(focusNode[2]),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Color(0xffB87878), width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'เบอร์โทร :',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hintText: "เบอร์โทร",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* กรุณากรอก เบอร์โทร";
                } else if (value.contains(RegExp(r'^[0-9]+$'))) {
                  return "* กรุณากรอก เบอร์โทร ให้ถูกต้อง";
                }
                return null;
              },
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String str) {
                FocusScope.of(context).requestFocus(focusNode[3]);
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            child: TextFormField(
                controller: controllerBuilding,
                focusNode: focusNode[3],
                onTap: () =>
                    FocusScope.of(context).requestFocus(focusNode[3]),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide:
                      BorderSide(color: Color(0xffB87878), width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'อาคาร / หมู่บ้าน :',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hintText: "กรุณากรอก อาคาร.... หรือ หมู่บ้าน....",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    )),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String str) {
                  FocusScope.of(context).requestFocus(focusNode[4]);
                }),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerAddressNumber,
                  focusNode: focusNode[4],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[4]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'บ้านเลขที่ :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "บ้านเลขที่",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* กรุณากรอกบ้านเลขที่";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).requestFocus(focusNode[5]);
                  },
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerSoi,
                  focusNode: focusNode[5],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[5]),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide:
                      BorderSide(color: Color(0xffB87878), width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "ซอย :",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hintText: "ซอย",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[6]);
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerMoo,
                  focusNode: focusNode[6],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[6]),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(16),
                        borderSide:
                        BorderSide(color: Color(0xffB87878), width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'หมู่ที่ :',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      hintText: "หมู่ที่",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[7]);
                  },
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllerStreet,
                  focusNode: focusNode[7],
                  onTap: () =>
                      FocusScope.of(context).requestFocus(focusNode[7]),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide:
                      BorderSide(color: Color(0xffB87878), width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "ถนน :",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hintText: "ถนน",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String str) {
                    FocusScope.of(context).requestFocus(focusNode[8]);
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: controllerSubDistrict,
              focusNode: focusNode[8],
              onTap: () =>
                  FocusScope.of(context).requestFocus(focusNode[8]),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Color(0xffB87878), width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'ตำบล/แขวง :',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hintText: "ตำบล/แขวง",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* กรุณากรอก ตำบล/แขวง";
                }
                return null;
              },
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String str) {
                FocusScope.of(context).requestFocus(focusNode[9]);
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: controllerDistrict,
              focusNode: focusNode[9],
              onTap: () =>
                  FocusScope.of(context).requestFocus(focusNode[9]),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Color(0xffB87878), width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'อำเภอ/เขต :',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hintText: "อำเภอ/เขต",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* กรุณากรอก อำเภอ/เขต";
                }
                return null;
              },
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String str) {
                FocusScope.of(context).requestFocus(focusNode[10]);
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: controllerProvince,
              focusNode: focusNode[10],
              onTap: () =>
                  FocusScope.of(context).requestFocus(focusNode[10]),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Color(0xffB87878), width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'จังหวัด :',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hintText: "จังหวัด",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* กรุณากรอก จังหวัด";
                }
                return null;
              },
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String str) {
                FocusScope.of(context).requestFocus(focusNode[11]);
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: controllerZipCode,
              focusNode: focusNode[11],
              onTap: () =>
                  FocusScope.of(context).requestFocus(focusNode[11]),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Color(0xffB87878), width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'รหัสไปรษณีย์ :',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hintText: "รหัสไปรษณีย์",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* กรุณากรอก รหัสไปรษณีย์ ให้ถูกต้อง";
                }
                return null;
              },
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 1),
            value: addressUser != null ? addressUser!.isDefault: isSetDefault,
            activeColor: Colors.green,
            onChanged: (value) {
              if (addressUser != null) {
                setState(() {
                  addressUser!.isDefault = value!;
                });
              } else {
                setState(() {
                  isSetDefault = value!;
                });
              }
            },
            title: const Text(
              'ตั้งค่าที่อยู่นี้เป็นสถานที่ตั้งตั้น',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),

        addressUser != null
        ? Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              primary: Colors.red,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),

            ),
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 24,
            ),
            label: const Text(
              "ลบสถานที่",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white
              ),
            ),
            onPressed: () async {
              MyDialog(context: context).warningDialog(
                  title: 'ต้องการบันทึกสถานที่นี้ใช่ไหม',
                  okFunc: ()=>Navigator.of(context).pop()
              );
              //delete Address then pop to Previous Screen
              // Navigator.of(context).pop();
            },
          ),
        )
        : Container(),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            primary: Colors.green,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),

          ),
          icon: const Icon(
            Icons.home_rounded,
            color: Colors.white,
            size: 24,
          ),
          label: const Text(
            "ยืนยันที่อยู่จัดส่ง",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white
            ),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              // setAddressUser();
              MyDialog(context: context).warningDialog(
                title: 'คุณต้องการบันทึกสถานที่นี้ใช่ไหม',
                okFunc: ()=>Navigator.of(context).pop()
              );
            }
          },
        ),
      ],
    ),
  );

}
