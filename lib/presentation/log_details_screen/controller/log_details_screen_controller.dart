import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import 'package:pdf/widgets.dart' as p;
import 'package:pdf/pdf.dart';

class LogDetailsScreenController extends GetxController {
  var arguments = Get.arguments;

  Rx<CreateLog> logDetails = CreateLog().obs;
  @override
  void onInit() {
    if (arguments != null && arguments['createLog'] != null) {
      logDetails.value = arguments['createLog'];
    }
    super.onInit();
  }

  Future<void> makePdf(String name, String logNumber, bool isShare) async {
    ProgressDialogUtils.showProgressDialog(isCancellable: false);

    final pdf = p.Document();
    final ByteData bytes =
        await rootBundle.load('assets/images/png/img_app_logo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();

    List<p.Widget> widgets = [];

    if (logDetails.value.isInductionEnr == 'Induction')
      widgets.add(
        p.Column(
          children: [
            p.Center(
              child: p.Text(
                AppString.induction,
                style: p.TextStyle(
                    fontSize: getFontSize(16),
                    fontWeight: p.FontWeight.bold,
                    color: PdfColor.fromHex('#FBBC31')),
              ),
            ),
            p.SizedBox(
              height: getHeight(25),
            ),
          ],
        ),
      );
    if (logDetails.value.isInductionEnr == 'Energised')
      widgets.add(
        p.Column(
          children: [
            p.Center(
              child: p.Text(
                AppString.caution,
                style: p.TextStyle(
                    fontSize: getFontSize(16),
                    fontWeight: p.FontWeight.bold,
                    color: PdfColor.fromHex('#FF2121')),
              ),
            ),
            p.SizedBox(
              height: getHeight(25),
            ),
          ],
        ),
      );

    widgets.add(
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
                  logDetails.value.testType ?? '',
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
                      logDetails.value.fullName ?? '',
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
                      logDetails.value.pTSNumber ?? '',
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
                      logDetails.value.companyName ?? '',
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
                      logDetails.value.formBNumber ?? '',
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
                      logDetails.value.formCNumber ?? '',
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
                      logDetails.value.location ?? '',
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
          p.SizedBox(
            height: getHeight(25),
          ),
        ],
      ),
    );
    widgets.add(
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
            logDetails.value.gpsLocation ?? '',
            style: p.TextStyle(
                fontSize: getFontSize(16),
                fontWeight: p.FontWeight.normal,
                color: PdfColor.fromHex('#222663')),
          ),
        ],
      ),
    );

    if (logDetails.value.isBatteryCalibration == 'Battery')
      widgets.add(
        p.Column(
          crossAxisAlignment: p.CrossAxisAlignment.start,
          children: [
            p.SizedBox(
              height: getHeight(25),
            ),
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
      );

    if (logDetails.value.isBatteryCalibration == 'Calibration')
      widgets.add(
        p.Column(
          crossAxisAlignment: p.CrossAxisAlignment.start,
          children: [
            p.SizedBox(
              height: getHeight(25),
            ),
            p.Text(
              AppString.statusMessage,
              style: p.TextStyle(
                  fontSize: getFontSize(16),
                  fontWeight: p.FontWeight.bold,
                  color: PdfColor.fromHex('#222663')),
            ),
            p.SizedBox(
              height: getHeight(8),
            ),
            p.Text(
              AppString.attentionCalibrationDes,
              style: p.TextStyle(
                  fontSize: getFontSize(16),
                  fontWeight: p.FontWeight.normal,
                  color: PdfColor.fromHex('#222663')),
            ),
          ],
        ),
      );

    widgets.add(p.Column(
      children: [
        p.SizedBox(
          height: getHeight(25),
        ),
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
                logDetails.value.startUp ?? '',
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
    ));
    widgets.add(p.Column(
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
                logDetails.value.voltsDetected ?? '',
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
    ));
    widgets.add(p.Column(
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
                logDetails.value.duration ?? '',
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
    ));
    widgets.add(p.Column(
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
                logDetails.value.voltsHighest ?? '',
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
    ));
    widgets.add(p.Column(
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
                logDetails.value.voltsLowest ?? '',
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
    ));
    widgets.add(
        p.Column(crossAxisAlignment: p.CrossAxisAlignment.start, children: [
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
        logDetails.value.notes ?? '',
        style: p.TextStyle(
            fontSize: getFontSize(12),
            fontWeight: p.FontWeight.normal,
            color: PdfColor.fromHex('#222663')),
      ),
      p.SizedBox(
        height: getHeight(20),
      ),
    ]));

    // ),

    // if (logDetails.value.photoPath != null&&logDetails.value.photoPath!.isNotEmpty) {
    //   File photo1 = File(logDetails.value.photoPath!);
    //
    //   p.MemoryImage memoryImage = p.MemoryImage(photo1.readAsBytesSync());
    //   widgets.add(p.Column(children: [
    //     p.ClipRRect(
    //       horizontalRadius: 15,
    //       verticalRadius: 15,
    //       child: p.Image(memoryImage, height: 200),
    //     ),
    //     p.SizedBox(
    //       height: getHeight(30),
    //     ),
    //   ]));
    // }

    if (logDetails.value.photoPath != null && logDetails.value.photoPath!.isNotEmpty&& logDetails.value.photoPath!.contains('http')) {
      final String imageUrl = logDetails.value.photoPath!;
      try {
        // Download image bytes from the network URL
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          // Create a MemoryImage from the downloaded bytes
          final p.MemoryImage memoryImage = p.MemoryImage(response.bodyBytes);

          // Add the image to your widget list along with other layout elements
          widgets.add(
            p.Column(
              children: [
                p.ClipRRect(
                  horizontalRadius: 15,
                  verticalRadius: 15,
                  child: p.Image(
                    memoryImage,
                    height: 200,
                    fit: p.BoxFit.cover, // optional: adjust as needed
                  ),
                ),
                p.SizedBox(height: getHeight(30)),
              ],
            ),
          );
        } else if(logDetails.value.photoPath != null && logDetails.value.photoPath!.isNotEmpty){
          File photo1 = File(logDetails.value.photoPath!);

          p.MemoryImage memoryImage = p.MemoryImage(photo1.readAsBytesSync());
          widgets.add(p.Column(children: [
            p.ClipRRect(
              horizontalRadius: 15,
              verticalRadius: 15,
              child: p.Image(memoryImage, height: 200),
            ),
            p.SizedBox(
              height: getHeight(30),
            ),
          ]));
        }

        else {
          print('Failed to load image: HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('Error loading network image: $e');
      }
    }
    pdf.addPage(
      p.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) {
          return p.Column(
              crossAxisAlignment: p.CrossAxisAlignment.start,
              children: [
                p.Center(
                  child: p.Image(p.MemoryImage(byteList), height: 75),
                ),
                p.SizedBox(
                  height: getHeight(15),
                ),
                p.Row(mainAxisAlignment: p.MainAxisAlignment.end, children: [
                  p.Column(
                      crossAxisAlignment: p.CrossAxisAlignment.end,
                      children: [
                        p.Row(
                          children: [
                            p.Text(
                              '${AppString.date}: ',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.bold,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                            p.Text(
                              logDetails.value.date ?? '',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.normal,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                          ],
                        ),
                        p.SizedBox(
                          height: getHeight(8),
                        ),
                        p.Row(
                          children: [
                            p.Text(
                              '${AppString.logNumber}: ',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.bold,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                            p.Text(
                              logDetails.value.logNumber ?? '',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.normal,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                          ],
                        ),
                        p.SizedBox(
                          height: getHeight(8),
                        ),
                        p.Row(
                          children: [
                            p.Text(
                              '${AppString.deviceNumber}: ',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.bold,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                            p.Text(
                              logDetails.value.deviceSerialNumber ?? '',
                              style: p.TextStyle(
                                  fontSize: getFontSize(14),
                                  fontWeight: p.FontWeight.normal,
                                  color: PdfColor.fromHex('#222663')),
                            ),
                          ],
                        ),
                      ])
                ]),
                p.SizedBox(
                  height: getHeight(10),
                ),
                p.Divider(height: 2, color: PdfColors.grey),
                p.SizedBox(
                  height: getHeight(40),
                ),
              ]);
        },
        build: (context) => widgets, //here goes the widgets list
      ),
    );

    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        // If not we will ask for permission first
        await Permission.storage.request();
      }
      // Directory? _directory = await getExternalStorageDirectory();
      //
      // print("Saved Path:++++++++++ ${_directory?.path}");
      // String convertedDirectoryPath = (_directory?.path).toString();
      // print("Saved Path:++++++++++777777777 ${convertedDirectoryPath}");
      // String newPath = '';
      // List<String> paths = convertedDirectoryPath.split("/");
      // for (int x = 1; x < convertedDirectoryPath.length; x++) {
      //   String folder = paths[x];
      //   if (folder != "Android") {
      //     newPath += "/" + folder;
      //     print('00000000000000000000 ${folder}');
      //   } else {
      //     break;
      //   }
      //   print('++++00000000000000000000 ${newPath}');
      // }
      // if (Platform.isAndroid) {
      //   // Redirects it to download folder in android
      //   _directory = Directory("${newPath}/Download");
      // } else {
      //   _directory = await getApplicationDocumentsDirectory();
      // }
      //
      // final exPath = _directory.path;
      // print("Saved Path: $exPath");
      // // await Directory(exPath).create(recursive: true);
      // final myDir = Directory(exPath);
      //
      // print('++++++++++++++++++++++++++++${exPath}');
      // print('++++++++++++++++++++++++++++${myDir}');
      //
      // String path = '${exPath}/$name-$logNumber-${DateTime.now()}.pdf';
      // final file = File(path);
      // await file.writeAsBytes(await pdf.save());
      // print("Path  " + path);

      Directory? directory;

      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        print('Directory is null');
        return;
      }

      String path = '${directory.path}/$name-$logNumber-${DateTime.now().toIso8601String()}.pdf';

      File file = File(path);
      await file.writeAsBytes(await pdf.save());
      print('Saved to $path');
      ProgressDialogUtils.hideProgressDialog();

      if (isShare == true) {
        if (await isInternet() == true) {
          // Share.shareXFiles(
          //   [XFile(path)],
          // );
          send(path);
        } else {
          ProgressDialogUtils.showTitleSnackBar(
              headerText: AppString.internetConnection);
        }
      } else {
        ProgressDialogUtils.showTitleSnackBar(
            headerText: AppString.downloadSuccess);
      }
    } catch (e) {
      print('ERROR ++++++++++++++++++++++++++++${e.toString()}');
    }
  }

  Future<void> send(String path) async {
    final Email email = Email(
      body: "",
      subject: "",
      recipients: [""],
      attachmentPaths: [path],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = AppString.emailSent;
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    ProgressDialogUtils.showTitleSnackBar(headerText: platformResponse);
  }

  Future<String> generateCsv() async {
    List<List<dynamic>> rows = [
      ["Cotec", ""],
      ["", ""],
      ["Log Number : ", logDetails.value.logNumber ?? ''],
      ["Device Serial Number : ", logDetails.value.deviceSerialNumber ?? ''],
      ["Test Type : ", logDetails.value.testType ?? ''],
      ["Full Name : ", logDetails.value.fullName ?? ''],
      ["PTS Number : ", logDetails.value.pTSNumber ?? ''],
      ["Company Name : ", logDetails.value.companyName ?? ''],
      ["From B Number : ", logDetails.value.formBNumber ?? ''],
      ["From C Number : ", logDetails.value.formCNumber ?? ''],
      ["Location : ", logDetails.value.location ?? ''],
      ["", ""],
      ["GPS Location : ", logDetails.value.gpsLocation ?? ''],
      ["", ""],
      ["Start Up : ", logDetails.value.startUp ?? ''],
      ["Volts Detected : ", logDetails.value.voltsDetected ?? ''],
      ["Duration : ", logDetails.value.duration ?? ''],
      ["Volts (Highest) : ", logDetails.value.voltsHighest ?? ''],
      ["Volts (Lowest) : ", logDetails.value.voltsLowest ?? ''],
      ["Note : ", logDetails.value.notes ?? ''],
    ];
    if (logDetails.value.isInductionEnr == 'Induction')
{
  rows.add(["", ""]);
  rows.add(["", AppString.induction]);
}   if (logDetails.value.isInductionEnr == 'Energised')
{
  rows.add(["", ""]);

  rows.add(["", AppString.caution]);
}
      if (logDetails.value.isBatteryCalibration == 'Calibration') {

        rows.add(["", ""]);

      rows.add(["Status Message : ", AppString.attentionCalibrationDes]);
    }

    if (logDetails.value.isBatteryCalibration == 'Battery') {

      rows.add(["", ""]);

      rows.add(["Status Message : ", 'Low Battery. Please recharge the device at the earliest opportunity.']);
    }
    String csv = const ListToCsvConverter().convert(rows);
    return csv;
  }

  Future<File> saveCsvFile(String csvContent) async {
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

    String path =
        '${exPath}/${logDetails.value.fullName ?? ''}-${logDetails.value.logNumber}.csv';
    final file = File(path);
    return file.writeAsString(csvContent);
  }

  void cSVDownload() async {
    try {
      String csvContent = await generateCsv();
      File file = await saveCsvFile(csvContent);
      print('CSV file saved to ${file.path}');
      // Display a snackbar to show download completion
      ProgressDialogUtils.showTitleSnackBar(
          headerText: AppString.downloadCSVSuccess);
    } catch (e) {
      print('CSV ERROR = ${e.toString()}');
    }
  }

  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      return false;
    }
  }
}
// pdf.addPage(p.Page(build: (context) {
//   return p.Padding(
//       padding: p.EdgeInsets.symmetric(
//         horizontal: getWidth(16),
//       ),
//       child: p.Column(
//           crossAxisAlignment: p.CrossAxisAlignment.start,
//           children: [
//             p.Center(
//               child:
//               p.Image(p.MemoryImage(byteList),height: 75),
//
//             ),
//             p.SizedBox(
//               height: getHeight(20),
//             ),
//             p.Row(
//               mainAxisAlignment: p.MainAxisAlignment.end,
//               children: [
//                 p.Column(crossAxisAlignment: p.CrossAxisAlignment.end,
//                 children: [
//                   p.Row(
//                     children: [
//                       p.Text(
//                         '${AppString.date}: ',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.bold,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                       p.Text(
//                         logDetails.value.date ?? '',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.normal,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                     ],
//                   ),
//                   p.SizedBox(
//                     height: getHeight(8),
//                   ),p.Row(
//                     children: [
//                       p.Text(
//                         '${AppString.logNumber}: ',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.bold,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                       p.Text(
//                         logDetails.value.logNumber ?? '',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.normal,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                     ],
//                   ),
//                   p.SizedBox(
//                     height: getHeight(8),
//                   ),
//                   p.Row(
//                     children: [
//                       p.Text(
//                         '${AppString.deviceNumber}: ',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.bold,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                       p.Text(
//                         logDetails.value.deviceSerialNumber ?? '',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.normal,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                     ],
//                   ),
//                 ])
//               ]
//             ),
//
//             p.SizedBox(
//               height: getHeight(20),
//             ),
//             p.Container(
//               decoration: p.BoxDecoration(
//                   boxShadow: [
//                     p.BoxShadow(
//                         color: PdfColor.fromHex('#B7B7B7FF'),
//                         blurRadius: 5.0,
//                         spreadRadius: 0.5),
//                   ],
//                   borderRadius: p.BorderRadius.circular(15),
//                   color: PdfColor.fromHex('#FFFFFF')),
//               padding: p.EdgeInsets.symmetric(
//                   horizontal: getWidth(18), vertical: getHeight(20)),
//               child: p.Row(
//                 mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                 children: [
//                   p.Text(
//                     AppString.logNumber,
//                     style: p.TextStyle(
//                         fontSize: getFontSize(16),
//                         fontWeight: p.FontWeight.bold,
//                         color: PdfColor.fromHex('#222663')),
//                   ),
//                   p.Text(
//                     logDetails.value.logNumber ?? '',
//                     style: p.TextStyle(
//                         fontSize: getFontSize(16),
//                         fontWeight: p.FontWeight.normal,
//                         color: PdfColor.fromHex('#222663')),
//                   ),
//                 ],
//               ),
//             ),
//             p.SizedBox(
//               height: getHeight(10),
//             ),
//             // p.Container(
//             //   decoration: p.BoxDecoration(
//             //       boxShadow: [
//             //         p.BoxShadow(
//             //             color: PdfColor.fromHex('#B7B7B7FF'),
//             //             blurRadius: 5.0,
//             //             spreadRadius: 0.5),
//             //       ],
//             //       borderRadius: p.BorderRadius.circular(15),
//             //       color: PdfColor.fromHex('#FFFFFF')),
//             //   padding: p.EdgeInsets.symmetric(
//             //       horizontal: getWidth(18), vertical: getHeight(20)),
//             //   child:
//
//             p.Column(
//               children: [
//                 p.Row(
//                   mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                   children: [
//                     p.Expanded(
//                       child: p.Text(
//                         AppString.testTypes,
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.bold,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                     ),
//                     p.Expanded(
//                       child: p.Text(
//                         logDetails.value.testType ?? '',
//                         style: p.TextStyle(
//                             fontSize: getFontSize(14),
//                             fontWeight: p.FontWeight.normal,
//                             color: PdfColor.fromHex('#222663')),
//                       ),
//                     ),
//                   ],
//                 ),
//                 p.SizedBox(
//                   height: getHeight(5),
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.fullName}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.fullName ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(5),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.ptsNumber}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.pTSNumber ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(5),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.companyName}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.companyName ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(5),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.fromBNumber}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.formBNumber ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(5),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.fromCNumber}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.formCNumber ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(5),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.location}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.location ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(5),
//                     ),
//                   ],
//                 ),
//                 p.SizedBox(
//                   height: getHeight(25),
//                 ),
//               ],
//             ),
//             // ),
//
//             p.Row(
//               mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//               children: [
//                 p.Text(
//                   AppString.gpsLocation,
//                   style: p.TextStyle(
//                       fontSize: getFontSize(16),
//                       fontWeight: p.FontWeight.bold,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//                 p.Text(
//                   logDetails.value.gpsLocation ?? '',
//                   style: p.TextStyle(
//                       fontSize: getFontSize(16),
//                       fontWeight: p.FontWeight.normal,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//               ],
//             ),
//             p.SizedBox(
//               height: getHeight(25),
//             ),
//           ]));
// }));
//you could use async as well

// pdf.addPage(p.Page(build: (context) {
//   return p.Padding(
//       padding: p.EdgeInsets.symmetric(
//         horizontal: getWidth(16),
//       ),
//       child: p.Column(
//           crossAxisAlignment: p.CrossAxisAlignment.start,
//           children: [
//             p.SizedBox(
//               height: getHeight(25),
//             ),
//             p.Column(
//               crossAxisAlignment: p.CrossAxisAlignment.start,
//               children: [
//                 p.Text(
//                   AppString.statusMessage,
//                   style: p.TextStyle(
//                       fontSize: getFontSize(16),
//                       fontWeight: p.FontWeight.bold,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//                 p.Text(
//                   'Low Battery. Please recharge the device at the earliest opportunity.',
//                   style: p.TextStyle(
//                       fontSize: getFontSize(16),
//                       fontWeight: p.FontWeight.normal,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//               ],
//             ),
//             p.SizedBox(
//               height: getHeight(25),
//             ),
//             p.Column(
//               crossAxisAlignment: p.CrossAxisAlignment.start,
//               children: [
//                 p.Text(
//                   AppString.deviceNumber,
//                   style: p.TextStyle(
//                       fontSize: getFontSize(16),
//                       fontWeight: p.FontWeight.bold,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//                 p.Text(
//                   logDetails.value.deviceSerialNumber ?? '',
//                   style: p.TextStyle(
//                       fontSize: getFontSize(16),
//                       fontWeight: p.FontWeight.normal,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//               ],
//             ),
//             p.SizedBox(
//               height: getHeight(30),
//             ),
//             // p.Container(
//             //   decoration: p.BoxDecoration(
//             //       boxShadow: [
//             //         p.BoxShadow(
//             //             color: PdfColor.fromHex('#B7B7B7FF'),
//             //             blurRadius: 5.0,
//             //             spreadRadius: 0.5),
//             //       ],
//             //       borderRadius: p.BorderRadius.circular(15),
//             //       color: PdfColor.fromHex('#FFFFFF')),
//             //   padding: p.EdgeInsets.symmetric(
//             //       horizontal: getWidth(18), vertical: getHeight(20)),
//             //   child:
//             p.Column(
//               crossAxisAlignment: p.CrossAxisAlignment.start,
//               children: [
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.startUp}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.startUp ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(10),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.voltsDetected}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.voltsDetected ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(10),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.duration}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.duration ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(10),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.voltsHie}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.voltsHighest ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(10),
//                     ),
//                   ],
//                 ),
//                 p.Column(
//                   children: [
//                     p.Row(
//                       mainAxisAlignment: p.MainAxisAlignment.spaceBetween,
//                       children: [
//                         p.Expanded(
//                           child: p.Text(
//                             '${AppString.voltLow}:',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.bold,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                         p.Expanded(
//                           child: p.Text(
//                             logDetails.value.voltsLowest ?? '',
//                             style: p.TextStyle(
//                                 fontSize: getFontSize(14),
//                                 fontWeight: p.FontWeight.normal,
//                                 color: PdfColor.fromHex('#222663')),
//                           ),
//                         ),
//                       ],
//                     ),
//                     p.SizedBox(
//                       height: getHeight(10),
//                     ),
//                   ],
//                 ),
//                 p.Text(
//                   AppString.notes,
//                   style: p.TextStyle(
//                       fontSize: getFontSize(14),
//                       fontWeight: p.FontWeight.bold,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//                 p.SizedBox(
//                   height: getHeight(5),
//                 ),
//                 p.Text(
//                   logDetails.value.notes ?? '',
//                   style: p.TextStyle(
//                       fontSize: getFontSize(12),
//                       fontWeight: p.FontWeight.normal,
//                       color: PdfColor.fromHex('#222663')),
//                 ),
//               ],
//             ),
//             // ),
//
//             p.SizedBox(
//               height: getHeight(20),
//             ),
//             p.ClipRRect(
//               horizontalRadius: 15,
//               verticalRadius: 15,
//               child: p.Image(memoryImage,height: 200),
//             ),
//             p.SizedBox(
//               height: getHeight(30),
//             ),
//           ]));
// }));

//////////////////////////////
