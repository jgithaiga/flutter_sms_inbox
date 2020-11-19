library flutter_sms_inbox;

import 'dart:async';
import 'package:flutter/services.dart';

part 'src/enums.dart';
part 'src/models.dart';
part 'src/sms.query.dart';
part 'src/delete.sms.dart';

class FlutterSmsInbox {
  static const MethodChannel _channel = const MethodChannel('flutter_sms_inbox');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

