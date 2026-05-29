

import 'package:cotec/ApiServices/api_service.dart';
import 'package:cotec/core/constants/constants.dart';
import 'package:cotec/core/utils/pref_utils.dart';
import 'package:cotec/core/utils/progress_dialog_utils.dart';
import 'package:cotec/presentation/login_screen/model/login_model.dart';

import '../../../core/app_export.dart';

class LoginScreenController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Rx<LoginModel> loginModel = LoginModel().obs;

  RxBool isLoading = false.obs;


  Future<void> loginApi() async {
    await ApiService()
        .callPostApi(
        body: FormData({"email":email.text,
        "password":password.text,
        "fcmToken":'dsfg',
        "platform":'android',
        "deviceName":'gdgf'}),
        headerWithToken: false,
        showLoader: true,
        url: '${baseUrl}/login')
        .then((value) {
      if (value != null && value["status"] == 1) {
        loginModel.value = LoginModel.fromJson(value);
        PrefUtils.setString(AppString.AUTH_TOKEN, loginModel.value.response?.token??'');
        PrefUtils.putObject(AppString.LOGIN_RESPONSE, loginModel.value);
        Get.offAllNamed(AppRoutes.homeScreenRoute);

        ProgressDialogUtils.showTitleSnackBar(
          headerText: "Login Successfully");
      } else {
        ProgressDialogUtils.showTitleSnackBar(
             headerText: value["message"]);
      }
    });
  }

  login(){
    if(email.text.isEmpty){
      ProgressDialogUtils.showTitleSnackBar(
          headerText: "Please enter email",);
    }else if(password.text.isEmpty){
      ProgressDialogUtils.showTitleSnackBar(
        headerText: "Please enter password",);

    }else{
    loginApi();}
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

