// import 'package:cotec/MainPage.dart';
// import 'package:cotec/presentation/home_screen/widget/home_card_widget.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:cotec/vaibretion_helper.dart';
//
// import '../../../core/app_export.dart';
//
// import 'controller/home_screen_controller.dart';
//
// class HomeScreen extends GetWidget<HomeScreenController> {
//   const HomeScreen();
//
//   @override
//   Widget build(BuildContext context) {
//     sizeCalculate(context);
//     return Scaffold(
//         backgroundColor: ColorConstant.backgroundColor(context),
//         appBar: const CommonAppbar(hasBack: false),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//
//                     // LocalAudioPlayer.play('assets/sound/waring_sound.wav');
//
//                     Get.to(MainPage());
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: getWidth(45), vertical: getWidth(25)),
//                     child: CustomImageView(
//                       imagePath: ImageConstant.appLogo,
//                     ),
//                   ),
//                 ),
//                 GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     childAspectRatio: 2.5 / 2.7,
//                     crossAxisSpacing: getWidth(15),
//                     mainAxisSpacing: getHeight(5),
//                     children: List.generate(controller.choices.length, (index) {
//                       return Obx(
//                         () => HomeMenuCard(
//                           homeMenu: controller.choices[index],
//                           connected: index == 4
//                               ? controller.bluetoothState.value.isEnabled
//                               : false,
//                           deviceName: controller.selectedDevices.value.name,
//                           onTap: () {
//                             controller.cardTap(
//                                 controller.choices[index].type, context);
//                           },
//                         ),
//                       );
//                     })),
//                 SizedBox(
//                   height: getHeight(27),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: getWidth(25), vertical: getHeight(20)),
//                   decoration: BoxDecoration(
//                     color: ColorConstant.primaryBlue,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           CustomImageView(
//                             svgPath: ImageConstant.info,
//                           ),
//                           SizedBox(
//                             width: getWidth(8),
//                           ),
//                           Text(
//                             AppString.newDataBeen,
//                             style: CTC.style(16,
//                                 fontWeight: FontWeight.w600,
//                                 fontColor: ColorConstant.primaryWhite),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: getHeight(8),
//                       ),
//                       AppElevatedButton(
//                         showTextIcon: true,
//                         svgPath: ImageConstant.sync,
//                         buttonName: AppString.syncData,
//                         onPressed: () {
//                           controller.syncData(context);
//                         },
//                       ),
//                       SizedBox(
//                         height: getHeight(10),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: getHeight(33),
//                 ),
//                 InkWell(
//                   onTap: () async {
//                   },
//                   child: Text(
//                     '${AppString.dataLast}: 10:15AM 01/12/2022',
//                     style: CTC.style(
//                       16,
//                       fontWeight: FontWeight.w600,
//                       fontColor: ColorConstant.textBlackToWhite(context),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: getHeight(33),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:cotec/core/utils/app_prefs_key.dart';
import 'package:cotec/core/utils/hive_helper.dart';
import 'package:cotec/presentation/active_test_screen/controller/active_test_screen_controller.dart';
import 'package:cotec/presentation/home_screen/widget/home_card_widget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../MainPage.dart';
import '../../core/app_export.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    ActiveTestScreenController controller =
        Get.put(ActiveTestScreenController());
    controller.isActiveScreen.value = false;
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
              child: Column(
                children: [
                  SizedBox(
                    height: getHeight(20),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(45), vertical: getWidth(20)),
                    child: InkWell(
                      onTap: () {
                        Get.to(MainPage());
                      },
                      child: CustomImageView(
                        imagePath: ImageConstant.appLogo,
                      ),
                    ),
                  ),
                  GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.6 / 2.8,
                      crossAxisSpacing: getWidth(15),
                      mainAxisSpacing: getHeight(5),
                      children:
                          List.generate(controller.choices.length, (index) {
                        return Obx(
                          () => HomeMenuCard(
                            search: index == 4
                                ? controller.searchOnBluetooth.value
                                : false,
                            homeMenu: controller.choices[index],
                            connected: index == 4
                                ? controller.connectedDevice.value.isNotEmpty
                                : false,
                            deviceName: controller.connectedDevice.value,
                            onTap: () {
                              controller.cardTap(
                                  controller.choices[index].type, context);
                            },
                          ),
                        );
                      })),
                  SizedBox(
                    height: getHeight(20),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //
                  //           decoration: const InputDecoration(
                  //             labelText: 'Enter command',
                  //             border: OutlineInputBorder(),
                  //             hintText: 'Try "AT" or device-specific command',
                  //           ),
                  //           onSubmitted: (v) {
                  //             controller.sendMessage(v);
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       IconButton(
                  //         icon: const Icon(Icons.send),
                  //         onPressed: () {
                  //           // controller.sendCommand(v);
                  //
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'V ${snapshot.data?.version}',
                                style: CTC.style(
                                  15,
                                  fontWeight: FontWeight.w600,
                                  fontColor:
                                      ColorConstant.textBlackToWhite(context),
                                ),
                              ),
                            ],
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: DbHelper.getData().listenable(),
                    builder: (context, Box<CreateLog> box, _) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.loadList(box);
                      });
                      return SizedBox.shrink();
                    },
                  )
                  // SizedBox(
                  //   height: getHeight(30),
                  // ),
                  // AppElevatedButton(
                  //   buttonName: 'show',
                  //   onPressed: () {
                  //     controller.getChat();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: getHeight(10),
                  // ),
                  // TextFormField(
                  //   controller: controller.testController,
                  // ),
                  // SizedBox(
                  //   height: getHeight(10),
                  // ),
                  // AppElevatedButton(
                  //   buttonName: 'send',
                  //   onPressed: () {
                  //     controller.sendMessage(controller.testController.text);
                  //     controller.testController.clear();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: getHeight(10),
                  // ),
                  // AppElevatedButton(
                  //   buttonName: 'sesdfsdfnd',
                  //   onPressed: () {
                  //     controller.ok();
                  //   },
                  // ),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: Text(
                  //     'v.1.0.0',
                  //     style: CTC.style(
                  //       16,
                  //       fontWeight: FontWeight.w500,
                  //       fontColor: ColorConstant.textBlackToWhite(context),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: getHeight(33),
                  // ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            CommonConstant.instance.dbHelper.box.get(HiveKey.isShowLogs) == true
                ? FloatingActionButtonLocation.centerFloat
                : null,
        floatingActionButton:
            CommonConstant.instance.dbHelper.box.get(HiveKey.isShowLogs) == true
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      bottomSheet(controller);
                    },
                    label: Center(
                        child: Text(
                      'Show logs',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                  )
                : null);
  }

  bottomSheet(ActiveTestScreenController controller) {
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
                      // controller: controller.listScrollController,
                      itemCount: controller.messagesListConsoleHome.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.messagesListConsoleHome[index].text
                                  .trim(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                            Obx(
                              () => Divider(
                                color: index ==
                                        controller.messagesListConsoleHome
                                                .length -
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
}
