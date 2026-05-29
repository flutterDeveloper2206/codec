import '../../../core/app_export.dart';
import '../controller/log_test_screen_controller.dart';

class LogTestScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LogTestScreenController());
  }
}
