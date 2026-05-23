part of '../flutter_sms_inbox.dart';

class SmsQuery {
  static SmsQuery? instance;
  final MethodChannel _channel;

  factory SmsQuery() {
    if (instance == null) {
      const MethodChannel methodChannel = MethodChannel(
        "plugins.juliusgithaiga.com/querySMS",
        JSONMethodCodec(),
      );
      instance = SmsQuery._private(methodChannel);
    }
    return instance!;
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
    final Map<String, Object> arguments = <String, Object>{};
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

    final dynamic snapshot = await _channel.invokeMethod(function, arguments);
    return _decodeSnapshot(snapshot, msgKind);
  }

  List<SmsMessage> _decodeSnapshot(dynamic snapshot, SmsMessageKind msgKind) {
    if (snapshot is! List) {
      throw PlatformException(
        code: 'invalid_response',
        message: 'Expected a list response from platform query',
      );
    }

    final List<SmsMessage> messages = <SmsMessage>[];
    for (final dynamic item in snapshot) {
      if (item is! Map) {
        throw PlatformException(
          code: 'invalid_response',
          message: 'Expected each SMS item to be a map',
        );
      }
      final SmsMessage msg = SmsMessage.fromJson(item);
      msg.kind = msgKind;
      messages.add(msg);
    }

    return messages;
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
    if (count == 0) {
      return <SmsMessage>[];
    }

    if (kinds.isEmpty) {
      throw PlatformException(
        code: 'invalid_arguments',
        message: 'Argument "kinds" must contain at least one query kind',
      );
    }

    final String? normalizedAddress = address?.trim();
    final String? sanitizedAddress =
        (normalizedAddress == null || normalizedAddress.isEmpty)
            ? null
            : normalizedAddress;

    final List<SmsQueryKind> uniqueKinds = <SmsQueryKind>[];
    for (final SmsQueryKind kind in kinds) {
      if (!uniqueKinds.contains(kind)) {
        uniqueKinds.add(kind);
      }
    }

    List<SmsMessage> result = [];
    for (var kind in uniqueKinds) {
      result.addAll(await _querySms(
        start: start,
        count: count,
        address: sanitizedAddress,
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
