part of flutter_sms_inbox;

class DeleteSms {
  static DeleteSms _instance;
  final MethodChannel _channel;

  factory DeleteSms() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(
        "plugins.juliusgithaiga.com/deleteSMS",
        const JSONMethodCodec(),
      );
      _instance = new DeleteSms._private(methodChannel);
    }
    return _instance;
  }

  DeleteSms._private(this._channel);

  /// DELETE SMS BY ID (< Android 4.4)
  Future<String> deleteSms({ int smsId, }) async {
    Map arguments = {};
    if (smsId != null && smsId >= 0) {
      arguments["smsId"] = smsId;
    }

    String function = 'deleteSms';
    dynamic response = await _channel.invokeMethod(function, arguments);
    print('DeleteSms > _queryWrapper > response: $response');

    return response;
  }
}
