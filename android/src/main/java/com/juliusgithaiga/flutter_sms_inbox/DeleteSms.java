package com.juliusgithaiga.flutter_sms_inbox;

import android.content.Context;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DeleteSms implements MethodChannel.MethodCallHandler {
    private final ActivityPluginBinding activityPluginBinding;
    private final Permissions permissions;
    private Context appContext;

    DeleteSms(Context appContext, ActivityPluginBinding binding) {
        this.appContext = appContext;
        this.activityPluginBinding = binding;
        this.permissions = new Permissions(binding.getActivity());
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
//        SmsQueryRequest request = SmsQueryRequest.Inbox;
        int smsId = -1;

        if (methodCall.hasArgument("smsId")) {
            smsId = methodCall.argument("smsId");
        }

        DeleteSmsHandler handler = new DeleteSmsHandler(appContext, result); // smsId
        this.activityPluginBinding.addRequestPermissionsResultListener(handler);
        handler.handle(permissions);
    }
}
