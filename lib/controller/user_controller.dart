import 'package:get/get.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/services/user_service.dart';

class UserController extends GetxController {

  static UserController instance = Get.find<UserController>();

  late UserModel _user;

  late Address _selectAddress;

  var _isSetDefaultAddressForm = false;

  set isSetDefaultAddressForm(bool value) {
    _isSetDefaultAddressForm = value;
    update();
  }

  UserModel get user => _user;
  Address get selectAddress => _selectAddress;
  bool get isSetDefaultAddressForm => _isSetDefaultAddressForm;

  Future getUserById(String id) async {
    var userModel = await DatabaseService().getUserById(id);
    if (userModel != null) {
      _user = userModel;
      selectDefaultAddress();
    }
  }

  void selectDefaultAddress({Address? address}) {
    if (address != null) {
      _selectAddress = address;
      update();
    } else {
      if (_user.address!.isNotEmpty) {
        _selectAddress = _user.address!.firstWhere((element) => element.isDefault);
        update();
      }
    }
  }

  insertAddress(Address address) {
    //first add address to list set selectAddressUser
    if (_user.address!.isEmpty) {
      _selectAddress = address;
    }
    _user.address!.add(address);
    update();
  }

  removeAddress(Address address) {
    _user.address!.remove(address);
    update();
  }

  updateAddress({required Address addressDelete, required Address addressUpdate}){
    print('address select: ${_selectAddress.isDefault}');
    _user.address!.add(addressUpdate);
    _user.address!.remove(addressDelete);
    _selectAddress = addressUpdate;
    update();
  }

  verifyDefaultAddress({required String userId, Address? addressEdited}) async {
    if (_user.address!.isNotEmpty) {
      if (_isSetDefaultAddressForm) {
        Address addressDefault = _user.address!.firstWhere((element) => element.isDefault);
        if (addressEdited != null) {
          if (addressEdited != addressDefault) {
            Address addressInsert = addressDefault.copyWith(isDefault: false);
            updateAddress(addressDelete: addressDefault, addressUpdate: addressInsert);
            await DatabaseService().updateAddress(userId, addressDefault, addressInsert);
          }
        } else {
          Address addressInsert = addressDefault.copyWith(isDefault: false);
          updateAddress(addressDelete: addressDefault, addressUpdate: addressInsert);
          await DatabaseService().updateAddress(userId, addressDefault, addressInsert);
        }
      }
    }
  }

}