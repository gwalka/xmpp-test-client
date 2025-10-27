import 'package:flutter/material.dart';
import '../xmpp_client.dart';

class LogoutPage extends StatelessWidget {
  final XmppClient xmppClient;

  const LogoutPage({super.key, required this.xmppClient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            xmppClient.disconnect();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}