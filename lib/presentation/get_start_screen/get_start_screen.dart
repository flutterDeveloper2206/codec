
import '../../../core/app_export.dart';
import 'controller/get_start_screen_controller.dart';

class GetStartScreen extends GetWidget<GetStartScreenController> {
  const GetStartScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        appBar: const CommonAppbar(title: AppString.getStart, hasBack: false),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(65), vertical: getHeight(100)),
              child: CustomImageView(
                imagePath: ImageConstant.appLogo,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getHeight(40), horizontal: getWidth(47)),
              child: AppElevatedButton(
                buttonName: AppString.getStart,
                onPressed: () {
                  Get.toNamed(AppRoutes.homeScreenRoute);
                },
              ),
            ),
          ],
        ));
  }
}
