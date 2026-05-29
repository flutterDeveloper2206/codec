import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/app_prefs_key.dart';
import '../../../core/utils/pref_utils.dart';

class SplashScreenController extends GetxController {
  RxBool isStarted = false.obs;
  RxBool permission = false.obs;
  @override
  void onInit() {
    changeRoute();
    checkVoltagePerSecond();
    super.onInit();
  }

  checkVoltagePerSecond() {
    if (CommonConstant.instance.dbHelper.box.get(HiveKey.voltagePerSecond) ==
        null) {
      CommonConstant.instance.dbHelper.box.put(HiveKey.voltagePerSecond, 3);
    }
  }

  void changeRoute() async {
    Timer(Duration(milliseconds: 4000), () {
      isStarted.value = true;
      // connectPermission();
    });
  }

  Future<void> getStarted() async {
    String? password =
        CommonConstant.instance.dbHelper.box.get(HiveKey.settingPassword);
    if (password == null || password.isEmpty) {
      CommonConstant.instance.dbHelper.box.put(HiveKey.settingPassword, '5272');
    }
   String authToken = await PrefUtils.getString(AppString.AUTH_TOKEN);

    if(authToken.isNotEmpty){

    Get.offAllNamed(AppRoutes.homeScreenRoute);
    }else{
    Get.offAllNamed(AppRoutes.loginScreenRoute);
  }}

  connectPermission() async {
    var status = await Permission.bluetoothScan.status;
    if (status.isDenied) {
      Permission.bluetoothScan.request();
    } else if (status.isPermanentlyDenied || status.isRestricted) {
    } else if (status.isGranted) {
      permission.value = true;
    }
    if (permission.value) {
      var status1 = await Permission.bluetoothAdvertise.status;
      if (status1.isDenied) {
        Permission.bluetoothAdvertise.request();
      } else if (status1.isPermanentlyDenied || status1.isRestricted) {
      } else if (status1.isGranted) {}
    }
  }
}

// Future<void> callDeleteAccountApi() async {
//   isLoadingDelete.value = true;
//   ApiService()
//       .callGetApi(
//       body: await ApiService().getBlankApiBody(),
//       headerWithToken: true,
//       showLoader: true,
//       url: NetworkUrl.getDeleteAccountUrl)
//       .then((value) {
//     if (value.body != null && value.body["status"] == true) {
//       isLoadingDelete.value = false;
//       PrefUtils().clearPreferencesData();
//       Get.offAllNamed(AppRoutes.welcomeScreenRoute);
//     } else {
//       isLoadingDelete.value = false;
//       ProgressDialogUtils.showSnackBar(
//           bodyText: value.body["message"], headerText: AppString.error);
//     }
//   });
// }

// Future<void> callUpdateShowMeOnPetMeetApi({required int isOn}) async {
//   await ApiService()
//       .callPostApi(
//       body: FormData({'show_me_on_petmeet': isOn}),
//       headerWithToken: true,
//       showLoader: true,
//       url: NetworkUrl.updateShowMeOnPetMeet)
//       .then((value) {
//     if (value != null && value["status"] == true) {
//       PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
//
//       ProgressDialogUtils.showSnackBar(
//           bodyText: value["message"], headerText: "SUCCESS");
//     } else {
//       ProgressDialogUtils.showSnackBar(
//           bodyText: value["message"], headerText: AppString.error);
//     }
//   });
// }
