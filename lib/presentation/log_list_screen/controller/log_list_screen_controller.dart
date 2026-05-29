import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cotec/ApiServices/api_service.dart';
import 'package:cotec/presentation/log_list_screen/model/history_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../ApiServices/common_model/create_log_model.dart';
import '../../../core/app_export.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/progress_dialog_utils.dart';

class LogListScreenController extends GetxController {
  RxList<CreateLog> itemLists = <CreateLog>[].obs;
  RxList<CreateLog> selectedList = <CreateLog>[].obs;
  RxList<CreateLog> searchList = <CreateLog>[].obs;
  Rx<HistoryModel> model = HistoryModel().obs;
  RxInt changeQuantity = 1.obs;
  RxBool isSelected = false.obs;
  var argument = Get.arguments;
  RxBool isBack = false.obs;
  RxBool isNetWork = false.obs;

  RxInt currentPage = 1.obs;
  int total = 0;
  RxBool isLoadingMore = false.obs;
  RxBool isLoadingFirst = false.obs;

  @override
  void onInit() {
    // loadList();
    if (argument != null) {
      isBack.value = argument[0]['isBack'];
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkNetwork(true);
    });
    super.onInit();
  }

  void filterSearchResults(String query) {
    searchList.value = itemLists.value
        .where((item) =>
            item.fullName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  checkNetwork(bool initial) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      isNetWork.value = false;
    } else {
      isNetWork.value = true;
      searchList.value = [];
      selectedList.value = [];
      itemLists.value = [];
      getLogHistory(initial);
    }
  }

  loadList(Box<CreateLog> box) async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      searchList.value = [];
      selectedList.value = [];
      itemLists.value = [];
      itemLists.value.addAll(box.values);
      searchList.value = itemLists.value.reversed.toList();    }

  }

  // var data = {
  //   "status": 1,
  //   "message": "Success",
  //   "total": 20,
  //   "response": [
  //
  //     {
  //       "id": "86859768-b422-448e-bb24-2230343f4554",
  //       "user_id": "ef676f46-1646-4098-8020-e6854ab8bf32",
  //       "log_number": "812881432",
  //       "test_type": "Isolation Pre-Test - Energised",
  //       "full_name": "Rajan Patel",
  //       "PTS_number": "PTS1234",
  //       "company_name": "Test  Company",
  //       "form_b_no": "B1234",
  //       "form_c_no": "C1234",
  //       "location": "Ahemdabad, Gujarat",
  //       "gps_location": "23.0105242, 72.5284018",
  //       "device_serial_number": "C31-9898",
  //       "start_up": "12:46 AM",
  //       "volts_detected": "12:47 AM",
  //       "duration": "05 Seconds",
  //       "volts_highest": "294 V",
  //       "volts_lowest": "4 V",
  //       "notes": "for Testing",
  //       "image": "log_data\/1748891885muJUCS.png",
  //       "date": "2003-06-25",
  //       "is_battery_calibration": "NO",
  //       "is_inductionEnr": "NO",
  //       "is_visible": 1,
  //       "deleted_at": null,
  //       "created_at": "2025-06-02T19:18:05.000000Z",
  //       "updated_at": "2025-06-02T19:18:05.000000Z",
  //       "image_url":
  //       "https:\/\/codec-media.s3.eu-west-2.amazonaws.com\/log_data\/1748891885muJUCS.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZOZQFKPCFNR327MY%2F20250603%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250603T164313Z&X-Amz-SignedHeaders=host&X-Amz-Expires=1200&X-Amz-Signature=8cea0129f600fe36370cea4e902c0a5ea24ec5a8343f4eb9e4774ed340c0af84"
  //     },
  //     {
  //       "id": "86859768-b422-448e-bb24-2230343f4554",
  //       "user_id": "ef676f46-1646-4098-8020-e6854ab8bf32",
  //       "log_number": "812881432",
  //       "test_type": "Isolation Pre-Test - Energised",
  //       "full_name": "Rajan Patel",
  //       "PTS_number": "PTS1234",
  //       "company_name": "Test  Company",
  //       "form_b_no": "B1234",
  //       "form_c_no": "C1234",
  //       "location": "Ahemdabad, Gujarat",
  //       "gps_location": "23.0105242, 72.5284018",
  //       "device_serial_number": "C31-9898",
  //       "start_up": "12:46 AM",
  //       "volts_detected": "12:47 AM",
  //       "duration": "05 Seconds",
  //       "volts_highest": "294 V",
  //       "volts_lowest": "4 V",
  //       "notes": "for Testing",
  //       "image": "log_data\/1748891885muJUCS.png",
  //       "date": "2003-06-25",
  //       "is_battery_calibration": "NO",
  //       "is_inductionEnr": "NO",
  //       "is_visible": 1,
  //       "deleted_at": null,
  //       "created_at": "2025-06-02T19:18:05.000000Z",
  //       "updated_at": "2025-06-02T19:18:05.000000Z",
  //       "image_url":
  //       "https:\/\/codec-media.s3.eu-west-2.amazonaws.com\/log_data\/1748891885muJUCS.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZOZQFKPCFNR327MY%2F20250603%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250603T164313Z&X-Amz-SignedHeaders=host&X-Amz-Expires=1200&X-Amz-Signature=8cea0129f600fe36370cea4e902c0a5ea24ec5a8343f4eb9e4774ed340c0af84"
  //     },
  //     {
  //       "id": "86859768-b422-448e-bb24-2230343f4554",
  //       "user_id": "ef676f46-1646-4098-8020-e6854ab8bf32",
  //       "log_number": "812881432",
  //       "test_type": "Isolation Pre-Test - Energised",
  //       "full_name": "Rajan Patel",
  //       "PTS_number": "PTS1234",
  //       "company_name": "Test  Company",
  //       "form_b_no": "B1234",
  //       "form_c_no": "C1234",
  //       "location": "Ahemdabad, Gujarat",
  //       "gps_location": "23.0105242, 72.5284018",
  //       "device_serial_number": "C31-9898",
  //       "start_up": "12:46 AM",
  //       "volts_detected": "12:47 AM",
  //       "duration": "05 Seconds",
  //       "volts_highest": "294 V",
  //       "volts_lowest": "4 V",
  //       "notes": "for Testing",
  //       "image": "log_data\/1748891885muJUCS.png",
  //       "date": "2003-06-25",
  //       "is_battery_calibration": "NO",
  //       "is_inductionEnr": "NO",
  //       "is_visible": 1,
  //       "deleted_at": null,
  //       "created_at": "2025-06-02T19:18:05.000000Z",
  //       "updated_at": "2025-06-02T19:18:05.000000Z",
  //       "image_url":
  //       "https:\/\/codec-media.s3.eu-west-2.amazonaws.com\/log_data\/1748891885muJUCS.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZOZQFKPCFNR327MY%2F20250603%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250603T164313Z&X-Amz-SignedHeaders=host&X-Amz-Expires=1200&X-Amz-Signature=8cea0129f600fe36370cea4e902c0a5ea24ec5a8343f4eb9e4774ed340c0af84"
  //     },
  //     {
  //       "id": "86859768-b422-448e-bb24-2230343f4554",
  //       "user_id": "ef676f46-1646-4098-8020-e6854ab8bf32",
  //       "log_number": "812881432",
  //       "test_type": "Isolation Pre-Test - Energised",
  //       "full_name": "Keval Patel",
  //       "PTS_number": "PTS1234",
  //       "company_name": "Test  Company",
  //       "form_b_no": "B1234",
  //       "form_c_no": "C1234",
  //       "location": "Ahemdabad, Gujarat",
  //       "gps_location": "23.0105242, 72.5284018",
  //       "device_serial_number": "C31-9898",
  //       "start_up": "12:46 AM",
  //       "volts_detected": "12:47 AM",
  //       "duration": "05 Seconds",
  //       "volts_highest": "294 V",
  //       "volts_lowest": "4 V",
  //       "notes": "for Testing",
  //       "image": "log_data\/1748891885muJUCS.png",
  //       "date": "2003-06-25",
  //       "is_battery_calibration": "NO",
  //       "is_inductionEnr": "NO",
  //       "is_visible": 1,
  //       "deleted_at": null,
  //       "created_at": "2025-06-02T19:18:05.000000Z",
  //       "updated_at": "2025-06-02T19:18:05.000000Z",
  //       "image_url":
  //       "https:\/\/codec-media.s3.eu-west-2.amazonaws.com\/log_data\/1748891885muJUCS.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZOZQFKPCFNR327MY%2F20250603%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250603T164313Z&X-Amz-SignedHeaders=host&X-Amz-Expires=1200&X-Amz-Signature=8cea0129f600fe36370cea4e902c0a5ea24ec5a8343f4eb9e4774ed340c0af84"
  //     },
  //     {
  //       "id": "86859768-b422-448e-bb24-2230343f4554",
  //       "user_id": "ef676f46-1646-4098-8020-e6854ab8bf32",
  //       "log_number": "812881432",
  //       "test_type": "Isolation Pre-Test - Energised",
  //       "full_name": "Kishan Patel",
  //       "PTS_number": "PTS1234",
  //       "company_name": "Test  Company",
  //       "form_b_no": "B1234",
  //       "form_c_no": "C1234",
  //       "location": "Ahemdabad, Gujarat",
  //       "gps_location": "23.0105242, 72.5284018",
  //       "device_serial_number": "C31-9898",
  //       "start_up": "12:46 AM",
  //       "volts_detected": "12:47 AM",
  //       "duration": "05 Seconds",
  //       "volts_highest": "294 V",
  //       "volts_lowest": "4 V",
  //       "notes": "for Testing",
  //       "image": "log_data\/1748891885muJUCS.png",
  //       "date": "2003-06-25",
  //       "is_battery_calibration": "NO",
  //       "is_inductionEnr": "NO",
  //       "is_visible": 1,
  //       "deleted_at": null,
  //       "created_at": "2025-06-02T19:18:05.000000Z",
  //       "updated_at": "2025-06-02T19:18:05.000000Z",
  //       "image_url":
  //       "https:\/\/codec-media.s3.eu-west-2.amazonaws.com\/log_data\/1748891885muJUCS.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZOZQFKPCFNR327MY%2F20250603%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250603T164313Z&X-Amz-SignedHeaders=host&X-Amz-Expires=1200&X-Amz-Signature=8cea0129f600fe36370cea4e902c0a5ea24ec5a8343f4eb9e4774ed340c0af84"
  //     },
  //
  //   ]
  // };
  // Future<void> getLogHistory(bool initial) async {
  //   await ApiService()
  //       .callGetApi(
  //       headerWithToken: true,
  //       body: FormData({}),
  //       showLoader: true,
  //       url: '${baseUrl}/logHistory')
  //       .then((value) {
  //     if (value != null && value.body["status"] == 1) {
  //       // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
  //       model.value= HistoryModel.fromJson(value.body);
  //       if(model.value.response!=null&&model.value.response!.isNotEmpty){
  //         searchList.value = [];
  //         selectedList.value = [];
  //         itemLists.value = [];
  //         for (var value in model.value.response!){
  //
  //           itemLists.value.add(CreateLog(
  //               fullName:value.fullName,
  //               pTSNumber:value.ptsNumber,
  //               companyName:value.companyName,
  //               formBNumber:value.formBNo,
  //               formCNumber:value.formCNo,
  //               location:value.location,
  //               gpsLocation:value.gpsLocation,
  //               deviceSerialNumber:value.deviceSerialNumber,
  //               logNumber:value.logNumber,
  //               testType:value.testType,
  //               startUp:value.startUp,
  //               voltsDetected:value.voltsDetected,
  //               duration:value.duration,
  //               voltsHighest:value.voltsHighest,
  //               voltsLowest:value.voltsLowest,
  //               date:value.date ,
  //               isBatteryCalibration:value.isBatteryCalibration,
  //               isInductionEnr:value.isInductionEnr,
  //               photoPath:value.imageUrl,
  //           ));
  //                   }
  //         searchList.value = itemLists.value;
  //       }
  //
  //     } else {
  //       ProgressDialogUtils.showTitleSnackBar(
  //           headerText: value.body["message"]);
  //     }
  //   });
  // }
  Future<void> getLogHistory(bool initial) async {
    if (initial) {
      isLoadingFirst.value=true;
      currentPage.value = 1;
      itemLists.clear();
      searchList.clear();
      selectedList.clear();
    }

    isLoadingMore.value = true;
    try {
      final value = await ApiService().callGetApi(
        headerWithToken: true,
        body: FormData({

        }),
        showLoader: initial,
        url: '${baseUrl}/logHistory?page=${currentPage}',
      );

      if (value != null && value.body["status"] == 1) {
        model.value = HistoryModel.fromJson(value.body);
        // model.value = HistoryModel.fromJson(data);
        final newItems = model.value.response ?? [];

        itemLists.addAll(newItems.map((value) => CreateLog(
              fullName: value.fullName,
              pTSNumber: value.ptsNumber,
              companyName: value.companyName,
              formBNumber: value.formBNo,
              formCNumber: value.formCNo,
              location: value.location,
              gpsLocation: value.gpsLocation,
              deviceSerialNumber: value.deviceSerialNumber,
              logNumber: value.logNumber,
              testType: value.testType,
              startUp: value.startUp,
              voltsDetected: value.voltsDetected,
              duration: value.duration,
              voltsHighest: value.voltsHighest,
              voltsLowest: value.voltsLowest,
              date: value.date,
              isBatteryCalibration: value.isBatteryCalibration,
              isInductionEnr: value.isInductionEnr,
              photoPath: value.imageUrl,
            )));

        // Update searchList (if not in search mode)
        searchList.value = itemLists;

        // Check total
        total = model.value.total ?? itemLists.length;
        currentPage++;
        isLoadingFirst.value=false;
      } else {
        isLoadingFirst.value=false;

        ProgressDialogUtils.showTitleSnackBar(
          headerText: value.body["message"],
        );
      }
    } finally {
      isLoadingFirst.value=false;

      isLoadingMore.value = false;
    }
  }

  Future<void> makePdf() async {
    ProgressDialogUtils.showProgressDialog(isCancellable: false);

    for (int i = 0; i < selectedList.length; i++) {
      final pdf = p.Document();
      final ByteData bytes =
          await rootBundle.load('assets/images/png/img_app_logo.png');
      final Uint8List byteList = bytes.buffer.asUint8List();
      pdf.addPage(p.Page(build: (context) {
        return p.Padding(
            padding: p.EdgeInsets.symmetric(
              horizontal: getWidth(16),
            ),
            child: p.Column(
                crossAxisAlignment: p.CrossAxisAlignment.start,
                children: [
                  p.Center(
                    child: p.Image(p.MemoryImage(byteList),
                        fit: p.BoxFit.fitWidth),
                  ),
                  p.SizedBox(
                    height: getHeight(10),
                  ),
                  p.Container(
                    decoration: p.BoxDecoration(
                        boxShadow: [
                          p.BoxShadow(
                              color: PdfColor.fromHex('#B7B7B7FF'),
                              blurRadius: 5.0,
                              spreadRadius: 0.5),
                        ],
                        borderRadius: p.BorderRadius.circular(15),
                        color: PdfColor.fromHex('#FFFFFF')),
                    padding: p.EdgeInsets.symmetric(
                        horizontal: getWidth(18), vertical: getHeight(20)),
                    child: p.Row(
                      mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                      children: [
                        p.Text(
                          AppString.logNumber,
                          style: p.TextStyle(
                              fontSize: getFontSize(16),
                              fontWeight: p.FontWeight.bold,
                              color: PdfColor.fromHex('#222663')),
                        ),
                        p.Text(
                          selectedList[i].logNumber ?? '',
                          style: p.TextStyle(
                              fontSize: getFontSize(16),
                              fontWeight: p.FontWeight.normal,
                              color: PdfColor.fromHex('#222663')),
                        ),
                      ],
                    ),
                  ),
                  p.SizedBox(
                    height: getHeight(10),
                  ),
                  // p.Container(
                  //   decoration: p.BoxDecoration(
                  //       boxShadow: [
                  //         p.BoxShadow(
                  //             color: PdfColor.fromHex('#B7B7B7FF'),
                  //             blurRadius: 5.0,
                  //             spreadRadius: 0.5),
                  //       ],
                  //       borderRadius: p.BorderRadius.circular(15),
                  //       color: PdfColor.fromHex('#FFFFFF')),
                  //   padding: p.EdgeInsets.symmetric(
                  //       horizontal: getWidth(18), vertical: getHeight(20)),
                  //   child:
                  p.Column(
                    children: [
                      p.Row(
                        mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                        children: [
                          p.Expanded(
                            child: p.Text(
                              AppString.testTypes,
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.bold,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                          ),
                          p.Expanded(
                            child: p.Text(
                              selectedList[i].testType ?? '',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.normal,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                          ),
                        ],
                      ),
                      p.SizedBox(
                        height: getHeight(5),
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.fullName}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].fullName ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(5),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.ptsNumber}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].pTSNumber ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(5),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.companyName}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].companyName ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(5),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.fromBNumber}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].formBNumber ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(5),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.fromCNumber}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].formCNumber ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(5),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.location}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].location ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ),
                  p.SizedBox(
                    height: getHeight(25),
                  ),
                  p.Row(
                    mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                    children: [
                      p.Text(
                        AppString.gpsLocation,
                        style: p.TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: p.FontWeight.bold,
                            color: PdfColor.fromHex('#222663')),
                      ),
                      p.Text(
                        selectedList[i].gpsLocation ?? '',
                        style: p.TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: p.FontWeight.normal,
                            color: PdfColor.fromHex('#222663')),
                      ),
                    ],
                  ),
                  p.SizedBox(
                    height: getHeight(25),
                  ),
                ]));
      }));
      pdf.addPage(p.Page(build: (context) {
        return p.Padding(
            padding: p.EdgeInsets.symmetric(
              horizontal: getWidth(16),
            ),
            child: p.Column(
                crossAxisAlignment: p.CrossAxisAlignment.start,
                children: [
                  p.SizedBox(
                    height: getHeight(25),
                  ),
                  p.Column(
                    crossAxisAlignment: p.CrossAxisAlignment.start,
                    children: [
                      p.Text(
                        AppString.statusMessage,
                        style: p.TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: p.FontWeight.bold,
                            color: PdfColor.fromHex('#222663')),
                      ),
                      p.Text(
                        'Low Battery. Please recharge the device at the earliest opportunity.',
                        style: p.TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: p.FontWeight.normal,
                            color: PdfColor.fromHex('#222663')),
                      ),
                    ],
                  ),
                  p.SizedBox(
                    height: getHeight(25),
                  ),
                  p.Column(
                    crossAxisAlignment: p.CrossAxisAlignment.start,
                    children: [
                      p.Text(
                        AppString.deviceNumber,
                        style: p.TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: p.FontWeight.bold,
                            color: PdfColor.fromHex('#222663')),
                      ),
                      p.Text(
                        selectedList[i].deviceSerialNumber ?? '',
                        style: p.TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: p.FontWeight.normal,
                            color: PdfColor.fromHex('#222663')),
                      ),
                    ],
                  ),
                  p.SizedBox(
                    height: getHeight(30),
                  ),
                  // p.Container(
                  //   decoration: p.BoxDecoration(
                  //       boxShadow: [
                  //         p.BoxShadow(
                  //             color: PdfColor.fromHex('#B7B7B7FF'),
                  //             blurRadius: 5.0,
                  //             spreadRadius: 0.5),
                  //       ],
                  //       borderRadius: p.BorderRadius.circular(15),
                  //       color: PdfColor.fromHex('#FFFFFF')),
                  //   padding: p.EdgeInsets.symmetric(
                  //       horizontal: getWidth(18), vertical: getHeight(20)),
                  //   child:
                  p.Column(
                    crossAxisAlignment: p.CrossAxisAlignment.start,
                    children: [
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.startUp}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].startUp ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(10),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.voltsDetected}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].voltsDetected ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(10),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.duration}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].duration ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(10),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.voltsHie}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].voltsHighest ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(10),
                          ),
                        ],
                      ),
                      p.Column(
                        children: [
                          p.Row(
                            mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
                            children: [
                              p.Expanded(
                                child: p.Text(
                                  '${AppString.voltLow}:',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.bold,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                              p.Expanded(
                                child: p.Text(
                                  selectedList[i].voltsLowest ?? '',
                                  style: p.TextStyle(
                                      fontSize: getFontSize(14),
                                      fontWeight: p.FontWeight.normal,
                                      color: PdfColor.fromHex('#222663')),
                                ),
                              ),
                            ],
                          ),
                          p.SizedBox(
                            height: getHeight(10),
                          ),
                        ],
                      ),
                      p.Text(
                        AppString.notes,
                        style: p.TextStyle(
                            fontSize: getFontSize(14),
                            fontWeight: p.FontWeight.bold,
                            color: PdfColor.fromHex('#222663')),
                      ),
                      p.SizedBox(
                        height: getHeight(5),
                      ),
                      p.Text(
                        selectedList[i].notes ?? '',
                        style: p.TextStyle(
                            fontSize: getFontSize(12),
                            fontWeight: p.FontWeight.normal,
                            color: PdfColor.fromHex('#222663')),
                      ),
                    ],
                  ),
                  // ),
                  p.SizedBox(
                    height: getHeight(30),
                  ),
                ]));
      }));

      //////////////////////////////

      try {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          // If not we will ask for permission first
          await Permission.storage.request();
        }
        Directory? _directory = await getExternalStorageDirectory();

        print("Saved Path:++++++++++ ${_directory?.path}");
        String convertedDirectoryPath = (_directory?.path).toString();
        print("Saved Path:++++++++++777777777 ${convertedDirectoryPath}");
        String newPath = '';
        List<String> paths = convertedDirectoryPath.split("/");
        for (int x = 1; x < convertedDirectoryPath.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
            print('00000000000000000000 ${folder}');
          } else {
            break;
          }
          print('++++00000000000000000000 ${newPath}');
        }
        if (Platform.isAndroid) {
          // Redirects it to download folder in android
          _directory = Directory("${newPath}/Download");
        } else {
          _directory = await getApplicationDocumentsDirectory();
        }

        final exPath = _directory.path;
        print("Saved Path: $exPath");
        // await Directory(exPath).create(recursive: true);
        final myDir = Directory(exPath);

        print('++++++++++++++++++++++++++++${exPath}');
        print('++++++++++++++++++++++++++++${myDir}');

        ///////////////////////////
        // Directory root = await getApplicationDocumentsDirectory();
        String path =
            '${exPath}/${selectedList[i].fullName}-${selectedList[i].logNumber}.pdf';
        final file = File(path);
        await file.writeAsBytes(await pdf.save());
        print("Path  " + path);
      } catch (e) {
        print('ERROR ++++++++++++++++++++++++++++${e.toString()}');
      }
    }
    selectedList.clear();
    ProgressDialogUtils.hideProgressDialog();
    ProgressDialogUtils.showTitleSnackBar(
        headerText: AppString.downloadSuccess);
  }
}
