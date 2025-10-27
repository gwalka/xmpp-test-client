import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class XmppClient {
  xmpp.Connection? _connection;
  xmpp.Connection? get connection => _connection;
  
  Future<bool> connect({
    required String jid,
    required String password,
    required String host,
    int port = 5222,
    String resource = 'flutter_client',
  }) async {
    final completer = Completer<bool>();
    try {
      // Настройки аккаунта
      final accountSettings = xmpp.XmppAccountSettings.fromJid(jid, password)
        ..host = host
        ..resource = resource
        ..port = kIsWeb ? 443 : port
        ..wsPath = kIsWeb ? '/xmpp-websocket' : null
        ..wsProtocols = kIsWeb ? ['xmpp'] : null;

      await disconnect();

      
      _connection = xmpp.Connection.getInstance(accountSettings);

      _connection!.connect();

      return completer.future;
    } catch (e, st) {
      debugPrint('Error connecting to XMPP: $e\n$st');
      if (!completer.isCompleted) completer.complete(false);
      return false;
    }
  }

  
  Future<void> disconnect() async {
  try {
    if (_connection != null && _connection!.state != xmpp.XmppConnectionState.Closed) {
      _connection!.close();
    }
    _connection = null;
  } catch (e) {
    debugPrint('Error disconecting $e');
  }
}
}

