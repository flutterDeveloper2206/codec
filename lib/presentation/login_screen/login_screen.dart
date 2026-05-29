import 'package:cotec/widgets/common_title_textField.dart';

import '../../core/app_export.dart';
import 'controller/login_screen_controller.dart';

class LoginScreen extends GetWidget<LoginScreenController> {
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return Scaffold(
        backgroundColor: ColorConstant.backgroundColor(context),
        body: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.logIn,
                      style: CTC.style(50,
                          fontWeight: FontWeight.w500,
                          fontColor:  ColorConstant.text00ToWhite(context)),
                    ),
                    SizedBox(height: getHeight(20),),
                    titleText(
                        context: context,
                        title: AppString.email,

                        hintText: AppString.enterYourEmail,
                        onChanged: (p0) {
                          if (p0.isNotEmpty) {
                            // controller.ptsValidate.value = false;
                            // controller.isAllValidate.value = false;
                          }
                        },
                        textController: controller.email),SizedBox(height: getHeight(5),),
                    titleText(
                        context: context,
                        title: AppString.password,

                        hintText: AppString.enterPassword,
                        onChanged: (p0) {
                          if (p0.isNotEmpty) {
                            // controller.ptsValidate.value = false;
                            // controller.isAllValidate.value = false;
                          }
                        },
                        textController: controller.password),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getWidth(47),
                        right: getWidth(47),
                        bottom: getHeight(30),
                      ),
                      child: Obx(
                        () =>  AppElevatedButton(
                          hasBoxShadow: true,
                          isLoading: controller.isLoading.value,
                          buttonName: AppString.logIn,
                          onPressed: () {
                            controller.login();
                          },
                        ),
                      ),
                    )

                  ],
                ),
              )
            ),
        ),
        );

    // body: Center(
    //   child: Lottie.asset(
    //       Theme.of(context).brightness == Brightness.light
    //           ? 'assets/animation/cotec_light_bg.json'
    //           : 'assets/animation/cotec_dark_bg.json',
    //       repeat: false),
    // ));
  }
}
