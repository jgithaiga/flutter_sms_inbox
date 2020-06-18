import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/enums.dart';
import 'package:flutter_sms_inbox/models.dart';

class DeleteSms {
  static DeleteSms _instance;
  final MethodChannel _channel;

  factory DeleteSms() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(
          "plugins.juliusgithaiga.com/deleteSMS", const JSONMethodCodec());
      _instance = new DeleteSms._private(methodChannel);
    }
    return _instance;
  }

  DeleteSms._private(this._channel);

  /// Wrapper for query only one kind
  Future<List<SmsMessage>> _querySmsWrapper({
    int start,
    int count,
    int threadId,
    String address,
    SmsQueryKind kind: SmsQueryKind.Inbox,
  }) async {
    Map arguments = {};
    if (start != null && start >= 0) {
      arguments["start"] = start;
    }
    if (count != null && count > 0) {
      arguments["count"] = count;
    }
    if (address != null && address.isNotEmpty) {
      arguments["address"] = address;
    }
    if (threadId != null && threadId >= 0) {
      arguments["thread_id"] = threadId;
    }

    String function = 'deleteSms';
    return await _channel.invokeMethod(function, arguments).then((dynamic val) {
      List<SmsMessage> list = [];
      for (Map data in val) {
        SmsMessage msg = new SmsMessage.fromJson(data);
        msg.kind = SmsMessageKind.Received;
        list.add(msg);
      }
      return list;
    });
  }

  /// Query a list of SMS
  Future<List<SmsMessage>> deleteSms({
    int start,
    int count,
    int threadId,
    String address,
    List<SmsQueryKind> kinds: const [SmsQueryKind.Inbox],
    bool sort: true,
  }) async {
    List<SmsMessage> result = [];
    for (var kind in kinds) {
      result
        ..addAll(await this._querySmsWrapper(
          start: start,
          count: count,
          address: address,
          threadId: threadId,
          kind: kind,
        ));
    }
    if (sort == true) {
      result.sort((a, b) => a.compareTo(b));
    }
    return (result);
  }
}
