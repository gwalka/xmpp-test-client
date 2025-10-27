// lib/screens/contacts_page.dart
import 'package:flutter/material.dart';
import '../xmpp_client.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class ContactsPage extends StatelessWidget {
  final XmppClient xmppClient;

  const ContactsPage({super.key, required this.xmppClient});

  @override
  Widget build(BuildContext context) {
    final connection = xmppClient.connection!;
    final rosterManager = xmpp.RosterManager.getInstance(connection);
    final roster = rosterManager.getRoster();

    final contactsList = roster.isEmpty
        ? ['Контактов нет']
        : roster.map((buddy) {
            final jid = buddy.jid!.userAtDomain;
            final name = buddy.name ?? 'Uknown';
            debugPrint('📋 $name ($jid)');
            return '$name ($jid)';
          }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contactsList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(contactsList[index]),
          trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.close,
        size: 18,
        color: const Color.fromARGB(231, 193, 30, 8)),
    const SizedBox(width: 8),
    Icon(Icons.chat_bubble_outline,
        size: 18,
        color: const Color.fromARGB(215, 6, 6, 226)),
            ],
          ),
        ),
      ),
    );
  }
}
