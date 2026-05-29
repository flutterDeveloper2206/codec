import 'package:cotec/ApiServices/api_service.dart';
import 'package:cotec/core/constants/constants.dart';
import 'package:cotec/presentation/setting_screen/model/departnment_test_type_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../ApiServices/common_model/create_log_model.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/app_prefs_key.dart';
import '../../../core/utils/hive_helper.dart';
import '../../../core/utils/progress_dialog_utils.dart';

class LogTestScreenController extends GetxController {
  TextEditingController testTypeController = TextEditingController();

  Rx<CreateLog> selectedName = CreateLog().obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController ptsNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController depotController = TextEditingController();
  TextEditingController bNumberController = TextEditingController();
  TextEditingController cNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  RxBool checkBoxValidateController = false.obs;
  RxBool checkBoxValidateLiveController = false.obs;
  RxBool nameValidate = false.obs;
  RxBool checkBoxValidate = false.obs;
  RxBool checkBoxLiveValidate = false.obs;
  RxBool ptsValidate = false.obs;
  RxBool companyValidate = false.obs;
  RxBool testTypeValidate = false.obs;
  RxBool bNumberValidate = false.obs;
  RxBool cNumberValidate = false.obs;
  RxBool locationValidate = false.obs;
  RxBool depotValidate = false.obs;
  RxBool isAllValidate = true.obs;
  RxBool companyReadOnly = false.obs;

  final List<String> items = [
    AppString.isolationPreTest,
    AppString.isolationDead,
    AppString.testBefore,
    AppString.reinstateLive,
  ];
  final RxList<CreateLog> nameList = <CreateLog>[].obs;
  RxString selectedValue = AppString.isolationPreTest.obs;
  RxString selectedValueDrop = ''.obs;
  RxString location = ''.obs;
  RxList<CreateLog> storeDataList = <CreateLog>[].obs;

  dynamic arguments = Get.arguments;
  // Rx<BluetoothDevice> selectedDevices = BluetoothDevice(address: "").obs;
  var server;
  RxString connectedDevice = ''.obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStoreData();
      getTestType();
    });
    if (arguments != null) {
      server = arguments['server'];
      connectedDevice.value = arguments['connectedDevice'];
    }
    getCurrentLatLong();
    setDefaultCompanyDeport();

    super.onInit();
  }



  Rx<DepartMentAndTestTypeModel> departMentAndTestTypeModel = DepartMentAndTestTypeModel().obs;

  Future<void> getTestType() async {
    await ApiService()
        .callGetApi(
        headerWithToken: true,
        body: FormData({}),
        showLoader: true,
        url: '${baseUrl}/getTestTypeList')
        .then((value) {
      if (value != null && value.body["status"] == 1) {
        // PrefUtils.setInt(AppString.SHOWMEONPETMEET, isOn);
        departMentAndTestTypeModel.value= DepartMentAndTestTypeModel.fromJson(value.body);
        if(departMentAndTestTypeModel.value.response!=null&&departMentAndTestTypeModel.value.response!.isNotEmpty){
          items.clear();
         for (var value in departMentAndTestTypeModel.value.response!){
           items.add(value.name??'');
        }}
      } else {
        ProgressDialogUtils.showTitleSnackBar(
            headerText: value.body["message"]);
      }
    });
  }
  void setDefaultCompanyDeport() {
    String? companyName =
        CommonConstant.instance.dbHelper.box.get(HiveKey.setCompanyName);
    String? deportName =
        CommonConstant.instance.dbHelper.box.get(HiveKey.setDeport);

    if (companyName == null || companyName.isEmpty) {
      companyReadOnly.value = false;
    } else {
      if (deportName != null && deportName.isNotEmpty) {
        depotController.text = deportName;
      }
      companyNameController.text = companyName;
      companyReadOnly.value = true;
    }
  }

  void onChangeCheckBox() {
    checkBoxValidate.value = !checkBoxValidate.value;
  }

  void onChangeLiveCheckBox() {
    checkBoxLiveValidate.value = !checkBoxLiveValidate.value;
  }

  void clearAll() {
    nameController.clear();
    ptsNumberController.clear();
    bNumberController.clear();
    cNumberController.clear();
    selectedValueDrop.value = '';
  }

  // void next(BuildContext context) {
  //   if (isAllValidate.value) {
  //     if (selectedValueDrop.isEmpty) {
  //       testTypeValidate.value = true;
  //       isAllValidate.value = true;
  //       fieldsMissedDialog(context);
  //     } else {
  //       testTypeValidate.value = false;
  //       isAllValidate.value = false;
  //     }
  //     if (nameController.text.isEmpty) {
  //       nameValidate.value = true;
  //       isAllValidate.value = true;
  //       fieldsMissedDialog(context);
  //     } else {
  //       nameValidate.value = false;
  //       isAllValidate.value = false;
  //     }
  //     if (ptsNumberController.text.isEmpty) {
  //       ptsValidate.value = true;
  //       isAllValidate.value = true;
  //       fieldsMissedDialog(context);
  //     } else {
  //       ptsValidate.value = false;
  //       isAllValidate.value = false;
  //     }
  //     if (companyNameController.text.isEmpty) {
  //       companyValidate.value = true;
  //       isAllValidate.value = true;
  //       fieldsMissedDialog(context);
  //     } else {
  //       companyValidate.value = false;
  //       isAllValidate.value = false;
  //     }
  //     if (bNumberController.text.isEmpty) {
  //       bNumberValidate.value = true;
  //       isAllValidate.value = true;
  //       fieldsMissedDialog(context);
  //     } else {
  //       bNumberValidate.value = false;
  //       isAllValidate.value = false;
  //     }
  //
  //     // if (locationController.text.isEmpty) {
  //     //   locationValidate.value = true;
  //     //   isAllValidate.value = true;
  //     // } else {
  //     //   locationValidate.value = false;
  //     //   isAllValidate.value = false;
  //     // }
  //   } else {
  //     Get.offAndToNamed(AppRoutes.activeTestScreenRoute);
  //   }
  //   print('object == ${checkBoxValidate.value}');
  //   print('object == ${isAllValidate.value}');
  // }
  void next(BuildContext context) {
    if (selectedValueDrop.value == 'Isolation Pre-Test - Energised' ||
        selectedValueDrop.value == 'Isolation - Dead Test') {
      checkBoxValidate.value = false;
      checkBoxLiveValidate.value = false;
      checkBoxValidateController.value = false;
      checkBoxValidateLiveController.value = false;
    }

    if (selectedValueDrop.isEmpty ||
        nameController.text.isEmpty ||
        ptsNumberController.text.isEmpty ||
        companyNameController.text.isEmpty ||
        bNumberController.text.isEmpty ||
        ((selectedValueDrop.value == 'Isolation Pre-Test - Energised' ||
                    selectedValueDrop.value == 'Isolation - Dead Test'
                ? false
                : !checkBoxValidate.value) ||
            (selectedValueDrop.value == 'Isolation - Dead Test' ||
                    selectedValueDrop.value == 'Isolation Pre-Test - Energised'
                ? false
                : !checkBoxLiveValidate.value))) {
      isAllValidate.value = true;
      fieldsMissedDialog(context);
    } else {
      if (selectedValueDrop.value == 'Test Before Touch' &&
          !checkBoxValidate.value) {
        isAllValidate.value = true;
      } else {
        isAllValidate.value = false;
      }
      if (selectedValueDrop.value == 'Reinstate Live - Energised' &&
          !checkBoxLiveValidate.value) {
        isAllValidate.value = true;
      } else {
        isAllValidate.value = false;
      }
    }
    if (isAllValidate.value) {
      if (selectedValueDrop.isEmpty) {
        testTypeValidate.value = true;
        isAllValidate.value = true;
      } else {
        testTypeValidate.value = false;
        isAllValidate.value = false;
      }
      if (!checkBoxValidate.value) {
        checkBoxValidateController.value = true;
        isAllValidate.value = true;
      } else {
        checkBoxValidateController.value = false;
        isAllValidate.value = false;
      }
      if (!checkBoxLiveValidate.value) {
        checkBoxValidateLiveController.value = true;
        isAllValidate.value = true;
      } else {
        checkBoxValidateLiveController.value = false;
        isAllValidate.value = false;
      }
      if (nameController.text.isEmpty) {
        nameValidate.value = true;
        isAllValidate.value = true;
      } else {
        nameValidate.value = false;
        isAllValidate.value = false;
      }
      if (ptsNumberController.text.isEmpty) {
        ptsValidate.value = true;
        isAllValidate.value = true;
      } else {
        ptsValidate.value = false;
        isAllValidate.value = false;
      }
      if (companyNameController.text.isEmpty) {
        companyValidate.value = true;
        isAllValidate.value = true;
      } else {
        companyValidate.value = false;
        isAllValidate.value = false;
      }
      if (bNumberController.text.isEmpty) {
        bNumberValidate.value = true;
        isAllValidate.value = true;
      } else {
        bNumberValidate.value = false;
        isAllValidate.value = false;
      }
      if (cNumberController.text.isEmpty) {
        cNumberValidate.value = true;
      } else {
        cNumberValidate.value = false;
      }

      if (locationController.text.isEmpty) {
        locationValidate.value = true;
      } else {
        locationValidate.value = false;
      }
    } else {
      CommonConstant.instance.dbHelper.box
          .put(HiveKey.setCompanyName, companyNameController.text.trim());
      CommonConstant.instance.dbHelper.box
          .put(HiveKey.setDeport, depotController.text.trim());
      CommonConstant.instance.dbHelper.box.put(HiveKey.isLogCreated, false);
      Get.toNamed(AppRoutes.activeTestScreenRoute, arguments: [
        {
          'server': server,
          'test_type': selectedValueDrop.value,
          'name': nameController.text,
          'pts_number': ptsNumberController.text,
          'company_name': companyNameController.text,
          'depot': depotController.text,
          'form_b': bNumberController.text,
          'form_c': cNumberController.text,
          'location': locationController.text,
          'screen': '1',
          'connectedDevice': connectedDevice.value,
          'locationGPS': location.value,
        }
      ]);
    }
    print('object == ${checkBoxValidate.value}');
    print('object == ${isAllValidate.value}');
  }

  void getStoreData() {
    ProgressDialogUtils.showProgressDialog(isCancellable: false);
    Box<CreateLog> itemBox = DbHelper.getDataLastFiveDataBox();
    itemBox.values.forEach((element) {
      storeDataList.add(element);
    });
    ProgressDialogUtils.hideProgressDialog();
    if (storeDataList.isNotEmpty) {
      // selectedValue.value = storeDataList.last.testType ?? '';
      // selectedValueDrop.value = storeDataList.last.testType ?? '';
      ptsNumberController.text = storeDataList.last.pTSNumber ?? '';

      // int count = storeDataList.length < 5 ? storeDataList.length : 5;
      // nameList.addAll(storeDataList.sublist(storeDataList.length - count));
      Set<String> uniqueNames = {};

      for (var log in storeDataList.reversed) {
        // Reverse to preserve order
        if (uniqueNames.length < 5) {
          if (log.fullName != null && !uniqueNames.contains(log.fullName)) {
            uniqueNames.add(log.fullName!);
            nameList.add(log);
          }
        }
      }
      nameList.refresh();
      nameController.text = storeDataList.last.fullName ?? '';

      // bNumberController.text = storeDataList.last.formBNumber ?? '';
      // cNumberController.text = storeDataList.last.formCNumber ?? '';
    }
  }

  getCurrentLatLong() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      Permission.location.request();
    } else if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        if (position != null) {
          location.value = '${position.latitude}, ${position.longitude}';
          print(
              '***************************000000000000000000000 ${position.latitude}');
        } else {}
      } catch (e) {
        print('ERROR = ${e.toString()}');
      }
    }
  }

  void fieldsMissedDialog(BuildContext context) {
    return CommonConstant.instance.commonShowDialogs(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppString.fieldsMiss,
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
                AppString.fieldsMissText,
                textAlign: TextAlign.center,
                style: CTC.style(14,
                    fontColor: ColorConstant.textBlackToWhite(context)),
              ),
            ),
            SizedBox(
              height: getHeight(15),
            ),
          ],
        ),
        firstButtonTitle: AppString.proceed,
        firstOnPressed: () {
          Get.back();
        },
        context: context);
  }
}
