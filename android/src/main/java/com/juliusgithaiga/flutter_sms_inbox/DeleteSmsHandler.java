package com.juliusgithaiga.flutter_sms_inbox;

import android.Manifest;
import android.content.Context;
import android.database.Cursor;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class DeleteSmsHandler implements PluginRegistry.RequestPermissionsResultListener {
    private final String[] permissionsList = new String[]{Manifest.permission.READ_SMS};
    private Context appContext;
    private MethodChannel.Result result;

    DeleteSmsHandler(Context appContext, MethodChannel.Result result) {
        this.appContext = appContext;
        this.result = result;
    }

    void handle(Permissions permissions) {
        if (permissions.checkAndRequestPermission(permissionsList, Permissions.DELETE_SMS_ID_REQ)) {
            deleteSms();
        }
    }

    private void deleteSms() {
        SmsQueryRequest request = SmsQueryRequest.Inbox;
        Cursor cursor = appContext.getContentResolver().query(request.toUri(), null, null, null, null);
        if (cursor == null) {
            result.error("#01", "permission denied", null);
            return;
        }
    }

    @Override
    public boolean onRequestPermissionsResult(int i, String[] strings, int[] ints) {
        return false;
    }
}
