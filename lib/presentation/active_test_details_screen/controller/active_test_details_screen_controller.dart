import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/hive_helper.dart';
import '../../../core/utils/progress_dialog_utils.dart';

class ActiveTestDetailScreenController extends GetxController {
  dynamic argumentData = Get.arguments;
  RxString kv = ''.obs;
  RxString voltsDetect = ''.obs;
  RxString startUp = ''.obs;
  RxString duration = ''.obs;

  RxString highest = ''.obs;
  RxString lowest = ''.obs;
  RxString image = ''.obs;
  Rx<XFile> photoPath = XFile('').obs;
  RxList<CreateLog> storeDataList = <CreateLog>[].obs;
  RxList<CreateLog> storeDataListLastFiveDataBox = <CreateLog>[].obs;

  /// Test form data
  RxString testType = ''.obs;
  RxString name = ''.obs;
  RxString ptsNumber = ''.obs;
  RxString companyName = ''.obs;
  RxString depot = ''.obs;
  RxString formBNumber = ''.obs;
  RxString formCNumber = 'Not Entered'.obs;
  RxString location = 'Not Entered'.obs;
  RxString locationGPS = ''.obs;
  RxString isBatteryCalibration = ''.obs;
  RxString isInductionEnr = ''.obs;
  RxString connectedDevice = ''.obs;

  TextEditingController noteController = TextEditingController();
  RxString textLength = '0'.obs;

  Future<void> pickImages(ImageSource source) async {
    var result = await CommonConstant.instance.requestFilePermission();
    if (result) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        photoPath.value = pickedFile;
        image.value = File(pickedFile.name)
            .toString()
            .replaceAll('File:', '')
            .replaceAll('\'', '')
            .replaceAll('null', '');
        Get.back();
      } else {
        print('No image selected.');
      }
    } else {
      openAppSettings();
    }
  }

  @override
  void onInit() {
    getStoreData();

    if (argumentData != null) {
      kv.value = argumentData[0]['kv'];
      voltsDetect.value = argumentData[1]['volts_detect'];
      duration.value = argumentData[2]['duration'];
      highest.value = argumentData[3]['highest'];
      lowest.value = argumentData[4]['lowest'];
      startUp.value = argumentData[5]['startUp'];

      /////////////////////
      testType.value = argumentData[6]['test_type'];
      name.value = argumentData[6]['name'];
      ptsNumber.value = argumentData[6]['pts_number'];
      companyName.value = argumentData[6]['company_name'];
      depot.value = argumentData[6]['depot'];
      formBNumber.value = argumentData[6]['form_b'];
      formCNumber.value = argumentData[6]['form_c'];
      location.value = argumentData[6]['location'];
      connectedDevice.value = argumentData[6]['connectedDevice'];
      locationGPS.value = argumentData[6]['locationGPS'];
      isBatteryCalibration.value = argumentData[6]['isBatteryCalibration'];
      isInductionEnr.value = argumentData[6]['isInductionEnr'];
    }
    super.onInit();
  }

  void getStoreData() {
    Box<CreateLog> itemBox = DbHelper.getData();
    itemBox.values.forEach((element) {
      storeDataList.add(element);
    });
    Box<CreateLog> itemBoxLastFiveDataBox = DbHelper.getDataLastFiveDataBox();
    itemBoxLastFiveDataBox.values.forEach((element) {
      storeDataListLastFiveDataBox.add(element);
    });
  }

  // Future<Uint8List> imagePathToBytes(String path) async {
  //   final file = File(path);
  //   if (await file.exists()) {
  //     return await file.readAsBytes();
  //   } else {
  //     throw Exception("File does not exist at path: $path");
  //   }
  // }
  // Future<void> createLog() async {
  //   print('sdf');
  //   var number = "";
  //   var randomnumber = Random();
  //   //chnage i < 15 on your digits need
  //   for (var i = 0; i < 9; i++) {
  //     number = number + randomnumber.nextInt(9).toString();
  //   }
  //   Uint8List? imageBytes;
  //   String imagePath = '/storage/emulated/0/Download/Image${DateTime.now()}.jpg'; // your image path
  //   try {
  //      imageBytes = await imagePathToBytes(imagePath);
  //     print('Image size: ${imageBytes} bytes');
  //     print('Image size: ${imageBytes.length} bytes');
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  //   final createLog = CreateLog(
  //       companyName: companyName.value,
  //       deviceSerialNumber: connectedDevice.value,
  //       isBatteryCalibration: isBatteryCalibration.value,
  //       isInductionEnr: isInductionEnr.value,
  //       duration: duration.value,
  //       formBNumber: formBNumber.value,
  //       formCNumber: formCNumber.value,
  //       fullName: name.value,
  //       gpsLocation: locationGPS.value,
  //       location: location.value,
  //       logNumber: number,
  //       notes:
  //           noteController.text.isEmpty ? 'Not Entered' : noteController.text,
  //       pTSNumber: ptsNumber.value,
  //       startUp: startUp.value,
  //       voltsDetected: voltsDetect.value,
  //       testType: testType.value,
  //       voltsHighest: highest.value,
  //       // photoPath: photoPath.value.path,
  //       photoPath: imageBytes.toString(),
  //       date: DateFormat("dd-MM-yy").format(DateTime.now()),
  //       voltsLowest: lowest.value);
  //   if (storeDataList.length == 300) {
  //     DbHelper.getData().deleteAt(0);
  //     DbHelper.getData().add(createLog);
  //     Get.toNamed(AppRoutes.logListScreenRoute, arguments: [
  //       {'isBack': true}
  //     ]);
  //
  //     ProgressDialogUtils.showTitleSnackBar(headerText: AppString.dataSaved);
  //   } else {
  //     Get.toNamed(AppRoutes.logListScreenRoute, arguments: [
  //       {'isBack': true}
  //     ]);
  //     DbHelper.getData().add(createLog);
  //     ProgressDialogUtils.showTitleSnackBar(headerText: AppString.dataSaved);
  //   }
  // }
  Future<Uint8List> imagePathToBytes(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    } else {
      throw Exception("File does not exist at path: $path");
    }
  }

  Future<void> createLog() async {
    print('Creating Log...');

    var number = "";

    Uint8List? imageBytes;
    String? imagePath =
        photoPath.value?.path; // Get the path from your observable

    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        imageBytes = await imagePathToBytes(imagePath);
        print('Image loaded: ${imageBytes.length} bytes');
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    String numericOnly = connectedDevice.value.replaceAll(RegExp(r'[^0-9]'), '');

// Current timestamp in milliseconds
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

// Final output
    String output = numericOnly + timestamp;
    final createLog = CreateLog(
      companyName: companyName.value,
      deviceSerialNumber: connectedDevice.value,
      isBatteryCalibration: isBatteryCalibration.value,
      isInductionEnr: isInductionEnr.value,
      duration: duration.value,
      formBNumber: formBNumber.value,
      formCNumber: formCNumber.value,
      fullName: name.value,
      gpsLocation: locationGPS.value,
      location: location.value,
      logNumber: output,
      notes: noteController.text.isEmpty ? 'Not Entered' : noteController.text,
      pTSNumber: ptsNumber.value,
      startUp: startUp.value,
      voltsDetected: voltsDetect.value,
      testType: testType.value,
      voltsHighest: highest.value,
      photoPath: imageBytes != null
          ? base64Encode(imageBytes)
          : null, // Save as base64 string
      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      voltsLowest: lowest.value,
    );

    // Save logic
    if (storeDataList.length == 300) {
      DbHelper.getData().deleteAt(0);
    }
    DbHelper.getData().add(createLog);

    if (storeDataListLastFiveDataBox.length == 5) {
      DbHelper.getDataLastFiveDataBox().deleteAt(0);
    }
    DbHelper.getDataLastFiveDataBox().add(createLog);

    Get.toNamed(AppRoutes.logListScreenRoute, arguments: [
      {'isBack': true}
    ]);
    ProgressDialogUtils.showTitleSnackBar(headerText: AppString.dataSaved);
  }
}
