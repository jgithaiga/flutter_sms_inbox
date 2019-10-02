import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_sms_inbox');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterSmsInbox.platformVersion, '42');
  });
}
