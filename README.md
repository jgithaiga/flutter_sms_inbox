# Flutter SMS Inbox

Flutter android SMS inbox library based on [Flutter SMS](https://github.com/babariviere/flutter_sms).

## Installation

Install the library from pub:

```
dependencies:
  flutter_sms_inbox: ^0.1.1+1
```

## Querying SMS messages

Add the import statement for sms and create an instance of the SmsQuery class:

```
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() {
  SmsQuery query = new SmsQuery();
}
```

## Getting all SMS messages

`List<SmsMessage> messages = await query.getAllSms;`

## Filtering SMS messages
The method `querySms` from the `SmsQuery` class returns a list of sms depending of the supplied parameters. For example, for querying all the sms messages sent and received write the followed code:

```
await query.querySms({
    kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent]
});
```
You can also query all the sms messages sent and received from a specific contact:

```
await query.querySms({
    address: getContactAddress()
});
```
