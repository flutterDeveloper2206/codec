import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotec/core/utils/app_prefs_key.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../core/app_export.dart';
import 'controller/active_test_screen_controller.dart';

class ActiveTestScreen extends StatefulWidget {
  const ActiveTestScreen();

  @override
  State<ActiveTestScreen> createState() => _ActiveTestScreenState();
}

class _ActiveTestScreenState extends State<ActiveTestScreen>
    with TickerProviderStateMixin {
  ActiveTestScreenController controller =
      Get.find<ActiveTestScreenController>();

  //  late final AnimationController _controller =  AnimationController(
  //   // value: ,
  //   lowerBound: 0.7,
  //   upperBound: 1.0,
  //   duration: const Duration(milliseconds: 300),
  //   vsync: this,
  // );
  //
  //  late final Animation<double> _animation= CurvedAnimation(
  //   parent: _controller,
  //
  //   curve: Curves.fastOutSlowIn,
  // );
  var arguments = Get.arguments;

  @override
  void initState() {
    if (arguments != null) {
      controller.testType.value = arguments[0]['test_type']??'';
      controller.name.value = arguments[0]['name'];
      controller.ptsNumber.value = arguments[0]['pts_number'];
      controller.companyName.value = arguments[0]['company_name'];
      controller.depot.value = arguments[0]['depot'];
      controller.formBNumber.value = arguments[0]['form_b'];
      controller.formCNumber.value = arguments[0]['form_c'];
      controller.location.value = arguments[0]['location'];
      controller.screen.value = arguments[0]['screen'];
      controller.connectedDeviceSend.value = arguments[0]['connectedDevice'];
      controller.locationGPS.value = arguments[0]['locationGPS'];
      print('object ${controller.locationGPS.value}');
    }
    controller.startUpDateTime = DateTime.now();

    controller.sendMessage('s');
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        controller.sendMessage('j');
      },
    );
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        controller.sendMessage('f');
      },
    );
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        controller.sendMessage('f');
        print('==========================sadddddddddddddddddddddddddddddddddd');
      },
    );
    controller.isLogTestScreen.value = false;
    controller.isActiveScreen.value = true;
    controller.hasVoiceActive.value = false;
    controller.hasMeterView.value = true;

    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        controller.startMeter.value = true;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);

    return WillPopScope(
      onWillPop: () async {
        controller.back();

        return false;
      },
      child: Scaffold(
          backgroundColor: ColorConstant.backgroundColor(context),
          appBar: CommonAppbar(
            title: AppString.activeTest,
            statusBarColor: ColorConstant.appBarColor(context),
            backgroundColor: ColorConstant.appBarColor(context),
            onTap: () {
              controller.back();
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
              child: Column(
                children: [
                  SizedBox(
                    height: getHeight(15),
                  ),
                  Container(
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
                    padding: EdgeInsets.only(
                        right: getWidth(10),
                        left: getWidth(10),
                        bottom: getHeight(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Padding(
                            padding: EdgeInsets.only(top: getHeight(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.warning_rounded,
                                      color: controller
                                              .hasInductionWarningTextShow.value
                                          ? ColorConstant.primaryYellow
                                          : controller.hasWarningDetectTextShow
                                                  .value
                                              ? ColorConstant.redFF2
                                              : ColorConstant.transparent,
                                      size: getHeight(35),
                                    ),
                                    Icon(
                                      Icons.warning_rounded,
                                      color: ColorConstant.transparent,
                                      size: getHeight(35),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'V 1.38',
                                      style: CTC.style(15,
                                          fontWeight: FontWeight.w600,
                                          fontColor: ColorConstant
                                              .textPrimaryBlackToWhite(
                                                  context)),
                                    ),
                                    Obx(
                                      () => controller
                                              .firmwareVersion.value.isNotEmpty
                                          ? Text(
                                              controller.firmwareVersion.value,
                                              style: CTC.style(15,
                                                  fontWeight: FontWeight.w600,
                                                  fontColor: ColorConstant
                                                      .textPrimaryBlackToWhite(
                                                          context)),
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.isConnecting.value
                              ? Obx(
                                  () => controller.hasMeterView.value
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              getWidth(50)),
                                          child: SfRadialGauge(

                                              // enableLoadingAnimation: controller.value,
                                              backgroundColor: ColorConstant
                                                  .containerBackGround(context),
                                              // animationDuration: 4500,
                                              axes: <RadialAxis>[
                                                RadialAxis(
                                                  minimum: 0,
                                                  showFirstLabel: false,
                                                  showTicks: false,
                                                  showLabels: false,
                                                  interval: controller
                                                      .voltMeterData
                                                      .value
                                                      .interval,
                                                  axisLineStyle:
                                                      const AxisLineStyle(
                                                          cornerStyle:
                                                              CornerStyle
                                                                  .bothCurve,
                                                          color: Colors
                                                              .transparent,
                                                          thickness: 15),
                                                  maximum: controller
                                                      .voltMeterData
                                                      .value
                                                      .endValue,
                                                  ranges: <GaugeRange>[
                                                    GaugeRange(
                                                      rangeOffset: 0,
                                                      startValue: 0,
                                                      endValue: controller
                                                          .voltMeterData
                                                          .value
                                                          .endValue,
                                                      color: Colors.transparent,
                                                      endWidth: 25,
                                                      startWidth: 25,
                                                    ),
                                                  ],
                                                  tickOffset: 10,
                                                  startAngle: 120,
                                                  minorTickStyle:
                                                      MinorTickStyle(
                                                          length: 8,
                                                          thickness: 3,
                                                          color: ColorConstant
                                                              .text00ToWhite(
                                                                  context)),
                                                  majorTickStyle:
                                                      MajorTickStyle(
                                                          length: 12,
                                                          thickness: 5,
                                                          color: ColorConstant
                                                              .text00ToWhite(
                                                                  context)),
                                                  axisLabelStyle:
                                                      GaugeTextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: ColorConstant
                                                              .text00ToWhite(
                                                                  context)),
                                                  pointers: <GaugePointer>[
                                                    NeedlePointer(
                                                      needleEndWidth: 11,
                                                      needleStartWidth: 1,
                                                      value: 10,
                                                      needleColor: controller
                                                              .startMeter.value
                                                          ? ColorConstant
                                                              .transparent
                                                          : ColorConstant
                                                              .redFF2,

                                                      knobStyle: KnobStyle(
                                                          color: controller
                                                                  .startMeter
                                                                  .value
                                                              ? ColorConstant
                                                                  .transparent
                                                              : ColorConstant
                                                                  .greyE6E6,
                                                          knobRadius: 0.13),
                                                      // value: double.parse(randomValues.toString()),
                                                      animationDuration: 1000,
                                                      animationType:
                                                          AnimationType.ease,
                                                      enableAnimation: true,
                                                      needleLength: 0.8,
                                                    )
                                                  ],
                                                  annotations: <GaugeAnnotation>[
                                                    GaugeAnnotation(
                                                        widget: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          key: ValueKey(
                                                              controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .toString()),
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .showVoltage,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: CTC.style(
                                                                  50,
                                                                  fontColor: ColorConstant
                                                                      .textGrey4c4cToWhite(
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .voltage,
                                                              // key: ValueKey(controller
                                                              //     .voltMeterData.value
                                                              //     .toString()),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: CTC.style(
                                                                44,
                                                                fontColor: ColorConstant
                                                                    .textGrey4c4cToWhite(
                                                                        context),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        angle: 90,
                                                        positionFactor: 0.7)
                                                  ],
                                                ),
                                                RadialAxis(
                                                  minimum: 0,
                                                  interval: controller
                                                      .voltMeterData
                                                      .value
                                                      .interval,
                                                  axisLineStyle:
                                                      const AxisLineStyle(
                                                          color: Colors
                                                              .transparent,
                                                          cornerStyle:
                                                              CornerStyle
                                                                  .bothCurve,
                                                          thickness: 15),
                                                  maximum: controller
                                                      .voltMeterData
                                                      .value
                                                      .endValue,
                                                  ranges: <GaugeRange>[
                                                    GaugeRange(
                                                      rangeOffset: 0,
                                                      startValue: 0,

                                                      endValue: controller
                                                          .voltMeterData
                                                          .value
                                                          .endValue,

                                                      color: controller
                                                          .meterColor.value,
                                                      // color: controller
                                                      //     .voltMeterData.value.color,
                                                      endWidth: 25,
                                                      startWidth: 25,
                                                    ),
                                                  ],
                                                  tickOffset: 10,
                                                  onLabelCreated:
                                                      (AxisLabelCreatedArgs
                                                          args) {
                                                    if (!controller
                                                        .hasPrevVoltage.value) {
                                                      if (controller
                                                              .voltMeterData
                                                              .value
                                                              .defaultValue <
                                                          300) {
                                                        if (args.text ==
                                                            '100') {
                                                          args.text = '100';
                                                        }

                                                        if (args.text ==
                                                            '200') {
                                                          args.text = '200';
                                                        }
                                                        if (args.text ==
                                                            '300') {
                                                          args.text = '300';

                                                          print(
                                                              "GAUGE CHANGED TO FIRST");

                                                          if (controller
                                                                  .lastAnimatedGauge
                                                                  .value !=
                                                              "300") {
                                                            print(
                                                                "GAUGE CHANGED TO FIRST");

                                                            controller
                                                                .startAnimation();
                                                            controller
                                                                .lastAnimatedGauge
                                                                .value = "300";
                                                          }
                                                        }
                                                      } else if (controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .defaultValue >
                                                              300 &&
                                                          controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .defaultValue <
                                                              3000) {
                                                        if (args.text ==
                                                            '100') {
                                                          args.text = '1';
                                                        }
                                                        if (args.text ==
                                                            '200') {
                                                          args.text = '2';
                                                        }
                                                        if (args.text ==
                                                            '300') {
                                                          args.text = '3';
                                                          print(
                                                              "GAUGE CHANGED TO second");
                                                          if (controller
                                                                  .lastAnimatedGauge
                                                                  .value !=
                                                              '3000') {
                                                            print(
                                                                "GAUGE CHANGED TO FIRST");

                                                            controller
                                                                .startAnimation();
                                                            controller
                                                                .lastAnimatedGauge
                                                                .value = "3000";
                                                          }
                                                        }
                                                      } else {
                                                        if (args.text ==
                                                            '100') {
                                                          args.text = '10';
                                                        }
                                                        if (args.text ==
                                                            '200') {
                                                          args.text = '20';
                                                        }
                                                        if (args.text ==
                                                            '300') {
                                                          args.text = '30';
                                                          print(
                                                              "GAUGE CHANGED TO THIRD");

                                                          if (controller
                                                                  .lastAnimatedGauge
                                                                  .value !=
                                                              "30000") {
                                                            print(
                                                                "GAUGE CHANGED TO FIRST");

                                                            controller
                                                                .startAnimation();
                                                            controller
                                                                .lastAnimatedGauge
                                                                .value = "30000";
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      if (controller
                                                              .voltMeterData
                                                              .value
                                                              .defaultValue <
                                                          270) {
                                                        if (args.text ==
                                                            '100') {
                                                          args.text = '100';
                                                        }

                                                        if (args.text ==
                                                            '200') {
                                                          args.text = '200';
                                                        }
                                                        if (args.text ==
                                                            '300') {
                                                          args.text = '300';

                                                          print(
                                                              "GAUGE CHANGED TO FIRST");

                                                          if (controller
                                                                  .lastAnimatedGauge
                                                                  .value !=
                                                              "270") {
                                                            print(
                                                                "GAUGE CHANGED TO FIRST");

                                                            controller
                                                                .startAnimation();
                                                            controller
                                                                .lastAnimatedGauge
                                                                .value = "270";
                                                          }
                                                        }
                                                      } else if (controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .defaultValue >
                                                              270 &&
                                                          controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .defaultValue <
                                                              2800) {
                                                        if (args.text ==
                                                            '100') {
                                                          args.text = '1';
                                                        }
                                                        if (args.text ==
                                                            '200') {
                                                          args.text = '2';
                                                        }
                                                        if (args.text ==
                                                            '300') {
                                                          args.text = '3';
                                                          print(
                                                              "GAUGE CHANGED TO second");
                                                          if (controller
                                                                  .lastAnimatedGauge
                                                                  .value !=
                                                              '2800') {
                                                            print(
                                                                "GAUGE CHANGED TO FIRST");

                                                            controller
                                                                .startAnimation();
                                                            controller
                                                                .lastAnimatedGauge
                                                                .value = "2800";
                                                          }
                                                        }
                                                      } else {
                                                        if (args.text ==
                                                            '100') {
                                                          args.text = '10';
                                                        }
                                                        if (args.text ==
                                                            '200') {
                                                          args.text = '20';
                                                        }
                                                        if (args.text ==
                                                            '300') {
                                                          args.text = '30';
                                                          print(
                                                              "GAUGE CHANGED TO THIRD");

                                                          if (controller
                                                                  .lastAnimatedGauge
                                                                  .value !=
                                                              "30000") {
                                                            print(
                                                                "GAUGE CHANGED TO FIRST");

                                                            controller
                                                                .startAnimation();
                                                            controller
                                                                .lastAnimatedGauge
                                                                .value = "30000";
                                                          }
                                                        }
                                                      }
                                                    }
                                                  },
                                                  startAngle: 130,
                                                  minorTickStyle:
                                                      MinorTickStyle(
                                                          length: 8,
                                                          thickness: 3,
                                                          color: ColorConstant
                                                              .text00ToWhite(
                                                                  context)),
                                                  majorTickStyle:
                                                      MajorTickStyle(
                                                          length: 12,
                                                          thickness: 5,
                                                          color: ColorConstant
                                                              .text00ToWhite(
                                                                  context)),
                                                  axisLabelStyle:
                                                      GaugeTextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: ColorConstant
                                                              .text00ToWhite(
                                                                  context)),
                                                  pointers: <GaugePointer>[
                                                    NeedlePointer(
                                                      needleEndWidth: 11,
                                                      needleStartWidth: 1,

                                                      value: controller
                                                          .voltMeterData
                                                          .value
                                                          .value,
                                                      needleColor: controller
                                                              .startMeter.value
                                                          ? ColorConstant.redFF2
                                                          : Colors.transparent,
                                                      knobStyle: KnobStyle(
                                                          color: controller
                                                                  .startMeter
                                                                  .value
                                                              ? ColorConstant
                                                                  .greyE6E6
                                                              : Colors
                                                                  .transparent,
                                                          knobRadius: 0.13),
                                                      // value: double.parse(randomValues.toString()),
                                                      animationDuration: controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .value ==
                                                              0.0
                                                          ? 1
                                                          : 1500,
                                                      animationType:
                                                          AnimationType.ease,
                                                      enableAnimation: true,
                                                      needleLength: 0.8,
                                                    ),
                                                  ],
                                                  annotations: <GaugeAnnotation>[
                                                    GaugeAnnotation(
                                                        widget: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          key: ValueKey(
                                                              controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .toString()),
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .showVoltage,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: CTC.style(
                                                                  50,
                                                                  fontColor: ColorConstant
                                                                      .textGrey4c4cToWhite(
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              controller
                                                                  .voltMeterData
                                                                  .value
                                                                  .voltage,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: CTC.style(
                                                                44,
                                                                fontColor: ColorConstant
                                                                    .textGrey4c4cToWhite(
                                                                        context),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        angle: 90,
                                                        positionFactor: 0.7),
                                                    GaugeAnnotation(
                                                        widget: AvatarGlow(
                                                          animate: controller
                                                              .hasCenterAnimation
                                                              .value,
                                                          glowRadiusFactor: 5.4,
                                                          glowCount: 1,
                                                          glowColor: !controller
                                                                  .hasCenterAnimation
                                                                  .value
                                                              ? Colors
                                                                  .transparent
                                                              : ColorConstant
                                                                  .naturalGrey,
                                                          child: Container(
                                                            height: !controller
                                                                    .hasCenterAnimation
                                                                    .value
                                                                ? 0
                                                                : 50,
                                                            width: !controller
                                                                    .hasCenterAnimation
                                                                    .value
                                                                ? 0
                                                                : 50,
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                        ),
                                                        angle: 90,
                                                        positionFactor: 0.05),
                                                  ],
                                                ),
                                              ]))
                                      : Container(
                                          margin: EdgeInsets.only(
                                              bottom: getHeight(30),
                                              top: getHeight(30)),
                                          decoration: BoxDecoration(
                                              color: ColorConstant
                                                  .containerBackGround(context),
                                              border: Border.all(
                                                  color: controller
                                                      .meterColor.value,
                                                  width: 8),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: EdgeInsets.symmetric(
                                            vertical: getHeight(30),
                                            // horizontal: getWidth(50)
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${controller.voltMeterData.value.showVoltage}',
                                                  style: CTC.style(90,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontColor: controller
                                                          .meterColor.value),
                                                  // .voltMeterData.value.color),
                                                ),
                                                Text(
                                                  '${controller.voltMeterData.value.voltage}',
                                                  style: CTC.style(30,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontColor: controller
                                                          .meterColor.value),
                                                  // .voltMeterData.value.color),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                )
                              : SizedBox(
                                  height: getHeight(350),
                                  child: Center(
                                    child: Text(
                                      'NO DATA \nAVAILABLE',
                                      textAlign: TextAlign.center,
                                      style: CTC
                                          .style(44,
                                              fontWeight: FontWeight.w600,
                                              fontColor: ColorConstant.redFF2)
                                          .copyWith(letterSpacing: 0.5),
                                    ),
                                  ),
                                ),
                        ),

                        Obx(() => controller.screen.value == '0'
                            ? SizedBox.shrink()
                            : Bounce(
                                onTap: () {
                                  // warningDetectDialog(context);
                                  if (controller.isCapture.value) {
                                    if (!controller.isCalibration.value) {
                                      controller.next();
                                    } else {

                                      controller.calibration(
                                          AppString.attentionCalibrationDes);
                                    }
                                  }
                                },
                                child: CustomImageView(
                                  svgPath: ImageConstant.capture,
                                ),
                              )),
                        Obx(() => controller.hasWarningDetectTextShow.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      style: CTC.style(22,
                                          fontWeight: FontWeight.w600,
                                          fontColor: ColorConstant.redFF2),
                                    )
                                  ])
                            : SizedBox.shrink()),
                        Obx(() => controller.hasInductionWarningTextShow.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      style: CTC.style(22,
                                          fontWeight: FontWeight.w500,
                                          fontColor:
                                              ColorConstant.primaryYellow),
                                    )
                                  ])
                            : SizedBox.shrink()),
                        SizedBox(
                          height: getHeight(10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomImageView(
                                  svgPath: ImageConstant.manVoice,
                                  color: ColorConstant.textDarkTOLight(context),
                                ),
                                SizedBox(
                                  width: getWidth(5),
                                ),
                                Obx(
                                  () => CupertinoSwitch(
                                    value: controller.hasVoiceActive.value,
                                    onChanged: (value) {
                                      controller.hasVoiceActive.value = value;
                                      if (!value) {
                                        controller.speak?.cancel();
                                        controller.flutterTts.stop();
                                      } else {
                                        controller.speakTimer();
                                      }
                                    },
                                    trackColor: ColorConstant.backGroundColor,
                                    thumbColor: controller.hasVoiceActive.value
                                        ? ColorConstant.primaryBlack
                                        : ColorConstant.primaryWhite,
                                    activeColor: ColorConstant.primaryYellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  AppString.meterView,
                                  style: CTC.style(12,
                                      fontWeight: FontWeight.w600,
                                      fontColor: ColorConstant.textBlackToWhite(
                                          context)),
                                ),
                                SizedBox(
                                  width: getWidth(5),
                                ),
                                Obx(
                                  () => CupertinoSwitch(
                                    value: controller.hasMeterView.value,
                                    onChanged: (value) {
                                      controller.hasMeterView.value = value;
                                      if (!value) {
                                        controller.startMeter.value = false;
                                      } else {
                                        Future.delayed(
                                          Duration(milliseconds: 1000),
                                          () {
                                            controller.startMeter.value = true;
                                          },
                                        );
                                      }
                                    },
                                    trackColor: ColorConstant.backGroundColor,
                                    thumbColor: controller.hasMeterView.value
                                        ? ColorConstant.primaryBlack
                                        : ColorConstant.primaryWhite,
                                    activeColor: ColorConstant.primaryYellow,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: getHeight(10),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? 0.2
                                            : 0),
                                    blurRadius: 5.0,
                                    spreadRadius: 0.5),
                              ],
                              border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? ColorConstant.transparent
                                      : Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  ColorConstant.containerBackGround(context)),
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(18),
                              vertical: getHeight(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => CircleAvatar(
                                      radius: 8,
                                      backgroundColor: controller
                                              .isConnecting.value
                                          ? !controller.linkColor.value
                                              ? ColorConstant
                                                  .containerBackGround(context)
                                              : ColorConstant.primaryGreen
                                          : ColorConstant.textRedFF,
                                    ),
                                  ),
                                  SizedBox(
                                    width: getWidth(5),
                                  ),
                                  Text(
                                    AppString.link,
                                    style: CTC.style(15,
                                        fontWeight: FontWeight.w500,
                                        fontColor: ColorConstant.text00ToWhite(
                                            context)),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Obx(
                                    () => CircleAvatar(
                                      radius: 8,
                                      backgroundColor: !controller
                                              .hasPermission.value
                                          ? ColorConstant.textRedFF
                                          : controller.hasLocation.value
                                              ? !controller.gpsColor.value
                                                  ? ColorConstant
                                                      .containerBackGround(
                                                          context)
                                                  : ColorConstant.primaryYellow
                                              : ColorConstant.primaryGreen,
                                    ),
                                  ),
                                  SizedBox(
                                    width: getWidth(5),
                                  ),
                                  Text(
                                    AppString.gps,
                                    style: CTC.style(15,
                                        fontWeight: FontWeight.w500,
                                        fontColor: ColorConstant.text00ToWhite(
                                            context)),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Obx(
                                    () => CircleAvatar(
                                      radius: 8,
                                      backgroundColor: !controller
                                                  .isBattery.value &&
                                              !controller.isCalibration.value
                                          ? ColorConstant.primaryGreen
                                          : ColorConstant.textRedFF,
                                    ),
                                  ),
                                  SizedBox(
                                    width: getWidth(5),
                                  ),
                                  Text(
                                    AppString.status,
                                    style: CTC.style(15,
                                        fontWeight: FontWeight.w500,
                                        fontColor: ColorConstant.text00ToWhite(
                                            context)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///battery
                        SizedBox(
                          height: getHeight(15),
                        ),
                        Obx(
                          () => controller.isBattery.value &&
                                  !controller.isBatteryLoading.value
                              ?
                          Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: ColorConstant.primaryYellow),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getWidth(18),
                                          vertical: getHeight(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CustomImageView(
                                                svgPath: ImageConstant.warning,
                                              ),
                                              SizedBox(
                                                width: getWidth(10),
                                              ),
                                              Text(
                                                AppString.lowBattery,
                                                style: CTC.style(14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: getHeight(15),
                                          ),
                                          Text(
                                            AppString.lowBatteryDes,
                                            style: CTC.style(12,
                                                fontColor:
                                                    ColorConstant.grey4c4c),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: getHeight(15),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),

                        ///calibration
                        Obx(
                          () => controller.isCalibration.value &&
                                  !controller.isBatteryLoading.value
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: ColorConstant.primaryYellow),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getWidth(18),
                                      vertical: getHeight(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CustomImageView(
                                            svgPath: ImageConstant.warning,
                                          ),
                                          SizedBox(
                                            width: getWidth(10),
                                          ),
                                          Text(
                                            AppString.attentionCalibration,
                                            style: CTC.style(14,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: getHeight(15),
                                      ),
                                      Text(
                                        AppString.attentionCalibrationDes,
                                        style: CTC.style(12,
                                            fontColor: ColorConstant.grey4c4c),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getHeight(25),
                  ),
                  Obx(() => controller.screen.value == '0'
                      ? SizedBox.shrink()
                      : Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? 0.3
                                            : 0),
                                    blurRadius: 5.0,
                                    spreadRadius: 0.5),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  ColorConstant.containerBackGround(context)),
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(18),
                              vertical: getHeight(20)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppString.testTypes,
                                      style: CTC.style(14,
                                          fontWeight: FontWeight.w600,
                                          fontColor: ColorConstant
                                              .textPrimaryBlackToWhite(
                                                  context)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      controller.testType.value,
                                      style: CTC.style(14,
                                          fontWeight: FontWeight.w500,
                                          fontColor: ColorConstant
                                              .textPrimaryBlackToWhite(
                                                  context)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: getHeight(5),
                              ),
                              itemNameValue(AppString.fullName,
                                  controller.name.value, context),
                              itemNameValue(AppString.ptsNumber,
                                  controller.ptsNumber.value, context),
                              itemNameValue(AppString.companyName,
                                  '${controller.companyName.value} ', context),
                              itemNameValue(AppString.fromBNumber,
                                  controller.formBNumber.value, context),
                              itemNameValue(AppString.fromCNumber,
                                  controller.formCNumber.value, context),
                              itemNameValue(AppString.location,
                                  controller.location.value, context)
                            ],
                          ),
                        )),
                  // SizedBox(
                  //   height: getHeight(25),
                  // ),
                  // AppElevatedButton(
                  //   buttonName: AppString.confirm,
                  //   onPressed: () {
                  //     controller.next();
                  //   },
                  // ),
                  SizedBox(
                    height: getHeight(25),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              CommonConstant.instance.dbHelper.box.get(HiveKey.isShowLogs) ==
                      true
                  ? FloatingActionButtonLocation.centerFloat
                  : null,
          floatingActionButton:
              CommonConstant.instance.dbHelper.box.get(HiveKey.isShowLogs) ==
                      true
                  ? FloatingActionButton.extended(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        bottomSheet();
                      },
                      label: Center(
                          child: Text(
                        'Show logs',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    )
                  : null),
    );
  }

  bottomSheet() {
    showModalBottomSheet<void>(
      barrierColor: Colors.transparent,
      context: Get.overlayContext as BuildContext,
      builder: (BuildContext context) {
        return SizedBox(
          height: getHeight(350),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                    border: Border.all(color: Colors.black)),
                child: Obx(
                  () => SafeArea(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: getHeight(50)),
                      shrinkWrap: true,
                      controller: controller.listScrollController,
                      itemCount: controller.messagesListConsole.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.messagesListConsole[index].text.trim(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                            Obx(
                              () => Divider(
                                color: index ==
                                        controller.messagesListConsole.length -
                                            1
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ));
          }),
        );
      },
    );
  }

  Widget itemNameValue(String title, String value, BuildContext context) {
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
                    fontColor: ColorConstant.textPrimaryBlackToWhite(context)),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: CTC.style(14,
                    fontWeight: FontWeight.w500,
                    fontColor: ColorConstant.textPrimaryBlackToWhite(context)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: getHeight(5),
        ),
      ],
    );
  }
}

class VoltMeterData {
  double interval;
  double value;
  double defaultValue;
  String showVoltage;
  double endValue;
  double startValue;
  String voltage;

  VoltMeterData({
    this.interval = 100,
    this.endValue = 301,
    this.value = 0,
    this.defaultValue = 0,
    this.showVoltage = '0',
    this.voltage = 'V',
    this.startValue = 0,
  });
}
