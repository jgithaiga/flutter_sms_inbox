part of '../flutter_sms_inbox.dart';

/// Message
class SmsMessage implements Comparable<SmsMessage> {
  int? id;
  int? threadId;
  String? address;
  String? body;
  bool? read;
  DateTime? date;
  int? subId;
  DateTime? dateSent;
  SmsMessageKind? kind;
  SmsMessageState _state = SmsMessageState.none;
  final StreamController<SmsMessageState> _stateStreamController =
      StreamController<SmsMessageState>();

  SmsMessage.fromJson(Map data) {
    address = data["address"]?.toString();
    body = data["body"]?.toString();
    subId = _asInt(data["sub_id"]);

    if (data.containsKey("_id")) {
      id = _asInt(data["_id"]);
    }
    if (data.containsKey("thread_id")) {
      threadId = _asInt(data["thread_id"]);
    }
    if (data.containsKey("read")) {
      read = _asBool(data["read"]);
    }
    if (data.containsKey("kind")) {
      kind = data["kind"];
    }
    if (data.containsKey("date")) {
      final int? timestamp = _asInt(data["date"]);
      if (timestamp != null) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    }
    if (data.containsKey("date_sent")) {
      final int? timestamp = _asInt(data["date_sent"]);
      if (timestamp != null) {
        dateSent = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } else if (data.containsKey("dateSent")) {
      final int? timestamp = _asInt(data["dateSent"]);
      if (timestamp != null) {
        dateSent = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    }
  }

  static int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static bool? _asBool(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    final int? parsedInt = _asInt(value);
    if (parsedInt != null) {
      return parsedInt == 1;
    }
    if (value is String) {
      final String normalized = value.trim().toLowerCase();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
    return null;
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
    if (subId != null) {
      data["sub_id"] = subId;
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
      final int timestamp = dateSent!.millisecondsSinceEpoch;
      data["date_sent"] = timestamp;
      data["dateSent"] = timestamp;
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
    final int thisId = id ?? -1;
    final int otherId = other.id ?? -1;
    return otherId - thisId;
  }
}
