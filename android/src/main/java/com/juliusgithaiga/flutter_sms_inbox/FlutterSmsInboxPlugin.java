package com.juliusgithaiga.flutter_sms_inbox;

import android.content.Context;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterSmsInboxPlugin */
public class FlutterSmsInboxPlugin implements ActivityAware, FlutterPlugin, MethodCallHandler {
  private static final String CHANNEL_QUERY = "plugins.juliusgithaiga.com/querySMS";
  private static final String CHANNEL_DELETE = "plugins.juliusgithaiga.com/deleteSMS";

  private ActivityPluginBinding activityPluginBinding;
  private BinaryMessenger binaryMessenger;
  private MethodChannel querySmsMethodChannel;
  private MethodChannel deleteSmsMethodChannel;

  /** Plugin registration. */
  @SuppressWarnings("deprecation")
//  public static void registerWith(Registrar registrar) {
//    final FlutterSmsInboxPlugin plugin = new FlutterSmsInboxPlugin();
//
////    plugin.activityPluginBinding = registrar.;
//    plugin.binaryMessenger = registrar.messenger();
//    plugin.setupPlugin(registrar.context(), registrar.messenger());
//
//    registrar.addRequestPermissionsResultListener(Permissions.getRequestsResultsListener());
//  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    this.binaryMessenger = binding.getBinaryMessenger();
    setupPlugin(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  private void setupPlugin(Context appContext, BinaryMessenger messenger) {
    /// QUERY SMS
    querySmsMethodChannel = new MethodChannel(messenger, CHANNEL_QUERY, JSONMethodCodec.INSTANCE);
    querySmsMethodChannel.setMethodCallHandler(new SmsQuery(appContext, this.activityPluginBinding));

    /// DELETE SMS
    deleteSmsMethodChannel = new MethodChannel(messenger, CHANNEL_DELETE, JSONMethodCodec.INSTANCE);
    deleteSmsMethodChannel.setMethodCallHandler(new DeleteSms(appContext, this.activityPluginBinding));
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    tearDownPlugin();
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    this.activityPluginBinding = binding;

    setupPlugin(binding.getActivity().getApplicationContext(), binaryMessenger);
    binding.addRequestPermissionsResultListener(Permissions.getRequestsResultsListener());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    tearDownPlugin();
  }

  private void tearDownPlugin() {
    this.activityPluginBinding = null;
    this.binaryMessenger = null;

    querySmsMethodChannel.setMethodCallHandler(null);
    querySmsMethodChannel = null;

    deleteSmsMethodChannel.setMethodCallHandler(null);
    deleteSmsMethodChannel = null;
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
