import 'package:cotec/ApiServices/api_service.dart';
import 'package:cotec/core/constants/constants.dart';
import 'package:cotec/core/utils/progress_dialog_utils.dart';
import 'package:cotec/presentation/setting_screen/model/company_model.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/app_prefs_key.dart';
import '../model/departnment_test_type_model.dart';

class SettingScreenController extends GetxController {
  Rx<Type> type = Type.delete.obs;
  RxBool hasLightDark = false.obs;
  RxBool isShowLogs = false.obs;
  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;
Rx<CompanyModel> companyModel = CompanyModel().obs;
Rx<CompanyData> selectedCompany = CompanyData().obs;
Rx<DepData> selectedDepart = DepData().obs;
Rx<DepartMentAndTestTypeModel> departMentAndTestTypeModel = DepartMentAndTestTypeModel().obs;
  TextEditingController companyNameController = TextEditingController();
  TextEditingController deportController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  @override
  void onInit() {
    bool isLight =
        CommonConstant.instance.dbHelper.box.get(HiveKey.isDarkMode) ?? true;
    isShowLogs.value =
        CommonConstant.instance.dbHelper.box.get(HiveKey.isShowLogs) ?? false;
    currentTheme.value = isLight ? ThemeMode.light : ThemeMode.dark;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    getCompany();
    getDepartMent();
    });
    super.onInit();
  }

  // function to switch between themes
  void switchTheme() {
    currentTheme.value = currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    CommonConstant.instance.dbHelper.box
        .put(HiveKey.isDarkMode, currentTheme.value == ThemeMode.light);
  }

  void showLogsChange(bool value) {
    isShowLogs.value = !isShowLogs.value;
    CommonConstant.instance.dbHelper.box
        .put(HiveKey.isShowLogs, isShowLogs.value);
  }

  void setDefaultCompanyDeport() {
    String? companyName =
        CommonConstant.instance.dbHelper.box.get(HiveKey.setCompanyName);
    String? deportName =
        CommonConstant.instance.dbHelper.box.get(HiveKey.setDeport);
    print('companyName ${companyName}');
    if (companyName != null && deportName != null) {
      selectedCompany.value = CompanyData(name: companyName);
      selectedDepart.value = DepData(name: deportName);
    }
  }

  void companyDeportSet() {
    // if (companyNameController.text.isEmpty) {
    //   ProgressDialogUtils.showTitleSnackBar(
    //       headerText: AppString.enterCompanyName);
    // } else {
      CommonConstant.instance.dbHelper.box
          .put(HiveKey.setCompanyName, selectedCompany.value.name?.trim()??'');
      CommonConstant.instance.dbHelper.box
          .put(HiveKey.setDeport, selectedDepart.value.name?.trim()??'');

      Get.back();
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.companyNameAdded);
    // }
  }

  Future<void> setPin(String pin) async {
    await ApiService()
        .callPutApi(
        body: {"pin":pin},
        headerWithToken: true,
        showLoader: true,
        url: '${baseUrl}/setPin')
        .then((value) {
      if (value != null && value["status"] == 1) {
        // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
Get.back();
        ProgressDialogUtils.showTitleSnackBar(
            headerText: AppString.passwordChangeSuccess);
      } else {
        ProgressDialogUtils.showTitleSnackBar(
            headerText: value["message"]);
      }
    });
  }

  Future<void> getCompany() async {
    await ApiService()
        .callGetApi(
        headerWithToken: true,
        body: FormData({}),
        showLoader: true,
        url: '${baseUrl}/getCompanyList')
        .then((value) {
      if (value != null && value.body["status"] == 1) {
        // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
        companyModel.value= CompanyModel.fromJson(value.body);
        if(companyModel.value.response!=null&&companyModel.value.response!.isNotEmpty){
          selectedCompany.value = companyModel.value.response!.first;
        }
      } else {
        ProgressDialogUtils.showTitleSnackBar(
            headerText: value.body["message"]);
      }
    });
  }Future<void> getDepartMent() async {
    await ApiService()
        .callGetApi(
        headerWithToken: true,
        body: FormData({}),
        showLoader: true,
        url: '${baseUrl}/departmentList')
        .then((value) {
      if (value != null && value.body["status"] == 1) {
        // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
        departMentAndTestTypeModel.value= DepartMentAndTestTypeModel.fromJson(value.body);
        if(departMentAndTestTypeModel.value.response!=null&&departMentAndTestTypeModel.value.response!.isNotEmpty){
          selectedDepart.value = departMentAndTestTypeModel.value.response!.first;
        }
      } else {
        ProgressDialogUtils.showTitleSnackBar(
            headerText: value.body["message"]);
      }
    });
  }

  void changePinDialog(BuildContext context) {
    passwordController.clear();
    newPasswordController.clear();
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.changePin,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.enterNewPinText,
                textAlign: TextAlign.center,
                style: CTC.style(16,
                    fontColor: ColorConstant.textBlackToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
            Text(
              AppString.securityPin,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textBlackToWhite(context)),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            CustomAppTextFormField(
              fillColor: ColorConstant.primaryWhite,
              hintText: AppString.hide,
              obscuringCharacter: '*',
              controller: passwordController,
              isObscureText: true,
              textInputType: TextInputType.number,
              borderColor: ColorConstant.greyD3,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              borderRadius: BorderRadius.circular(5),
              hintFontStyle: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.grey9DA),
            ),
            SizedBox(
              height: getHeight(24),
            ),
            Text(
              AppString.confirmSecurityPin,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textBlackToWhite(context)),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            CustomAppTextFormField(
              fillColor: ColorConstant.primaryWhite,
              hintText: AppString.hide,
              controller: newPasswordController,
              obscuringCharacter: '*',
              isObscureText: true,
              textInputType: TextInputType.number,
              borderColor: ColorConstant.greyD3,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              borderRadius: BorderRadius.circular(5),
              hintFontStyle: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.grey9DA),
            ),
            SizedBox(
              height: getHeight(8),
            ),
          ],
        ),
        firstButtonTitle: AppString.submit,
        firstOnPressed: () {
          changePassword();
        },
        context: context);
  }

  void changePassword() {
    if (passwordController.text.trim().isEmpty) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.enterPasswordSecurity,
          color: ColorConstant.textRedFF);
    } else if (passwordController.text.length < 4) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.securityPinLength,
          color: ColorConstant.textRedFF);
    } else if (newPasswordController.text.trim().isEmpty) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.enterPasswordSecurityConfirm,
          color: ColorConstant.textRedFF);
    } else if (newPasswordController.text.length < 4) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.securityPinLength,
          color: ColorConstant.textRedFF);
    } else if (passwordController.text != newPasswordController.text) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.pinConfirmNotSame,
          color: ColorConstant.textRedFF);
    } else {
      // CommonConstant.instance.dbHelper.box
      //     .put(HiveKey.settingPassword, passwordController.text.trim());
      setPin(passwordController.text.trim());
      // Get.back();
      // ProgressDialogUtils.showTitleSnackBar(
      //     headerText: AppString.passwordChangeSuccess);
    }
  }

  void getStoringLogs() {
    String? types = CommonConstant.instance.dbHelper.box.get(HiveKey.storeType);
    if (types != null && types.isNotEmpty) {
      if (types == 'delete') {
        type.value = Type.delete;
      } else {
        type.value = Type.overwrite;
      }
    } else {
      type.value = Type.delete;
    }
  }
}

enum Type { delete, overwrite }
