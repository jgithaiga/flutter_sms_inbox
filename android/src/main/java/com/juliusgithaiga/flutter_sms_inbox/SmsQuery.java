package com.juliusgithaiga.flutter_sms_inbox;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SmsQuery implements MethodChannel.MethodCallHandler {

    private final Context applicationContext;
    private final Permissions permissions;

    SmsQuery(Activity activity, Context applicationContext) {
        this.applicationContext = applicationContext;
        this.permissions = new Permissions(activity);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int start = 0;
        int count = -1;
        int threadId = -1;
        String address = null;
        SmsQueryRequest request;
        switch (call.method) {
            case "getInbox":
                request = SmsQueryRequest.Inbox;
                break;
            case "getSent":
                request = SmsQueryRequest.Sent;
                break;
            case "getDraft":
                request = SmsQueryRequest.Draft;
                break;
            default:
                result.notImplemented();
                return;
        }
        if (call.hasArgument("start")) {
            start = call.argument("start");
        }
        if (call.hasArgument("count")) {
            count = call.argument("count");
        }
        if (call.hasArgument("thread_id")) {
            threadId = call.argument("thread_id");
        }
        if (call.hasArgument("address")) {
            address = call.argument("address");
        }
        SmsQueryHandler handler = new SmsQueryHandler(this.applicationContext, result, request, start, count, threadId, address);
//        this.registrar.addRequestPermissionsResultListener(handler);
        handler.handle(permissions);
    }
}
