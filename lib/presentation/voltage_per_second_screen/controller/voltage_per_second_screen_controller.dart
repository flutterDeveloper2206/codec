import '../../../core/app_export.dart';
import '../../../core/utils/app_prefs_key.dart';

class VoltagePerSecondScreenController extends GetxController {
  RxInt selectedValue = 3.obs;

  @override
  void onInit() {
    setSecond();
    super.onInit();
  }

  setSecond() {
    var value =
        CommonConstant.instance.dbHelper.box.get(HiveKey.voltagePerSecond);
    selectedValue.value = value;
    print('VOLTAGE SECOND = ${value}');
  }
}
