import '../../../core/app_export.dart';
import '../controller/active_test_screen_controller.dart';

class ActiveTestScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActiveTestScreenController());
  }
}
