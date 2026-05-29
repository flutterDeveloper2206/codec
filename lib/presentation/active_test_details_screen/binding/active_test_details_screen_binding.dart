import '../../../core/app_export.dart';
import '../controller/active_test_details_screen_controller.dart';

class ActiveTestDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActiveTestDetailScreenController());
  }
}
