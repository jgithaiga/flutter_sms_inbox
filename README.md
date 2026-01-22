# Flutter SMS Inbox

[![pub package](https://img.shields.io/pub/v/flutter_sms_inbox.svg)](https://pub.dev/packages/flutter_sms_inbox)
[![pub points](https://img.shields.io/pub/points/flutter_sms_inbox?color=2E8B57&label=pub%20points)](https://pub.dev/packages/flutter_sms_inbox/score)

Flutter android SMS inbox library based on [Flutter SMS](https://github.com/babariviere/flutter_sms).

## Installation

1. Add the package to your project by the following command:

```bash
flutter pub add flutter_sms_inbox
```

2. Add `permission_handler` package to your project because this package uses it for permission handling:

```bash
flutter pub add permission_handler
```

3. Add the following permission to your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.READ_SMS"/>
```

## Permission Handling

You need to request the SMS permission before dealing with the package. You can do it by using the `permission_handler` package. Here is an example of how to request the permission:

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> getSmsPermission() async {
  var permissionStatus = await Permission.sms.status;

  if (permissionStatus.isGranted) {
    return true;
  } else if (permissionStatus.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    if (await Permission.sms.request().isGranted) {
      return true;
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    openAppSettings();
  }
  return false;
}
```

## Querying SMS messages

Add the import statement for sms and create an instance of the SmsQuery class:

```
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() {
  SmsQuery query = SmsQuery();
}
```

## Getting all SMS messages

`List<SmsMessage> messages = await query.getAllSms;`

## Filtering SMS messages
The method `querySms` from the `SmsQuery` class returns a list of sms depending of the supplied parameters. For example, for querying all the sms messages sent and received write the followed code:

```
await query.querySms(
    kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
);
```
You can also query all the sms messages sent and received from a specific contact:

```
await query.querySms(
    address: getContactAddress()
);
```
