package com.juliusgithaiga.flutter_sms_inbox;

import android.content.Context;
import android.database.Cursor;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import io.flutter.plugin.common.MethodChannel;

public class SmsQueryHandler {

    private final Context applicationContext;
    private final MethodChannel.Result result;
    private final SmsQueryRequest request;
    private final String address;
    private final int threadId;
    private int start;
    private int count;

    SmsQueryHandler(Context applicationContext, MethodChannel.Result result, SmsQueryRequest request,
                    int start, int count, int threadId, String address) {
        this.applicationContext = applicationContext;
        this.result = result;
        this.request = request;
        this.threadId = threadId;
        this.address = address;
        this.start = start;
        this.count = count;
    }

    void handle() {
        ArrayList<JSONObject> list = new ArrayList<>();
        Cursor cursor = this.applicationContext.getContentResolver().query(this.request.toUri(), null, null, null, null);
        if (cursor == null) {
            result.error("no_cursor", "flutter_sms_inbox plugin requires cursor to resolve content", null);
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

    private JSONObject readSms(Cursor cursor) {
        JSONObject res = new JSONObject();
        for (int i = 0; i < cursor.getColumnCount(); i++) {
            try {
                if (cursor.getColumnName(i).equals("address") || cursor.getColumnName(i).equals("body")) {
                    res.put(cursor.getColumnName(i), cursor.getString(i));
                } else if (cursor.getColumnName(i).equals("date") || cursor.getColumnName(i).equals("date_sent")) {
                    res.put(cursor.getColumnName(i), cursor.getLong(i));
                } else {
                    res.put(cursor.getColumnName(i), cursor.getInt(i));
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return res;
    }

}
