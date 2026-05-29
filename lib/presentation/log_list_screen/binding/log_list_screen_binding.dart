import '../../../core/app_export.dart';
import '../controller/log_list_screen_controller.dart';

class LogListScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LogListScreenController());
  }
}
