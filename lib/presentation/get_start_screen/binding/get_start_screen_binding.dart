
import '../../../core/app_export.dart';
import '../controller/get_start_screen_controller.dart';

class GetStartScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetStartScreenController());
  }
}
