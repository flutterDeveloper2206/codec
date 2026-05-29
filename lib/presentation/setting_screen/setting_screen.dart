import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cotec/presentation/setting_screen/model/company_model.dart';
import 'package:cotec/presentation/setting_screen/model/departnment_test_type_model.dart';

import '../../core/app_export.dart';
import '../../core/utils/app_prefs_key.dart';
import 'controller/setting_screen_controller.dart';

class SettingScreen extends GetWidget<SettingScreenController> {
  const SettingScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        appBar: const CommonAppbar(title: AppString.setting),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
            child: Column(
              children: [
                SizedBox(
                  height: getHeight(30),
                ),
                listTileList(
                  title: AppString.changePin,
                  svgPath: ImageConstant.changePin,
                  context: context,
                  onTap: () {
                    controller.changePinDialog(context);
                  },
                ),
                listTileList(
                  title: AppString.setCompanyName,
                  svgPath: ImageConstant.company,
                  context: context,
                  onTap: () {
                    // controller.setDefaultCompanyDeport();
                    setCompanyNameDialog(context);
                  },
                ),
                listTileList(
                  title: AppString.clearAppData,
                  svgPath: ImageConstant.clearData,
                  context: context,
                  onTap: () {
                    // confirmLicenseDialog(context);
                  },
                ),
                listTileList(
                  title: AppString.voltagePerSecond,
                  svgPath: ImageConstant.timer,
                  context: context,
                  onTap: () {
                    Get.toNamed(AppRoutes.voltagePerSecondScreenRoute);
                    // confirmLicenseDialog(context);
                  },
                ),
                Column(
                  children: [
                    Bounce(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? 0.3
                                          : 0.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: ColorConstant.containerBackGround(context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidth(12), vertical: getHeight(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomImageView(
                                  svgPath: ImageConstant.theme,
                                  color: ColorConstant.textDarkTOLight(context),
                                ),
                                SizedBox(
                                  width: getWidth(10),
                                ),
                                Text(
                                  AppString.themes,
                                  style: CTC.style(16,
                                      fontWeight: FontWeight.w600,
                                      fontColor: ColorConstant.textDarkTOLight(
                                          context)),
                                )
                              ],
                            ),
                            Obx(
                              () => CupertinoSwitch(
                                value: controller.currentTheme.value ==
                                    ThemeMode.dark,
                                onChanged: (value) {
                                  controller.switchTheme();
                                  Get.changeThemeMode(
                                      controller.currentTheme.value);

                                  // controller.hasLightDark.value = value;
                                },
                                trackColor: ColorConstant.backGroundColor,
                                thumbColor: ColorConstant.primaryWhite,
                                activeColor: ColorConstant.primaryYellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(20),
                    )
                  ],
                ),
                listTileList(
                  title: AppString.largerFont,
                  svgPath: ImageConstant.font,
                  context: context,
                  onTap: () {},
                ),
                listTileList(
                  title: AppString.tones,
                  svgPath: ImageConstant.music,
                  context: context,
                  onTap: () {},
                ),
                listTileList(
                  title: AppString.storingLogOffline,
                  context: context,
                  svgPath: ImageConstant.storeLog,
                  onTap: () {
                    controller.getStoringLogs();
                    storingOfflineDialog(context);
                  },
                ),
                Column(
                  children: [
                    Bounce(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? 0.3
                                          : 0.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: ColorConstant.containerBackGround(context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidth(12), vertical: getHeight(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomImageView(
                                  svgPath: ImageConstant.theme,
                                  color: ColorConstant.textDarkTOLight(context),
                                ),
                                SizedBox(
                                  width: getWidth(10),
                                ),
                                Text(
                                  AppString.showLogs,
                                  style: CTC.style(16,
                                      fontWeight: FontWeight.w600,
                                      fontColor: ColorConstant.textDarkTOLight(
                                          context)),
                                )
                              ],
                            ),
                            Obx(
                              () => CupertinoSwitch(
                                value: controller.isShowLogs.value,
                                onChanged: (value) {
                                  controller.showLogsChange(value);
                                },
                                trackColor: ColorConstant.backGroundColor,
                                thumbColor: ColorConstant.primaryWhite,
                                activeColor: ColorConstant.primaryYellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(20),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget listTileList(
      {required String title,
      required String svgPath,
      required BuildContext context,
      required void Function() onTap}) {
    return Column(
      children: [
        Bounce(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(
                          Theme.of(context).brightness == Brightness.light
                              ? 0.3
                              : 0.0),
                      blurRadius: 5.0,
                      spreadRadius: 0.5),
                ],
                borderRadius: BorderRadius.circular(15),
                color: ColorConstant.containerBackGround(context)),
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(12), vertical: getHeight(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  svgPath: svgPath,
                  height: getHeight(24),
                  width: getHeight(24),
                  color: ColorConstant.textDarkTOLight(context),
                ),
                SizedBox(
                  width: getWidth(10),
                ),
                Text(
                  title,
                  style: CTC.style(16,
                      fontWeight: FontWeight.w600,
                      fontColor: ColorConstant.textDarkTOLight(context)),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: getHeight(20),
        )
      ],
    );
  }

  void setCompanyNameDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        radius: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.setCompanyName,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(30),
            ),
            Text(
              AppString.companyName,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textGrey4c4cToWhite(context)),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            // CustomAppTextFormField(
            //   fillColor: ColorConstant.primaryWhite,
            //   hintText: AppString.companyName,
            //   borderColor: ColorConstant.greyD3,
            //   inputFormatters: [LengthLimitingTextInputFormatter(20)],
            //   controller: controller.companyNameController,
            //   borderRadius: BorderRadius.circular(5),
            //   hintFontStyle: CTC.style(16,
            //       fontWeight: FontWeight.w500,
            //       fontColor: ColorConstant.grey9DA),
            // ),
            if(controller.companyModel.value.response!=null &&controller.companyModel.value.response!.isNotEmpty)
            DropdownButtonFormField2<CompanyData>(
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
              // isExpanded: true,
              hint: Text(
                AppString.selectTestType,
                style:
                CTC.style(16, fontColor: ColorConstant.grey9DA),
                overflow: TextOverflow.ellipsis,
              ),
              items: controller.companyModel.value.response!.map((CompanyData? item) => DropdownMenuItem<CompanyData>(
                value: item,
                child: SizedBox(
                  width: getWidth(200),
                  child: Text(
                    item?.name??'',
                    style: CTC.style(16,
                        fontWeight: FontWeight.w500,
                        fontColor:
                        ColorConstant.textGrey4c4cToWhite(
                            context)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ))
                  .toList(),
              value:  controller.selectedCompany.value,
              onChanged: (CompanyData? value) {
                  },
              buttonStyleData: ButtonStyleData(
                height: getHeight(54),
                // padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color:  ColorConstant.greyD3),
                  color: ColorConstant.containerBackGround(context),
                ),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
                // iconSize: 24,

              ),
              isDense: true,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: ColorConstant.containerBackGround(context),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
              style: CTC.style(14,
                  fontColor: ColorConstant.textBlackToWhite(context)),
            ),
            SizedBox(
              height: getHeight(15),
            ),
            Text(
              AppString.depot,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textGrey4c4cToWhite(context)),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            // CustomAppTextFormField(
            //   fillColor: ColorConstant.primaryWhite,
            //   hintText: AppString.depot,
            //   borderColor: ColorConstant.greyD3,
            //   controller: controller.deportController,
            //   borderRadius: BorderRadius.circular(5),
            //   hintFontStyle: CTC.style(16,
            //       fontWeight: FontWeight.w500,
            //       fontColor: ColorConstant.grey9DA),
            // ),
            if(controller.departMentAndTestTypeModel.value.response!=null &&controller.departMentAndTestTypeModel.value.response!.isNotEmpty)
              DropdownButtonFormField2<DepData>(
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                // isExpanded: true,
                hint: Text(
                  AppString.selectTestType,
                  style:
                  CTC.style(16, fontColor: ColorConstant.grey9DA),
                  overflow: TextOverflow.ellipsis,
                ),
                items: controller.departMentAndTestTypeModel.value.response!.map((DepData? item) => DropdownMenuItem<DepData>(
                  value: item,
                  child: SizedBox(
                    width: getWidth(200),
                    child: Text(
                      item?.name??'',
                      style: CTC.style(16,
                          fontWeight: FontWeight.w500,
                          fontColor:
                          ColorConstant.textGrey4c4cToWhite(
                              context)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
                    .toList(),
                value:  controller.selectedDepart.value,
                onChanged: (DepData? value) {
                },
                buttonStyleData: ButtonStyleData(
                  height: getHeight(54),
                  // padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color:  ColorConstant.greyD3),
                    color: ColorConstant.containerBackGround(context),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                  // iconSize: 24,

                ),
                isDense: true,
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: ColorConstant.containerBackGround(context),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
                style: CTC.style(14,
                    fontColor: ColorConstant.textBlackToWhite(context)),
              ),
            SizedBox(
              height: getHeight(30),
            ),
            Row(
              children: [
                Expanded(
                    child: AppElevatedButton(
                  buttonName: AppString.close,
                  onPressed: () {
                    Get.back();
                  },
                )),
                SizedBox(
                  width: getWidth(10),
                ),
                Expanded(
                    child: AppElevatedButton(
                  buttonName: AppString.submit,
                  onPressed: () {
                    controller.companyDeportSet();
                  },
                ))
              ],
            )
          ],
        ),
        context: context);
  }

  void storingOfflineDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        radius: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.storingLogOffline,
                textAlign: TextAlign.center,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlueToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.storeText,
                textAlign: TextAlign.center,
                style: CTC.style(14,
                    fontWeight: FontWeight.w500,
                    fontColor: ColorConstant.textDarkTOLight(context)),
              ),
            ),
            SizedBox(
              height: getHeight(30),
            ),
            Obx(
              () => RadioListTile<Type>(
                title: Text(
                  AppString.storeDeleting,
                  style: CTC.style(18,
                      fontWeight: FontWeight.w600,
                      fontColor: ColorConstant.textDarkTOLight(context)),
                ),
                fillColor:
                    MaterialStatePropertyAll(ColorConstant.primaryYellow),
                value: Type.delete,
                groupValue: controller.type.value,
                onChanged: (Type? value) {
                  controller.type.value = value!;
                  CommonConstant.instance.dbHelper.box
                      .put(HiveKey.storeType, 'delete');
                },
              ),
            ),
            SizedBox(
              height: getHeight(20),
            ),
            Obx(
              () => RadioListTile<Type>(
                title: Text(
                  AppString.overwrite,
                  style: CTC.style(18,
                      fontWeight: FontWeight.w600,
                      fontColor: ColorConstant.textDarkTOLight(context)),
                ),
                fillColor:
                    MaterialStatePropertyAll(ColorConstant.primaryYellow),
                value: Type.overwrite,
                groupValue: controller.type.value,
                onChanged: (Type? value) {
                  controller.type.value = value!;
                  CommonConstant.instance.dbHelper.box
                      .put(HiveKey.storeType, 'overwrite');
                },
              ),
            ),
            SizedBox(
              height: getHeight(30),
            ),
          ],
        ),
        firstButtonTitle: AppString.submit,
        firstOnPressed: () {
          Get.back();
        },
        context: context);
  }

  void confirmLicenseDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.confirmLicense,
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
                AppString.confirmLicenseText,
                textAlign: TextAlign.center,
                style: CTC.style(16,
                    fontColor: ColorConstant.textDarkTOLight(context)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
            Text(
              AppString.licenseKey,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textGrey4c4cToWhite(context)),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            CustomAppTextFormField(
              fillColor: ColorConstant.primaryWhite,
              hintText: AppString.licenseKey,
              borderColor: ColorConstant.greyD3,
              borderRadius: BorderRadius.circular(5),
              hintFontStyle: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.grey9DA),
            ),
            SizedBox(
              height: getHeight(20),
            ),
            Text(
              AppString.companyName,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textGrey4c4cToWhite(context)),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            CustomAppTextFormField(
              fillColor: ColorConstant.primaryWhite,
              hintText: AppString.companyName,
              borderColor: ColorConstant.greyD3,
              borderRadius: BorderRadius.circular(5),
              hintFontStyle: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.grey9DA),
            ),
            SizedBox(
              height: getHeight(20),
            ),
          ],
        ),
        firstButtonTitle: AppString.submit,
        firstOnPressed: () {
          Get.back();
        },
        context: context);
  }
}
