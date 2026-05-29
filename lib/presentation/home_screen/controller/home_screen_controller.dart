import 'dart:async';
import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cotec/core/utils/progress_dialog_utils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../ApiServices/common_model/create_log_model.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/app_prefs_key.dart';
import '../../../core/utils/hive_helper.dart';

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}
/// common var

class HomeScreenController extends GetxController {
  /*Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;

  RxList<BluetoothDiscoveryResult> results =
      RxList<BluetoothDiscoveryResult>.empty(growable: true);
  RxList<BluetoothDiscoveryResult> checkResults =
      RxList<BluetoothDiscoveryResult>.empty(growable: true);

  StreamSubscription<BluetoothDiscoveryResult>? streamSubscription;

  Rx<BluetoothDevice> selectedDevices = BluetoothDevice(address: "").obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController licenceKeyController = TextEditingController();

  List<_Message> messages = List<_Message>.empty(growable: true);
  RxBool isDiscovering = false.obs;
  RxBool isLicenseKeyLoading = true.obs;
  RxBool searchOnBluetooth = false.obs;
  RxString isLicenseKey = '1234'.obs;

  RxInt selectedDevice = 0.obs;
  RxString connectedDevice = ''.obs;
  RxString address = ''.obs;
  RxList<CreateLog> storeDataList = <CreateLog>[].obs;



  void deviceSelect(int index) {
    selectedDevice.value = index;
  }


  Future<void> checkDiscovery() async {

    bool result = await connectPermission();

    if (result) {
      streamSubscription?.cancel();
      checkResults.clear();
      searchOnBluetooth.value = true;
      print('SRART SEARCHING =======================');
      streamSubscription =
          FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        final existingIndex = checkResults.indexWhere(
            (element) => element.device.address == r.device.address);

        final existingIndex1 = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex1 >= 0)
          results[existingIndex1] = r;
        else
          results.add(r);
        results.refresh();
        if (existingIndex >= 0) {
          checkResults[existingIndex] = r;
        } else {
          checkResults.add(r);
          checkResults.forEach((element) {
            print(
                'DEVICE ADDRESS   ${element.device.address} BLUETOOTH NAME = ${element.device.name}  isBonded ${element.device.isBonded}');

            if (element.device.isBonded == true) {
              // address.value = element.device.address;
              // connectedDevice.value = element.device.name ?? '';
              // selectedDevices.value = element.device;

              // FlutterBluetoothSerial.instance
              //     .removeDeviceBondWithAddress(element.device.address);
              // address.value = '';
              // connectedDevice.value = '';
              searchOnBluetooth.value = false;
              print('CONNECTED BLUETOOTH ADDRESS   ${address.value}');
              print('CONNECTED BLUETOOTH NAME   ${element.device.name}');
              FlutterBluetoothSerial.instance.cancelDiscovery();
            }
          });
          checkResults.refresh();
        }
      });

      streamSubscription!.onDone(() {
        searchOnBluetooth.value = false;

        print('END SEARCHING =======================');

        isDiscovering.value = false;
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    getStoreData();
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState.value = state;
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        print('addressaddress ${address}');
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      print('addressaddress ${name}');
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState.value = state;

      // Discoverable mode is disabled when Bluetooth gets disabled
      // _discoverableTimeoutTimer = null;
      // _discoverableTimeoutSecondsLeft = 0;
;      if(bluetoothState.value==BluetoothState.STATE_OFF ){
        connections?.close();
        connections?.dispose();
        selectedDevices.value = BluetoothDevice(address: "");
        connectedDevice.value = '';
      }
    print('BLUETOOTH DISCONECT == ${state} ');
    print('BLUETOOTH DISCONECT == ');
    print('======================= ${bluetoothState.value.isEnabled}');
    });
    // scanDevice();
  }

  // scanDevice() async {
  //   if (bluetoothState.value.isEnabled) {
  //     checkDiscovery();
  //   } else {
  //     bool result = await connectPermission();
  //     if (result) {
  //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //         await FlutterBluetoothSerial.instance
  //             .requestEnable()
  //             .then((value) async {
  //           if (value == true) {
  //             isDiscovering.value = true;
  //             checkDiscovery();
  //           }
  //           print("HK ${value}");
  //         });
  //       });
  //     }
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription?.cancel();
  }

  RxBool isDisconnecting = false.obs;
  BluetoothConnection? connection;
  bool get isConnected => (connection?.isConnected ?? false);
  static final clientID = 0;

  List<HomeMenu> choices = <HomeMenu>[
    HomeMenu(
        type: 'logTest',
        title: AppString.logTest,
        image: ImageConstant.logTest),
    HomeMenu(
        type: 'measureVolts',
        title: AppString.measureVolts,
        image: ImageConstant.logTest),
    HomeMenu(
        type: 'logs', title: AppString.logsView, image: ImageConstant.logs),
    HomeMenu(
        type: 'userManual',
        title: AppString.userManual,
        image: ImageConstant.userManual),
    HomeMenu(
        type: 'scanForDevices',
        title: AppString.scanForDevices,
        image: ImageConstant.bluetooth),
    HomeMenu(
        type: 'setting',
        title: AppString.setting,
        image: ImageConstant.setting),
  ];

  Future<void> cardTap(String type, BuildContext context) async {
    switch (type) {
      case 'logTest':
        if ((connectedDevice.value == '' || connectedDevice.value.isEmpty) &&
            !bluetoothState.value.isEnabled) {
          warningDialog(context);
          selectedDevices.value = BluetoothDevice(address: "");
          connectedDevice.value = "";
        } else {
          getStoreData();

          getChat();
        } // do something
        break;
      case 'measureVolts':
        // final temp =
        //     await BluetoothConnection.toAddress(selectedDevices.value.address);
        // print('DEVICE IS CONNECT = ${temp.isConnected}');
        if (bluetoothState.value.isEnabled) {
          if (connectedDevice.value == '' || connectedDevice.value.isEmpty) {
            warningDialog(context);
          } else {
            Get.toNamed(AppRoutes.activeTestScreenRoute, arguments: [
              {
                'server': selectedDevices.value,
                'test_type': '',
                'name': '',
                'pts_number': '',
                'company_name': '',
                'depot': '',
                'form_b': '',
                'form_c': '',
                'location': '',
                'screen': '0',
                'connectedDevice': connectedDevice.value,
                'locationGPS': '',
              }
            ])?.then((value) {
              // if (bluetoothState.value.isEnabled) {
              //   checkDiscovery();
              // } else {
              //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              //     await FlutterBluetoothSerial.instance
              //         .requestEnable()
              //         .then((value) {
              //       print("BLUETOOTH IS CONNECT VALUE ${value}");
              //       if (value == true) {
              //         checkDiscovery();
              //       }
              //     });
              //   });
              // }
            });
          }
        } else {
          warningDialog(context);
          selectedDevices.value = BluetoothDevice(address: "");
          connectedDevice.value = "";
        }
        break;
      case 'logs':
        Get.toNamed(AppRoutes.logListScreenRoute);
        //     ?.then((value) {
        //   if (bluetoothState.value.isEnabled) {
        //     checkDiscovery();
        //   } else {
        //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        //       await FlutterBluetoothSerial.instance
        //           .requestEnable()
        //           .then((value) {
        //         print("BLUETOOTH IS CONNECT VALUE ${value}");
        //         if (value == true) {
        //           checkDiscovery();
        //         }
        //       });
        //     });
        //   }
        // });

        // do something else
        break;
      case 'userManual':
        // do something else
        break;
      case 'scanForDevices':
        if (connectedDevice.isNotEmpty || connectedDevice.value!= "") {
          // results[results.indexOf(result)] =
          //     BluetoothDiscoveryResult(
          //         device: BluetoothDevice(
          //           name: device.name ?? '',
          //           address: addresses,
          //           type: device.type,
          //           bondState: bonded
          //               ? BluetoothBondState.bonded
          //               : BluetoothBondState.none,
          //         ),
          //         rssi: result.rssi);
          results.refresh();

          connections?.close();
          connections?.dispose();
          selectedDevices.value = BluetoothDevice(address: "");
          connectedDevice.value = '';
        } else {
          bool result = await connectPermission();
          // bool result1 = await connectBPermission();
          print('00000000000000000000000000000000000 ${result} }');
          if (result) {
            print('address.value.isEmpty ${address.value.isEmpty}');
            // if (address.value.isEmpty) {
            if (!bluetoothState.value.isEnabled) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await FlutterBluetoothSerial.instance
                    .requestEnable()
                    .then((value) async {
                  if (value == true) {
                    isDiscovering.value = true;
                    checkDiscovery();

                    await deviceDialog(context);
                  }
                  print("HK ${value}");
                });
              });
            } else {
              isDiscovering.value = true;
              if (isDiscovering.value) {
                checkDiscovery();
              }
              await deviceDialog(context);
            }
            // } else {
            //   checkDiscovery();
            // }
          }
        }
        break;
      case 'setting':
        passwordController.clear();
        enterPinDialog(context);
        // do something else
        break;
    }
  }

  Future<bool> connectPermission() async {
    var status = await Permission.bluetoothScan.status;
    var status1 = await Permission.bluetoothConnect.status;
    if (status.isDenied || status1.isDenied) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
      // Permission.bluetoothScan.request();
      return false;
    } else if (status.isPermanentlyDenied ||
        status.isRestricted ||
        status1.isPermanentlyDenied ||
        status1.isRestricted) {
      return false;
    } else if (status.isGranted && status1.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> connectBPermission() async {
    var status = await Permission.bluetoothConnect.status;
    if (status.isDenied) {
      Permission.bluetoothConnect.request();
      return false;
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      return false;
    } else if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void syncData(BuildContext context) {
    reachingLogsLimit(context);
  }

  void warningDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.warning_rounded,
                color: ColorConstant.redFF2,
                size: getHeight(70),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.warning,
                textAlign: TextAlign.center,
                style: CTC.style(26,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(15),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: () {
          if (connection?.isConnected == true) {
            isDisconnecting.value = true;
            connection?.close();
            connection?.dispose();
            print('DISPOSE++++++==== IS BACK');
          }
          Get.back();
        },
        secondButtonTitle: AppString.learn,
        secondOnPressed: () {
          if (connection?.isConnected == true) {
            isDisconnecting.value = true;
            connection?.close();
            connection?.dispose();
            print('DISPOSE++++++==== IS BACK');
          }
          Get.back();
        },
        context: context);
  }

  void checkWarningDialog(BuildContext context, String text) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.warning_rounded,
                color: ColorConstant.redFF2,
                size: getHeight(70),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(15),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: () {
          Get.back();
        },
        context: context);
  }

  Future deviceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SimpleDialog(
          backgroundColor: ColorConstant.containerBackGround(context),
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: getWidth(20)),
          contentPadding: EdgeInsets.symmetric(
              horizontal: getWidth(25), vertical: getHeight(30)),
          children: [
            Text(
              AppString.deviceList,
              style: CTC.style(26,
                  fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.textBlackToYellow(context)),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            SizedBox(
              height: constraints.maxHeight * .18, // 70% height
              width: constraints.maxWidth * .9,
              child: Obx(
                () => isDiscovering.value
                    ? Center(
                        child: SizedBox(
                            height: getHeight(20),
                            width: getWidth(20),
                            child: CircularProgressIndicator()))
                    : ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: ((context, index) {
                          BluetoothDiscoveryResult result = results[index];
                          final device = result.device;
                          final addresses = device.address;

                          return Obx(
                            () => Bounce(
                              onTap: () async {
                                deviceSelect(index);
                                try {
                                  bool bonded = false;
                                  print('0000000000000000000000 ${device.isBonded}');
                                  print('0000000000000000000000 ${device.address}');
                                  if (device.isBonded) {

                                    await BluetoothConnection.toAddress(
                                            device.address)
                                        .then((value) {
                                      connections = value;
                                      connectedDevice.value =
                                      device.name != null &&
                                          device.name!.isNotEmpty
                                          ? device.name ?? ''
                                          : device.address ?? '';
                                      selectedDevices.value = result.device;
                                      print(
                                          'BLUETOOTH START = ${connections?.isConnected}');
                                      Navigator.of(context).pop();
                                    }).catchError((e){
                                      print(
                                          'Error BLUETOOTH OFF  = ${e.toString()}');

                                    });

                                    // Navigator.of(context).pop();
                                    // print(
                                    //     'Unbonding from ${device.address}...');
                                    // var res = await FlutterBluetoothSerial
                                    //     .instance
                                    //     .removeDeviceBondWithAddress(addresses);
                                    // print(
                                    //     'Unbonding from ${device.address} has succed');
                                    // print('Unbonding from ${res} has succed');
                                    // selectedDevices.value = result.device;
                                    // connectedDevice.value = '';
                                  } else {
                                    FlutterBluetoothSerial.instance
                                        .setPairingRequestHandler(
                                            (BluetoothPairingRequest request) {
                                      print(
                                          "Trying to auto-pair with Pin 1234");
                                      if (request.pairingVariant ==
                                          PairingVariant.Pin) {
                                        return Future.value("1234");
                                      }
                                      return Future.value(null);
                                    });

                                    print('Bonding with ${device.address}...');
                                    bonded = (await FlutterBluetoothSerial
                                        .instance
                                        .bondDeviceAtAddress(addresses))!;

                                    print(
                                        'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                                    // Navigator.of(context).pop();
                                    results[results.indexOf(result)] =
                                        BluetoothDiscoveryResult(
                                            device: BluetoothDevice(
                                              name: device.name ?? '',
                                              address: addresses,
                                              type: device.type,
                                              bondState: bonded
                                                  ? BluetoothBondState.bonded
                                                  : BluetoothBondState.none,
                                            ),
                                            rssi: result.rssi);
                                    results.refresh();

                                    await BluetoothConnection.toAddress(
                                            device.address)
                                        .then((value) {
                                      connections = value;
                                      if (bonded == true) {
                                        connectedDevice.value =
                                        device.name != null &&
                                            device.name!.isNotEmpty
                                            ? device.name ?? ''
                                            : device.address ?? '';
                                        selectedDevices.value = result.device;
                                      }
                                      print(
                                          'BLUETOOTH START = ${connections?.isConnected}');
                                      Navigator.of(context).pop();
                                    }).catchError((e){
                                      print(
                                          'Error BLUETOOTH OFF  = ${e.toString()}');

                                    });
                                  }

                                  // checkDiscovery();

                                  print(selectedDevices.value.isConnected);
                                  print(selectedDevices.value.isBonded);
                                } catch (ex) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Error occured while bonding'),
                                        content: Text("${ex.toString()}"),
                                        actions: <Widget>[
                                          new TextButton(
                                            child: new Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                // deviceSelect(index);
                                // connectedDevice.value = deviceList[index];
                                // licenseKeyDialog(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: getHeight(5)),
                                decoration: BoxDecoration(
                                    color: selectedDevice.value == index
                                        ? ColorConstant.backGroundGreyColor
                                        : ColorConstant.transparent,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getWidth(20),
                                    vertical: getHeight(7)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        device.name != null &&
                                                device.name!.isNotEmpty
                                            ? device.name ?? ''
                                            : device.address ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: CTC.style(21,
                                            fontWeight: FontWeight.w500,
                                            fontColor: selectedDevice.value ==
                                                    index
                                                ? ColorConstant.textBlack
                                                : ColorConstant
                                                    .textBlackToWhite(context)),
                                      ),
                                    ),
                                    // if (device.isBonded)
                                    //   Expanded(
                                    //     child: Text(
                                    //       'Disconnected',
                                    //       overflow: TextOverflow.ellipsis,
                                    //       maxLines: 1,
                                    //       style: CTC.style(16,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontColor:
                                    //               selectedDevice.value == index
                                    //                   ? ColorConstant.textBlack
                                    //                   : ColorConstant
                                    //                       .textBlackToWhite(
                                    //                           context)),
                                    //     ),
                                    //   ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            AppElevatedButton(
                buttonName: AppString.cancel,
                onPressed: () {
                  FlutterBluetoothSerial.instance.cancelDiscovery();
                  Get.back();
                }),
            SizedBox(
              height: getHeight(10),
            ),
          ],
        ),
      ),
    );
  }

  void licenseKeyDialog(BuildContext context) {
    licenceKeyController.clear();
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.confirmLicenseKey,
                style: CTC.style(26,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.enterLicenseKey,
                textAlign: TextAlign.center,
                style: CTC.style(16,
                    fontColor: ColorConstant.textGrey4c4cToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
            Text(
              AppString.licenseKey,
              style: CTC.style(16,
                  fontColor: ColorConstant.text00ToWhite(context),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: getHeight(8),
            ),
            CustomAppTextFormField(
              fillColor: ColorConstant.greyF5,
              hintText: AppString.enterHere,
              controller: licenceKeyController,
              borderRadius: BorderRadius.circular(18),
              hintFontStyle: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.grey9DA),
            ),
            SizedBox(
              height: getHeight(15),
            ),
          ],
        ),
        firstButtonTitle: AppString.confirm,
        firstOnPressed: () {
          verifyLicense();
        },
        secondButtonTitle: AppString.cancel,
        secondOnPressed: () {
          Get.back();
        },
        context: context);
  }

  void verifyLicense() {
    if (licenceKeyController.text.trim().isEmpty) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.enterLicenseKeys,
          color: ColorConstant.textRedFF);
    }
    // else if (licenceKeyController.text == isLicenseKey.value) {
    //   // CommonConstant.instance.dbHelper.box.put(HiveKey.licenseKey, true);
    //   Get.back();
    //   licenseSet();
    //   Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
    //     'server': selectedDevices.value,
    //     'connectedDevice': connectedDevice.value
    //   });
    // }
    else {
      Get.back();
      sendMessage('q${licenceKeyController.text}');
      // ProgressDialogUtils.showTitleSnackBar(
      //     headerText: AppString.enterLicenseKeysValid,
      //     color: ColorConstant.textRedFF);
    }
  }

  void getStoreData() {
    Box<CreateLog> itemBox = DbHelper.getData();
    storeDataList.clear();
    itemBox.values.forEach((element) {
      storeDataList.add(element);
    });
  }

  void enterPinDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.enterPin,
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
                AppString.enterPinSettingText,
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
              controller: passwordController,
              textInputType: TextInputType.number,
              borderColor: ColorConstant.greyD3,
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
          passwordCheck();
        },
        context: context);
  }

  void passwordCheck() {
    String? password =
        CommonConstant.instance.dbHelper.box.get(HiveKey.settingPassword);
    if (passwordController.text.isEmpty) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.enterPassword, color: ColorConstant.textRedFF);
    } else if (passwordController.text == password ||
        passwordController.text == '9112232') {
      Get.back();
      Get.toNamed(AppRoutes.settingScreenRoute);
    } else {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.passwordInvalid,
          color: ColorConstant.textRedFF);
    }
  }

  void reachingLogsLimit(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.reachingLogsLimit,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.text00ToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.reachingLogsLimitDes,
                textAlign: TextAlign.center,
                style: CTC.style(16,
                    fontColor: ColorConstant.textGrey4c4cToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: () {
          if (connection?.isConnected == true) {
            isDisconnecting.value = true;
            connection?.close();
            connection?.dispose();

            print('DISPOSE++++++====');
          }
          Get.back();
          Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
            'server': selectedDevices.value,
            'connectedDevice': connectedDevice.value
          });
        },
        context: context);
  }

  void logsLimitReached(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.reachingLogsLimitReached,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.text00ToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.reachingLogsLimitReachedDes,
                textAlign: TextAlign.center,
                style: CTC.style(16,
                    fontColor: ColorConstant.textGrey4c4cToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: () {
          String? types =
              CommonConstant.instance.dbHelper.box.get(HiveKey.storeType);
          print('OWERRIDE =================================================');

          if (types != null && types == 'overwrite') {
            print('CANCELLS =================================================');

            if (connection?.isConnected == true) {
              isDisconnecting.value = true;
              connection?.close();

              connection?.dispose();

              print('DISPOSE++++++====');
            }
            Get.back();
            Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
              'server': selectedDevices.value,
              'connectedDevice': connectedDevice.value
            });
          } else {
            print(
                'CANCELLS++++++++++++++ =================================================');

            if (connection?.isConnected == true) {
              isDisconnecting.value = true;
              connection?.close();

              connection?.dispose();

              print('DISPOSE++++++====');
            }
            Get.back();
          }
        },
        context: context);
  }

  @override
  void onClose() {
    if (connection?.isConnected == true) {
      isDisconnecting.value = true;
      connection?.close();

      connection?.dispose();

      print('DISPOSE++++++====');
    }
    super.onClose();
  }

  getChat() {
    if (connection?.isConnected == true) {
      connection?.close();

      connection?.dispose();
    }

    print('DISPOSE++++++====');

    ProgressDialogUtils.showProgressDialogSmall(isCancellable: false);
    BluetoothConnection.toAddress(selectedDevices.value.address)
        .then((_connection) {
      connection = _connection;

      isDisconnecting.value = false;

      if (_connection.isConnected == true) {
        sendMessage('0i');
        sendMessage('1i');
        Future.delayed(Duration(milliseconds: 1000), () {
          print(
              'DISPOSE++++++============================================================');

          sendMessage('j');
        });
        // messages.clear();
        // _sendMessage('f');
      }
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting.value) {
          ProgressDialogUtils.hideProgressDialog();

          print('------Disconnecting locally!');
        } else {
          // warningDialog(Get.overlayContext as BuildContext);
          ProgressDialogUtils.hideProgressDialog();
          print('++++++Disconnected remotely!');
        }
        // if (this.mounted) {
        //   setState(() {});
        // }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
      ProgressDialogUtils.hideProgressDialog();

      warningDialog(Get.overlayContext as BuildContext);
    });
  }

  String _messageBuffer = '';
  List<String> messageList = [];

  void _onDataReceived(Uint8List data) {

    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    String newMessage = String.fromCharCodes(buffer);

    int index = buffer.indexOf(13);
    bool isExpireOrNot = false;

    try {
      String testMessage = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + newMessage.substring(0, index);

      print(' GET MESSAGES =========  ${testMessage}');

      /////////////////////////////////////////
      if (testMessage.trim().contains('S') || newMessage.trim().contains('S')) {
        print(' GET MESSAGES STATUS =========  ${testMessage}');
      }
      if (testMessage.trim().contains('J') && testMessage.trim().length == 7) {
        print(
            'MESSAGE LENGTH :- ${testMessage.trim().length}  +++  ${testMessage}');
        String expireDate = testMessage.replaceAll('J', '');
        DateFormat dateFormat = DateFormat("ddMMyy");
        String todayDate = dateFormat.format(DateTime.now());
        print('expireDate VALID == ${expireDate}');
        print('todayDate VALID == ${todayDate}');

        isExpireOrNot = expireDate == todayDate;
      }
      if (testMessage.trim().contains('J')) {
        ProgressDialogUtils.hideProgressDialog();

        if (isExpireOrNot == true) {
          print('isExpireOrNot LICENSE == ${newMessage}');
          ProgressDialogUtils.hideProgressDialog();

          checkWarningDialog(Get.overlayContext as BuildContext,
              AppString.enterLicenseKeysValid);
        } else if (testMessage == 'J0') {
          print('J0 LICENSE == ${testMessage}');
          ProgressDialogUtils.hideProgressDialog();

          licenseKeyDialog(Get.overlayContext as BuildContext);
        } else if (testMessage.toString().trim() == 'J1') {
          print('J1 LICENSE == ${newMessage}');
          ProgressDialogUtils.hideProgressDialog();

          checkWarningDialog(Get.overlayContext as BuildContext,
              AppString.enterLicenseKeysValid);
        } else {
          ProgressDialogUtils.hideProgressDialog();
          print('REACHINGLOGLIMIT ${storeDataList.length}');

          if (storeDataList.length > 5 && storeDataList.length < 9) {
            reachingLogsLimit(Get.overlayContext as BuildContext);
            print('REACHINGLOGLIMIT LLLLLLLLLLLLLLLLLLL');
          } else {
            if (storeDataList.length == 10) {
              print('LOGLIMITRICHED MMMMMMMMMMMMMMMMMM');

              logsLimitReached(Get.overlayContext as BuildContext);
            } else {
              if (connection?.isConnected == true) {
                print(
                    '=========testMessagetestMessagetestMessagetestMessagetestMessagetestMessagetestMessagetestMessagetestMessagetestMessagetestMessage  ${testMessage}');
                connection?.close();
                connection?.dispose();
              }
              print('DISPOSE++++++====');

              Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
                'server': selectedDevices.value,
                'connectedDevice': connectedDevice.value
              });
                //   ?.then((value) {
                // if (bluetoothState.value.isEnabled) {
                //   checkDiscovery();
                // } else {
                //   WidgetsBinding.instance
                //       .addPostFrameCallback((timeStamp) async {
                //     await FlutterBluetoothSerial.instance
                //         .requestEnable()
                //         .then((value) {
                //       print("BLUETOOTH IS CONNECT VALUE ${value}");
                //       if (value == true) {
                //         checkDiscovery();
                //       }
                //     });
                //   });
              //   }
              // });
            }
          }
        }
      }
      ///////////////////////////////////////////////////////////////////////
    } catch (e) {
      // print('ERROR: = ${e.toString()}');
    }

    // else {
    //   if (storeDataList.length > 5 && storeDataList.length < 9) {
    //     reachingLogsLimit(Get.overlayContext as BuildContext);
    //   } else {
    //     if (storeDataList.length == 10) {
    //       logsLimitReached(Get.overlayContext as BuildContext);
    //     } else {
    //       Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
    //         'server': selectedDevices.value,
    //         'connectedDevice': connectedDevice.value
    //       });
    //     }
    //   }
    // }
  }

  TextEditingController testController = TextEditingController();
  void sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        messages.add(_Message(clientID, text));

        print('TEXT SEND = $text');
        // setState(() {
        // });
      } catch (e) {
        // Ignore error, but notify state
        // setState(() {});
      }
    }
  }*/
}


