part of flutter_sms_inbox;

class SmsQuery {
  static SmsQuery? _instance;
  final MethodChannel _channel;

  factory SmsQuery() {
    if (_instance == null) {
      const MethodChannel methodChannel = MethodChannel(
        "plugins.juliusgithaiga.com/querySMS",
        JSONMethodCodec(),
      );
      _instance = SmsQuery._private(methodChannel);
    }
    return _instance!;
  }

  SmsQuery._private(this._channel);

  /// Wrapper to query one kind at a time
  Future<List<SmsMessage>> _querySms({
    int? start,
    int? count,
    String? address,
    int? threadId,
    SmsQueryKind kind = SmsQueryKind.inbox,
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

    String function;
    SmsMessageKind msgKind;
    if (kind == SmsQueryKind.inbox) {
      function = "getInbox";
      msgKind = SmsMessageKind.received;
    } else if (kind == SmsQueryKind.sent) {
      function = "getSent";
      msgKind = SmsMessageKind.sent;
    } else {
      function = "getDraft";
      msgKind = SmsMessageKind.draft;
    }

    var snapshot = await _channel.invokeMethod(function, arguments);
    return snapshot.map<SmsMessage>(
      (var data) {
        var msg = SmsMessage.fromJson(data);
        msg.kind = msgKind;
        return msg;
      },
    ).toList();
  }

  /// Query a list of SMS
  Future<List<SmsMessage>> querySms({
    int? start,
    int? count,
    String? address,
    int? threadId,
    List<SmsQueryKind> kinds = const [SmsQueryKind.inbox],
    bool sort = false,
  }) async {
    List<SmsMessage> result = [];
    for (var kind in kinds) {
      result.addAll(await _querySms(
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

  /// Get all SMS
  Future<List<SmsMessage>> get getAllSms async {
    return querySms(kinds: [
      SmsQueryKind.sent,
      SmsQueryKind.inbox,
      SmsQueryKind.draft,
    ]);
  }
}
