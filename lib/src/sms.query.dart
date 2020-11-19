part of flutter_sms_inbox;

/// A SMS query
class SmsQuery {
  static SmsQuery _instance;
  final MethodChannel _channel;

  factory SmsQuery() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(
        "plugins.juliusgithaiga.com/querySMS",
        const JSONMethodCodec(),
      );
      _instance = new SmsQuery._private(methodChannel);
    }
    return _instance;
  }

  SmsQuery._private(this._channel);

  /// Wrapper for query only one kind
  Future<List<SmsMessage>> _querySmsWrapper({
    int start,
    int count,
    int threadId,
    String address,
    SmsQueryKind kind: SmsQueryKind.Inbox,
  }) {
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

    String function;
    SmsMessageKind msgKind;
    if (kind == SmsQueryKind.Inbox) {
      function = "getInbox";
      msgKind = SmsMessageKind.Received;
    } else if (kind == SmsQueryKind.Sent) {
      function = "getSent";
      msgKind = SmsMessageKind.Sent;
    } else {
      function = "getDraft";
      msgKind = SmsMessageKind.Draft;
    }

    return _channel.invokeMethod(function, arguments).then((dynamic val) {
      List<SmsMessage> list = [];
      for (Map data in val) {
        SmsMessage msg = new SmsMessage.fromJson(data);
        msg.kind = msgKind;
        list.add(msg);
      }
      return list;
    });
  }

  /// Query a list of SMS
  Future<List<SmsMessage>> querySms({
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
          kind: kind,
          start: start,
          count: count,
          address: address,
          threadId: threadId,
        ));
    }

    if (sort == true) {
      result.sort((a, b) => a.compareTo(b));
    }

    return (result);
  }

  /// Get all SMS
  Future<List<SmsMessage>> get getAllSms {
    return this.querySms(
      kinds: [
        SmsQueryKind.Sent,
        SmsQueryKind.Inbox,
        SmsQueryKind.Draft,
      ],
    );
  }
}
