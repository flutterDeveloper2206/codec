import 'package:cotec/presentation/voltage_per_second_screen/controller/voltage_per_second_screen_controller.dart';

import '../../../core/app_export.dart';

class VoltagePerSecondScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoltagePerSecondScreenController());
  }
}
