package com.juliusgithaiga.flutter_sms_inbox;

import android.Manifest;
import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.PackageManager;
import android.database.Cursor;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class SmsQueryHandler implements PluginRegistry.RequestPermissionsResultListener {
	private final String[] permissionsList = new String[]{ Manifest.permission.READ_SMS };
	private Context appContext;
	private MethodChannel.Result result;
	private SmsQueryRequest request;
	private int start = 0;
	private int count = -1;
	private int threadId = -1;
	private String address = null;

	SmsQueryHandler(Context appContext, MethodChannel.Result result, SmsQueryRequest request,
					int start, int count, int threadId, String address) {
		this.appContext = appContext;
		this.result = result;
		this.request = request;
		this.start = start;
		this.count = count;
		this.threadId = threadId;
		this.address = address;
	}

	void handle(Permissions permissions) {
		if (permissions.checkAndRequestPermission(permissionsList, Permissions.READ_SMS_ID_REQ)) {
			querySms();
		}
	}

	private JSONObject readSms(Cursor cursor) {
		JSONObject res = new JSONObject();
		for (int idx = 0; idx < cursor.getColumnCount(); idx++) {
			try {
				if (cursor.getColumnName(idx).equals("address") || cursor.getColumnName(idx).equals("body")) {
					res.put(cursor.getColumnName(idx), cursor.getString(idx));
				} else if (cursor.getColumnName(idx).equals("date") || cursor.getColumnName(idx).equals("date_sent")) {
					res.put(cursor.getColumnName(idx), cursor.getLong(idx));
				} else {
					res.put(cursor.getColumnName(idx), cursor.getInt(idx));
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return res;
	}

	private void querySms() {
		ArrayList<JSONObject> list = new ArrayList<>();
		ContentResolver contextResolver = appContext.getContentResolver();
		Cursor cursor = contextResolver.query(this.request.toUri(), null, null, null, null);
		if (cursor == null) {
			result.error("#01", "permission denied", null);
			return;
		}

		if (!cursor.moveToFirst()) {
			cursor.close();
			result.success(list);
			return;
		}

		do {
			JSONObject obj = readSms(cursor);
			try {
				if (threadId >= 0 && obj.getInt("thread_id") != threadId) {
					continue;
				}
				if (address != null && !obj.getString("address").equals(address)) {
					continue;
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}

			if (start > 0) {
				start--;
				continue;
			}

			list.add(obj);

			if (count > 0) {
				count--;
			}
		} while (cursor.moveToNext() && count != 0);

		cursor.close();

		result.success(list);
	}

	@Override
	public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
		System.out.println("onRequestPermissionsResult > requestCode:" + requestCode);
		if (requestCode != Permissions.READ_SMS_ID_REQ) {
			return false;
		}

		boolean isOk = true;
		for (int res : grantResults) {
			if (res != PackageManager.PERMISSION_GRANTED) {
				isOk = false;
				break;
			}
		}

		if (isOk) {
			querySms();
			return true;
		}

		result.error("#01", "permission denied", null);

		return false;
	}
}
