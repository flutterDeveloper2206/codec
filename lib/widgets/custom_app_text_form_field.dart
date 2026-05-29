import '../core/app_export.dart';

class CustomAppTextFormField extends StatelessWidget {
  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;
  BorderRadius? borderRadius;

  TextStyle? fontStyle;
  TextStyle? hintFontStyle;

  Alignment? alignment;
  List<TextInputFormatter>? inputFormatters;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;
  String? obscuringCharacter;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;
  Color? fillColor;
  Color? borderColor;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  bool? readOnly;

  Function()? onTap;

  Function(String)? onChanged;
  CustomAppTextFormField(
      {this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.borderColor,
      this.width,
      this.margin,
      this.hintFontStyle,
      this.controller,
      this.focusNode,
      this.borderRadius,
      this.inputFormatters,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.obscuringCharacter,
      this.fillColor,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.readOnly,
      this.onTap,
      this.onChanged,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        onTap: onTap,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        focusNode: focusNode,
        style: fontStyle ?? CTC.style(14),
        obscureText: isObscureText ?? false,
        obscuringCharacter: obscuringCharacter ?? '.',
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",

      hintStyle: hintFontStyle ?? CTC.style(14),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,

      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: fillColor ?? ColorConstant.primaryWhite,
      filled: true,

      isDense: true,
      // contentPadding: _setPadding(),
    );
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      case TextFormFieldShape.RoundedBorder18:
        return BorderRadius.circular(
          getWidth(
            18.00,
          ),
        );

      default:
        return BorderRadius.circular(
          getWidth(
            12.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.White:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.redFF2,
            width: 1,
          ),
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: borderRadius ?? _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: borderColor ?? ColorConstant.transparent,
            width: 1,
          ),
        );
    }
  }

  // _setPadding() {
  //   switch (padding) {
  //     case TextFormFieldPadding.PaddingT13:
  //       return getPadding(
  //         left: 12,
  //         top: 13,
  //         bottom: 13,
  //       );
  //     default:
  //       return getPadding(
  //         left: 12,
  //         top: 16,
  //         right: 12,
  //         bottom: 16,
  //       );
  //   }
  // }
}

enum TextFormFieldShape {
  RoundedBorder12,
  RoundedBorder18,
}

enum TextFormFieldPadding {
  PaddingT14,
  PaddingT13,
}

enum TextFormFieldVariant {
  None,
  OutlineGray200,
  White,
}

enum TextFormFieldFontStyle {
  GilroyMedium16Bluegray40001,
  GilroyMedium16,
  txtGilroyMedium
}
