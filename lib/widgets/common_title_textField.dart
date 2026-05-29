import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:cotec/presentation/active_test_screen/controller/active_test_screen_controller.dart';

import '../../core/app_export.dart';
Widget titleText(
    {required String title,
       bool? isValidate =true,
      bool isRequired = true,
      required BuildContext context,
      required Function(String) onChanged,
      List<TextInputFormatter>? inputFormatters,
      Color? fillColor,
      Widget? suffix,
      bool? readOnly,
      required TextEditingController textController,
      required String hintText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: CTC.style(16,
                fontWeight: FontWeight.w500,
                fontColor: !isValidate!
                    ? ColorConstant.textRedFF
                    : ColorConstant.text00ToWhite(context)),
          ),
          if (!isValidate && isRequired)
            Text(
              AppString.isRequired,
              style: CTC.style(16,
                  fontWeight: FontWeight.w400,
                  fontColor: ColorConstant.textRedFF),
            ),
        ],
      ),
      SizedBox(
        height: getHeight(10),
      ),
      Form(
        child: CustomAppTextFormField(
          controller: textController,
          hintText: hintText,
          readOnly: readOnly ?? false,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          fillColor: fillColor ?? ColorConstant.containerBackGround(context),
          fontStyle: CTC.style(16,
              fontWeight: FontWeight.w500,
              fontColor: ColorConstant.textGrey4c4cToWhite(context)),
          hintFontStyle: CTC.style(16, fontColor: ColorConstant.grey9DA),
          suffix: suffix,
          borderColor: !isValidate
              ? ColorConstant.textRedFF
              : ColorConstant.transparent,
        ),
      ),
      SizedBox(
        height: getHeight(15),
      ),
    ],
  );
}