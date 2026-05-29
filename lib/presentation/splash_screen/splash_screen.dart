import '../../core/app_export.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends GetWidget<SplashScreenController> {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        body: Obx(
          () => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.isStarted.value
                          ? CommonAppbar(hasBack: false)
                          : SizedBox(),
                      controller.isStarted.value
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: getWidth(47),
                                right: getWidth(47),
                                bottom: getHeight(30),
                              ),
                              child: AppElevatedButton(
                                hasBoxShadow: true,
                                buttonName: AppString.getStartedCamelCase,
                                onPressed: () {
controller.getStarted();                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Center(
                  child: Lottie.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? 'assets/animation/cotec_light_bg.json'
                          : 'assets/animation/cotec_dark_bg.json',
                      repeat: false),
                ),
              ],
            ),
          ),
        ));

    // body: Center(
    //   child: Lottie.asset(
    //       Theme.of(context).brightness == Brightness.light
    //           ? 'assets/animation/cotec_light_bg.json'
    //           : 'assets/animation/cotec_dark_bg.json',
    //       repeat: false),
    // ));
  }
}
