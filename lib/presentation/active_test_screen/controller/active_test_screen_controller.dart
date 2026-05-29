import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cotec/core/assets_audio_player_compat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as b;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cotec/ApiServices/api_service.dart';
import 'package:cotec/core/constants/constants.dart';
import 'package:cotec/vaibretion_helper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../ApiServices/common_model/create_log_model.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/app_prefs_key.dart';
import '../../../core/utils/hive_helper.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../active_test_screen.dart';

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

enum TtsState { playing, stopped, paused, continued }

class ActiveTestScreenController extends GetxController {
  //////
  RxList<b.BluetoothDevice> _devices = <b.BluetoothDevice>[].obs;
  b.BluetoothDevice? _connectedDevice;
  b.BluetoothDevice? devices;
  List<String> _logs = [];
  bool _isScanning = false;
  // final TextEditingController _commandController = TextEditingController();
  Rx<b.BluetoothCharacteristic>? _txCharacteristic;
  Rx<b.BluetoothCharacteristic>? _rxCharacteristic;

  // Replace these with your device's actual UUIDs
  static const String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
  RxString TX_CHARACTERISTIC_UUID = "ffe1".obs;
  RxString RX_CHARACTERISTIC_UUID = "ffe1".obs;
  //////

  /// messageList console
  RxList<_Message> messagesListConsole =
      List<_Message>.empty(growable: true).obs;
  RxList<_Message> messagesListConsoleHome =
      List<_Message>.empty(growable: true).obs;
  final ScrollController listScrollController = new ScrollController();

  ///
  Rx<VoltMeterData> voltMeterData = VoltMeterData().obs;
  RxBool hasVoiceActive = false.obs;
  RxBool isLogTestScreen = false.obs;
  RxBool hasMeterView = true.obs;
  RxBool hasWarningDetect = true.obs;
  RxBool hasWarningDetectTextShow = false.obs;
  RxBool hasInductionWarningTextShow = false.obs;
  RxBool hasPlay = true.obs;
  RxBool isLicenced = false.obs;
  RxString isLicencedDate = ''.obs;
  RxBool hasBeepSound = false.obs;
  RxBool hasCenterAnimation = false.obs;
  RxBool hasPointerAnimation = true.obs;

  startAnimation() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => hasCenterAnimation.value = true);

    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        stopAnimation();
      },
    );
  }

  stopAnimation() {
    if (hasCenterAnimation.value) {
      print("STOPPED");
      hasCenterAnimation.value = false;
    }
  }

  List<double> voltageLastAndPrevList = [
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  RxBool hasPrevVoltage = false.obs;

  RxString lastAnimatedGauge = '300'.obs;

  var arguments = Get.arguments;
  late FlutterTts flutterTts;
  double volume = 1.0;
  double pitch = 0.0;
  double rate = 0.0;
  Rx<TtsState> ttsState = TtsState.stopped.obs;

  RxBool isConnecting = false.obs;
  RxBool hasNextVoice = true.obs;
  RxBool disconnectButton = false.obs;
  RxBool isBack = false.obs;
  RxBool isDisconnecting = false.obs;
  // BluetoothConnection? connection;
  bool get isConnected => (connections?.isConnected ?? false);
  // List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  List<String> messageList = [];

  RxString lowVoltage = ''.obs;
  RxString firmwareVersion = ''.obs;

  RxBool startMeter = false.obs;
  RxBool linkColor = false.obs;

  RxBool ringColor = false.obs;
  RxDouble ringValue = 0.0.obs;
  RxString ringValueString = ''.obs;

  Rx<Color> meterColor = ColorConstant.primaryGreen.obs;

  RxBool energisedIconColor = false.obs;
  RxBool inductionsIconColor = false.obs;
  RxBool isProtection = true.obs;

  RxBool isCapture = true.obs;
  RxBool gpsColor = false.obs;
  RxBool hasLocation = false.obs;
  RxBool hasPermission = false.obs;

  RxBool hasReconnect = true.obs;

  ///calibration and battery
  RxBool isCalibration = true.obs;
  RxBool isBattery = true.obs;
  RxBool isBatteryLoading = true.obs;
  RxBool sValue = true.obs;
  // late Stopwatch stopwatch;
  Timer? speak;
  Timer? t;
  Timer? t2;
  Timer? r;
  Timer? tg;
  Timer? tw;
  Timer? ts;
  Timer? disconnectTimer;
  Timer? disconnectAudioTimer;
  Timer? beepTimer;
  Timer? setDataTimer;

  static final clientID = 0;

  /// Test form data
  RxString testType = ''.obs;
  RxString name = ''.obs;
  RxString ptsNumber = ''.obs;
  RxString companyName = ''.obs;
  RxString depot = ''.obs;
  RxString formBNumber = ''.obs;
  RxString formCNumber = ''.obs;
  RxString location = ''.obs;
  RxString locationGPS = ''.obs;
  RxString screen = '0'.obs;
  RxString connectedDeviceSend = ''.obs;

  DateTime voltsDetectedDateTime = DateTime.now();
  DateTime startUpDateTime = DateTime.now();

  RxString voltsDetected = ''.obs;
  RxString startUp = ''.obs;
  RxString duration = ''.obs;

  RxBool isActiveScreen = false.obs;
  @override
  void onInit() {
    bluetoothCheckConnect();
    flutterTts = FlutterTts();
    // stopwatch = Stopwatch();

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState.value = TtsState.playing;
    });
    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState.value = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState.value = TtsState.stopped;
    });
    Future.delayed(
      Duration(milliseconds: 2000),
      () {
        startMeter.value = true;
      },
    );
    // bluetoothStart();

    if (arguments != null) {
      testType.value = arguments[0]['test_type'];
      name.value = arguments[0]['name'];
      ptsNumber.value = arguments[0]['pts_number'];
      companyName.value = arguments[0]['company_name'];
      depot.value = arguments[0]['depot'];
      formBNumber.value = arguments[0]['form_b'];
      formCNumber.value = arguments[0]['form_c'];
      location.value = arguments[0]['location'];
      screen.value = arguments[0]['screen'];
      connectedDeviceSend.value = arguments[0]['connectedDevice'];
      locationGPS.value = arguments[0]['locationGPS'];
      print('screen.value screen.value ${screen.value}');
    }
    initPagination();
    //////
    _requestPermissions();
    _setupBluetoothListeners();
    //////
    super.onInit();
  }

  //////
  Future<void> _requestPermissions() async {
    // Request all necessary permissions
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();
  }

  void _setupBluetoothListeners() {
    // Listen for scan results
    b.FlutterBluePlus.scanResults.listen((results) {
      _devices.value = results
           .where((r) => r.device.name.isNotEmpty)
          .map((r) => r.device)
          .toList();

      // Remove duplicates by device id
      _devices.value = _devices.fold([], (list, device) {
        if (!list.any((d) => d.id == device.id)) {
          if(device.name.isNotEmpty){
          list.add(device);}
        }
        return list;
      });
    });

    // Listen for connection state changes
    b.FlutterBluePlus.scanResults.listen((event) {
      if (event.contains(b.BluetoothConnectionState.connected)) {
        // log('Connection state changed: ${event}');
        if (event.contains(b.BluetoothConnectionState.disconnected)) {
          _cleanupAfterDisconnection();
        }
      }
    });
  }

  void _cleanupAfterDisconnection() {
    _connectedDevice = null;
    _txCharacteristic = null;
    _rxCharacteristic = null;
    isConnecting.value = false;
    // stopwatch.stop();
    // warningDialog(Get.overlayContext as BuildContext);
    // voltMeterData.value = VoltMeterData(
    //     endValue: 301,
    //     interval: 100,
    //     startValue: 0,
    //     value: 0,
    //     defaultValue: 0,
    //     showVoltage: '',
    //     voltage: '');
    meterColor.value = ColorConstant.primaryGreen;
    t?.cancel();
    t2?.cancel();
    r?.cancel();
    r = null;
    t = null;
    t2 = null;
    beepTimer?.cancel();
    beepTimer = null;
    isCalibration.value = true;
    isBattery.value = true;
    isBatteryLoading.value = true;

    hasInductionWarningTextShow.value = false;
    hasWarningDetectTextShow.value = false;
    isBack.value = true;
    selectedDevices.value = b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
    connectedDevice.value = '';
    firmwareVersion.value = '';
    Get.back();
  }

  //////
  bluetoothCheckConnect() {
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
      // FlutterBluetoothSerial.instance.address.then((address) {
      //   print('addressaddress ${address}');
      // });
    });

    // FlutterBluetoothSerial.instance.name.then((name) {
    //   print('addressaddress ${name}');
    // });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState.value = state;

      // Discoverable mode is disabled when Bluetooth gets disabled
      // _discoverableTimeoutTimer = null;
      // _discoverableTimeoutSecondsLeft = 0;
      ;
      if (bluetoothState.value == BluetoothState.STATE_OFF) {
        r?.cancel();
        r = null;
        connections?.close();
        connections?.dispose();
        selectedDevices.value =
            b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
        connectedDevice.value = '';
      }
      print('BLUETOOTH DISCONECT == ${state} ');
      print('BLUETOOTH DISCONECT == ');
      print('======================= ${bluetoothState.value.isEnabled}');
    });
  }

  RxBool isOnLast = true.obs;
  initPagination() {
    listScrollController.addListener(() async {
      isOnLast.value = (listScrollController.offset >=
          listScrollController.position.maxScrollExtent - 100);
      // if (listScrollController.position.pixels ==
      //     listScrollController.position.maxScrollExtent) {
      //   isOnLast.value = true;
      //   print('INSIDE ');
      // }
      // if (listScrollController.position.pixels !=
      //     listScrollController.position.maxScrollExtent) {
      //   print('OUTSIDE ');
      //
      //   isOnLast.value = false;
      // }
    });
  }

  //////
  Future<void> _startScan() async {
    isDiscovering.value = false;

    try {
      // if (!_isScanning) {
      log('Starting BLE scan...');
      await b.FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: false,
      );
      _isScanning = true;
      // }
    } catch (e) {
      log('Scan error: $e');
    }
  }

  Future<void> _stopScan() async {
    try {
      if (_isScanning) {
        log('Stopping BLE scan...');
        await b.FlutterBluePlus.stopScan();
        _isScanning = false;
      }
    } catch (e) {
      log('Stop scan error: $e');
    }
  }

  Future<void> _connectToDevice(b.BluetoothDevice device) async {
    try {
      log('Connecting to ${device.name}...');
      await device.connect(autoConnect: false, license: b.License.nonprofit);
      log('Connected to ${device.name}');

      // Listen for disconnection
      device.connectionState.listen((state) {
        log('Connection state: $state');
        if (state == b.BluetoothConnectionState.disconnected) {
          _cleanupAfterDisconnection();
        }
        if (state == b.BluetoothConnectionState.connected) {
          // syncStatus(event: 'Device Connect', device: connectedDevice.value, status: 'Active');

          _sendMessage('0i');
          _sendMessage('1i');
        }
      });

      await device.requestMtu(512);
      _connectedDevice = device;
      devices = device;
      Get.back();

      connectedDevice.value = device.name;

      log('Discovering services...');
      List<b.BluetoothService> services = await device.discoverServices();
      log('Found ${services.length} services');

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write == true &&
              characteristic.properties.notify == true) {
            selectedDeviceLoading.value = false;

            TX_CHARACTERISTIC_UUID.value = characteristic.uuid.toString();
            RX_CHARACTERISTIC_UUID.value = characteristic.uuid.toString();

            log('characteristic= ${service.characteristics}');
          }
          log('service ${service.characteristics}');
        }
      }

      bool foundTx = false;
      bool foundRx = false;

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() ==
              TX_CHARACTERISTIC_UUID.toLowerCase()) {
            // _txCharacteristic?.value = characteristic;
            _txCharacteristic = Rx<b.BluetoothCharacteristic>(characteristic);

            foundTx = true;
            log('Found TX characteristic');
          }

          if (characteristic.uuid.toString().toLowerCase() ==
              RX_CHARACTERISTIC_UUID.toLowerCase()) {
            // _rxCharacteristic?.value = characteristic;
            _rxCharacteristic = Rx<b.BluetoothCharacteristic>(characteristic);

            foundRx = true;
            log('Found RX characteristic');

            await _rxCharacteristic?.value.setNotifyValue(true);
            print('Connected to the device');
            startUpDateTime = DateTime.now();
            startUp.value = formatDate(DateTime.now());
            // connection = _connection;
            // Get.put(HomeScreenController()).connectedDevice.value = server.name;
            //
            // print('Connected to the device0++++++++++++++++++++++  ${server.name}');
            disconnectTimer?.cancel();
            disconnectTimer = null;
            disconnectAudioTimer?.cancel();
            disconnectAudioTimer = null;
            hasReconnect.value = true;
            // setState(() {
            isConnecting.value = true;
            isDisconnecting.value = false;
            // });
            // stopwatch.start();
            linkColorChange();
            // if (connections?.isConnected == true) {
            _sendMessage('0i');
            _sendMessage('1i');
            // Future.delayed(Duration(milliseconds: 800), () {
            //   _sendMessage('f');
            // });

            /// For testing status
            // checkDecimal();
            // _sendMessage('1i');
            // messages.clear();
            // _sendMessage('f');
            // }
            _rxCharacteristic!.value.onValueReceived.listen((value) {
              _onDataReceived(Uint8List.fromList(value));
              log('Received: ${String.fromCharCodes(value)}');
            }).onDone(() {
              // Example: Detect which side closed the connection
              // There should be `isDisconnecting` flag to show are we are (locally)
              // in middle of disconnecting process, should be set before calling
              // `dispose`, `finish` or `close`, which all causes to disconnect.
              // If we except the disconnection, `onDone` should be fired as result.
              // If we didn't except this (no flag set), it means closing by remote.
              if (isDisconnecting.value) {
                isConnecting.value = false;
                // stopwatch.stop();
                // warningDialog(Get.overlayContext as BuildContext);
                // voltMeterData.value = VoltMeterData(
                //     endValue: 301,
                //     interval: 100,
                //     startValue: 0,
                //     value: 0,
                //     defaultValue: 0,
                //     showVoltage: '',
                //     voltage: '');
                meterColor.value = ColorConstant.primaryGreen;
                t?.cancel();
                t2?.cancel();
                r?.cancel();
                r = null;
                t = null;
                t2 = null;
                beepTimer?.cancel();
                beepTimer = null;
                isCalibration.value = true;
                isBattery.value = true;
                isBatteryLoading.value = true;

                hasInductionWarningTextShow.value = false;
                hasWarningDetectTextShow.value = false;
                isBack.value = true;
                selectedDevices.value =
                    b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
                connectedDevice.value = '';
                firmwareVersion.value = '';

                print('++++++Disconnecting locally!');
              } else {
                isConnecting.value = false;
                isBack.value = true;

                // stopwatch.stop();
                // if (disconnectButton.value == false) {
                //   warningDialog();
                // }
                // voltMeterData.value = VoltMeterData(
                //     endValue: 301,
                //     interval: 100,
                //     startValue: 0,
                //     value: 0,
                //     defaultValue: 0,
                //     showVoltage: '',
                //     voltage: '');
                meterColor.value = ColorConstant.primaryGreen;
                if (disconnectButton.value == false) {
                  if (hasReconnect.value) {
                    onDisconnectAudioStart();
                    disconnectTimer = Timer.periodic(
                        Duration(milliseconds: 3000), (timer) async {
                      /// 3 second bluetooth start
                      ///
                      // bluetoothStart();
                      disconnectTimer?.cancel();
                      disconnectTimer = null;
                      isLicenced.value = false;
                      _connectToDevice(selectedDevicesLast.value).then((value) {
                        hasReconnect.value = false;
                        print('safddddddddddddddddddddddddddddddddd');
                        // connections = value;
                        connectedDevice.value =
                            selectedDevicesLast.value.name != null &&
                                    selectedDevicesLast.value.name!.isNotEmpty
                                ? selectedDevicesLast.value.name ?? ''
                                : 'Unknown Device';
                        selectedDevices.value = selectedDevicesLast.value;
                        bluetoothStart();
                        hasReconnect.value = false;
                        disconnectTimer?.cancel();
                        disconnectTimer = null;
                        disconnectAudioTimer?.cancel();
                        disconnectAudioTimer = null;
                      }).catchError((e) {
                        hasReconnect.value = false;
                        disconnectTimer?.cancel();
                        disconnectTimer = null;
                        disconnectAudioTimer?.cancel();
                        disconnectAudioTimer = null;
                        ProgressDialogUtils.showTitleSnackBar(
                            headerText: 'Please try again!');
                        warningDialog(
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                        );

                        print('Error BLUETOOTH OFF  = ${e.toString()}');
                      });
                    });
                  }
                }
                t?.cancel();
                t2?.cancel();
                r?.cancel();
                r = null;
                t = null;
                t2 = null;
                beepTimer?.cancel();
                beepTimer = null;
                isCalibration.value = true;
                isBattery.value = true;
                isBatteryLoading.value = true;
                hasInductionWarningTextShow.value = false;
                hasWarningDetectTextShow.value = false;
                selectedDevices.value =
                    b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
                connectedDevice.value = '';
                firmwareVersion.value = '';

                print('++++++Disconnected remotely!');
              }
              // if (this.mounted) {
              //   setState(() {});
              // }
            });
          }
        }
      }

      if (!foundTx || !foundRx) {
        selectedDeviceLoading.value = false;
        log('ERROR: Could not find required characteristics');
      }
    } catch (e) {
      selectedDeviceLoading.value = false;

      log('Connection error: $e');
    }
  }

  Future<void> _disconnectDevice() async {
    if (_connectedDevice != null) {
      try {
        log('Disconnecting from ${_connectedDevice!.name}...');
        // syncStatus(event: 'Device Disconnect', device: connectedDevice.value, status: 'Disconnect');
        await _connectedDevice!.disconnect();
        _cleanupAfterDisconnection();
        log('Disconnected successfully');
      } catch (e) {
        log('Disconnection error: $e');
      }
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) {
      log('Command cannot be empty');
      return;
    }

    if (_txCharacteristic?.value == null) {
      log('No TX characteristic found');
      return;
    }

    final command = message;
    log('Sending: $command');

    try {
      await _txCharacteristic?.value.write('$command\n'.codeUnits);
      // _commandController.clear();
    } catch (e) {
      log('Send error: $e');
      try {
        await _txCharacteristic?.value.write(
          '$command\n'.codeUnits,
        );
        log('Sent without response');
        // _commandController.clear();
      } catch (e2) {
        log('Send without response also failed: $e2');
      }
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) {
      log('Command cannot be empty');
      return;
    }
    log('MESSAGE = $messages');

    if (_txCharacteristic?.value == null) {
      log('No TX characteristic found');
      return;
    }

    final command = message;
    log('Sending: $command');

    try {
      await _txCharacteristic?.value.write('$command\n'.codeUnits);
      // _commandController.clear();
    } catch (e) {
      log('Send error: $e');
      try {
        await _txCharacteristic?.value.write(
          '$command\n'.codeUnits,
        );
        log('Sent without response');
        // _commandController.clear();
      } catch (e2) {
        log('Send without response also failed: $e2');
      }
    }
  }

  void _addLog(String message) {
    log('==message $messages');
    _logs.insert(0, '${DateTime.now().toLocal()}: $message');
    if (_logs.length > 100) {
      _logs.removeLast();
    }
  }
  //////

  bluetoothStart() {
    // if (arguments != null && arguments[0]['server'] != null) {
    //   var server = arguments[0]['server'];
    //   print('******************server   ${server.address}');

    // try {
    // BluetoothConnection.toAddress(server.address).then((_connection) {

    print('Connected to the device');
    startUpDateTime = DateTime.now();
    startUp.value = formatDate(DateTime.now());
    // connection = _connection;
    // Get.put(HomeScreenController()).connectedDevice.value = server.name;
    //
    // print('Connected to the device0++++++++++++++++++++++  ${server.name}');
    disconnectTimer?.cancel();
    disconnectTimer = null;
    disconnectAudioTimer?.cancel();
    disconnectAudioTimer = null;
    hasReconnect.value = true;
    // setState(() {
    isConnecting.value = true;
    isDisconnecting.value = false;
    // });
    // stopwatch.start();
    linkColorChange();
    if (connections?.isConnected == true) {
      _sendMessage('0i');
      _sendMessage('1i');
      // Future.delayed(Duration(milliseconds: 800), () {
      //   _sendMessage('f');
      // });

      /// For testing status
      // checkDecimal();
      // _sendMessage('1i');
      // messages.clear();
      // _sendMessage('f');
    }

    /// old
    // connections?.input!.listen(_onDataReceived).onDone(() {
    //   // Example: Detect which side closed the connection
    //   // There should be `isDisconnecting` flag to show are we are (locally)
    //   // in middle of disconnecting process, should be set before calling
    //   // `dispose`, `finish` or `close`, which all causes to disconnect.
    //   // If we except the disconnection, `onDone` should be fired as result.
    //   // If we didn't except this (no flag set), it means closing by remote.
    //   if (isDisconnecting.value) {
    //     isConnecting.value = false;
    //     // stopwatch.stop();
    //     // warningDialog(Get.overlayContext as BuildContext);
    //     // voltMeterData.value = VoltMeterData(
    //     //     endValue: 301,
    //     //     interval: 100,
    //     //     startValue: 0,
    //     //     value: 0,
    //     //     defaultValue: 0,
    //     //     showVoltage: '',
    //     //     voltage: '');
    //     meterColor.value = ColorConstant.primaryGreen;
    //     t?.cancel();
    //     t2?.cancel();
    //     r?.cancel();
    //     r = null;
    //     t = null;
    //     t2 = null;
    //     beepTimer?.cancel();
    //     beepTimer = null;
    //     isCalibration.value = true;
    //     isBattery.value = true;
    //     isBatteryLoading.value = true;
    //
    //     hasInductionWarningTextShow.value = false;
    //     hasWarningDetectTextShow.value = false;
    //     isBack.value = true;
    //     selectedDevices.value = BluetoothDevice(address: "");
    //     connectedDevice.value = '';
    //     firmwareVersion.value = '';
    //
    //     print('++++++Disconnecting locally!');
    //   } else {
    //     isConnecting.value = false;
    //     isBack.value = true;
    //
    //     // stopwatch.stop();
    //     // if (disconnectButton.value == false) {
    //     //   warningDialog();
    //     // }
    //     // voltMeterData.value = VoltMeterData(
    //     //     endValue: 301,
    //     //     interval: 100,
    //     //     startValue: 0,
    //     //     value: 0,
    //     //     defaultValue: 0,
    //     //     showVoltage: '',
    //     //     voltage: '');
    //     meterColor.value = ColorConstant.primaryGreen;
    //     if (disconnectButton.value == false) {
    //       if (hasReconnect.value) {
    //         onDisconnectAudioStart();
    //         disconnectTimer =
    //             Timer.periodic(Duration(milliseconds: 3000), (timer) async {
    //           /// 3 second bluetooth start
    //           ///
    //           // bluetoothStart();
    //           disconnectTimer?.cancel();
    //           disconnectTimer = null;
    //           isLicenced.value = false;
    //           await BluetoothConnection.toAddress(
    //                   selectedDevicesLast.value.address)
    //               .then((value) {
    //             hasReconnect.value = false;
    //             print('safddddddddddddddddddddddddddddddddd');
    //             connections = value;
    //             connectedDevice.value =
    //                 selectedDevicesLast.value.name != null &&
    //                         selectedDevicesLast.value.name!.isNotEmpty
    //                     ? selectedDevicesLast.value.name ?? ''
    //                     : selectedDevicesLast.value.address ?? '';
    //             selectedDevices.value = selectedDevicesLast.value;
    //             bluetoothStart();
    //             hasReconnect.value = false;
    //             disconnectTimer?.cancel();
    //             disconnectTimer = null;
    //             disconnectAudioTimer?.cancel();
    //             disconnectAudioTimer = null;
    //           }).catchError((e) {
    //             hasReconnect.value = false;
    //             disconnectTimer?.cancel();
    //             disconnectTimer = null;
    //             disconnectAudioTimer?.cancel();
    //             disconnectAudioTimer = null;
    //             ProgressDialogUtils.showTitleSnackBar(
    //                 headerText: 'Please try again!');
    //             warningDialog(
    //               onPressed: () {
    //                 Get.back();
    //                 Get.back();
    //               },
    //             );
    //
    //             print('Error BLUETOOTH OFF  = ${e.toString()}');
    //           });
    //         });
    //       }
    //     }
    //     t?.cancel();
    //     t2?.cancel();
    //     r?.cancel();
    //     r = null;
    //     t = null;
    //     t2 = null;
    //     beepTimer?.cancel();
    //     beepTimer = null;
    //     isCalibration.value = true;
    //     isBattery.value = true;
    //     isBatteryLoading.value = true;
    //     hasInductionWarningTextShow.value = false;
    //     hasWarningDetectTextShow.value = false;
    //     selectedDevices.value = BluetoothDevice(address: "");
    //     connectedDevice.value = '';
    //     firmwareVersion.value = '';
    //
    //     print('++++++Disconnected remotely!');
    //   }
    //   // if (this.mounted) {
    //   //   setState(() {});
    //   // }
    // });
    /// old
    /// new
    _rxCharacteristic!.value.onValueReceived.listen((value) {
      _onDataReceived(Uint8List.fromList(value));
      log('Received: ${String.fromCharCodes(value)}');
    }).onDone(() {
      // Example: Detect which side closed the connection
      // There should be `isDisconnecting` flag to show are we are (locally)
      // in middle of disconnecting process, should be set before calling
      // `dispose`, `finish` or `close`, which all causes to disconnect.
      // If we except the disconnection, `onDone` should be fired as result.
      // If we didn't except this (no flag set), it means closing by remote.
      if (isDisconnecting.value) {
        isConnecting.value = false;
        // stopwatch.stop();
        // warningDialog(Get.overlayContext as BuildContext);
        // voltMeterData.value = VoltMeterData(
        //     endValue: 301,
        //     interval: 100,
        //     startValue: 0,
        //     value: 0,
        //     defaultValue: 0,
        //     showVoltage: '',
        //     voltage: '');
        meterColor.value = ColorConstant.primaryGreen;
        t?.cancel();
        t2?.cancel();
        r?.cancel();
        r = null;
        t = null;
        t2 = null;
        beepTimer?.cancel();
        beepTimer = null;
        isCalibration.value = true;
        isBattery.value = true;
        isBatteryLoading.value = true;

        hasInductionWarningTextShow.value = false;
        hasWarningDetectTextShow.value = false;
        isBack.value = true;
        selectedDevices.value =
            b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
        connectedDevice.value = '';
        firmwareVersion.value = '';

        print('++++++Disconnecting locally!');
      } else {
        isConnecting.value = false;
        isBack.value = true;

        // stopwatch.stop();
        // if (disconnectButton.value == false) {
        //   warningDialog();
        // }
        // voltMeterData.value = VoltMeterData(
        //     endValue: 301,
        //     interval: 100,
        //     startValue: 0,
        //     value: 0,
        //     defaultValue: 0,
        //     showVoltage: '',
        //     voltage: '');
        meterColor.value = ColorConstant.primaryGreen;
        if (disconnectButton.value == false) {
          if (hasReconnect.value) {
            onDisconnectAudioStart();
            disconnectTimer =
                Timer.periodic(Duration(milliseconds: 3000), (timer) async {
              /// 3 second bluetooth start
              ///
              // bluetoothStart();
              disconnectTimer?.cancel();
              disconnectTimer = null;
              isLicenced.value = false;
              _connectToDevice(selectedDevicesLast.value).then((value) {
                hasReconnect.value = false;
                print('safddddddddddddddddddddddddddddddddd');
                // connections = value;
                connectedDevice.value =
                    selectedDevicesLast.value.name != null &&
                            selectedDevicesLast.value.name!.isNotEmpty
                        ? selectedDevicesLast.value.name ?? ''
                        : 'Unknown Device';
                selectedDevices.value = selectedDevicesLast.value;
                bluetoothStart();
                hasReconnect.value = false;
                disconnectTimer?.cancel();
                disconnectTimer = null;
                disconnectAudioTimer?.cancel();
                disconnectAudioTimer = null;
              }).catchError((e) {
                hasReconnect.value = false;
                disconnectTimer?.cancel();
                disconnectTimer = null;
                disconnectAudioTimer?.cancel();
                disconnectAudioTimer = null;
                ProgressDialogUtils.showTitleSnackBar(
                    headerText: 'Please try again!');
                warningDialog(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                );

                print('Error BLUETOOTH OFF  = ${e.toString()}');
              });
            });
          }
        }
        t?.cancel();
        t2?.cancel();
        r?.cancel();
        r = null;
        t = null;
        t2 = null;
        beepTimer?.cancel();
        beepTimer = null;
        isCalibration.value = true;
        isBattery.value = true;
        isBatteryLoading.value = true;
        hasInductionWarningTextShow.value = false;
        hasWarningDetectTextShow.value = false;
        selectedDevices.value =
            b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
        connectedDevice.value = '';
        firmwareVersion.value = '';

        print('++++++Disconnected remotely!');
      }
      // if (this.mounted) {
      //   setState(() {});
      // }
    });

    /// new
    // }).catchError((error) {
    //   print('Cannot connect, exception occured');
    //   print(error);
    //   isBack.value = true;
    //
    //   warningDialog(Get.overlayContext as BuildContext);
    // });
    // } catch (e) {
    //   print('CONNECTION ERROR = ${e.toString()}');
    // }
    // }
  }

  onDisconnectAudioStart() {
    disconnectAudioTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (isActiveScreen.value) {
        //   disconnectAudio?.open(
        // Audio('assets/sound/beepb.wav'),
        // volume: 0.8,
        // );

        LocalAudioPlayer.play('assets/sound/beep.wav');
      }
    });
  }

  beepSoundOn() {
    beepTimer?.cancel();
    beepTimer = null;

    beepTimer = Timer.periodic(Duration(milliseconds: 2900), (timer) {
      if (isActiveScreen.value) {
        if (ttsState.value != TtsState.playing) {
          LocalAudioPlayer2.play('assets/sound/beep1.wav');
        }
      }
    });
  }

  String formatDate(DateTime time) {
    DateFormat dateFormat = DateFormat("hh:mm a");
    return dateFormat.format(time);
  }

  String minutesCalculate(DateTime start, DateTime end) {
    Duration difference = end.difference(start);

    print(difference);

    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;
    print('${minutes}:${seconds} Minutes');
    if (minutes == 0) {
      return '${intToString(seconds.toString())} Seconds';
    } else {
      return '${intToString(minutes.toString())}:${intToString(seconds.toString())} Minutes';
    }
  }

  String intToString(String value) {
    if (value.length == 1) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  void back() {
    screen.value = '0';
    isActiveScreen.value = false;
    startMeter.value = false;
    flutterTts.stop();
    print('DISPOSE++++++==== IS BACK  ${connections?.isConnected == true}');

    // if (connections?.value.isConnected == true) {
    //   if (connections?.value.isConnected == true) {
    //     isDisconnecting.value = true;
    //     connections?.value.close();
    //
    //     connections?.value.dispose();
    //     print('DISPOSE++++++==== IS BACK');
    //   }
    // hasVoiceActive.value=false;
    //
    //
    // beepTimer?.cancel();
    // beepTimer = null;
    // hasBeepSound.value = false;
    // disconnectTimer?.cancel();
    // disconnectTimer = null;
    // disconnectAudioTimer?.cancel();
    // disconnectAudioTimer = null;
    // flutterTts.stop();

    Get.back();
    // }
  }

  @override
  void onClose() {
    // if (isConnected) {
    isDisconnecting.value = true;
    //   connections?.dispose();
    // }
    flutterTts.stop();
    r?.cancel();
    r = null;
    beepTimer?.cancel();
    beepTimer = null;

    disconnectTimer?.cancel();
    disconnectTimer = null;
    disconnectAudioTimer?.cancel();
    disconnectAudioTimer = null;
    _stopScan();
    _disconnectDevice();
    super.onClose();
  }

  @override
  void dispose() {
    // if (isConnected) {
    //   isDisconnecting.value = true;
    //   connections?.dispose();
    // }
    streamSubscription?.cancel();
    _stopScan();
    _disconnectDevice();
    flutterTts.stop();
    r?.cancel();
    r = null;
    beepTimer?.cancel();
    beepTimer = null;
    disconnectTimer?.cancel();
    disconnectTimer = null;
    disconnectAudioTimer?.cancel();
    disconnectAudioTimer = null;

    super.dispose();
  }

  void next() {
    voltsDetectedDateTime = DateTime.now();
    voltsDetected.value = formatDate(DateTime.now());
    duration.value = minutesCalculate(startUpDateTime, voltsDetectedDateTime);

    print('startUp.value  ${startUp.value}');
    print('voltsDetected.value  ${voltsDetected.value}');
    print('duration.value  ${duration.value}');
    hasPlay.value = false;
    LocalAudioPlayer.disposes();
    flutterTts.stop();
    hasNextVoice.value = false;
    // syncStatus(event: 'Voltage Capture ${{'test_type': testType.value,
    //   'name': name.value,
    //   'pts_number': ptsNumber.value,
    //   'company_name': companyName.value,
    //   'depot': depot.value,
    //   'form_b': formBNumber.value,
    //   'form_c': formCNumber.value,
    //   'location': location.value,
    //   'connectedDevice': connectedDeviceSend.value,
    //   'locationGPS': locationGPS.value,
    //   'isBatteryCalibration': isBattery.value == true
    //       ? 'Battery'
    //       : isCalibration.value == true
    //       ? 'Calibration'
    //       : 'NO',
    //   'isInductionEnr': hasInductionWarningTextShow.value == true
    //       ? 'Induction'
    //       : hasWarningDetectTextShow.value == true
    //       ? 'Energised'
    //       : 'NO',}}', device: _connectedDevice?.name??'', status: 'Active');

    Get.toNamed(AppRoutes.activeTestDetailsScreenRoute, arguments: [
      {
        "kv":
            '${voltMeterData.value.showVoltage} ${voltMeterData.value.voltage}'
      },
      {"volts_detect": voltsDetected.value},
      {"duration": duration.value},
      {
        "highest":
            '${voltMeterData.value.showVoltage} ${voltMeterData.value.voltage}'
      },
      {
        "lowest":
            voltMeterData.value.showVoltage == '0' ? '0 V' : lowVoltage.value
      },
      {"startUp": startUp.value},
      {
        'test_type': testType.value,
        'name': name.value,
        'pts_number': ptsNumber.value,
        'company_name': companyName.value,
        'depot': depot.value,
        'form_b': formBNumber.value,
        'form_c': formCNumber.value,
        'location': location.value,
        'connectedDevice': connectedDeviceSend.value,
        'locationGPS': locationGPS.value,
        'isBatteryCalibration': isBattery.value == true
            ? 'Battery'
            : isCalibration.value == true
                ? 'Calibration'
                : 'NO',
        'isInductionEnr': hasInductionWarningTextShow.value == true
            ? 'Induction'
            : hasWarningDetectTextShow.value == true
                ? 'Energised'
                : 'NO',
      }
    ])?.then((value) {
      hasPlay.value = true;
      hasNextVoice.value = true;
    });
  }

  void linkColorChange() {
    t?.cancel();
    t2?.cancel();
    t = null;
    t2 = null;
    t = Timer.periodic(Duration(milliseconds: 200), (timer) {
      linkColor.value = true;
    });
    t2 = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      linkColor.value = false;
      linkColorChange();
    });
  }

  void ringColorChange() {
    r?.cancel();
    r = null;
    r = Timer.periodic(Duration(milliseconds: 250), (timer) {
      ringColor.value = !ringColor.value;
      if (!ringColor.value) {
        meterColor.value = Colors.green.withOpacity(0.6);
      } else {
        meterColor.value = ColorConstant.flashingGreen;
      }
    });
  }

  // Future _speak(String? value) async {
  //   await flutterTts.setVolume(volume);
  //   await flutterTts.setSpeechRate(rate);
  //   await flutterTts.setPitch(pitch);
  //   await flutterTts.setLanguage("en-us");
  //   if (value != null) {
  //     if (value.isNotEmpty) {
  //       await flutterTts.speak(value);
  //     }
  //   }
  // }

  Future _speakDetect(String? value) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.setLanguage("en-US");
    if (value != null) {
      if (value.isNotEmpty) {
        await flutterTts.speak(value);
      }
    }
  }

  RxBool isTimeOpen = false.obs;
  speakTimer() {
    if (ttsState.value == TtsState.stopped) {
      print('================================= ');

      print('VALUE 300');

      if (ringValue.value <= 300) {
        _speakDetect('Voltage is \n\n${ringValue.value.toInt()} volts}');
      } else {
        double newSpeak = ringValue.value / 1000;

        _speakDetect('Voltage is \n\n${newSpeak.toStringAsFixed(1)} Kilovolts');
      }
    } else {
      print('================================= s');

      return;
    }
    speak = Timer.periodic(Duration(seconds: 10), (timer) {
      isTimeOpen.value = true;
    });
  }

  void voltageAnaunce(double value) {
    if (isActiveScreen.value && hasNextVoice.value && hasVoiceActive.value) {
      if (ttsState.value == TtsState.playing) {
        return;
      }
      if (isTimeOpen.value) {
        Future.delayed(
          Duration(milliseconds: 2500),
          () {
            value = ringValue.value;
            if (ttsState.value == TtsState.stopped) {
              print('================================= ');

              print('VALUE 300');

              if (value <= 300) {
                _speakDetect('Voltage is \n\n${value.toInt()} volts}');
                isTimeOpen.value = false;
              } else {
                double newSpeak = value / 1000;

                _speakDetect(
                    'Voltage is \n\n${newSpeak.toStringAsFixed(1)} Kilovolts');
                isTimeOpen.value = false;
              }
            } else {
              print('================================= s');

              return;
            }
          },
        );
      }
    }
  }

  RxString gaugeCount = '1'.obs;

  dataCalculate(double value, String value1) {
    if (!hasPrevVoltage.value) {
      if (value <= 300) {
        gaugeCount.value = '1';
        voltMeterData.value = VoltMeterData(
            endValue: 301,
            interval: 100,
            startValue: 0,
            value: value,
            defaultValue: value,
            showVoltage: value.toInt().toString(),
            voltage: 'V');
      }

      if (value > 300 && value < 3001) {
        gaugeCount.value = '2';

        var needleValue = value / 10;
        var newValue = value / 1000;

        voltMeterData.value = VoltMeterData(
            endValue: 301,
            interval: 100,
            startValue: 0,
            defaultValue: value,
            value: needleValue,
            showVoltage: newValue.toStringAsFixed(1),
            voltage: 'kV');
      }

      // if (value >= 3001 && value < 30000) {
      if (value >= 3001) {
        gaugeCount.value = '3';

        var needleValue = value / 100;
        var newValue = value / 1000;

        voltMeterData.value = VoltMeterData(
            endValue: 301,
            interval: 100,
            startValue: 0,
            defaultValue: value,
            value: needleValue,
            showVoltage: newValue.toStringAsFixed(1),
            voltage: 'kV');
      }
    } else {
      if (value <= 270) {
        voltMeterData.value = VoltMeterData(
            endValue: 301,
            interval: 100,
            startValue: 0,
            value: value,
            defaultValue: value,
            showVoltage: value.toInt().toString(),
            voltage: 'V');
      }

      if (value > 270 && value < 2800) {
        var needleValue = value / 10;
        var newValue = value / 1000;

        voltMeterData.value = VoltMeterData(
            endValue: 301,
            interval: 100,
            startValue: 0,
            defaultValue: value,
            value: needleValue,
            showVoltage: newValue.toStringAsFixed(1),
            voltage: 'kV');
      }

      // if (value >= 2800 && value < 30000) {
      if (value >= 2800) {
        var needleValue = value / 100;
        var newValue = value / 1000;

        voltMeterData.value = VoltMeterData(
            endValue: 301,
            interval: 100,
            startValue: 0,
            defaultValue: value,
            value: needleValue,
            showVoltage: newValue.toStringAsFixed(1),
            voltage: 'kV');
      }
    }
  }

  Future<bool> getCurrentLatLong() async {
    tg?.cancel();
    tg = null;
    var status = await Permission.location.status;
    tg = Timer.periodic(Duration(milliseconds: 600), (timer) {
      gpsColor.value = !gpsColor.value;
    });
    if (status.isDenied) {
      hasPermission.value = false;
      Permission.location.request();
      return false;
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      hasPermission.value = false;
      CommonConstant.instance.CustomCupertinoAlertDilouge(
          context: Get.overlayContext as BuildContext,
          Header: "Permission Denied",
          subTitle: "Allow access to Location Permission",
          yesButtonText: "yesButtonText",
          noButtonText: "noButtonText",
          yesButtonTap: () async {
            Get.back();
            await openAppSettings().whenComplete(() {});
          },
          cancelButtonTap: () {
            Get.back();
          });
      return false;
    } else if (status.isGranted) {
      hasPermission.value = true;
      hasLocation.value = true;
      try {
        bool locationEnable = await Geolocator.isLocationServiceEnabled();
        if (locationEnable == false) {
          Position position = await Geolocator.getCurrentPosition();
          print('POSITION LOCATION = ${position.latitude}');

          hasLocation.value = false;
        } else {
          hasLocation.value = false;
        }
      } catch (e) {
        print('ERROR LOCATION = ${e.toString()}');
        hasPermission.value = false;
        return false;
      }
      return true;
    }
    return false;
  }

  RxInt dataCount = 0.obs;
  List<double> voltageList = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  RxString fSendCommand = ''.obs;
  RxString fReturnCommand = ''.obs;
  RxInt fWrongCommandCount = 0.obs;
  double done = 350;

  void _onDataReceived(Uint8List data) {
    if (!isLogTestScreen.value) {
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

      String dataString = String.fromCharCodes(buffer);
      String dataStringSend = String.fromCharCodes(data);
      // print('data ++77777   ${data}');
      // print('dataString ++77777   ${dataString}');
      int index = buffer.indexOf(13);
      // print('MESSAGE START FULLL ==   ${dataString.replaceAll(' ', '').trim()}');

      // setState(() {

      try {
        if (listScrollController.hasClients) {
          if (isOnLast.value) {
            listScrollController.animateTo(
                listScrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut);
          }
        }
        String livem = '';
        if (~index != 0) {
          livem = backspacesCounter > 0
              ? _messageBuffer
                  .substring(0, _messageBuffer.length - backspacesCounter)
                  .trim()
              : _messageBuffer + dataString.substring(0, index);
          _messageBuffer = dataString.substring(index).trim();
          String modifiedString =
              livem.replaceAll('\n', '').replaceAll('\r', '').trim();

          // if (modifiedString.isNotEmpty) {
          messagesListConsole.add(
            _Message(
              1,
              livem,
            ),
          );
          if (!livem.contains('V')) {
            messagesListConsoleHome.add(
              _Message(
                1,
                livem,
              ),
            );
          }
          // }
        } else {
          _messageBuffer = (backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString);
        }

        isOnLast.value = true;

        messagesListConsole.refresh();

        print('ALL ORIGINAL MESSAGE ==   ${livem.trim()}');

        /// calibration nad battery
        // _sendMessage('0i');

        if (dataStringSend
                .replaceAll(" ", "")
                .trim()
                .contains("X${fReturnCommand.value}u") ||
            livem
                .replaceAll(" ", "")
                .trim()
                .contains("X${fReturnCommand.value}u")) {
          if (fWrongCommandCount.value == 5) {
            fWrongCommandCount.value = 0;
            wrongUDialog("$fSendCommand/$fReturnCommand");
            hasReconnect.value = false;
            connections?.close();
            connections?.dispose();
            selectedDevices.value =
                b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
            connectedDevice.value = '';
            return;
          } else {
            fWrongCommandCount.value++;
            _sendMessage('f');
            return;
          }
        }

        int messageF = 0;
        sendCommand(livem);
        if (firmwareVersion.value.isEmpty) {
          _sendMessage('f');
        }
        // if (livem.contains('X0f') || livem == 'X0f') {
        //   print('X0F  COMMAND =============== ');
        //   _sendMessage('0i');
        //   sendCommand(livem);
        // }

        /// getLicence info
        if (livem.trim().contains('J')) {
          livem = getJValue(livem).isNotEmpty ? getJValue(livem) : livem;

          if (livem.trim().contains('J') && livem.trim().length == 7) {
            print('MESSAGE LENGTH :- ${livem.trim().length}  +++  ${livem}');
            String expireDate = livem.replaceAll('J', '');
            // String expireDate = '120624';

            String formattedDate = formatDateString(expireDate);
            print('formattedDate ${formattedDate}');

            DateTime expFormat = DateFormat("dd/MM/yy").parse(formattedDate);
            print('formattedDateTime ${expFormat}');

            DateTime todayFormat = DateFormat("dd/MM/yy")
                .parse(DateFormat('dd/MM/yy').format(DateTime.now()));
            print('formattedDateTimedt2 ${todayFormat}');

            if (expFormat.compareTo(todayFormat) < 0) {
              isLicenced.value = false;
              print("DT1 is before DT2 Licence is expire");
            } else {
              isLicencedDate.value = formattedDate;
              isLicenced.value = true;

              print("DT1 is after DT2 Licence is not expire");
            }

            print('expireDate VALID == ${expFormat}');
            print('todayDate VALID == ${todayFormat}');
          }
        }
        if (livem.trim().contains('J') &&
            (livem.toString().trim() == 'J0' ||
                livem.toString().trim() == 'J1' ||
                livem.toString().trim() == 'J2' ||
                livem.toString().trim() == 'J3' ||
                livem.toString().trim() == 'J4')) {
          isLicenced.value = false;
        }
        var fContainVariable = splitStringAfterSpaces(livem);
        if (livem.contains('F')) {
          fContainVariable = containFs(livem);
        }
        if (fContainVariable.contains('F')) {
          fContainVariable = containFs(livem);
        }
        if (fContainVariable.isNotEmpty && fContainVariable.startsWith('F')) {
          messageList.clear();
          messageList.add(fContainVariable);
          var listF = messageList.first.split(';');

          messageF = int.parse(listF.last.toString().trim());

          if (listF.isNotEmpty &&
              listF[1].isNotEmpty &&
              firmwareVersion.value.isEmpty) {
            print('firmwareVersion  = ${listF[1]}');
            firmwareVersion.value =
                'F ${(int.parse(listF[1]) / 100).toStringAsFixed(2)}';
          }
          // messageF = 212656562;
          int c12 = excelFunction(messageF);
          print('messageF  = ${messageF}');
          print('c12  = ${c12}');

          fSendCommand.value = messageF.toString();
          fReturnCommand.value = c12.toString();
          _sendMessage('$c12' + 'u');
        } else {
          if (livem.startsWith('V')) {
            if (sValue.value == true) {
              Future.delayed(Duration(milliseconds: 2000), () {
                _sendMessage('s');
              });

              sValue.value = false;
            }
            var listF = livem.split(';');
            lowVoltage.value =
                '${double.parse(listF.first.replaceAll('V', '')) <= 300 ? '${int.parse(listF.first.replaceAll('V', ''))} V' : '${(double.parse(listF.first.replaceAll('V', '')) / 1000).toStringAsFixed(1)} kV'}';
            if (listF.last.isNotEmpty && listF.last != "V") {
              messageF = int.parse(listF.last);
              ringValue.value = double.parse(listF.last);
              ringValueString.value = listF.last.toString();

              // value = !value;
              // double done = 0.0;
              // if (value) {
              //   // print('true');
              //
              //   done = 285;
              //   done = 288;
              //   done = 290;
              //   done = 294;
              //   // done = done+100;
              // } else {
              //   // print('false');
              //   done = 350;
              //   // done = 3115;
              // }
              // print('ALL ORIGINAL MESSAGE ==   ${done}');
              ///get 3 readings per second
              voltageList.add(double.parse(listF.last));
              // voltageList.add(done);

              if (voltageList.length > 4) {
                voltageList.removeAt(0);
              }

              // if (hasMeterView.value) {
              dataCount++;
              if (dataCount.value % 5 == 0 || livem.startsWith('S')) {
                final tempVal = calculateAverage(voltageList);
                voltageAnaunce(tempVal);

                if (voltageLastAndPrevList.length > 3) {
                  voltageLastAndPrevList.removeLast();
                }
                // voltageLastAndPrevList.insert(0, double.parse(listF.last));
                voltageLastAndPrevList.insert(0, tempVal);
                // if (voltageLastAndPrevList.length > 3) {
                //   // print(
                //   //     'ALL ORIGINAL MESSAGE ==  0 = ${voltageLastAndPrevList[0]} 1= ${voltageLastAndPrevList[1]} 2= ${voltageLastAndPrevList[2]} 3= ${voltageLastAndPrevList[3]} 4= ${voltageLastAndPrevList[4]} 5= ${voltageLastAndPrevList[5]}');
                //
                //   if (voltageLastAndPrevList[1] > voltageLastAndPrevList[0] ||
                //       voltageLastAndPrevList[2] > voltageLastAndPrevList[0] ||
                //       voltageLastAndPrevList[3] > voltageLastAndPrevList[0] ) {
                //     hasPrevVoltage.value = true;
                //   } else {
                //     hasPrevVoltage.value = false;
                //   }
                // }
                if (gaugeCount.value == '2' &&
                    (tempVal > 270 && tempVal < 300)) {
                  hasPrevVoltage.value = true;
                } else {
                  hasPrevVoltage.value = false;
                }
                if (gaugeCount.value == '3' &&
                    (tempVal > 2800 && tempVal < 3000)) {
                  hasPrevVoltage.value = true;
                } else {
                  hasPrevVoltage.value = false;
                }

                dataCalculate(tempVal, listF.last.toString());

                dataCount.value = 0;
              }
              // } else {
              //   dataCount++;
              //
              //   if (dataCount.value % 5 == 0 || livem.startsWith('S')) {
              //     voltageAnaunce(double.parse(listF.last));
              //     dataCount.value = 0;
              //   }
              //   dataCalculate(double.parse(listF.last), listF.last.toString());
              // }
            }
          }
        }
        if (!livem.startsWith('S') && livem.contains('S')) {
          print('CONTAINS SS====================>>> ${livem.trim()}');
          isBatteryLoading.value = false;
          messageList.clear();
          messageList.add(livem);

          int decimal = int.parse(getSValue(livem));
          String binValue = decimalToBinary16(decimal);

          String reverseString = binValue.split('').reversed.join('');
          print('ALL = ${decimal} BINARY = ${reverseString}');

          /// for color change
          // UNLOCK

          getColor(reverseString, ringValue.value);
          return;
        }
        // livem = "V63;3421S19;56;100;2V31;1633V120;308";
        if (livem.startsWith('S')) {
          print('====================>>> ${livem.trim()}');
          isBatteryLoading.value = false;
          messageList.clear();
          messageList.add(livem);
          var battery = messageList.first.split(';');
          int decimal = int.parse(battery.first.replaceAll('S', ''));
          String binValue = decimalToBinary16(decimal);

          String reverseString = binValue.split('').reversed.join('');
          print('ALL = ${battery} BINARY = ${reverseString}');

          /// for color change
          // UNLOCK

          getColor(reverseString, ringValue.value);

          // print('S binValue = ${reverseString}');
          var eightIndex = reverseString.toString()[8];
          var nineIndex = reverseString.toString()[9];
          // print('S newString = ${eightIndex}  S newString = ${nineIndex}');
          var eightAndNineIndex = '${eightIndex}${nineIndex}';
          print('NUMBERBC == $eightAndNineIndex');

          if (eightAndNineIndex == '11') {
            isBattery.value = true;
            syncStatus(event: 'Battery Low', device: _connectedDevice?.name??'', status: 'DeActive');

            // print('BATTRY IS LOW ${eightAndNineIndex}');
          } else {
            isBattery.value = false;
            syncStatus(event: 'Battery Full', device: _connectedDevice?.name??'', status: 'Active');

            // print('BATTRY IS FULL ${eightAndNineIndex}');
          }

          ///calibration check

          var calibration = int.parse(battery.last);
          // print('calibration calibration = $calibration');
          // var calibrationBinary = calibration.toRadixString(2);
          String calibrationBinary = decimalToBinary16(calibration);

          String reverseStringCalibration =
              calibrationBinary.split('').reversed.join('');

          // print('calibrationBinary binValue = $reverseStringCalibration');

          var numberB = '';
          if (reverseStringCalibration.length == 1) {
            numberB = reverseStringCalibration.toString()[0];
          } else {
            numberB = reverseStringCalibration.toString()[1];
          }

          print('NUMBERB == $numberB');
          if (int.parse(numberB) == 1) {
            isCalibration.value = true;
            // print(' due calibration == $numberB');
            syncStatus(event: 'Due Calibration', device: _connectedDevice?.name??'', status: 'DeActive');

          } else {
            isCalibration.value = false;
            syncStatus(event: 'Calibration Ok', device: _connectedDevice?.name??'', status: 'Active');

            // print('all ok == $numberB');
          }
        }
      } catch (e) {
        print('ERROR:-- ${e.toString()} ');
      }
      // });
    } else {
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
      String testMessage = '';
      try {
        if (~index != 0) {
          testMessage = backspacesCounter > 0
              ? _messageBuffer
                  .substring(0, _messageBuffer.length - backspacesCounter)
                  .trim()
              : _messageBuffer + newMessage.substring(0, index);
          _messageBuffer = newMessage.substring(index).trim();

          // if (modifiedString.isNotEmpty) {
          if (!testMessage.contains('V')) {
            messagesListConsoleHome.add(
              _Message(
                1,
                '=====> $testMessage',
              ),
            );
          }
          // }
        } else {
          _messageBuffer = (backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + newMessage);
        }
        messagesListConsoleHome.refresh();

        print(' GET MESSAGES =========  ${testMessage}');

        /////////////////////////////////////////
        if (testMessage.startsWith('S')) {
          print('====================>>> ${testMessage.trim()}');
          isBatteryLoading.value = false;
          messageList.clear();
          messageList.add(testMessage);
          var battery = messageList.first.split(';');
          int decimal = int.parse(battery.first.replaceAll('S', ''));
          String binValue = decimalToBinary16(decimal);

          String reverseString = binValue.split('').reversed.join('');
          print('ALL = ${battery} BINARY = ${reverseString}');

          /// for color change
          // UNLOCK

          // getColor(reverseString, ringValue.value);

          // print('S binValue = ${reverseString}');
          var eightIndex = reverseString.toString()[8];
          var nineIndex = reverseString.toString()[9];
          // print('S newString = ${eightIndex}  S newString = ${nineIndex}');
          var eightAndNineIndex = '${eightIndex}${nineIndex}';
          print('NUMBERBC == $eightAndNineIndex');

          if (eightAndNineIndex == '11') {
            isBattery.value = true;
            syncStatus(event: 'Battery Low', device: _connectedDevice?.name??'', status: 'DeActive');

            // print('BATTRY IS LOW ${eightAndNineIndex}');
          } else {
            isBattery.value = false;
            syncStatus(event: 'Battery Full', device: _connectedDevice?.name??'', status: 'Active');

            // print('BATTRY IS FULL ${eightAndNineIndex}');
          }

          ///calibration check

          var calibration = int.parse(battery.last);
          // print('calibration calibration = $calibration');
          // var calibrationBinary = calibration.toRadixString(2);
          String calibrationBinary = decimalToBinary16(calibration);

          String reverseStringCalibration =
              calibrationBinary.split('').reversed.join('');

          // print('calibrationBinary binValue = $reverseStringCalibration');

          var numberB = '';
          if (reverseStringCalibration.length == 1) {
            numberB = reverseStringCalibration.toString()[0];
          } else {
            numberB = reverseStringCalibration.toString()[1];
          }

          print('NUMBERB == $numberB');
          if (int.parse(numberB) == 1) {
            isCalibration.value = true;
            syncStatus(event: 'Due Calibration', device: _connectedDevice?.name??'', status: 'DeActive');

          } else {
            isCalibration.value = false;
            syncStatus(event: 'Calibration Ok', device: _connectedDevice?.name??'', status: 'Active');

            // print('all ok == $numberB');
          }
        }

        if (testMessage.trim().contains('J')) {
          print(
              '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ${isLicencedDate.value} ${testMessage}');
          testMessage = getJValue(testMessage).isNotEmpty
              ? getJValue(testMessage)
              : testMessage;
          if ((testMessage.trim().contains('J') &&
              testMessage.trim().length == 7)) {
            print(
                'MESSAGE LENGTH :- ${testMessage.trim().length}  +++  ${testMessage}');
            String expireDate = testMessage.replaceAll('J', '');
            // String expireDate = '120624';

            String formattedDate = formatDateString(expireDate);
            print('formattedDate ${formattedDate}');

            isLicencedDate.value = formattedDate;
            DateTime expFormat = DateFormat("dd/MM/yy").parse(formattedDate);
            print('formattedDateTime ${expFormat}');

            DateTime todayFormat = DateFormat("dd/MM/yy")
                .parse(DateFormat('dd/MM/yy').format(DateTime.now()));
            print('formattedDateTimedt2 ${todayFormat}');
            messagesListConsoleHome.add(
              _Message(
                1,
                '=====> contains(J) 7 ${formattedDate}',
              ),
            );
            if (expFormat.compareTo(todayFormat) < 0) {
              isExpireOrNot = true;
              // if (isExpireOrNot == true) {
              //   print('isExpireOrNot LICENSE == ${newMessage}');
              //   ProgressDialogUtils.hideProgressDialog();
              //
              //   checkWarningDialog(AppString.enterLicenseKeysExpired);
              //   isExpireOrNot = false;
              //
              // }
              ProgressDialogUtils.hideProgressDialog();
              isLicenced.value = false;
              ProgressDialogUtils.showTitleSnackBar(
                  headerText: 'Your licence is expire ($formattedDate)');
              print("DT1 is before DT2 Licence is expire");
              // syncStatus(event: 'Your licence is expire ($formattedDate)', device: _connectedDevice?.name??'', status: 'DeActive');

              messagesListConsoleHome.add(
                _Message(
                  1,
                  'DT1 is before DT2 Licence is expire',
                ),
              );
            } else {
              isExpireOrNot = false;
              ProgressDialogUtils.hideProgressDialog();
              isLicenced.value = true;
              isLicencedDate.value = formattedDate;

              ProgressDialogUtils.showTitleSnackBar(
                  headerText: 'Your licence is accepted ($formattedDate)');
              print("DT1 is after DT2 Licence is not expire");
              messagesListConsoleHome.add(
                _Message(
                  1,
                  'DT1 is after DT2 Licence is not expire',
                ),
              );
            }

            print('expireDate VALID == ${expFormat}');
            print('todayDate VALID == ${todayFormat}');
          }
          if (testMessage.trim().contains('J')) {
            ProgressDialogUtils.hideProgressDialog();

            // if (isExpireOrNot == true) {
            //   print('isExpireOrNot LICENSE == ${newMessage}');
            //   ProgressDialogUtils.hideProgressDialog();
            //
            //   checkWarningDialog(AppString.enterLicenseKeysExpired);
            // } else
            if (testMessage.trim() == 'J0') {
              print('J0 LICENSE == ${testMessage}');
              isLicenced.value = false;
              ProgressDialogUtils.hideProgressDialog();
              messagesListConsoleHome.add(
                _Message(
                  1,
                  'J0 ${testMessage.trim()}',
                ),
              );
              if (!isLicenseKeyDialogOpen.value) {
                ProgressDialogUtils.showTitleSnackBar(
                    headerText:
                        'No licence info found! (${testMessage.trim()})');
                licenseKeyDialog();
              }
              return;
            } else if (testMessage.toString().trim() == 'J1') {
              isLicenced.value = false;
              print('J1 LICdgfENSE == ${newMessage}');
              ProgressDialogUtils.hideProgressDialog();
              ProgressDialogUtils.showTitleSnackBar(
                  headerText:
                      'License string too short! (${testMessage.trim()})');
              messagesListConsoleHome.add(
                _Message(
                  1,
                  'J1 ${testMessage.trim()}',
                ),
              );
              checkWarningDialog(AppString.enterLicenseKeysValid);
            } else if (testMessage.toString().trim() == 'J2' ||
                testMessage.toString().trim() == 'J3' ||
                testMessage.toString().trim() == 'J4') {
              print('J1 LICdgfENSE == ${newMessage}');
              isLicenced.value = false;
              ProgressDialogUtils.hideProgressDialog();
              ProgressDialogUtils.showTitleSnackBar(
                  headerText:
                      'Incorrect license code! (${testMessage.trim()})');
              messagesListConsoleHome.add(
                _Message(
                  1,
                  'J1 OTHER ${testMessage.trim()}',
                ),
              );
              checkWarningDialog(AppString.enterLicenseKeysValid);
            } else {
              isLicenced.value = true;

              ProgressDialogUtils.hideProgressDialog();
              print('REACHINGLOGLIMIT ${storeDataList.length}');
              messagesListConsoleHome.add(
                _Message(
                  1,
                  'J CHECK NAVIGATE',
                ),
              );
              if (storeDataList.length > 250 && storeDataList.length < 299) {
                reachingLogsLimit();
                print('REACHINGLOGLIMIT LLLLLLLLLLLLLLLLLLL');
              } else {
                if (storeDataList.length == 300) {
                  print('LOGLIMITRICHED MMMMMMMMMMMMMMMMMM');

                  logsLimitReached();
                } else {
                  ProgressDialogUtils.hideProgressDialog();
                  print(
                      '************************************* ${isLicencedDate.value} ${testMessage}');

                  screen.value = '1';
                  Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
                    'server': selectedDevices.value,
                    'connectedDevice': connectedDevice.value
                  });
                }
              }
            }
          }
        } else {
          // print('ERROR ==');
          if (testMessage.trim().contains('R0j') ||
              testMessage.trim() == 'R0j') {
            print('ERROR ==');
            _sendMessage('j');
            messagesListConsoleHome.add(
              _Message(
                1,
                'R0j SEND J MESSAGE',
              ),
            );
          }
          ProgressDialogUtils.hideProgressDialog();

          // ProgressDialogUtils.showTitleSnackBar(headerText: 'Please try again!');
        }
        ///////////////////////////////////////////////////////////////////////
      } catch (e) {
        print('ERROR: = ${e.toString()}');
      }
    }
  }

  String getJValue(input) {
    RegExp regExp = RegExp(r'J(\d+)');

    Match? match = regExp.firstMatch(input);

    if (match != null) {
      String numberAfterS = match.group(1)!;
      print(numberAfterS);
      return 'J${numberAfterS}';
      // Outputs: 3091
    } else {
      _sendMessage('J');
      return '';

      print('No match found');
    }
  }

  String getSValue(String input) {
    RegExp regExp = RegExp(r'S(\d+)');

    Match? match = regExp.firstMatch(input.trim().replaceAll(' ', ''));

    if (match != null) {
      String numberAfterS = match.group(1)!;
      print(
          'numberAfterS =================== ${numberAfterS}'); // Outputs: 3091
      return numberAfterS;
    } else {
      print('No match found');
      return '';
    }
  }

  String formatDateString(String dateString) {
    if (dateString.length != 6) {
      throw FormatException('Invalid date format');
    }

    String month = dateString.substring(0, 2);
    String day = dateString.substring(2, 4);
    String year = dateString.substring(4, 6);

    return '$month/$day/$year';
  }

  String containFs(String input) {
    // Find the starting index where the desired portion begins (where 'F' starts)
    int startIndex = input.indexOf('F');

    // Split the string starting from the found index
    String dynamicPart =
        input.substring(startIndex); // This gives "F2106;129;65106;sadf;345"

    // Split the remaining string by ";"
    List<String> parts = dynamicPart.split(';');

    // Join the first three parts: "F2106;129;65106"
    String result = "${parts[0]};${parts[1]};${parts[2]}";
    print(
        'sadfgkl;asdfglkas;gngas;dgnds;lfkg${result}'); // Output: F2106;129;65106
    return result;
  }

  String splitStringAfterSpaces(String input) {
    String temVar = '';
    // Split the input string by spaces
    List<String> parts = input.split('\n');

    // Remove any empty parts resulting from multiple spaces
    parts.removeWhere((part) => part.isEmpty);
    parts.forEach((element) {
      if (element.contains('F')) {
        temVar = element.trim();
      }
    });
    return temVar;
  }

  bool value = false;

  double calculateAverage(List<double> numbers) {
    numbers.sort();

    // Find the number of elements
    int n = numbers.length;

    // Find the median
    double median;
    if (n % 2 == 0) {
      median = (numbers[n ~/ 2 - 1] + numbers[n ~/ 2]) / 2.0;
    } else {
      median = numbers[n ~/ 2].toDouble();
    }

    return median;
  }

  ///Convert decimal to binary (16)
  String decimalToBinary16(int decimal) {
    // Convert decimal to binary string
    String binary = decimal.toRadixString(2);
    // Ensure the binary string has 16 digits by padding with leading zeros
    while (binary.length < 16) {
      binary = '0$binary';
    }
    return binary;
  }

  /// for testing
  // int count = 0;
  // checkDecimal() {
  //   Future.delayed(
  //     Duration(seconds: 10),
  //     () {
  //       String binValue = decimalToBinary16(count);
  //
  //       // var binValue = count.toRadixString(2);
  //
  //       String reverseString = binValue.split('').reversed.join('');
  //       print('ALL = ${binValue} BINARY = ${reverseString}');
  //       print('BINVALUE LANGTH  = ${binValue.length}');
  //
  //       /// for color change
  //
  //       getColor(reverseString);
  //       count += 121;
  //       print('COUNT = ${count}');
  //       if (isConnecting.value) {
  //         checkDecimal();
  //       }
  //     },
  //   );
  // }

  void getColor(String binary, double value) {
    try {
      var tenIndex = binary.toString()[10];
      var twoIndex = binary.toString()[2];
      var sevenIndex = binary.toString()[7];
      print('&&&&&&&&&&&&&77777777777777777777777777  ${sevenIndex}');
      if (sevenIndex == '0') {
        isProtection.value = true;
      } else {
        isProtection.value = false;
      }
      if (tenIndex == '1') {
        r?.cancel();
        r = null;
        beepSoundOn();

        meterColor.value = ColorConstant.redFF2;
        hasWarningDetectTextShow.value = true;
        // syncStatus(event: 'High Voltage Detect', device: connectedDevice.value, status: 'Active');

        hasInductionWarningTextShow.value = false;
        if (isActiveScreen.value) {
          energisedWarningDetectDialog(value);
        }

        print('METER COLOR = RED');
      } else {
        if (twoIndex == '0') {
          r?.cancel();
          r = null;

          meterColor.value = ColorConstant.primaryGreen;
          hasWarningDetectTextShow.value = false;
          hasInductionWarningTextShow.value = false;
          beepTimer?.cancel();
          beepTimer = null;
          print('METER COLOR = STEADY GREEN');
        } else {
          ringColorChange();
          hasInductionWarningTextShow.value = true;

          hasWarningDetectTextShow.value = false;
          beepTimer?.cancel();
          beepTimer = null;
          if (isActiveScreen.value) {
            inductionsWarningDetectDialog(
                Get.overlayContext as BuildContext, value);
          }
          print('METER COLOR = FLASHING GREEN');
        }
      }
    } catch (e) {
      print('ERROR INDEX ONE = ${e.toString()}');
    }
  }

  sendCommand(String livem) {
    if (livem.contains('X0i') || livem.contains('R0i')) {
      _sendMessage('1i');

      Future.delayed(Duration(milliseconds: 1000), () {
        _sendMessage('f');
      });
      Future.delayed(Duration(milliseconds: 2000), () {
        _sendMessage('s');
      });
      Future.delayed(Duration(milliseconds: 1500), () {
        print(
            'COMMAND ${CommonConstant.instance.dbHelper.box.get(HiveKey.voltagePerSecond)}d');
        _sendMessage(
            '${CommonConstant.instance.dbHelper.box.get(HiveKey.voltagePerSecond) ?? 3}d');
      });
      Future.delayed(Duration(milliseconds: 500), () {
        _sendMessage('j');
      });
    }
  }

  int excelFunction(int c12) {
    print('C12 VALUE = $c12');
    int mod5 = c12 % 5;
    int mod17 = c12 % 17;
    int result = ((c12 + mod5 + mod17) * 16 + c12) ~/ 128;
    print('C12 RESULT = $result');
    return result;
  }

  void calibration(String text) {
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
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
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
        context: Get.overlayContext as BuildContext);
  }

  final TextEditingController textEditingController =
      new TextEditingController();
  // void _sendMessage(String text) async {
  //   print('SEND MESSAGE == $text');
  //   text = text.trim();
  //   textEditingController.clear();
  //
  //   if (text.length > 0) {
  //     try {
  //       connections!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
  //       await connections!.output.allSent;
  //     } catch (e) {}
  //   }
  // }

  // void sendMessage(String text) async {
  //   print('SEND MESSAGE == $text');
  //   text = text.trim();
  //   textEditingController.clear();
  //
  //   if (text.length > 0) {
  //     try {
  //       connections!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
  //       await connections!.output.allSent;
  //     } catch (e) {}
  //   }
  // }

  void energisedIconColorChange() {
    ts?.cancel();
    ts = null;
    tw?.cancel();
    tw = null;
    tw = Timer.periodic(Duration(milliseconds: 500), (timer) {
      energisedIconColor.value = !energisedIconColor.value;
      // VibrationHelper.orderSuccessVibrate();
    });
  }

  Future<void> energisedWarningDetectDialog(double value) async {
    Rx back = false.obs;
    energisedIconColorChange();
    AssetsAudioPlayer? warningAudio = AssetsAudioPlayer();
    // AssetsAudioPlayer? disconnectAudio = AssetsAudioPlayer();
    isCapture.value = false;
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    Future.delayed(
      Duration(seconds: 4),
      () {
        if (!back.value) {
          tw?.cancel();
          tw = null;
          VibrationHelper.cancelVibrate();
          if (Get.isDialogOpen == true) {
            warningAudio?.stop();
            warningAudio?.dispose();
            warningAudio = null;
            Get.back();
          }
          Future.delayed(
            Duration(milliseconds: 500),
            () {
              isCapture.value = true;
            },
          );
        }
      },
    );

    if (hasPlay.value) {
      warningAudio?.open(
        Audio('assets/sound/waring_sound.wav'),
        volume: 0.8,
      );

      Future.delayed(Duration(milliseconds: 800), () {
        warningAudio?.open(
          Audio('assets/sound/waring_sound.wav'),
          volume: 0.8,
        );
      });
      Future.delayed(Duration(milliseconds: 1300), () {
        warningAudio?.open(
          Audio('assets/sound/waring_sound.wav'),
          volume: 0.8,
        );
      });
    }
    double newSpeak = value / 1000;
    if (isLicenced.value) {
      Future.delayed(Duration(milliseconds: 1500), () {
        _speakDetect(
            'DANGER! Line is Energised \n\n\n\n\n Voltage is ${value <= 300 ? value.toInt() : newSpeak.toStringAsFixed(1)} ${value <= 300 ? 'volts' : 'Kilovolts'}');
      });
    }
    return CommonConstant.instance.commonShowDialogsWar(
        dialogThen: (value) {
          VibrationHelper.cancelVibrate();
          warningAudio?.stop();
          warningAudio?.dispose();
          warningAudio = null;

          back.value = true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Obx(
              () => Icon(
                Icons.warning_rounded,
                color: energisedIconColor.value
                    ? ColorConstant.redFF2
                    : ColorConstant.primaryYellow,
                size: getHeight(60),
              ),
            )),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.warningDetectedLong,
                textAlign: TextAlign.center,
                style: CTC.style(24,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.text00ToYellow(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.warningDetectedDes,
                textAlign: TextAlign.center,
                style: CTC.style(14,
                    fontColor: ColorConstant.textGrey4c4cToWhite(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
          ],
        ),
        firstButtonTitle: AppString.acknowledge,
        firstOnPressed: () {
          tw?.cancel();
          tw = null;
          warningAudio?.stop();
          warningAudio?.dispose();
          warningAudio = null;
          VibrationHelper.cancelVibrate();
          back.value = true;
          isCapture.value = true;

          Get.back();
        },
        context: Get.overlayContext as BuildContext);
  }

  void inductionsIconColorChange() {
    tw?.cancel();
    tw = null;
    ts?.cancel();
    ts = null;
    ts = Timer.periodic(Duration(milliseconds: 500), (timer) {
      inductionsIconColor.value = !inductionsIconColor.value;
    });
  }

  Future<void> inductionsWarningDetectDialog(
      BuildContext context, double value) async {
    AssetsAudioPlayer? warningSortAudio = AssetsAudioPlayer();
    isCapture.value = false;
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    Rx back = false.obs;
    inductionsIconColorChange();
    Future.delayed(
      Duration(seconds: 4),
      () {
        if (!back.value) {
          ts?.cancel();
          ts = null;
          VibrationHelper.cancelVibrate();
          if (Get.isDialogOpen == true) {
            print(
                '============================================================= OPEN');
            warningSortAudio?.stop();
            warningSortAudio?.dispose();
            warningSortAudio = null;
            Get.back();
          }
          Future.delayed(
            Duration(milliseconds: 500),
            () {
              isCapture.value = true;
            },
          );
        }
      },
    );
    if (hasPlay.value) {
      warningSortAudio?.open(Audio('assets/sound/waring_sound.wav'),
          volume: 0.15);

      Future.delayed(Duration(milliseconds: 900), () {
        warningSortAudio?.open(
          Audio('assets/sound/waring_sound.wav'),
          volume: 0.15,
        );
      });
      Future.delayed(Duration(milliseconds: 2000), () {
        warningSortAudio?.open(Audio('assets/sound/waring_sound.wav'),
            volume: 0.15);
      });
    }
    double newSpeak = value / 1000;
    if (isLicenced.value) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _speakDetect(
            'Warning: Induction Detected \n\n\n\n\n Voltage is ${value <= 300 ? value.toInt() : newSpeak.toStringAsFixed(1)} ${value <= 300 ? 'volts' : 'Kilovolts'}');
      });
    }
    return CommonConstant.instance.commonShowDialogsWar(
        dialogThen: (value) {
          VibrationHelper.cancelVibrate();
          print(
              '============================================================= OPEN');
          warningSortAudio?.stop();
          warningSortAudio?.dispose();
          warningSortAudio = null;
          back.value = true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Obx(
              () => Icon(
                Icons.warning_rounded,
                color: inductionsIconColor.value
                    ? ColorConstant.redFF2
                    : ColorConstant.primaryYellow,
                size: getHeight(60),
              ),
            )),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.warningDetected,
                textAlign: TextAlign.center,
                style: CTC.style(24,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.text00ToYellow(context)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                AppString.sortWarningDetectedDes,
                textAlign: TextAlign.center,
                style: CTC.style(14,
                    fontColor: ColorConstant.textGrey4c4cToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
          ],
        ),
        firstButtonTitle: AppString.acknowledge,
        firstOnPressed: () {
          Get.back();
          ts?.cancel();
          ts = null;
          warningSortAudio?.stop();
          warningSortAudio?.dispose();
          warningSortAudio = null;
          VibrationHelper.cancelVibrate();
          back.value = true;
          isCapture.value = true;
        },
        context: context);
  }

  void warningDialog({void Function()? onPressed}) {
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
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(15),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: onPressed ??
            () {
              isDisconnecting.value = true;
              isActiveScreen.value = false;
              // connections?.close();
              // connections?.dispose();
              isBack.value = true;
              Get.back();
            },
        secondButtonTitle: AppString.learn,
        secondOnPressed: onPressed ??
            () {
              isDisconnecting.value = true;
              // connections?.close();
              // connections?.dispose();
              isBack.value = true;

              Get.back();
            },
        context: Get.overlayContext as BuildContext);
  }

  void wrongUDialog(String value) {
    return CommonConstant.instance.commonShowDialogsUStatus(
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
                'Device access problem (u)',
                textAlign: TextAlign.center,
                style: CTC.style(18,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Center(
              child: Text(
                '($value)',
                textAlign: TextAlign.center,
                style: CTC.style(18,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(15),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: () {
          // if (connections?.isConnected == true) {
          isDisconnecting.value = true;
          // connections?.close();
          // connections?.dispose();
          print('DISPOSE++++++==== IS BACK');
          // }

          beepTimer?.cancel();
          beepTimer = null;
          hasBeepSound.value = false;
          disconnectTimer?.cancel();
          disconnectTimer = null;
          disconnectAudioTimer?.cancel();
          disconnectAudioTimer = null;
          flutterTts.stop();

          Get.back();
          Get.back();
        },
        context: Get.overlayContext as BuildContext);
  }

  /// homeController

  Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;

  // RxList<BluetoothDiscoveryResult> results =
  //     RxList<BluetoothDiscoveryResult>.empty(growable: true);
  RxList<BluetoothDiscoveryResult> checkResults =
      RxList<BluetoothDiscoveryResult>.empty(growable: true);

  StreamSubscription<BluetoothDiscoveryResult>? streamSubscription;

  Rx<b.BluetoothDevice> selectedDevices =
      b.BluetoothDevice(remoteId: b.DeviceIdentifier('')).obs;
  Rx<b.BluetoothDevice> selectedDevicesLast =
      b.BluetoothDevice(remoteId: b.DeviceIdentifier('')).obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController licenceKeyController = TextEditingController();

  List<_Message> messages = List<_Message>.empty(growable: true);
  RxBool isDiscovering = false.obs;
  RxBool isLicenseKeyLoading = true.obs;
  RxBool searchOnBluetooth = false.obs;
  RxBool isLicenseKeyDialogOpen = false.obs;

  RxBool selectedDeviceLoading = false.obs;
  RxInt selectedDevice = (-1).obs;
  RxString connectedDevice = ''.obs;
  RxString address = ''.obs;
  RxList<CreateLog> storeDataList = <CreateLog>[].obs;
  BluetoothConnection? connection;

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
        isLicenseKeyDialogOpen.value = false;
        if ((connectedDevice.value == '' || connectedDevice.value.isEmpty) ||
            !bluetoothState.value.isEnabled) {
          print('ffffffffffffff  ${connectedDevice.value}');

          warningDialog();
          selectedDevices.value =
              b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
          connectedDevice.value = "";
        } else {
          if (isLicenced.value) {
            print(
                '=================================================================================');

            ProgressDialogUtils.hideProgressDialog();
            print('isLicenced.value  ${isLicenced.value}');
            messagesListConsoleHome.add(
              _Message(
                1,
                '=====> licence is accepted(${isLicencedDate.value})',
              ),
            );
            ProgressDialogUtils.showTitleSnackBar(
                headerText:
                    'Your licence is accepted (${isLicencedDate.value})');
            if (storeDataList.length > 250 && storeDataList.length < 299) {
              reachingLogsLimit();
              messagesListConsoleHome.add(
                _Message(
                  1,
                  '=====> LOG LIMIT (250/299)',
                ),
              );
              print('REACHINGLOGLIMIT LLLLLLLLLLLLLLLLLLL');
            } else {
              if (storeDataList.length == 300) {
                print('LOGLIMITRICHED MMMMMMMMMMMMMMMMMM');
                messagesListConsoleHome.add(
                  _Message(
                    1,
                    '=====> LOG LIMIT (300)',
                  ),
                );
                logsLimitReached();
              } else {
                if (!isCalibration.value) {
                  ProgressDialogUtils.hideProgressDialog();
                  messagesListConsoleHome.add(
                    _Message(
                      1,
                      '=====> logTestScreenRoute',
                    ),
                  );
                  screen.value = '1';
                  Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
                    'server': selectedDevices.value,
                    'connectedDevice': connectedDevice.value
                  });
                } else {
                  calibration(AppString.attentionCalibrationDes);
                }
              }
            }
          } else {
            print(
                '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
            messagesListConsoleHome.add(
              _Message(
                1,
                '=====> _sendMessage(J)',
              ),
            );
            isLogTestScreen.value = true;
            ProgressDialogUtils.showProgressDialogSmall(isCancellable: false);
            getStoreData();
            _sendMessage('j');
          }
          // getChat();
        } // do something
        break;
      case 'measureVolts':
        // final temp =
        //     await BluetoothConnection.toAddress(selectedDevices.value.address);
        // print('DEVICE IS CONNECT = ${temp.isConnected}');
        if (bluetoothState.value.isEnabled) {
          if (connectedDevice.value == '' || connectedDevice.value.isEmpty) {
            warningDialog();
          } else {
            if (isProtection.value) {
              if (!isCalibration.value) {
                isLogTestScreen.value = false;
                disconnectButton.value = false;

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
              } else {
                calibration(AppString.attentionCalibrationDes);
              }
            } else {
              ProgressDialogUtils.showTitleSnackBar(
                  headerText: 'Data Protection is On');
            }
          }
        } else {
          warningDialog();
          selectedDevices.value =
              b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
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
        try {
          isLicenseKeyDialogOpen.value = false;
          if (connectedDevice.isNotEmpty || connectedDevice.value != "") {
            disconnectButton.value = true;
            _disconnectDevice();
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
            _devices.refresh();
            hasReconnect.value = false;
            connections?.close();
            connections?.dispose();
            selectedDevices.value =
                b.BluetoothDevice(remoteId: b.DeviceIdentifier(''));
            connectedDevice.value = '';
            isLicencedDate.value = '';
            isLicenced.value = false;
            isLogTestScreen.value = false;
          } else {
            RxBool result = false.obs;
            RxBool resultLocation = false.obs;
            resultLocation.value = await getCurrentLatLong();
            if (resultLocation.value) {
              result.value = await connectPermission();
            }
            if (resultLocation.value && result.value) {
              print('address.value.isEmpty ${address.value.isEmpty}');
              if (!bluetoothState.value.isEnabled) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  await FlutterBluetoothSerial.instance
                      .requestEnable()
                      .then((value) async {
                    if (value == true) {
                      isDiscovering.value = true;
                      // checkDiscovery();
                      _devices.clear();
                      _startScan();
                      await deviceDialog(context);
                    }
                  });
                });
              } else {
                isDiscovering.value = true;
                if (isDiscovering.value) {
                  _devices.clear();

                  _startScan();
                  // checkDiscovery();
                }
                await deviceDialog(context);
              }
              // } else {
              //   checkDiscovery();
              // }
            }
          }
        } on Exception catch (e) {
          print(' ERRORRR  = ${e.toString()}');
        }
        break;
      case 'setting':
        passwordController.clear();
        enterPinDialog();
        // do something else
        break;
    }
  }

  void deviceSelect(int index) {
    selectedDevice.value = index;
    selectedDeviceLoading.value = true;
  }

  BluetoothConnection? connections;

  Future deviceDialog(BuildContext context) {
    if (Get.isDialogOpen == true) {
      Get.back();
      FlutterBluetoothSerial.instance.cancelDiscovery();
    }
    return Get.dialog(
      LayoutBuilder(
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
                    : _devices.isEmpty
                        ? Center(
                            child: Text(
                              'Devices not found!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: CTC.style(21,
                                  fontWeight: FontWeight.w500,
                                  fontColor:
                                      ColorConstant.textBlackToWhite(context)),
                            ),
                          )
                        : ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: _devices.length,
                            itemBuilder: ((context, index) {
                              b.BluetoothDevice result = _devices[index];
                              final device = result;
                              // final addresses = device.address;

                              return Obx(
                                () => Bounce(
                                  onTap: () async {
                                    deviceSelect(index);
                                    _connectToDevice(device);
                                    selectedDevicesLast.value = device;

                                    // try {
                                    //   bool bonded = false;
                                    //
                                    //   if (device.isBonded) {
                                    //     await BluetoothConnection.toAddress(
                                    //             device.address)
                                    //         .then((value) {
                                    //       connections = value;
                                    //       connectedDevice.value =
                                    //           device.name != null &&
                                    //                   device.name!.isNotEmpty
                                    //               ? device.name ?? ''
                                    //               : device.address ?? '';
                                    //       selectedDevices.value = result.device;
                                    //       selectedDevicesLast.value = device;
                                    //       isLicenced.value = false;
                                    //       bluetoothStart();
                                    //       selectedDeviceLoading.value = false;
                                    //
                                    //       Navigator.of(context).pop();
                                    //     }).catchError((e) {
                                    //       Get.back();
                                    //       selectedDeviceLoading.value = false;
                                    //
                                    //       ProgressDialogUtils.showTitleSnackBar(
                                    //           headerText: 'Please try again!');
                                    //     });
                                    //   } else {
                                    //     FlutterBluetoothSerial.instance
                                    //         .setPairingRequestHandler(
                                    //             (BluetoothPairingRequest
                                    //                 request) {
                                    //       print(
                                    //           "Trying to auto-pair with Pin 1234");
                                    //       if (request.pairingVariant ==
                                    //           PairingVariant.Pin) {
                                    //         return Future.value("1234");
                                    //       }
                                    //       return Future.value(null);
                                    //     });
                                    //
                                    //     print(
                                    //         'Bonding with ${device.address}...');
                                    //     bonded = (await FlutterBluetoothSerial
                                    //         .instance
                                    //         .bondDeviceAtAddress(addresses))!;
                                    //
                                    //     results[results.indexOf(result)] =
                                    //         BluetoothDiscoveryResult(
                                    //             device: BluetoothDevice(
                                    //               name: device.name ?? '',
                                    //               address: addresses,
                                    //               type: device.type,
                                    //               bondState: bonded
                                    //                   ? BluetoothBondState
                                    //                       .bonded
                                    //                   : BluetoothBondState.none,
                                    //             ),
                                    //             rssi: result.rssi);
                                    //     results.refresh();
                                    //
                                    //     await BluetoothConnection.toAddress(
                                    //             device.address)
                                    //         .then((value) {
                                    //       connections = value;
                                    //       if (bonded == true) {
                                    //         isLicenced.value = false;
                                    //
                                    //         bluetoothStart();
                                    //
                                    //         connectedDevice.value =
                                    //             device.name != null &&
                                    //                     device.name!.isNotEmpty
                                    //                 ? device.name ?? ''
                                    //                 : device.address ?? '';
                                    //         selectedDevices.value =
                                    //             result.device;
                                    //         selectedDevicesLast.value = device;
                                    //       }
                                    //       selectedDeviceLoading.value = false;
                                    //       print(
                                    //           'BLUETOOTH START = ${connections?.isConnected}');
                                    //       Navigator.of(context).pop();
                                    //     }).catchError((e) {
                                    //       Get.back();
                                    //       selectedDeviceLoading.value = false;
                                    //       ProgressDialogUtils.showTitleSnackBar(
                                    //           headerText: 'Please try again!');
                                    //     });
                                    //   }
                                    //
                                    //   // checkDiscovery();
                                    //
                                    //   print(selectedDevices.value.isConnected);
                                    //   print(selectedDevices.value.isBonded);
                                    // } catch (ex) {
                                    //   selectedDeviceLoading.value = false;
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         title: const Text(
                                    //             'Error occured while bonding'),
                                    //         content: Text("${ex.toString()}"),
                                    //         actions: <Widget>[
                                    //           new TextButton(
                                    //             child: new Text("Close"),
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop();
                                    //             },
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: getHeight(5)),
                                    decoration: BoxDecoration(
                                        color: selectedDevice.value == index
                                            ? ColorConstant.backGroundGreyColor
                                            : ColorConstant.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getWidth(20),
                                        vertical: getHeight(7)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            device.name.isNotEmpty
                                                ? device.name ?? ''
                                                : 'Unknown Device',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: CTC.style(21,
                                                fontWeight: FontWeight.w500,
                                                fontColor: selectedDevice
                                                            .value ==
                                                        index
                                                    ? ColorConstant.textBlack
                                                    : ColorConstant
                                                        .textBlackToWhite(
                                                            context)),
                                          ),
                                        ),
                                        if (selectedDevice.value == index &&
                                            selectedDeviceLoading.value)
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CupertinoActivityIndicator(
                                                color:
                                                    ColorConstant.primaryBlack),
                                          )
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
                  _stopScan();
                  // FlutterBluetoothSerial.instance.cancelDiscovery();
                  selectedDevice.value = (-1);
                  Get.back();
                }),
            SizedBox(
              height: getHeight(10),
            ),
          ],
        ),
      ),
    ).then((value) {
      selectedDevice.value = (-1);

      selectedDeviceLoading.value = false;
    });

    // return showDialog(
    //   context: context,
    //   builder: (BuildContext context) => LayoutBuilder(
    //     builder: (context, constraints) => SimpleDialog(
    //       backgroundColor: ColorConstant.containerBackGround(context),
    //       surfaceTintColor: Colors.transparent,
    //       insetPadding: EdgeInsets.symmetric(horizontal: getWidth(20)),
    //       contentPadding: EdgeInsets.symmetric(
    //           horizontal: getWidth(25), vertical: getHeight(30)),
    //       children: [
    //         Text(
    //           AppString.deviceList,
    //           style: CTC.style(26,
    //               fontWeight: FontWeight.w600,
    //               fontColor: ColorConstant.textBlackToYellow(context)),
    //         ),
    //         SizedBox(
    //           height: getHeight(10),
    //         ),
    //         SizedBox(
    //           height: constraints.maxHeight * .18, // 70% height
    //           width: constraints.maxWidth * .9,
    //           child: Obx(
    //             () => isDiscovering.value
    //                 ? Center(
    //                     child: SizedBox(
    //                         height: getHeight(20),
    //                         width: getWidth(20),
    //                         child: CircularProgressIndicator()))
    //                 : results.isEmpty
    //                     ? Center(
    //                         child: Text(
    //                           'Devices not found!',
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 1,
    //                           style: CTC.style(21,
    //                               fontWeight: FontWeight.w500,
    //                               fontColor:
    //                                   ColorConstant.textBlackToWhite(context)),
    //                         ),
    //                       )
    //                     : ListView.builder(
    //                         // physics: NeverScrollableScrollPhysics(),
    //                         itemCount: results.length,
    //                         itemBuilder: ((context, index) {
    //                           BluetoothDiscoveryResult result = results[index];
    //                           final device = result.device;
    //                           final addresses = device.address;
    //
    //                           return Obx(
    //                             () => Bounce(
    //                               onTap: () async {
    //                                 deviceSelect(index);
    //                                 try {
    //                                   bool bonded = false;
    //                                   print(
    //                                       '0000000000000000000000 ${device.isBonded}');
    //                                   print(
    //                                       '0000000000000000000000 ${device.address}');
    //
    //                                   if (device.isBonded) {
    //                                     await BluetoothConnection.toAddress(
    //                                             device.address)
    //                                         .then((value) {
    //                                       print(
    //                                           'safddddddddddddddddddddddddddddddddd');
    //                                       connections = value;
    //                                       connectedDevice.value =
    //                                           device.name != null &&
    //                                                   device.name!.isNotEmpty
    //                                               ? device.name ?? ''
    //                                               : device.address ?? '';
    //                                       selectedDevices.value = result.device;
    //                                       selectedDevicesLast.value = device;
    //                                       bluetoothStart();
    //                                       selectedDeviceLoading.value = false;
    //                                       print(
    //                                           'BLUETOOTH START = ${connections?.isConnected}');
    //                                       Navigator.of(context).pop();
    //                                     }).catchError((e) {
    //                                       Get.back();
    //                                       selectedDeviceLoading.value = false;
    //
    //                                       ProgressDialogUtils.showTitleSnackBar(
    //                                           headerText: 'Please try again!');
    //
    //                                       print(
    //                                           'Error BLUETOOTH OFF  = ${e.toString()}');
    //                                     });
    //
    //                                     // Navigator.of(context).pop();
    //                                     // print(
    //                                     //     'Unbonding from ${device.address}...');
    //                                     // var res = await FlutterBluetoothSerial
    //                                     //     .instance
    //                                     //     .removeDeviceBondWithAddress(addresses);
    //                                     // print(
    //                                     //     'Unbonding from ${device.address} has succed');
    //                                     // print('Unbonding from ${res} has succed');
    //                                     // selectedDevices.value = result.device;
    //                                     // connectedDevice.value = '';
    //                                   } else {
    //                                     FlutterBluetoothSerial.instance
    //                                         .setPairingRequestHandler(
    //                                             (BluetoothPairingRequest
    //                                                 request) {
    //                                       print(
    //                                           "Trying to auto-pair with Pin 1234");
    //                                       if (request.pairingVariant ==
    //                                           PairingVariant.Pin) {
    //                                         return Future.value("1234");
    //                                       }
    //                                       return Future.value(null);
    //                                     });
    //
    //                                     print(
    //                                         'Bonding with ${device.address}...');
    //                                     bonded = (await FlutterBluetoothSerial
    //                                         .instance
    //                                         .bondDeviceAtAddress(addresses))!;
    //
    //                                     print(
    //                                         'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
    //                                     // Navigator.of(context).pop();
    //                                     results[results.indexOf(result)] =
    //                                         BluetoothDiscoveryResult(
    //                                             device: BluetoothDevice(
    //                                               name: device.name ?? '',
    //                                               address: addresses,
    //                                               type: device.type,
    //                                               bondState: bonded
    //                                                   ? BluetoothBondState
    //                                                       .bonded
    //                                                   : BluetoothBondState.none,
    //                                             ),
    //                                             rssi: result.rssi);
    //                                     results.refresh();
    //
    //                                     await BluetoothConnection.toAddress(
    //                                             device.address)
    //                                         .then((value) {
    //                                       connections = value;
    //                                       if (bonded == true) {
    //                                         bluetoothStart();
    //
    //                                         connectedDevice.value =
    //                                             device.name != null &&
    //                                                     device.name!.isNotEmpty
    //                                                 ? device.name ?? ''
    //                                                 : device.address ?? '';
    //                                         selectedDevices.value =
    //                                             result.device;
    //                                         selectedDevicesLast.value = device;
    //                                       }
    //                                       selectedDeviceLoading.value = false;
    //                                       print(
    //                                           'BLUETOOTH START = ${connections?.isConnected}');
    //                                       Navigator.of(context).pop();
    //                                     }).catchError((e) {
    //                                       Get.back();
    //                                       selectedDeviceLoading.value = false;
    //                                       ProgressDialogUtils.showTitleSnackBar(
    //                                           headerText: 'Please try again!');
    //                                       print(
    //                                           'Error BLUETOOTH OFF  = ${e.toString()}');
    //                                     });
    //                                   }
    //
    //                                   // checkDiscovery();
    //
    //                                   print(selectedDevices.value.isConnected);
    //                                   print(selectedDevices.value.isBonded);
    //                                 } catch (ex) {
    //                                   selectedDeviceLoading.value = false;
    //                                   showDialog(
    //                                     context: context,
    //                                     builder: (BuildContext context) {
    //                                       return AlertDialog(
    //                                         title: const Text(
    //                                             'Error occured while bonding'),
    //                                         content: Text("${ex.toString()}"),
    //                                         actions: <Widget>[
    //                                           new TextButton(
    //                                             child: new Text("Close"),
    //                                             onPressed: () {
    //                                               Navigator.of(context).pop();
    //                                             },
    //                                           ),
    //                                         ],
    //                                       );
    //                                     },
    //                                   );
    //                                 }
    //
    //                                 // deviceSelect(index);
    //                                 // connectedDevice.value = deviceList[index];
    //                                 // licenseKeyDialog(context);
    //                               },
    //                               child: Container(
    //                                 margin: EdgeInsets.only(top: getHeight(5)),
    //                                 decoration: BoxDecoration(
    //                                     color: selectedDevice.value == index
    //                                         ? ColorConstant.backGroundGreyColor
    //                                         : ColorConstant.transparent,
    //                                     borderRadius:
    //                                         BorderRadius.circular(10)),
    //                                 padding: EdgeInsets.symmetric(
    //                                     horizontal: getWidth(20),
    //                                     vertical: getHeight(7)),
    //                                 child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     Expanded(
    //                                       child: Text(
    //                                         device.name != null &&
    //                                                 device.name!.isNotEmpty
    //                                             ? device.name ?? ''
    //                                             : device.address ?? '',
    //                                         overflow: TextOverflow.ellipsis,
    //                                         maxLines: 1,
    //                                         style: CTC.style(21,
    //                                             fontWeight: FontWeight.w500,
    //                                             fontColor: selectedDevice
    //                                                         .value ==
    //                                                     index
    //                                                 ? ColorConstant.textBlack
    //                                                 : ColorConstant
    //                                                     .textBlackToWhite(
    //                                                         context)),
    //                                       ),
    //                                     ),
    //                                     if (selectedDevice.value == index &&
    //                                         selectedDeviceLoading.value)
    //                                       SizedBox(
    //                                         height: 20,
    //                                         width: 20,
    //                                         child: CupertinoActivityIndicator(
    //                                             color:
    //                                                 ColorConstant.primaryBlack),
    //                                       )
    //                                     // if (device.isBonded)
    //                                     //   Expanded(
    //                                     //     child: Text(
    //                                     //       'Disconnected',
    //                                     //       overflow: TextOverflow.ellipsis,
    //                                     //       maxLines: 1,
    //                                     //       style: CTC.style(16,
    //                                     //           fontWeight: FontWeight.w500,
    //                                     //           fontColor:
    //                                     //               selectedDevice.value == index
    //                                     //                   ? ColorConstant.textBlack
    //                                     //                   : ColorConstant
    //                                     //                       .textBlackToWhite(
    //                                     //                           context)),
    //                                     //     ),
    //                                     //   ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         }),
    //                       ),
    //           ),
    //         ),
    //         SizedBox(
    //           height: getHeight(10),
    //         ),
    //         AppElevatedButton(
    //             buttonName: AppString.cancel,
    //             onPressed: () {
    //               FlutterBluetoothSerial.instance.cancelDiscovery();
    //               selectedDevice.value = (-1);
    //               Get.back();
    //             }),
    //         SizedBox(
    //           height: getHeight(10),
    //         ),
    //       ],
    //     ),
    //   ),
    // ).then((value) {
    //   selectedDevice.value = (-1);
    //
    //   selectedDeviceLoading.value = false;
    // });
  }

  void getStoreData() {
    Box<CreateLog> itemBox = DbHelper.getData();
    storeDataList.clear();
    itemBox.values.forEach((element) {
      storeDataList.add(element);
    });
  }

  // Future<void> checkDiscovery() async {
  //   bool result = await connectPermission();
  //
  //   if (result) {
  //     streamSubscription?.cancel();
  //     checkResults.clear();
  //     searchOnBluetooth.value = true;
  //     print('SRART SEARCHING =======================');
  //     streamSubscription =
  //         FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
  //       final existingIndex = checkResults.indexWhere(
  //           (element) => element.device.address == r.device.address);
  //
  //       final existingIndex1 = results.indexWhere(
  //           (element) => element.device.address == r.device.address);
  //       if (existingIndex1 >= 0)
  //         results[existingIndex1] = r;
  //       else
  //         results.add(r);
  //       results.refresh();
  //       if (existingIndex >= 0) {
  //         checkResults[existingIndex] = r;
  //       } else {
  //         checkResults.add(r);
  //         checkResults.forEach((element) {
  //           print(
  //               'DEVICE ADDRESS   ${element.device.address} BLUETOOTH NAME = ${element.device.name}  isBonded ${element.device.isBonded}');
  //
  //           if (element.device.isBonded == true) {
  //             // address.value = element.device.address;
  //             // connectedDevice.value = element.device.name ?? '';
  //             // selectedDevices.value = element.device;
  //
  //             // FlutterBluetoothSerial.instance
  //             //     .removeDeviceBondWithAddress(element.device.address);
  //             // address.value = '';
  //             // connectedDevice.value = '';
  //             searchOnBluetooth.value = false;
  //             print('CONNECTED BLUETOOTH ADDRESS   ${address.value}');
  //             print('CONNECTED BLUETOOTH NAME   ${element.device.name}');
  //             FlutterBluetoothSerial.instance.cancelDiscovery();
  //           }
  //         });
  //         checkResults.refresh();
  //       }
  //     });
  //
  //     streamSubscription!.onDone(() {
  //       searchOnBluetooth.value = false;
  //
  //       print('END SEARCHING =======================');
  //
  //       isDiscovering.value = false;
  //     });
  //   }
  // }

  void enterPinDialog() {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.enterPin,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
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
                    fontColor: ColorConstant.textBlackToWhite(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
            Text(
              AppString.securityPin,
              style: CTC.style(14,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.textBlackToWhite(
                      Get.overlayContext as BuildContext)),
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
        context: Get.overlayContext as BuildContext);
  }

  void passwordCheck() {
    String? password =
        CommonConstant.instance.dbHelper.box.get(HiveKey.settingPassword);
    if (passwordController.text.isEmpty) {
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.enterPassword, color: ColorConstant.textRedFF);
    } else if (passwordController.text == '9112232') {
      Get.back();
      Get.toNamed(AppRoutes.settingScreenRoute);
    }
    // else if (
    //     passwordController.text == '9112232') {
    //   verifyPin(passwordController.text);
    // }
    else {
      verifyPin(passwordController.text);
      // ProgressDialogUtils.showTitleSnackBar(
      //     headerText: AppString.passwordInvalid,
      //     color: ColorConstant.textRedFF);
    }
  }

  Future<void> verifyPin(String pin) async {
    await ApiService().callPostsApi(
        body: {
          "pin": pin,
        },
        headerWithToken: true,
        showLoader: true,
        url: '${baseUrl}/verifyPin').then((value) {
      if (value != null && value["status"] == 1) {
        // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
        Get.back();
        Get.toNamed(AppRoutes.settingScreenRoute);
      } else {
        ProgressDialogUtils.showTitleSnackBar(headerText: value["message"]);
      }
    });
  }

  void reachingLogsLimit() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.reachingLogsLimit,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.text00ToYellow(
                        Get.overlayContext as BuildContext)),
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
                    fontColor: ColorConstant.textGrey4c4cToWhite(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
          ],
        ),
        firstButtonTitle: AppString.ok,
        firstOnPressed: () {
          screen.value = '1';
          ProgressDialogUtils.hideProgressDialog();

          Get.back();
          Get.toNamed(AppRoutes.logTestScreenRoute, arguments: {
            'server': selectedDevices.value,
            'connectedDevice': connectedDevice.value
          });
        },
        context: Get.overlayContext as BuildContext);
  }

  Future<bool> connectPermission() async {
    var status = await Permission.bluetoothConnect.status;
    var status1 = await Permission.bluetoothScan.status;
    if (status.isDenied || status1.isDenied) {
      await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
      // Permission.bluetoothScan.request();
      return false;
    } else if (status.isPermanentlyDenied ||
        status.isRestricted ||
        status1.isPermanentlyDenied ||
        status1.isRestricted) {
      CommonConstant.instance.CustomCupertinoAlertDilouge(
          context: Get.overlayContext as BuildContext,
          Header: "Permission Denied",
          subTitle: "Allow access to Nearby device Permission",
          yesButtonText: "yesButtonText",
          noButtonText: "noButtonText",
          yesButtonTap: () async {
            Get.back();
            await openAppSettings().whenComplete(() {});
          },
          cancelButtonTap: () {
            Get.back();
          });
      return false;
    } else if (status.isGranted && status1.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void syncData() {
    reachingLogsLimit();
  }

  void logsLimitReached() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.reachingLogsLimitReached,
                style: CTC.style(21,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.text00ToYellow(
                        Get.overlayContext as BuildContext)),
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
                    fontColor: ColorConstant.textGrey4c4cToWhite(
                        Get.overlayContext as BuildContext)),
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
            ProgressDialogUtils.hideProgressDialog();
            screen.value = '1';
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
        context: Get.overlayContext as BuildContext);
  }

  void licenseKeyDialog() {
    isLicenseKeyDialogOpen.value = true;
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
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
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
                    fontColor: ColorConstant.textGrey4c4cToWhite(
                        Get.overlayContext as BuildContext)),
              ),
            ),
            SizedBox(
              height: getHeight(24),
            ),
            Text(
              AppString.licenseKey,
              style: CTC.style(16,
                  fontColor: ColorConstant.text00ToWhite(
                      Get.overlayContext as BuildContext),
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
        context: Get.overlayContext as BuildContext);
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
      _sendMessage('q${licenceKeyController.text}');
      isLicenseKeyDialogOpen.value = false;

      // ProgressDialogUtils.showTitleSnackBar(
      //     headerText: AppString.enterLicenseKeysValid,
      //     color: ColorConstant.textRedFF);
    }
  }

  void checkWarningDialog(String text) {
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
                    fontColor: ColorConstant.textBlackToYellow(
                        Get.overlayContext as BuildContext)),
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
        context: Get.overlayContext as BuildContext);
  }

  RxList<CreateLog> itemLists = <CreateLog>[].obs;
  RxList<Map<String, dynamic>> itemListsSend = <Map<String, dynamic>>[].obs;

  loadList(Box<CreateLog> box) {
    itemLists.value = [];
    itemLists.value.addAll(box.values);
    // itemLists.value = itemLists.value.reversed.toList();

    for (var item in itemLists.value) {
      itemListsSend.add({
        "testType": item.testType,
        "logNumber": item.logNumber,
        "fullName": item.fullName,
        "pTSNumber": item.pTSNumber,
        "companyName": item.companyName,
        "formBNumber": item.formBNumber,
        "formCNumber": item.formCNumber,
        "location": item.location,
        "gpsLocation": item.gpsLocation,
        "deviceSerialNumber": item.deviceSerialNumber,
        "startUp": item.startUp,
        "voltsDetected": item.voltsDetected,
        "duration": item.duration,
        "voltsHighest": item.voltsHighest,
        "voltsLowest": item.voltsLowest,
        "notes": item.notes,
        "photoPath": item.photoPath,
        "date": item.date,
        "isBatteryCalibration": item.isBatteryCalibration,
        "isInductionEnr": item.isInductionEnr
      });
    }

    if (itemLists.isNotEmpty) {
      syncDataToServer();
    }
  }
  Future<void> syncDataToServer() async {

    // Remove duplicate logNumber
    final uniqueMap = <String, Map<String, dynamic>>{};

    for (var item in itemListsSend) {

      String logNumber =
      item['logNumber'].toString().trim();

      // Store only unique logNumber
      uniqueMap[logNumber] = item;
    }

    // Final unique list
    final uniqueList = uniqueMap.values.toList();

    log(jsonEncode({"data": uniqueList}));

    await ApiService().callPostsApi(
      body: {"data": uniqueList},
      headerWithToken: true,
      showLoader: true,
      url: '${baseUrl}/addLogData',
    ).then((value) async {

      if (value != null && value["status"] == 1) {

        await DbHelper.clearLogModelBox();

        await DbHelper.getData().flush();

        itemListsSend.clear();

        ProgressDialogUtils.showTitleSnackBar(
          headerText: 'Data sync successfully!',
        );

      } else {

        ProgressDialogUtils.showTitleSnackBar(
          headerText: value["message"],
        );
      }
    });
  }
  // Future<void> syncDataToServer() async {
  //   log('${jsonEncode({"data": itemListsSend})}');
  //
  //   await ApiService().callPostsApi(
  //       body: {"data": itemListsSend},
  //       headerWithToken: true,
  //       showLoader: true,
  //       url: '${baseUrl}/addLogData').then((value) async {
  //     if (value != null && value["status"] == 1) {
  //       // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
  //
  //
  //       await   DbHelper.clearLogModelBox();
  //       // DbHelper.getData().delete(key);
  //     await  DbHelper.getData().flush();
  //
  //       ProgressDialogUtils.showTitleSnackBar(
  //           headerText: 'Data sync successfully!');
  //     } else {
  //       ProgressDialogUtils.showTitleSnackBar(headerText: value["message"]);
  //     }
  //   });
  // }

  Future<void> syncStatus({required String event,required String device,required String status}) async {
    await ApiService().callPostsApi(
        body: {
          "event" : event,
          "device" : device,
          "dateTime" : DateFormat("yyyy-MM-dd, hh:mm").format(DateTime.now()),
          "status" : status
        },
        headerWithToken: true,
        showLoader: false,
        url: '${baseUrl}/addNotification').then((value) {
      if (value != null && value["status"] == 1) {
        // // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
        // DbHelper.clearLogModelBox();
        //
        // ProgressDialogUtils.showTitleSnackBar(
        //     headerText: 'Data sync successfully!');
      } else {
        // ProgressDialogUtils.showTitleSnackBar(headerText: value["message"]);
      }
    });
  }
}

class HomeMenu {
  const HomeMenu(
      {required this.title, required this.image, required this.type});
  final String title;
  final String image;
  final String type;
}
