import '../core/app_export.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final void Function()? onTap;
  final void Function()? clearOnTap;
  final bool hasActions;
  final bool hasBack;
  final Color? statusBarColor;
  final Color? backgroundColor;
  const CommonAppbar(
      {Key? key,
      this.onTap,
      this.clearOnTap,
      this.title,
      this.hasActions = false,
      this.hasBack = true,
      this.statusBarColor,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: statusBarColor ?? ColorConstant.appBarColor(context),

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
      backgroundColor: backgroundColor ?? ColorConstant.appBarColor(context),
      automaticallyImplyLeading: false,
      leading: hasBack
          ? Bounce(
              onTap: onTap ??
                  () {
                    Get.back();
                  },
              child: const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorConstant.primaryWhite,
                ),
              ))
          : null,
      actions: [
        hasActions
            ? Bounce(onTap: clearOnTap ?? () {}, child: const Icon(Icons.clear))
            : Container()
      ],
      centerTitle: true,
      title: title != null
          ? Text(
              title ?? '',
              style: CTC.style(16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.primaryWhite),
            )
          : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
