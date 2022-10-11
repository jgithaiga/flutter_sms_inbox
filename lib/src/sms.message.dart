part of flutter_sms_inbox;

/// Message
class SmsMessage implements Comparable<SmsMessage> {
  int? id;
  int? threadId;
  String? address;
  String? body;
  bool? read;
  DateTime? date;
  DateTime? dateSent;
  SmsMessageKind? kind;
  SmsMessageState _state = SmsMessageState.none;
  final StreamController<SmsMessageState> _stateStreamController =
      StreamController<SmsMessageState>();

  SmsMessage.fromJson(Map data) {
    address = data["address"];
    body = data["body"];
    if (data.containsKey("_id")) {
      id = data["_id"];
    }
    if (data.containsKey("thread_id")) {
      threadId = data["thread_id"];
    }
    if (data.containsKey("read")) {
      read = (data["read"].toInt() == 1);
    }
    if (data.containsKey("kind")) {
      kind = data["kind"];
    }
    if (data.containsKey("date")) {
      date = DateTime.fromMillisecondsSinceEpoch(data["date"]);
    }
    if (data.containsKey("date_sent")) {
      dateSent = DateTime.fromMillisecondsSinceEpoch(data["date_sent"]);
    }
  }

  /// Convert SMS to map
  Map get toMap {
    Map data = {};
    if (address != null) {
      data["address"] = address;
    }
    if (body != null) {
      data["body"] = body;
    }
    if (id != null) {
      data["_id"] = id;
    }
    if (threadId != null) {
      data["thread_id"] = threadId;
    }
    if (read != null) {
      data["read"] = read;
    }
    if (date != null) {
      data["date"] = date!.millisecondsSinceEpoch;
    }
    if (dateSent != null) {
      data["dateSent"] = dateSent!.millisecondsSinceEpoch;
    }
    return data;
  }

  /// Getters
  String? get sender => address;
  bool? get isRead => read;
  SmsMessageState get state => _state;
  Stream<SmsMessageState> get onStateChanged => _stateStreamController.stream;

  /// Setters
  set state(SmsMessageState state) {
    if (_state != state) {
      _state = state;
      _stateStreamController.add(state);
    }
  }

  @override
  int compareTo(SmsMessage other) {
    return other.id! - id!;
  }
}
