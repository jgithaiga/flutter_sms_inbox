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

  test('querySms throws invalid_arguments when kinds is empty', () {
    final SmsQuery query = SmsQuery();

    expect(
      () => query.querySms(kinds: const <SmsQueryKind>[]),
      throwsA(
        isA<PlatformException>().having(
          (PlatformException e) => e.code,
          'code',
          'invalid_arguments',
        ),
      ),
    );
  });

  test('querySms returns empty without platform call when count is zero',
      () async {
    MethodCall? capturedCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      capturedCall = call;
      return <Map<String, dynamic>>[];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> result = await query.querySms(
      count: 0,
      kinds: const [SmsQueryKind.inbox],
    );

    expect(result, isEmpty);
    expect(capturedCall, isNull);
  });

  test('querySms trims address before platform call', () async {
    MethodCall? capturedCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      capturedCall = call;
      return <Map<String, dynamic>>[];
    });

    final SmsQuery query = SmsQuery();
    await query.querySms(
      address: '  +1234567890  ',
      kinds: const [SmsQueryKind.inbox],
    );

    final Map<dynamic, dynamic> args =
        capturedCall!.arguments as Map<dynamic, dynamic>;
    expect(args['address'], '+1234567890');
  });

  test('querySms omits whitespace-only address', () async {
    MethodCall? capturedCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      capturedCall = call;
      return <Map<String, dynamic>>[];
    });

    final SmsQuery query = SmsQuery();
    await query.querySms(
      address: '   ',
      kinds: const [SmsQueryKind.inbox],
    );

    final Map<dynamic, dynamic> args =
        capturedCall!.arguments as Map<dynamic, dynamic>;
    expect(args.containsKey('address'), isFalse);
  });

  test('querySms de-duplicates kinds before platform calls', () async {
    final List<String> calledMethods = <String>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      calledMethods.add(call.method);
      return <Map<String, dynamic>>[
        <String, dynamic>{
          '_id': calledMethods.length,
          'thread_id': 1,
          'address': '+100',
          'body': 'ok',
          'read': 1,
          'date': 1700000000000,
          'date_sent': 1700000000000,
          'sub_id': 0,
        }
      ];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> messages = await query.querySms(
      kinds: const [SmsQueryKind.inbox, SmsQueryKind.inbox, SmsQueryKind.sent],
    );

    expect(calledMethods, <String>['getInbox', 'getSent']);
    expect(messages.length, 2);
  });

  test('querySms enforces count as global cap across kinds', () async {
    final List<String> calledMethods = <String>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      calledMethods.add(call.method);
      if (call.method == 'getInbox') {
        return <Map<String, dynamic>>[
          <String, dynamic>{
            '_id': 1,
            'thread_id': 1,
            'address': '+101',
            'body': 'first',
            'read': 1,
            'date': 1700000000000,
            'date_sent': 1700000000000,
            'sub_id': 0,
          },
          <String, dynamic>{
            '_id': 2,
            'thread_id': 1,
            'address': '+101',
            'body': 'second',
            'read': 1,
            'date': 1700000000001,
            'date_sent': 1700000000001,
            'sub_id': 0,
          },
        ];
      }

      return <Map<String, dynamic>>[
        <String, dynamic>{
          '_id': 3,
          'thread_id': 2,
          'address': '+202',
          'body': 'third',
          'read': 1,
          'date': 1700000000002,
          'date_sent': 1700000000002,
          'sub_id': 0,
        }
      ];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> messages = await query.querySms(
      count: 2,
      kinds: const [SmsQueryKind.inbox, SmsQueryKind.sent],
    );

    expect(messages.length, 2);
    expect(calledMethods, <String>['getInbox']);
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

  test('querySms maps kinds to platform methods and message kinds', () async {
    final List<String> calledMethods = <String>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      calledMethods.add(call.method);
      return <Map<String, dynamic>>[
        <String, dynamic>{
          '_id': calledMethods.length,
          'thread_id': 7,
          'address': '+1234567890',
          'body': 'Hello',
          'read': 1,
          'date': 1700000000000,
          'date_sent': 1700000000000,
          'sub_id': 0,
        }
      ];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> messages = await query.querySms(
      kinds: const [SmsQueryKind.inbox, SmsQueryKind.sent, SmsQueryKind.draft],
    );

    expect(calledMethods, <String>['getInbox', 'getSent', 'getDraft']);
    expect(messages.length, 3);
    expect(messages[0].kind, SmsMessageKind.received);
    expect(messages[1].kind, SmsMessageKind.sent);
    expect(messages[2].kind, SmsMessageKind.draft);
  });

  test('querySms throws invalid_response for non-list payload', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      return <String, dynamic>{'unexpected': true};
    });

    final SmsQuery query = SmsQuery();

    expect(
      () => query.querySms(kinds: const [SmsQueryKind.inbox]),
      throwsA(
        isA<PlatformException>().having(
          (PlatformException e) => e.code,
          'code',
          'invalid_response',
        ),
      ),
    );
  });

  test('querySms throws invalid_response for non-map item payload', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      return <dynamic>['invalid-item'];
    });

    final SmsQuery query = SmsQuery();

    expect(
      () => query.querySms(kinds: const [SmsQueryKind.inbox]),
      throwsA(
        isA<PlatformException>().having(
          (PlatformException e) => e.code,
          'code',
          'invalid_response',
        ),
      ),
    );
  });

  test('querySms accepts mixed primitive payload types', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      return <Map<String, dynamic>>[
        <String, dynamic>{
          '_id': '42',
          'thread_id': '7',
          'address': 12345,
          'body': 67890,
          'read': '1',
          'date': '1700000000000',
          'date_sent': 1700000000001,
          'sub_id': 2.0,
        }
      ];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> messages = await query.querySms(
      kinds: const [SmsQueryKind.inbox],
    );

    expect(messages.length, 1);
    final SmsMessage message = messages.first;
    expect(message.id, 42);
    expect(message.threadId, 7);
    expect(message.address, '12345');
    expect(message.body, '67890');
    expect(message.read, isTrue);
    expect(message.date, isNotNull);
    expect(message.dateSent, isNotNull);
    expect(message.subId, 2);
  });

  test('querySms sort does not throw when id is missing', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(queryChannel, (MethodCall call) async {
      return <Map<String, dynamic>>[
        <String, dynamic>{
          'thread_id': 3,
          'address': '+1234567890',
          'body': 'no id',
          'read': true,
        },
        <String, dynamic>{
          '_id': 9,
          'thread_id': 3,
          'address': '+1234567890',
          'body': 'with id',
          'read': false,
        },
      ];
    });

    final SmsQuery query = SmsQuery();
    final List<SmsMessage> messages = await query.querySms(
      kinds: const [SmsQueryKind.inbox],
      sort: true,
    );

    expect(messages.length, 2);
    expect(messages.first.id, 9);
  });

  test('SmsMessage supports both date_sent and dateSent input keys', () {
    final SmsMessage fromSnake = SmsMessage.fromJson(<String, dynamic>{
      'date_sent': '1700000000000',
    });
    final SmsMessage fromCamel = SmsMessage.fromJson(<String, dynamic>{
      'dateSent': 1700000000001,
    });

    expect(fromSnake.dateSent, isNotNull);
    expect(fromCamel.dateSent, isNotNull);
  });

  test('SmsMessage toMap includes both date_sent and dateSent', () {
    final SmsMessage message = SmsMessage.fromJson(<String, dynamic>{
      '_id': 1,
      'date_sent': 1700000000000,
    });

    final Map<dynamic, dynamic> map = message.toMap;
    expect(map['date_sent'], 1700000000000);
    expect(map['dateSent'], 1700000000000);
  });

  test('SmsMessage read parser accepts trimmed string boolean', () {
    final SmsMessage message = SmsMessage.fromJson(<String, dynamic>{
      'read': ' TRUE ',
    });

    expect(message.read, isTrue);
  });
}
