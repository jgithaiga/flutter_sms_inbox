package com.juliusgithaiga.flutter_sms_inbox;

import android.content.Context;
import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SmsQuery implements MethodChannel.MethodCallHandler {

    private static final String TAG = "SmsQuery";

    private final Context applicationContext;

    SmsQuery(Context applicationContext) {
        this.applicationContext = applicationContext;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int start;
        int count;
        int threadId;
        String address;
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

        try {
            start = getIntArg(call, "start", 0);
            count = getIntArg(call, "count", -1);
            threadId = getIntArg(call, "thread_id", -1);
            address = getStringArg(call, "address", null);

            if (start < 0) {
                throw new IllegalArgumentException("Argument 'start' must be >= 0");
            }
            if (count < -1) {
                throw new IllegalArgumentException("Argument 'count' must be -1 or >= 0");
            }
            if (threadId < -1) {
                throw new IllegalArgumentException("Argument 'thread_id' must be -1 or >= 0");
            }
        } catch (ClassCastException e) {
            Log.w(TAG, "Invalid method arguments for " + call.method, e);
            result.error("invalid_arguments", "One or more arguments had an invalid runtime type", null);
            return;
        } catch (IllegalArgumentException e) {
            Log.w(TAG, "Invalid method arguments for " + call.method, e);
            result.error("invalid_arguments", e.getMessage(), null);
            return;
        }

        SmsQueryHandler smsQueryHandler = new SmsQueryHandler(
                this.applicationContext, result, request, start, count, threadId, address);
        smsQueryHandler.handle();
    }

    private int getIntArg(MethodCall call, String key, int defaultValue) {
        if (!call.hasArgument(key)) {
            return defaultValue;
        }
        Object value;
        try {
            value = call.argument(key);
        } catch (ClassCastException e) {
            throw new IllegalArgumentException("Argument '" + key + "' must be a number", e);
        }
        if (value == null) {
            return defaultValue;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        throw new IllegalArgumentException("Argument '" + key + "' must be a number");
    }

    private String getStringArg(MethodCall call, String key, String defaultValue) {
        if (!call.hasArgument(key)) {
            return defaultValue;
        }
        Object value;
        try {
            value = call.argument(key);
        } catch (ClassCastException e) {
            throw new IllegalArgumentException("Argument '" + key + "' must be a string", e);
        }
        if (value == null) {
            return defaultValue;
        }
        if (value instanceof String) {
            return (String) value;
        }
        throw new IllegalArgumentException("Argument '" + key + "' must be a string");
    }
}
