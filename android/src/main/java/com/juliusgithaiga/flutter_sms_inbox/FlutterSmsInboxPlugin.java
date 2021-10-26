package com.juliusgithaiga.flutter_sms_inbox;

import android.content.Context;
import androidx.annotation.NonNull;
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
public class FlutterSmsInboxPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private static final String CHANNEL_QUERY = "plugins.juliusgithaiga.com/querySMS";

  private BinaryMessenger binaryMessenger;
  private Context applicationContext;
  private MethodChannel methodChannel;
  private MethodChannel querySmsChannel;

  /** Plugin registration. */
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    final FlutterSmsInboxPlugin instance = new FlutterSmsInboxPlugin();
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    this.binaryMessenger = messenger;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;

    querySmsChannel.setMethodCallHandler(null);
    querySmsChannel = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    methodChannel = new MethodChannel(this.binaryMessenger, "flutter_sms_inbox");
    methodChannel.setMethodCallHandler(this);

    querySmsChannel = new MethodChannel(this.binaryMessenger, CHANNEL_QUERY, JSONMethodCodec.INSTANCE);
    querySmsChannel.setMethodCallHandler(new SmsQuery(binding.getActivity(), applicationContext));
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) { }

  @Override
  public void onDetachedFromActivityForConfigChanges() { }

  @Override
  public void onDetachedFromActivity() { }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
