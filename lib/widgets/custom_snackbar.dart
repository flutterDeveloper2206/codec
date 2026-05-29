import '../core/app_export.dart';


class CustomSnackBar
{
  static void showSnackBar({headerText, bodyText}) {

    Get.closeAllSnackbars();
    Get.snackbar(
        headerText,
        bodyText,
        snackPosition: SnackPosition.TOP,
        colorText: ColorConstant.primaryBlack,
        backgroundColor: Color(0x66FFFFFF),
        margin: EdgeInsets.only(bottom: 26,left: 16,right: 16)

    );
  }
}