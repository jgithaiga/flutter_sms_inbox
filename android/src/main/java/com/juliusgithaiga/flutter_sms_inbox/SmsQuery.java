package com.juliusgithaiga.flutter_sms_inbox;

import android.content.Context;

import com.juliusgithaiga.flutter_sms_inbox.permissions.Permissions;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

class SmsQuery implements MethodCallHandler {
	private final ActivityPluginBinding activityPluginBinding;
	private final Permissions permissions;
	private Context appContext;

	SmsQuery(Context appContext, ActivityPluginBinding binding) {
		this.appContext = appContext;
		this.activityPluginBinding = binding;
		this.permissions = new Permissions(binding.getActivity());
	}

	@Override
	public void onMethodCall(MethodCall methodCall, Result result) {
		int start = 0;
		int count = -1;
		int threadId = -1;
		String address = null;
		SmsQueryRequest request;

		switch (methodCall.method) {
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

		if (methodCall.hasArgument("start")) {
			start = methodCall.argument("start");
		}

		if (methodCall.hasArgument("count")) {
			count = methodCall.argument("count");
		}

		if (methodCall.hasArgument("thread_id")) {
			threadId = methodCall.argument("thread_id");
		}

		if (methodCall.hasArgument("address")) {
			address = methodCall.argument("address");
		}

		SmsQueryHandler handler = new SmsQueryHandler(appContext, result, request, start, count, threadId, address);
		this.activityPluginBinding.addRequestPermissionsResultListener(handler);
		handler.handle(permissions);
	}

}
