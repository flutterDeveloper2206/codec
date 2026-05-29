import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/app_export.dart';
import '../../core/utils/hive_helper.dart';
import 'controller/log_list_screen_controller.dart';

class LogListScreen extends StatefulWidget {
  const LogListScreen();

  @override
  State<LogListScreen> createState() => _LogListScreenState();
}

class _LogListScreenState extends State<LogListScreen> {
  LogListScreenController controller = LogListScreenController();

  // final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    controller = Get.put(LogListScreenController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sizeCalculate(context);
    return WillPopScope(
      onWillPop: () async {
        if (controller.isBack.value) {
          Get.back();
          Get.back();
          Get.back();
          Get.back();
        } else {
          Get.back();
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: ColorConstant.backgroundColor(context),
          appBar: CommonAppbar(
            title: AppString.logs,
            onTap: () {
              if (controller.isBack.value) {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
              } else {
                Get.back();
              }
            },
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getHeight(17),
                    ),
                    CustomAppTextFormField(
                            borderRadius: BorderRadius.circular(50),
                            hintText: AppString.searchHere,
                            hintFontStyle: CTC.style(14),
                            onChanged: (p0) {
                              controller.filterSearchResults(p0);
                            },
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: CustomImageView(
                                svgPath: ImageConstant.search,
                              ),
                            )),
                    Obx(
                      () => Column(
                        children: [
                          if (controller.selectedList.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: getHeight(20)),
                              child: AppElevatedButton(
                                showTextIcon: true,
                                svgPath: ImageConstant.download,
                                textColor: ColorConstant.yellowToBlack(context),
                                buttonColor:
                                    ColorConstant.textBlueToYellow(context),
                                buttonName: AppString.download,
                                svgColor: ColorConstant.yellowToBlack(context),
                                // textColor: ColorConstant.primaryYellow,
                                onPressed: () {
                                  controller.makePdf();
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        height: getHeight(
                            controller.selectedList.isNotEmpty ? 0 : 10),
                      ),
                    ),
                    Obx(
                      () => controller.searchList.isEmpty
                          ? SizedBox.shrink()
                          : Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.isSelected.value =
                                        !controller.isSelected.value;
                                    if (controller.isSelected.value) {
                                      controller.selectedList
                                          .addAll(controller.searchList);
                                    } else {
                                      controller.selectedList.clear();
                                    }
                                    print(
                                        'controller.selectedList ${controller.selectedList.length}');
                                  },
                                  icon: Icon(
                                    controller.isSelected.value
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: getHeight(25),
                                  ),
                                  color: ColorConstant.primaryYellow,
                                ),
                                Text(
                                  controller.isSelected.value
                                      ? AppString.unSelectAll
                                      : AppString.selectAll,
                                  style: CTC.style(18,
                                      fontWeight: FontWeight.w600,
                                      fontColor:
                                          ColorConstant.text00ToWhite(context)),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
              // Expanded(
              //   child: Obx(
              //     () => ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: controller.searchList.length,
              //       itemBuilder: (context, index) {
              //         var data = controller.searchList.value[index];
              //
              //         return Padding(
              //           padding:
              //               EdgeInsets.only(top: getHeight(index == 0 ? 10 : 0)),
              //           child: Bounce(
              //             onTap: () {
              //               Get.toNamed(AppRoutes.logDetailsScreenRoute);
              //             },
              //             child: listItem(
              //               context: context,
              //               item: data,
              //               isSelecteds: (bool value) {
              //                 if (value) {
              //                   controller.selectedList
              //                       .add(controller.searchList[index]);
              //                 } else {
              //                   controller.selectedList
              //                       .remove(controller.searchList[index]);
              //                 }
              //                 if (controller.selectedList.length ==
              //                     controller.searchList.length) {
              //                   controller.isSelected.value = true;
              //                 } else {
              //                   controller.isSelected.value = false;
              //                 }
              //                 print("$index : $value");
              //               },
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // )

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: DbHelper.getData().listenable(),
                  builder: (context, Box<CreateLog> box, _) {
                    // controller.itemLists.addAll(box.values);
                    // controller.searchList.value = controller.itemLists.value;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.loadList(box);
                    });

                    print('object');
                    return Obx(() => controller.isLoadingFirst.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.searchList.isEmpty
                            ? Center(
                                child: Text(
                                  AppString.noDataFound,
                                  style: CTC.style(26,
                                      fontWeight: FontWeight.w600,
                                      fontColor:
                                          ColorConstant.text00ToWhite(context)),
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!controller.isLoadingMore.value &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      controller.itemLists.length <
                                          controller.total) {
                                    controller.getLogHistory(false);
                                  } else {}
                                  return true;
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.searchList.length + 1,
                                  itemBuilder: (context, index) {
                                    // final todo = box.getAt(index)!;
                                    if (index == controller.searchList.length) {
                                      return controller.itemLists.length <
                                              controller.total
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : SizedBox.shrink();
                                    }
                                    var data = controller.searchList[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: getHeight(index == 0 ? 10 : 0)),
                                      child: Bounce(
                                        onTap: () {
                                          Get.toNamed(
                                              AppRoutes.logDetailsScreenRoute,
                                              arguments: {'createLog': data});
                                        },
                                        child: listItem(
                                          context: context,
                                          item: data,
                                          isSelecteds: (bool value) {
                                            if (value) {
                                              controller.selectedList.add(
                                                  controller.searchList[index]);
                                            } else {
                                              controller.selectedList.remove(
                                                  controller.searchList[index]);
                                            }
                                            if (controller
                                                    .selectedList.length ==
                                                controller.searchList.length) {
                                              controller.isSelected.value =
                                                  true;
                                            } else {
                                              controller.isSelected.value =
                                                  false;
                                            }
                                            print("$index : $value");
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ));
                  },
                ),
              )
            ],
          )),
    );
  }

  Widget listItem({
    required CreateLog item,
    required ValueChanged<bool> isSelecteds,
    required BuildContext context,
  }) {
    RxBool isSelected = false.obs;

    return Row(
      children: [
        SizedBox(
          width: getWidth(16),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: getHeight(20)),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(
                          Theme.of(context).brightness == Brightness.light
                              ? 0.3
                              : 0),
                      blurRadius: 5.0,
                      spreadRadius: 0.5),
                ],
                borderRadius: BorderRadius.circular(20),
                color: ColorConstant.containerBackGround(context)),
            padding: EdgeInsets.only(right: getWidth(12), top: getHeight(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                              value: controller.selectedList.contains(item),
                              onChanged: (value) {
                                print(value);
                                isSelecteds(value!);
                              },
                              side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 2,
                                    color: ColorConstant.primaryYellow),
                              ),
                              overlayColor: MaterialStatePropertyAll(
                                  ColorConstant.primaryYellow),
                              activeColor: ColorConstant.primaryYellow,
                            )

                        //     IconButton(
                        //   onPressed: () {
                        //     isSelected.value = !isSelected.value;
                        //     isSelecteds(isSelected.value);
                        //     print(' isSelected.value +++++  ${isSelected.value}');
                        //     print(
                        //         ' isSelected.value ++++fsfd+  ${!controller.selectedList.contains(item)}');
                        //     // if (isSelected.value) {
                        //     //   controller.selectedList.add(item);
                        //     // } else {
                        //     //   controller.selectedList.remove(item);
                        //     // }
                        //   },
                        //   icon: Icon(
                        //     !controller.selectedList.contains(item)
                        //         ? Icons.check_box_outline_blank
                        //         : Icons.check_box,
                        //     size: getHeight(25),
                        //   ),
                        //   color: ColorConstant.primaryYellow,
                        // ),
                        ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.formBNumber ?? '',
                            style: CTC.style(18,
                                fontWeight: FontWeight.w600,
                                fontColor:
                                    ColorConstant.textGrey4c4cToWhite(context)),
                          ),
                          SizedBox(
                            height: getHeight(10),
                          ),
                          Text(item.fullName ?? '',
                              style: CTC.style(
                                16,
                                fontColor:
                                    ColorConstant.textGrey4c4cToWhite(context),
                              )),
                          SizedBox(
                            height: getHeight(10),
                          ),
                          Text(
                              '${item.deviceSerialNumber ?? ' '} - ${item.date ?? ''}',
                              style: CTC.style(
                                16,
                                fontColor:
                                    ColorConstant.textGrey4c4cToWhite(context),
                              )),
                          SizedBox(
                            height: getHeight(10),
                          ),
                          Text(item.duration ?? '',
                              style: CTC.style(
                                16,
                                fontColor:
                                    ColorConstant.textGrey4c4cToWhite(context),
                              )),
                          SizedBox(
                            height: getHeight(10),
                          ),
                          Text(
                            item.testType ?? '',
                            style: CTC.style(16,
                                fontColor:
                                    ColorConstant.textGrey4c4cToWhite(context)),
                          ),
                          SizedBox(
                            height: getHeight(20),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: getHeight(15),
                    color: ColorConstant.textGrey4c4cToWhite(context),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: getWidth(16),
        ),
      ],
    );
  }
}
