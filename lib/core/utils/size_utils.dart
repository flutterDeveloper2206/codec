import 'package:flutter/material.dart';

double widths = 0.0;
double heights = 0.0;
sizeCalculate(BuildContext context) {
  widths =
      View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
  heights =
      View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
}

double getWidth(double px) {
  return px * (widths / 360);
}

double getFontSize(double px) {
  return (widths / 360) > 1.5 ? px * 1.5 : px * (widths / 360);
}

double getHeight(double px) {
  return px * (heights / 370);
}
