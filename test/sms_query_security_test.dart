import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel queryChannel = MethodChannel(
    'plugins.juliusgithaiga.com/querySMS',
    JSONMethodCodec(),
  );

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, null);
    SmsQuery.instance = null;
  });

  test('querySms strips invalid filter arguments before platform call',
      () async {
    MethodCall? capturedCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      capturedCall = call;
      return <Map<String, dynamic>>[];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> result = await query.querySms(
      start: -1,
      count: -5,
      threadId: -2,
      address: '',
      kinds: const [SmsQueryKind.inbox],
    );

    expect(result, isEmpty);
    expect(capturedCall, isNotNull);
    expect(capturedCall!.method, 'getInbox');

    final Map<dynamic, dynamic> args =
        capturedCall!.arguments as Map<dynamic, dynamic>;
    expect(args.containsKey('start'), isFalse);
    expect(args.containsKey('count'), isFalse);
    expect(args.containsKey('thread_id'), isFalse);
    expect(args.containsKey('address'), isFalse);
  });

  test('querySms forwards permission_denied PlatformException', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      throw PlatformException(
        code: 'permission_denied',
        message: 'READ_SMS permission denied or unavailable',
      );
    });

    final SmsQuery query = SmsQuery();

    expect(
      () => query.querySms(kinds: const [SmsQueryKind.inbox]),
      throwsA(
        isA<PlatformException>().having(
          (PlatformException e) => e.code,
          'code',
          'permission_denied',
        ),
      ),
    );
  });

  test('querySms forwards query_failed PlatformException', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      throw PlatformException(
        code: 'query_failed',
        message: 'Failed to query SMS content provider',
      );
    });

    final SmsQuery query = SmsQuery();

    expect(
      () => query.querySms(kinds: const [SmsQueryKind.inbox]),
      throwsA(
        isA<PlatformException>().having(
          (PlatformException e) => e.code,
          'code',
          'query_failed',
        ),
      ),
    );
  });
}
