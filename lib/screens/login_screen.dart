import 'package:flutter/material.dart';
import '../xmpp_client.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _jidCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _hostCtrl = TextEditingController();
  final XmppClient _xmpp = XmppClient();
  bool _connecting = false;

  @override
  void dispose() {
    _jidCtrl.dispose();
    _passCtrl.dispose();
    _hostCtrl.dispose();
    super.dispose();
  }

  Future<void> _onConnectPressed() async {
    debugPrint("DEBUG: _onConnectPressed вызван!");
    setState(() => _connecting = true);
    final jid = _jidCtrl.text.trim();
    final pass = _passCtrl.text;
    final host = _hostCtrl.text.trim();

    if (jid.isEmpty || pass.isEmpty || host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      setState(() => _connecting = false);
      return;
    }

    final ok = await _xmpp.connect(jid: jid, password: pass, host: host);

    setState(() => _connecting = false);

    if (ok) {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(xmppClient: _xmpp)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to XMPP server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _jidCtrl,
              decoration: const InputDecoration(labelText: 'JID (user@domain)'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _hostCtrl,
              decoration: const InputDecoration(labelText: 'Host (xmpp server)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _connecting ? null : _onConnectPressed,
              child: Text(_connecting ? 'Connecting...' : 'Login'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

