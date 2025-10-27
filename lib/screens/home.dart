import 'package:flutter/material.dart';
import '../xmpp_client.dart';
import 'contacts.dart';
import 'login_screen.dart';

class HomePage extends StatelessWidget {
  final XmppClient xmppClient;

  const HomePage({super.key, required this.xmppClient});

  @override
  Widget build(BuildContext context) {
    final connection = xmppClient.connection;
    final accountName = connection?.account.fullJid.userAtDomain ?? 'Uknown';
    return Scaffold(
      appBar: AppBar(title: Text('Welcome \n$accountName')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsPage(xmppClient: xmppClient),
                  ),
                );
              },
              child: const Text('Contacts'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await xmppClient.disconnect();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}