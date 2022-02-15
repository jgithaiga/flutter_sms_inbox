part of flutter_sms_inbox;

enum SmsMessageState {
  sending,
  sent,
  delivered,
  fail,
  none,
}

enum SmsMessageKind {
  sent,
  received,
  draft,
}

enum SmsQueryKind { inbox, sent, draft }
