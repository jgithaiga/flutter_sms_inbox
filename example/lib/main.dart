import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = List<SmsMessage>();

  @override
  void initState() {
    super.initState();
  }

  Widget _showMessagesList() {
    return ListView.builder(
      itemCount: _messages?.length,
      itemBuilder: (BuildContext context, int i) {
        var message = _messages[i];

        return ListTile(
          title: Text('#${message.id} from ${message.address}'),
          subtitle: Text(message.body),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example App'),
          actions: <Widget>[
            OutlineButton(
              child: Text('READ 10 MESSAGES'),
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: () async {
                var messages = await _query.querySms(
                  kinds: [SmsQueryKind.Inbox],
                  count: 10,
                );
                setState(() => _messages = messages);
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: _showMessagesList(),
        ),
      ),
    );
  }
}
