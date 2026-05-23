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

## Security notes

- This plugin reads sensitive user data (SMS metadata and message body). Request `READ_SMS` only when needed and explain the purpose clearly to users.
- Do not log, persist, or transmit SMS message content unless your app has a clear product and compliance need.
- Handle permission denial gracefully. Calls may fail if SMS permission is revoked or restricted by device policy.

### Error handling

Query calls can return structured platform errors:

- `permission_denied`: `READ_SMS` was denied or unavailable.
- `invalid_arguments`: one or more query arguments had an unexpected type or invalid value (`start >= 0`, `count == -1 or >= 0`, `thread_id == -1 or >= 0`, `kinds` must not be empty).
- `invalid_response`: platform returned an unexpected payload shape.
- `query_failed`: an unexpected platform failure occurred while querying SMS.

### Vulnerability scanning

Run dependency vulnerability scans locally with:

```bash
bash scripts/security_scan.sh
```

The script auto-detects supported OSV flags across versions. If severity filtering flags are unavailable in your scanner version, it falls back to scanning all severities.

CI also runs lockfile scans on pull requests and pushes using `.github/workflows/security-scan.yml`.

### Dependency maintenance

Generate a dependency status report with:

```bash
bash scripts/dependency_report.sh
```

See `docs/dependency-refresh-plan.md` for update cadence and triage workflow.

### Security release gate

Use `docs/security-release-checklist.md` before release-bound merges.

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

`start` and `count` are applied globally across the ordered `kinds` list (not per kind). For example, with `kinds: [SmsQueryKind.inbox, SmsQueryKind.sent]`, `start: 2`, and `count: 5`, the query skips the first 2 messages across inbox then sent, and returns up to the next 5 messages from that combined ordered sequence.

For safety, queries are bounded in the Dart layer:

- If `count` is omitted (or negative), the query uses a default cap of `200` messages.
- Oversized request windows are clamped to `1000` messages before native queries are made.

The Android native layer also applies a defensive fallback cap of `1000` messages if requests arrive with unbounded or oversized values.

## Privacy-safe usage patterns

- Keep queries narrow: always set `count` and use `address`/`threadId` filters where possible.
- Avoid rendering full SMS bodies by default in UI. Prefer a masked preview and add explicit user action before showing full content.
- Do not log SMS body or sender details in production builds.
- Do not persist or transmit SMS content unless it is strictly required and compliant with your product/privacy obligations.

You can also query all the sms messages sent and received from a specific contact:

```
await query.querySms(
    address: getContactAddress()
);
```
