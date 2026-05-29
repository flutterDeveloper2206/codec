import 'package:cotec/core/utils/app_prefs_key.dart';
import 'package:cotec/core/utils/progress_dialog_utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_export.dart';
import 'controller/active_test_details_screen_controller.dart';

class ActiveTestDetailScreen
    extends GetWidget<ActiveTestDetailScreenController> {
  const ActiveTestDetailScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        appBar: const CommonAppbar(title: AppString.createLog),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getHeight(10),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(
                                Theme.of(context).brightness == Brightness.light
                                    ? 0.3
                                    : 0),
                            blurRadius: 5.0,
                            spreadRadius: 0.5),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConstant.containerBackGround(context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(18), vertical: getHeight(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          controller.kv.value,
                          style: CTC.style(50,
                              fontWeight: FontWeight.bold,
                              fontColor: ColorConstant.primaryYellow),
                        ),
                      ),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      Divider(
                        color: ColorConstant.textGrey4c4cToWhite(context),
                      ),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      if (controller.isInductionEnr.value == 'Induction')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: ColorConstant.primaryYellow,
                                    size: getHeight(30),
                                  ),
                                  SizedBox(
                                    width: getWidth(8),
                                  ),
                                  Text(
                                    AppString.induction,
                                    style: CTC.style(16,
                                        fontWeight: FontWeight.bold,
                                        fontColor: ColorConstant.primaryYellow),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getHeight(10),
                            ),
                          ],
                        ),
                      if (controller.isInductionEnr.value == 'Energised')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: ColorConstant.redFF2,
                                    size: getHeight(30),
                                  ),
                                  SizedBox(
                                    width: getWidth(8),
                                  ),
                                  Text(
                                    AppString.caution,
                                    style: CTC.style(16,
                                        fontWeight: FontWeight.bold,
                                        fontColor: ColorConstant.redFF2),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getHeight(10),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      itemNameValue(
                          AppString.startUp, controller.startUp.value, context,
                          isSize: true),
                      itemNameValue(AppString.voltsDetected,
                          controller.voltsDetect.value, context,
                          isSize: true),
                      itemNameValue(AppString.duration,
                          controller.duration.value, context,
                          isSize: true),
                      itemNameValue(
                          AppString.voltsHie, controller.highest.value, context,
                          isSize: true),
                      itemNameValue(
                          AppString.voltLow, controller.lowest.value, context,
                          isSize: true),
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(20),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(
                                Theme.of(context).brightness == Brightness.light
                                    ? 0.3
                                    : 0),
                            blurRadius: 5.0,
                            spreadRadius: 0.5),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConstant.containerBackGround(context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(18), vertical: getHeight(20)),
                  child: Obx(
                    () => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                AppString.testTypes,
                                style: CTC.style(14,
                                    fontWeight: FontWeight.w600,
                                    fontColor:
                                        ColorConstant.textDarkTOLight(context)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                controller.testType.value,
                                style: CTC.style(14,
                                    fontWeight: FontWeight.w500,
                                    fontColor:
                                        ColorConstant.textDarkTOLight(context)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getHeight(5),
                        ),
                        itemNameValue(
                            AppString.fullName, controller.name.value, context),
                        itemNameValue(AppString.ptsNumber,
                            controller.ptsNumber.value, context),
                        itemNameValue(
                            AppString.companyName,
                            '${controller.companyName.value} > ${controller.depot.value}',
                            context),
                        itemNameValue(AppString.fromBNumber,
                            controller.formBNumber.value, context),
                        itemNameValue(AppString.fromCNumber,
                            controller.formCNumber.value, context),
                        itemNameValue(
                          AppString.location,
                          controller.location.value,
                          context,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(30),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(
                                Theme.of(context).brightness == Brightness.light
                                    ? 0.3
                                    : 0),
                            blurRadius: 5.0,
                            spreadRadius: 0.5),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConstant.containerBackGround(context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(18), vertical: getHeight(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.addTestImage,
                        style: CTC.style(16,
                            fontWeight: FontWeight.w500,
                            fontColor: ColorConstant.textBlackToWhite(context)),
                      ),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: ColorConstant.primaryBlue,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(20),
                                vertical: getHeight(10)),
                            child: CustomImageView(
                              svgPath: ImageConstant.upload,
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: ColorConstant.primaryWhite,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: ColorConstant.primaryWhite,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: getWidth(20),
                                              vertical: getHeight(20)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Select Image',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ColorConstant
                                                            .primaryBlue),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: ColorConstant
                                                            .primaryBlue,
                                                      ))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .pickImages(
                                                                    ImageSource
                                                                        .camera);
                                                          },
                                                          icon: Icon(
                                                            Icons.camera,
                                                            color: ColorConstant
                                                                .primaryBlue,
                                                            size: 50,
                                                          )),
                                                      Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: ColorConstant
                                                                .primaryBlue),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            controller.pickImages(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                          icon: Icon(
                                                            Icons.image,
                                                            color: ColorConstant
                                                                .primaryBlue,
                                                            size: 50,
                                                          )),
                                                      Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: ColorConstant
                                                                .primaryBlue),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? ColorConstant.primaryWhite
                                          : ColorConstant.greyDCDC,
                                      border: Border.all(
                                          color: ColorConstant.greyD3),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                    left: getWidth(8),
                                    right: getWidth(8),
                                    top: getHeight(17),
                                    bottom: getHeight(17),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Obx(
                                          () => Text(
                                            controller.image.value.isEmpty
                                                ? 'Select Test Image'
                                                : controller.image.value,
                                            maxLines: 1,
                                            style: CTC.style(14,
                                                fontColor: controller
                                                        .image.value.isEmpty
                                                    ? Colors.grey
                                                    : ColorConstant.textBlack,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getWidth(4),
                                      ),
                                      Obx(
                                        () => !controller.image.value.isEmpty
                                            ? Bounce(
                                                onTap: () {
                                                  controller.image.value = '';
                                                },
                                                child: CustomImageView(
                                                  svgPath:
                                                      ImageConstant.fillClose,
                                                ))
                                            : SizedBox.shrink(),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        AppString.addNotes,
                        style: CTC.style(
                          16,
                          fontWeight: FontWeight.w500,
                          fontColor: ColorConstant.textBlackToWhite(context),
                        ),
                      ),
                      SizedBox(
                        height: getHeight(10),
                      ),
                      CustomAppTextFormField(
                        maxLines: 3,
                        fontStyle: CTC.style(16,
                            fontWeight: FontWeight.w500,
                            fontColor: ColorConstant.grey9DA),
                        hintText: AppString.enterNotes,
                        controller: controller.noteController,
                        onChanged: (p0) {
                          controller.textLength.value = p0.length.toString();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(500)
                        ],
                        fillColor: ColorConstant.containerBackGround(context),
                        borderRadius: BorderRadius.circular(5),
                        hintFontStyle: CTC.style(16,
                            fontWeight: FontWeight.w500,
                            fontColor: ColorConstant.grey9DA),
                        borderColor: ColorConstant.text00ToWhite(context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => Text(
                              controller.textLength.value,
                              style: CTC.style(16,
                                  fontWeight: FontWeight.w500,
                                  fontColor: ColorConstant.grey9DA),
                            ),
                          ),
                          Text(
                            '/500',
                            style: CTC.style(16,
                                fontWeight: FontWeight.w500,
                                fontColor: ColorConstant.grey9DA),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                AppElevatedButton(
                  buttonName: AppString.createLog,
                  onPressed: () {
                    // youHaveCreateLog

                    if (CommonConstant.instance.dbHelper.box
                            .get(HiveKey.isLogCreated) ==
                        true) {
                      ProgressDialogUtils.showTitleSnackBar(
                          headerText: AppString.youHaveCreateLog);
                    } else {
                      controller.createLog();
                      CommonConstant.instance.dbHelper.box
                          .put(HiveKey.isLogCreated, true);
                    }
                  },
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                AppElevatedButton(
                  borderColor: ColorConstant.primaryBlue,
                  hasGradient: false,
                  textColor: ColorConstant.textBlueToYellow(context),
                  buttonColor: ColorConstant.backgroundColor(context),
                  buttonName: AppString.retry,
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: getHeight(30),
                ),
              ],
            ),
          ),
        ));
  }

  Widget itemNameValue(String title, String value, BuildContext context,
      {bool isSize = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$title:',
                style: CTC.style(14,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textDarkTOLight(context)),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: CTC.style(14,
                    fontWeight: FontWeight.w500,
                    fontColor: ColorConstant.textDarkTOLight(context)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: getHeight(isSize ? 10 : 5),
        ),
      ],
    );
  }

  void createLogDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        radius: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.createLog,
                textAlign: TextAlign.center,
                style: CTC.style(24,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlueToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(30),
            ),
            Center(
              child: Text(
                AppString.createLogText,
                textAlign: TextAlign.center,
                style: CTC.style(14,
                    fontColor: ColorConstant.textBlackToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(30),
            ),
            Row(
              children: [
                Expanded(
                    child: AppElevatedButton(
                  borderColor: ColorConstant.primaryBlue,
                  hasGradient: false,
                  textColor: ColorConstant.textBlueToYellow(context),
                  buttonColor: ColorConstant.containerBackGround(context),
                  buttonName: AppString.retry,
                  onPressed: () {
                    Get.back();
                  },
                )),
                SizedBox(
                  width: getWidth(11),
                ),
                Expanded(
                    child: AppElevatedButton(
                  buttonName: AppString.accept,
                  onPressed: () {
                    Get.back();
                  },
                ))
              ],
            )
          ],
        ),
        context: context);
  }
}
