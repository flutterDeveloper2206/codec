import 'package:cotec/core/utils/app_prefs_key.dart';
import 'package:cotec/core/utils/hive_helper.dart';
import 'package:cotec/presentation/voltage_per_second_screen/controller/voltage_per_second_screen_controller.dart';

import '../../core/app_export.dart';

class VoltagePerSecondScreen
    extends GetWidget<VoltagePerSecondScreenController> {
  const VoltagePerSecondScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        appBar: const CommonAppbar(title: AppString.voltagePerSecond),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: getHeight(30),
              ),
              Obx(
                () => Container(
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
                      color: controller.selectedValue.value == 3
                          ? ColorConstant.primaryYellow
                          : ColorConstant.containerBackGround(context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(12), vertical: getHeight(5)),
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppString.threeSecond,
                      style: CTC.style(16,
                          fontWeight: FontWeight.w600,
                          fontColor: controller.selectedValue.value == 3
                              ? ColorConstant.primaryBlack
                              : ColorConstant.textDarkTOLight(context)),
                    ),
                    value: 3,
                    activeColor: ColorConstant.primaryBlue,
                    groupValue: controller.selectedValue.value,
                    onChanged: (int? value) {
                      controller.selectedValue.value = value!;

                      CommonConstant.instance.dbHelper.box.put(
                          HiveKey.voltagePerSecond,
                          controller.selectedValue.value);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: getHeight(10),
              ),
              Obx(
                () => Container(
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
                      color: controller.selectedValue.value == 6
                          ? ColorConstant.primaryYellow
                          : ColorConstant.containerBackGround(context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(12), vertical: getHeight(5)),
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppString.sixSecond,
                      style: CTC.style(16,
                          fontWeight: FontWeight.w600,
                          fontColor: controller.selectedValue.value == 6
                              ? ColorConstant.primaryBlack
                              : ColorConstant.textDarkTOLight(context)),
                    ),
                    value: 6,
                    activeColor: ColorConstant.primaryBlue,
                    groupValue: controller.selectedValue.value,
                    onChanged: (int? value) {
                      controller.selectedValue.value = value!;
                      CommonConstant.instance.dbHelper.box.put(
                          HiveKey.voltagePerSecond,
                          controller.selectedValue.value);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: getHeight(10),
              ),
              Obx(
                () => Container(
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
                      color: controller.selectedValue.value == 10
                          ? ColorConstant.primaryYellow
                          : ColorConstant.containerBackGround(context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(12), vertical: getHeight(5)),
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppString.tenSecond,
                      style: CTC.style(16,
                          fontWeight: FontWeight.w600,
                          fontColor: controller.selectedValue.value == 10
                              ? ColorConstant.primaryBlack
                              : ColorConstant.textDarkTOLight(context)),
                    ),
                    value: 10,
                    activeColor: ColorConstant.primaryBlue,
                    groupValue: controller.selectedValue.value,
                    onChanged: (int? value) {
                      controller.selectedValue.value = value!;
                      CommonConstant.instance.dbHelper.box.put(
                          HiveKey.voltagePerSecond,
                          controller.selectedValue.value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
