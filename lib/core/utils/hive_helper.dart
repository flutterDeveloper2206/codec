import 'package:cotec/ApiServices/common_model/create_log_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  late Box<dynamic> box; // Specify the type of the box
  late Box<dynamic> lastFiveDataBox; // Specify the type of the box

  Future<void> initHive() async {
    final document = await getApplicationDocumentsDirectory();
    print('SAVE PATH : ${document.path}');
    Hive.init(document.path);
    box = await Hive.openBox('BOX');
  }

  static Box<CreateLog> getData() => Hive.box<CreateLog>("log_model");
  static Box<CreateLog> getDataLastFiveDataBox() => Hive.box<CreateLog>("LastFiveDataBox");

  // static Future<void> clearLogModelBox() async {
  //   final box = Hive.box<CreateLog>('log_model');
  //   await box.clear();
  //   print('All log_model data deleted.');
  // }
  static Future<void> clearLogModelBox() async {

    final box = Hive.box<CreateLog>('log_model');

    print("Before Clear : ${box.length}");

    await box.clear();

    print("After Clear : ${box.length}");

    print('All log_model data deleted.');
  }
}
