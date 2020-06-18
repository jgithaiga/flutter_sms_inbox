enum SmsMessageState {
  Sending,
  Sent,
  Delivered,
  Fail,
  None,
}

enum SmsMessageKind {
  Sent,
  Received,
  Draft,
}

enum SmsQueryKind { Inbox, Sent, Draft }