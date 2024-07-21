import 'package:logger/logger.dart';

class AppLog {
  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  static void d(String tag, String text) {
    logger.d('$tag ->  $text');
  }

  static void i(String tag, String text) {
    logger.i('$tag ->  $text');
  }

  static void e(String tag, String text) {
    logger.e('$tag ->  $text');
  }
}
