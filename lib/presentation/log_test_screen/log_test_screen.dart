import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:cotec/presentation/active_test_screen/controller/active_test_screen_controller.dart';

import '../../core/app_export.dart';
import 'controller/log_test_screen_controller.dart';

class LogTestScreen extends GetWidget<LogTestScreenController> {
  const LogTestScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return WillPopScope(
        onWillPop: () async {
          Get.put(ActiveTestScreenController()).isLogTestScreen.value = false;
          Get.back();
          return false;
        },
        child: Scaffold(
            backgroundColor: ColorConstant.backgroundColor(context),
            appBar: CommonAppbar(
              title: AppString.logATest,
              onTap: () {
                Get.put(ActiveTestScreenController()).isLogTestScreen.value =
                    false;
                Get.back();
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(20), vertical: getHeight(20)),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppString.testType,
                            style: CTC.style(16,
                                fontWeight: FontWeight.w500,
                                fontColor: controller.testTypeValidate.value
                                    ? ColorConstant.textRedFF
                                    : ColorConstant.text00ToWhite(context)),
                          ),
                          if (controller.testTypeValidate.value)
                            Text(
                              ' - is required',
                              style: CTC.style(16,
                                  fontWeight: FontWeight.w500,
                                  fontColor: ColorConstant.textRedFF),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      DropdownButtonFormField2(
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
                        items: controller.items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: CTC.style(16,
                                        fontWeight: FontWeight.w500,
                                        fontColor:
                                            ColorConstant.textGrey4c4cToWhite(
                                                context)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: controller.selectedValueDrop.value.isEmpty
                            ? null
                            : controller.selectedValue.value,
                        onChanged: (String? value) {
                          if (value!.isNotEmpty) {

                            controller.testTypeValidate.value = false;
                            controller.isAllValidate.value = false;
                          }
                          controller.checkBoxValidate.value = false;
                          controller.checkBoxLiveValidate.value = false;
                          controller.checkBoxValidateController.value = false;
                          controller.checkBoxValidateLiveController.value =
                              false;
                          controller.selectedValue.value = value!;
                          controller.selectedValueDrop.value = value!;
                          print(controller.selectedValueDrop.value);
                        },
                        buttonStyleData: ButtonStyleData(
                          height: getHeight(54),
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: controller.testTypeValidate.value
                                    ? ColorConstant.textRedFF
                                    : ColorConstant.transparent),
                            color: ColorConstant.containerBackGround(context),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          iconSize: 24,
                          iconEnabledColor: controller.testTypeValidate.value
                              ? ColorConstant.textRedFF
                              : ColorConstant.text00ToWhite(context),
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
                      Obx(() => controller.selectedValueDrop.value ==
                              'Test Before Touch'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => IconButton(
                                    onPressed: () {
                                      controller.onChangeCheckBox();
                                      if (controller.checkBoxValidate.value ==
                                          true) {
                                        controller.checkBoxLiveValidate.value =
                                            true;

                                        controller.checkBoxValidateController
                                            .value = false;
                                      }
                                    },
                                    highlightColor: ColorConstant.transparent,
                                    focusColor: ColorConstant.transparent,
                                    splashColor: ColorConstant.transparent,
                                    icon: Icon(
                                      controller.checkBoxValidate.value
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      size: 30,
                                      color: controller
                                              .checkBoxValidateController.value
                                          ? ColorConstant.redF95
                                          : ColorConstant.textBlueToYellow(
                                              context),
                                    ))),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppString.checkBoxText,
                                      style: CTC.style(16,
                                          fontColor:
                                              ColorConstant.text00ToWhite(
                                                  context)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink()),
                      Obx(() => controller.selectedValueDrop.value ==
                              'Reinstate Live - Energised'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => IconButton(
                                    onPressed: () {
                                      controller.onChangeLiveCheckBox();
                                      if (controller
                                              .checkBoxLiveValidate.value ==
                                          true) {
                                        controller.checkBoxValidate.value =
                                            true;
                                        controller
                                            .checkBoxValidateLiveController
                                            .value = false;
                                      }
                                    },
                                    highlightColor: ColorConstant.transparent,
                                    focusColor: ColorConstant.transparent,
                                    splashColor: ColorConstant.transparent,
                                    icon: Icon(
                                      controller.checkBoxLiveValidate.value
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      size: 30,
                                      color: controller
                                              .checkBoxValidateLiveController
                                              .value
                                          ? ColorConstant.redF95
                                          : ColorConstant.textBlueToYellow(
                                              context),
                                    ))),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppString.checkBoxTextLive,
                                      style: CTC.style(16,
                                          fontColor:
                                              ColorConstant.text00ToWhite(
                                                  context)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink()),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      titleText(
                          context: context,
                          title: AppString.name,
                          hintText: AppString.enterHere,
                          suffix: Obx(
                            () => controller.nameList.isEmpty
                                ? SizedBox.shrink()
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton2<CreateLog>(
                                      customButton: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 46,
                                          color: ColorConstant.text00ToWhite(
                                              context)),
                                      items: controller.nameList.value
                                          .map((CreateLog item) =>
                                              DropdownMenuItem<CreateLog>(
                                                value: item,
                                                child: Text(
                                                  item.fullName ?? '',
                                                  style: CTC.style(16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontColor: ColorConstant
                                                          .textGrey4c4cToWhite(
                                                              context)),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: null,
                                      onChanged: (CreateLog? value) {
                                        controller.nameController.text =
                                            value?.fullName ?? '';
                                        controller.selectedName.value = value!;
                                        controller.ptsNumberController.text =
                                            controller.selectedName.value
                                                    .pTSNumber ??
                                                '';
                                      },

                                      // isExpanded: true,
                                      hint: Text(
                                        AppString.selectTestType,
                                        style: CTC.style(16,
                                            fontColor: ColorConstant.grey9DA),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        width: double.maxFinite,
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color:
                                              ColorConstant.containerBackGround(
                                                  context),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        offset: const Offset(0, 10),
                                      ),
                                      menuItemStyleData: MenuItemStyleData(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                          ),
                          isValidate: !controller.nameValidate.value,
                          onChanged: (p0) {
                            controller.ptsNumberController.clear();
                            if (p0.isNotEmpty) {
                              controller.nameValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          textController: controller.nameController),
                      titleText(
                          context: context,
                          title: AppString.ptsNumber,
                          hintText: AppString.enterPTSNumber,
                          isValidate: !controller.ptsValidate.value,
                          onChanged: (p0) {
                            if (p0.isNotEmpty) {
                              controller.ptsValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          textController: controller.ptsNumberController),
                      titleText(
                          context: context,
                          title: AppString.companyName,
                          hintText: AppString.johnCompany,
                          readOnly: controller.companyReadOnly.value,
                          isValidate: !controller.companyValidate.value,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          fillColor: ColorConstant.backgroundTextField(context),
                          onChanged: (p0) {
                            if (p0.isNotEmpty) {
                              controller.companyValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          textController: controller.companyNameController),
                      titleText(
                          context: context,
                          title: AppString.depot,
                          hintText: AppString.depot,
                          isValidate: !controller.depotValidate.value,
                          fillColor: ColorConstant.backgroundTextField(context),
                          onChanged: (p0) {
                            if (p0.isNotEmpty) {
                              controller.depotValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          textController: controller.depotController),
                      titleText(
                          context: context,
                          title: AppString.fromBNumber,
                          hintText: AppString.enterBNumber,
                          isValidate: !controller.bNumberValidate.value,
                          onChanged: (p0) {
                            if (p0.isNotEmpty) {
                              controller.bNumberValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          textController: controller.bNumberController),
                      titleText(
                          context: context,
                          isRequired: false,
                          title: AppString.fromCNumber,
                          hintText: AppString.enterCNumber,
                          isValidate: !controller.cNumberValidate.value,
                          onChanged: (p0) {
                            if (p0.isNotEmpty) {
                              controller.cNumberValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          textController: controller.cNumberController),
                      titleText(
                          isRequired: false,
                          context: context,
                          title: AppString.location,
                          hintText: AppString.enterLocation,
                          onChanged: (p0) {
                            if (p0.isNotEmpty) {
                              controller.locationValidate.value = false;
                              // controller.isAllValidate.value = false;
                            }
                          },
                          readOnly: false,
                          isValidate: !controller.locationValidate.value,
                          textController: controller.locationController),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: AppElevatedButton(
                            buttonName: AppString.clearAll,
                            onPressed: () {
                              controller.clearAll();
                            },
                          )),
                          SizedBox(
                            width: getWidth(10),
                          ),
                          Expanded(
                              child: AppElevatedButton(
                            buttonName: AppString.proceedToTest,
                            onPressed: () {
                              controller.next(context);
                            },
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget titleText(
      {required String title,
      required bool isValidate,
      bool isRequired = true,
      required BuildContext context,
      required Function(String) onChanged,
      List<TextInputFormatter>? inputFormatters,
      Color? fillColor,
      Widget? suffix,
      bool? readOnly,
      required TextEditingController textController,
      required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: !isValidate
                      ? ColorConstant.textRedFF
                      : ColorConstant.text00ToWhite(context)),
            ),
            if (!isValidate && isRequired)
              Text(
                AppString.isRequired,
                style: CTC.style(16,
                    fontWeight: FontWeight.w400,
                    fontColor: ColorConstant.textRedFF),
              ),
          ],
        ),
        SizedBox(
          height: getHeight(10),
        ),
        Form(
          child: CustomAppTextFormField(
            controller: textController,
            hintText: hintText,
            readOnly: readOnly ?? false,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            fillColor: fillColor ?? ColorConstant.containerBackGround(context),
            fontStyle: CTC.style(16,
                fontWeight: FontWeight.w500,
                fontColor: ColorConstant.textGrey4c4cToWhite(context)),
            hintFontStyle: CTC.style(16, fontColor: ColorConstant.grey9DA),
            suffix: suffix,
            borderColor: !isValidate
                ? ColorConstant.textRedFF
                : ColorConstant.transparent,
          ),
        ),
        SizedBox(
          height: getHeight(15),
        ),
      ],
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
