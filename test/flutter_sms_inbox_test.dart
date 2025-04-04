import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flutter_sms_inbox_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SmsQuery>()])
// import 'sms.query.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockSmsQuery = MockSmsQuery();
  SmsQuery.instance = mockSmsQuery;
  final SmsQuery smsQuery = SmsQuery();

  tearDown(resetMockitoState);

  test('getAllSms should call the underlying instance', () async {
    when(smsQuery.getAllSms).thenAnswer((_) async => Future.value([]));

    await smsQuery.getAllSms;
    verify(smsQuery.getAllSms).called(1);
  });

  test('querySms should call the underlying instance', () async {
    when(smsQuery.querySms()).thenAnswer((_) async => Future.value([]));

    await smsQuery.querySms();
    verify(smsQuery.querySms()).called(1);
  });
}
