package com.juliusgithaiga.flutter_sms_inbox;

import android.Manifest;
import android.database.Cursor;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class DeleteSmsHandler implements PluginRegistry.RequestPermissionsResultListener {
    private final PluginRegistry.Registrar registrar;
    private final String[] permissionsList = new String[]{Manifest.permission.READ_SMS};
    private MethodChannel.Result result;

    DeleteSmsHandler(PluginRegistry.Registrar registrar, MethodChannel.Result result) {
        this.registrar = registrar;
        this.result = result;
    }

    void handle(Permissions permissions) {
        if (permissions.checkAndRequestPermission(permissionsList, Permissions.SEND_SMS_ID_REQ)) {
            deleteSms();
        }
    }

    private void deleteSms() {
//        Uri uriSms = Uri.parse("content://sms/inbox");
        Cursor cursor = registrar.context().getContentResolver().query(this.request.toUri(), null, null, null, null);
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
