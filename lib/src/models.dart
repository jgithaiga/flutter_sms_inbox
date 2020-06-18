import 'dart:async';

import 'package:flutter_sms_inbox/enums.dart';

/// A SMS Message
///
/// Used to send message or used to read message.
class SmsMessage implements Comparable<SmsMessage> {
  int _id;
  int _threadId;
  String _address;
  String _body;
  bool _read;
  DateTime _date;
  DateTime _dateSent;
  SmsMessageKind _kind;
  SmsMessageState _state = SmsMessageState.None;
  StreamController<SmsMessageState> _stateStreamController =
  new StreamController<SmsMessageState>();

  SmsMessage(this._address, this._body,
      {int id,
        int threadId,
        bool read,
        DateTime date,
        DateTime dateSent,
        SmsMessageKind kind}) {
    this._id = id;
    this._threadId = threadId;
    this._read = read;
    this._date = date;
    this._dateSent = dateSent;
    this._kind = kind;
  }

  /// Read message from JSON
  ///
  /// Format:
  ///
  /// ```json
  /// {
  ///   "address": "phone-number-here",
  ///   "body": "text message here"
  /// }
  /// ```
  SmsMessage.fromJson(Map data) {
    this._address = data["address"];
    this._body = data["body"];
    if (data.containsKey("_id")) {
      this._id = data["_id"];
    }
    if (data.containsKey("thread_id")) {
      this._threadId = data["thread_id"];
    }
    if (data.containsKey("read")) {
      this._read = data["read"] as int == 1;
    }
    if (data.containsKey("kind")) {
      this._kind = data["kind"];
    }
    if (data.containsKey("date")) {
      this._date = new DateTime.fromMillisecondsSinceEpoch(data["date"]);
    }
    if (data.containsKey("date_sent")) {
      this._dateSent =
      new DateTime.fromMillisecondsSinceEpoch(data["date_sent"]);
    }
  }

  /// Convert SMS to map
  Map get toMap {
    Map res = {};
    if (_address != null) {
      res["address"] = _address;
    }
    if (_body != null) {
      res["body"] = _body;
    }
    if (_id != null) {
      res["_id"] = _id;
    }
    if (_threadId != null) {
      res["thread_id"] = _threadId;
    }
    if (_read != null) {
      res["read"] = _read;
    }
    if (_date != null) {
      res["date"] = _date.millisecondsSinceEpoch;
    }
    if (_dateSent != null) {
      res["dateSent"] = _dateSent.millisecondsSinceEpoch;
    }
    return res;
  }

  /// Get message id
  int get id => this._id;

  /// Get thread id
  int get threadId => this._threadId;

  /// Get sender, alias phone number
  String get sender => this._address;

  /// Get address, alias phone number
  String get address => this._address;

  /// Get message body
  String get body => this._body;

  /// Check if message is read
  bool get isRead => this._read;

  /// Get date
  DateTime get date => this._date;

  /// Get date sent
  DateTime get dateSent => this._dateSent;

  /// Get message kind
  SmsMessageKind get kind => this._kind;

  Stream<SmsMessageState> get onStateChanged => _stateStreamController.stream;

  /// Set message kind
  set kind(SmsMessageKind kind) => this._kind = kind;

  /// Set message date
  set date(DateTime date) => this._date = date;

  /// Get message state
  get state => this._state;

  set state(SmsMessageState state) {
    if (this._state != state) {
      this._state = state;
      _stateStreamController.add(state);
    }
  }

  @override
  int compareTo(SmsMessage other) {
    return other._id - this._id;
  }
}
