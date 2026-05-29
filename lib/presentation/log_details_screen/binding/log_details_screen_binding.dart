import '../../../core/app_export.dart';
import '../controller/log_details_screen_controller.dart';

class LogDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LogDetailsScreenController());
  }
}
