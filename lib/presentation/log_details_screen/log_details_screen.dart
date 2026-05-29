import 'dart:convert';
import 'dart:io';

import '../../core/app_export.dart';
import 'controller/log_details_screen_controller.dart';

class LogDetailsScreen extends GetWidget<LogDetailsScreenController> {
  const LogDetailsScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        appBar:
            CommonAppbar(title: controller.logDetails.value.logNumber ?? ''),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppString.logNumber,
                        style: CTC.style(16,
                            fontWeight: FontWeight.bold,
                            fontColor: ColorConstant.textDarkTOLight(context)),
                      ),
                      Text(
                        controller.logDetails.value.logNumber ?? '',
                        style: CTC.style(16,
                            fontWeight: FontWeight.w500,
                            fontColor: ColorConstant.textDarkTOLight(context)),
                      ),
                    ],
                  ),
                ),


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
                              controller.logDetails.value.testType ?? '',
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
                      itemNameValue(AppString.fullName,
                          controller.logDetails.value.fullName ?? '', context),
                      itemNameValue(AppString.ptsNumber,
                          controller.logDetails.value.pTSNumber ?? '', context),
                      itemNameValue(
                          AppString.companyName,
                          controller.logDetails.value.companyName ?? '',
                          context),
                      itemNameValue(
                          AppString.fromBNumber,
                          controller.logDetails.value.formBNumber ?? '',
                          context),
                      itemNameValue(
                          AppString.fromCNumber,
                          controller.logDetails.value.formCNumber ?? '',
                          context),
                      itemNameValue(AppString.location,
                          controller.logDetails.value.location ?? '', context)
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                if (controller.logDetails.value.isInductionEnr == 'Induction')
                  Column(
                  children: [
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
                      child:                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [  SizedBox(
                          height: getHeight(8),
                        ),
                          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: ColorConstant.primaryYellow,
                                size: getHeight(35),
                              ),
                              SizedBox(
                                width: getWidth(8),
                              ),
                              Text(
                                  AppString.induction,
                                  style: CTC.style(16,
                                    fontWeight: FontWeight.bold,
                                    fontColor: ColorConstant.primaryYellow,
                                  )),
                            ],
                          ),

                          SizedBox(
                            height: getHeight(8),
                          ),
                        ],
                      ),

                    ),
                    SizedBox(
                      height: getHeight(25),
                    ),
                  ],
                ),
                if (controller.logDetails.value.isInductionEnr == 'Energised')
                Column(
                  children: [
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
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getHeight(8),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: ColorConstant.redFF2,
                                size: getHeight(35),
                              ),
                              SizedBox(
                                width: getWidth(8),
                              ),
                              Text(
                                  AppString.caution,
                                  style: CTC.style(16,
                                    fontWeight: FontWeight.bold,
                                    fontColor: ColorConstant.redFF2,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: getHeight(8),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getHeight(25),
                    ),
                  ],
                ),
                if (controller.logDetails.value.isInductionEnr == 'NO')
                  SizedBox(
                  height: getHeight(25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppString.gpsLocation,
                      style: CTC.style(16,
                          fontWeight: FontWeight.bold,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                    Text(
                      controller.logDetails.value.gpsLocation ?? '',
                      style: CTC.style(16,
                          fontWeight: FontWeight.w500,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                  ],
                ),
                SizedBox(
                  height: getHeight(25),
                ),




                  if(controller.logDetails.value.isBatteryCalibration=='Battery')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      AppString.statusMessage,
                      style: CTC.style(16,
                          fontWeight: FontWeight.bold,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                    Text(
                      'Low Battery. Please recharge the device at the earliest opportunity.',
                      style: CTC.style(16,
                          fontWeight: FontWeight.w500,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ), SizedBox(
                      height: getHeight(25),
                    ),
                  ],
                ),
                if(controller.logDetails.value.isBatteryCalibration=='Calibration')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      AppString.statusMessage,
                      style: CTC.style(16,
                          fontWeight: FontWeight.bold,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                    Text(
                      AppString.attentionCalibrationDes,
                      style: CTC.style(16,
                          fontWeight: FontWeight.w500,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                    SizedBox(
                      height: getHeight(25),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.deviceNumber,
                      style: CTC.style(16,
                          fontWeight: FontWeight.bold,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                    Text(
                      controller.logDetails.value.deviceSerialNumber ?? '',
                      style: CTC.style(16,
                          fontWeight: FontWeight.w500,
                          fontColor: ColorConstant.textDarkTOLight(context)),
                    ),
                  ],
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
                      itemNameValue(AppString.createdDate,
                          controller.logDetails.value.date ?? '', context,
                          isSize: true),
                      itemNameValue(AppString.startUp,
                          controller.logDetails.value.startUp ?? '', context,
                          isSize: true),
                      itemNameValue(
                          AppString.voltsDetected,
                          controller.logDetails.value.voltsDetected ?? '',
                          context,
                          isSize: true),
                      itemNameValue(AppString.duration,
                          controller.logDetails.value.duration ?? '', context,
                          isSize: true),
                      itemNameValue(
                          AppString.voltsHie,
                          controller.logDetails.value.voltsHighest ?? '',
                          context,
                          isSize: true),
                      itemNameValue(
                          AppString.voltLow,
                          controller.logDetails.value.voltsLowest ?? '',
                          context,
                          isSize: true),
                      Text(
                        AppString.notes,
                        style: CTC.style(14,
                            fontWeight: FontWeight.w600,
                            fontColor: ColorConstant.textDarkTOLight(context)),
                      ),
                      SizedBox(
                        height: getHeight(5),
                      ),
                      Text(
                        controller.logDetails.value.notes ?? '',
                        style: CTC.style(12,
                            fontWeight: FontWeight.w500,
                            fontColor: ColorConstant.textDarkTOLight(context)),
                      ),
                    ],
                  ),
                ),

                if(controller.logDetails.value.photoPath!=null&&controller.logDetails.value.photoPath!.isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      height: getHeight(30),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
    controller.logDetails.value.photoPath!.contains('http')?
                        Image.network(controller.logDetails.value.photoPath??'',fit: BoxFit.cover,)
                        // CustomImageView(url:controller.logDetails.value.photoPath??'' ,fit: BoxFit.cover,)
                        :Image.memory(Base64Decoder().convert(controller.logDetails.value.photoPath??''))
                    ),
                  ],
                ),
                SizedBox(
                  height: getHeight(30),
                ),

                AppElevatedButton(
                  buttonName: AppString.downloadPDF,
                  onPressed: () {
                    CommonConstant.instance.commonShowDialogs(
                      child: dialogDownload(
                          controller.logDetails.value.fullName ?? '',
                          controller.logDetails.value.logNumber ?? ''),
                      backgroundColor: ColorConstant.primaryWhite,
                      context: context,
                      firstButtonTitle: AppString.cancel,
                      firstOnPressed: () {
                        Get.back();
                      },
                    );
                  },
                ),
                SizedBox(
                  height: getHeight(20),
                ),
                AppElevatedButton(
                  hasGradient: false,
                  buttonColor: ColorConstant.backgroundColor(context),
                  buttonName: AppString.shareLog,
                  textColor: ColorConstant.textBlueToYellow(context),
                  onPressed: () {
                    controller.makePdf(
                        controller.logDetails.value.fullName ?? '',
                        controller.logDetails.value.logNumber ?? '',
                        true);
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

  Widget dialogDownload(String name, String logNumber) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Bounce(
                  onTap: () {
                    Get.back();
                    controller.makePdf(name, logNumber, false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.primaryBlue,
                        borderRadius: BorderRadius.circular(100)),
                    padding: EdgeInsets.all(20),
                    child: CustomImageView(
                      height: getHeight(40),
                      width: getHeight(40),
                      svgPath: ImageConstant.pdfCSV,
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                Text(
                  AppString.pdf,
                  style: CTC.style(16,
                      fontColor: ColorConstant.primaryBlue,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            Column(
              children: [
                Bounce(
                  onTap: () {
                    controller.cSVDownload();
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.primaryBlue,
                        borderRadius: BorderRadius.circular(100)),
                    padding: EdgeInsets.all(20),
                    child: CustomImageView(
                      height: getHeight(40),
                      width: getHeight(40),
                      svgPath: ImageConstant.pdfCSV,
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                Text(
                  AppString.csv,
                  style: CTC.style(16,
                      fontColor: ColorConstant.primaryBlue,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: getHeight(10),
        ),
      ],
    );
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
}
