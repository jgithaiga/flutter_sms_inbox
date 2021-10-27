part of flutter_sms_inbox;

/// Message
class SmsMessage implements Comparable<SmsMessage> {
  int? _id;
  int? _threadId;
  String? _address;
  String? _body;
  bool? _read;
  DateTime? _date;
  DateTime? _dateSent;
  SmsMessageKind? _kind;
  SmsMessageState _state = SmsMessageState.none;
  final StreamController<SmsMessageState> _stateStreamController =
      StreamController<SmsMessageState>();

  SmsMessage(
    this._address,
    this._body, {
    int? id,
    int? threadId,
    bool? read,
    DateTime? date,
    DateTime? dateSent,
    SmsMessageKind? kind,
  }) {
    _id = id;
    _threadId = threadId;
    _read = read;
    _date = date;
    _dateSent = dateSent;
    _kind = kind;
  }

  SmsMessage.fromJson(Map data) {
    _address = data["address"];
    _body = data["body"];
    if (data.containsKey("_id")) {
      _id = data["_id"];
    }
    if (data.containsKey("thread_id")) {
      _threadId = data["thread_id"];
    }
    if (data.containsKey("read")) {
      _read = (data["read"].toInt() == 1);
    }
    if (data.containsKey("kind")) {
      _kind = data["kind"];
    }
    if (data.containsKey("date")) {
      _date = DateTime.fromMillisecondsSinceEpoch(data["date"]);
    }
    if (data.containsKey("date_sent")) {
      _dateSent = DateTime.fromMillisecondsSinceEpoch(data["date_sent"]);
    }
  }

  /// Convert SMS to map
  Map get toMap {
    Map data = {};
    if (_address != null) {
      data["address"] = _address;
    }
    if (_body != null) {
      data["body"] = _body;
    }
    if (_id != null) {
      data["_id"] = _id;
    }
    if (_threadId != null) {
      data["thread_id"] = _threadId;
    }
    if (_read != null) {
      data["read"] = _read;
    }
    if (_date != null) {
      data["date"] = _date!.millisecondsSinceEpoch;
    }
    if (_dateSent != null) {
      data["dateSent"] = _dateSent!.millisecondsSinceEpoch;
    }
    return data;
  }

  /// Getters
  int? get id => _id;
  int? get threadId => _threadId;
  String? get sender => _address;
  String? get address => _address;
  String? get body => _body;
  bool? get isRead => _read;
  DateTime? get date => _date;
  DateTime? get dateSent => _dateSent;
  SmsMessageKind? get kind => _kind;
  SmsMessageState get state => _state;
  Stream<SmsMessageState> get onStateChanged => _stateStreamController.stream;

  /// Setters
  set kind(SmsMessageKind? kind) => _kind = kind;
  set date(DateTime? date) => _date = date;
  set state(SmsMessageState state) {
    if (_state != state) {
      _state = state;
      _stateStreamController.add(state);
    }
  }

  @override
  int compareTo(SmsMessage other) {
    return other._id! - _id!;
  }
}
