// import 'package:flutter/material.dart';
// import 'package:cotec/core/app_export.dart';
// import 'package:cotec/presentation/splash_screen/login_screen.dart';
//
// import './MainPage.dart';
//
// void main() => runApp(new ExampleApplication());
//
// class ExampleApplication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(title: 'Cotec',
//       theme: CustomTheme.lightTheme,
//       home: SplashScreen(),
//       darkTheme: CustomTheme.darkTheme,
//       themeMode: ThemeMode.system,
//       // theme: ThemeData(useMaterial3: true),
//       debugShowCheckedModeBanner: false,
//       getPages: AppRoutes.pages,);
//   }
// }

import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:cotec/widgets/error_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

import 'core/app_export.dart';
import 'core/utils/app_prefs_key.dart';
import 'core/utils/pref_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KeepScreenOn.turnOn();
  await Hive.initFlutter();
  Hive.registerAdapter(CreateLogAdapter());
  await Hive.openBox<CreateLog>('log_model');
  await Hive.openBox<CreateLog>('LastFiveDataBox');
  await CommonConstant.instance.dbHelper.initHive();
  ColorConstant();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(PrefUtils());

  ErrorWidget.builder =
      (FlutterErrorDetails details) => AppFlutterErrorScreen(details: details);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RxBool _isLightTheme = false.obs;

  _getThemeStatus() async {
    bool isLight =
        CommonConstant.instance.dbHelper.box.get(HiveKey.isDarkMode) ?? true;

    _isLightTheme.value = isLight;
    Get.changeThemeMode(_isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  void initState() {
    _getThemeStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cotec',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      // theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.splashScreenRoute,
    );
  }
}
