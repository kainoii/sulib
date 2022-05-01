import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sulib/controller/user_controller.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/states/address_form.dart';
import 'package:sulib/utility/my_constant.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  List<Address> addressUserList = [
    Address(
      firstName: "สมชาย1",
        lastName: "ล่ายปี้เอ๋งเอ๋ง",
      phone: "0908745548",
      building: "Super Condo",
      addressNumber: "12/34",
      moo: "2",
      soi: "5",
      street: "ศักดิ์ดิเรท",
      subDistrict: "ศรีราชา",
      district: "แมกล่อง",
      province: "สมุทรปราการ",
      zipCode: "78452",
      isDefault: true
    ),
    Address(
        firstName: "สมหญิง2",
        lastName: "เอ๋งเอ๋ง",
        phone: "0897774412",
        building: "Batman Condo",
        addressNumber: "12/345",
        moo: "2",
        soi: "5",
        street: "ศักดิ์ดิเรท",
        subDistrict: "ศรีราชา",
        district: "แมกล่อง",
        province: "สมุทรปราการ",
        zipCode: "78452",
        isDefault: false
    ),
    Address(
        firstName: "สมชาย3",
        lastName: "ล่ายปี้เอ๋งเอ๋ง",
        phone: "0908745548",
        addressNumber: "5",
        moo: "2",
        soi: "5",
        subDistrict: "ศรีราชา",
        district: "แมกล่อง",
        province: "สมุทรปราการ",
        zipCode: "78452",
        isDefault: false
    ),
    Address(
        firstName: "สมหญิง4",
        lastName: "เอ๋งเอ๋ง",
        phone: "0897774412",
        addressNumber: "12/75",
        street: "ศักดิ์ดิเรท",
        subDistrict: "ศรีราชา",
        district: "แมกล่อง",
        province: "สมุทรปราการ",
        zipCode: "78452",
        isDefault: false
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('เลือกสถานที่จัดส่ง'),
        backgroundColor: MyContant.primary,
        actions: [
          GetBuilder<UserController>(
            builder: (controller) => (controller.user.address!.isNotEmpty)
             ? TextButton(
              onPressed: () => navigateToAddressForm(context: context),
              child: const Text(
                'เพิ่มที่อยู่',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
            )
             : Container()
          ),

        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GetBuilder<UserController>(
          builder: (controller) => (controller.user.address!.isNotEmpty)
              ? ListView(
            children: [
              const SizedBox(height: 16,),
              buildAddressList(),
              const SizedBox(height: 16,),
            ],
          )
              : buildInsertListAddressWidget()
        )
      ),
    );
  }

  Widget buildInsertListAddressWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: ()=> navigateToAddressForm(context: context),
            iconSize: 40,
            color: Colors.grey,
            icon: const Icon(Icons.add_business),
          ),
          const SizedBox(height: 24,),
          const Text(
            'กรุณากด + เพื่อเพิ่มที่อยู่',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w700
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddressList() {
    return GetBuilder<UserController>(
      builder: (controller) => ListView.separated(
        primary: false,
        shrinkWrap: true,
        reverse: true,
        itemCount: controller.user.address!.length,
        itemBuilder: (context, index) {
          Address address = controller.user.address![index];
          return buildAddressItemWidget(address);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
      ),
    );
  }

  Widget buildAddressItemWidget(Address address){
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.transparent,
      onTap: () {
        // context.read<UserModelProvider>().addressUser = address;
        //Todo onClick select Address
        UserController.instance.selectDefaultAddress(address: address);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          address.isDefault
                          ? RichText(
                            text: TextSpan(
                              text: address.getName(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black
                              ),
                              children: [
                                TextSpan(
                                  text: ' [ค่าเริ่มต้น]',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: MyContant.dark
                                  )
                                )
                              ]
                            )
                          )
                          : Text(
                            address.getName(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black
                            ),
                          ),
                          Text(
                            'โทร ${address.phone}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () => navigateToAddressForm(context: context, address: address),
                      icon: const Icon(Icons.edit)
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    address.building != null
                    ? Text(
                      address.building!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                      ),
                    )
                    : Container(),
                    Text(
                      address.getAddressSummary(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 14
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateToAddressForm({required BuildContext context, Address? address}) {
    if (address != null) {
      //edit address
      UserController.instance.isSetDefaultAddressForm = address.isDefault;
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AddressForm(addressUser: address,)
          )
      );
    } else {
      //add address
      // if don't have dataList setDefault = true and cannot change value
      // if have dataList setDefault = false and can change value
      UserController.instance.isSetDefaultAddressForm = (UserController.instance.user.address!.isEmpty);
      Navigator.of(context).pushNamed(MyContant.routeAddressForm);
    }

  }
}


