package com.juliusgithaiga.flutter_sms_inbox;

import android.net.Uri;

public enum SmsQueryRequest {
    Inbox,
    Sent,
    Draft;

    Uri toUri() {
        if (this == Inbox) {
            return Uri.parse("content://sms/inbox");
        } else if (this == Sent) {
            return Uri.parse("content://sms/sent");
        } else {
            return Uri.parse("content://sms/draft");
        }
    }
}
