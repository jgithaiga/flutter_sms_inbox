package com.juliusgithaiga.flutter_sms_inbox;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterSmsInboxPlugin */
public class FlutterSmsInboxPlugin implements MethodCallHandler {
  private static final String CHANNEL_QUERY = "plugins.juliusgithaiga.com/querySMS";

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_sms_inbox");
    channel.setMethodCallHandler(new FlutterSmsInboxPlugin());

    registrar.addRequestPermissionsResultListener(Permissions.getRequestsResultsListener());

    /// SMS query
    final SmsQuery query = new SmsQuery(registrar);
    final MethodChannel querySmsChannel = new MethodChannel(registrar.messenger(), CHANNEL_QUERY, JSONMethodCodec.INSTANCE);
    querySmsChannel.setMethodCallHandler(query);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
