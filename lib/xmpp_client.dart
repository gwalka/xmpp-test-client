import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class XmppClient {
  xmpp.Connection? _connection;
  xmpp.Connection? get connection => _connection;
  StreamSubscription<xmpp.XmppConnectionState>? _stateSub;

  
  
  Future<bool> connect({
    required String jid,
    required String password,
    required String host,
    int port = 5222,
    String resource = 'flutter_client',
  }) async {
    debugPrint("XmppClient: connect() вызван");
    final completer = Completer<bool>();
    try {
      debugPrint("XmppClient: В try блоке");
      final accountSettings = xmpp.XmppAccountSettings.fromJid(jid, password)
        ..host = host
        ..resource = resource
        ..port = kIsWeb ? 443 : port
        ..wsPath = kIsWeb ? '/xmpp-websocket' : null
        ..wsProtocols = kIsWeb ? ['xmpp'] : null;

      
      await disconnect();

      _connection = xmpp.Connection.getInstance(accountSettings);

      
      _stateSub = _connection!.connectionStateStream.listen((state) {
        debugPrint('🔹 XMPP State -> $state');

        switch (state) {
          case xmpp.XmppConnectionState.Ready:
            debugPrint('Соединение установлено (Ready).');
            if (!completer.isCompleted) completer.complete(true);
            break;
          case xmpp.XmppConnectionState.Closed:
            debugPrint('Соединение закрыто.');
            if (!completer.isCompleted) completer.complete(false);
            break;
          case xmpp.XmppConnectionState.ForcefullyClosed:
            debugPrint('Соединение принудительно закрыто.');
            if (!completer.isCompleted) completer.complete(false);
            break;
          default:
            debugPrint('Другое состояние: $state');
        }
      });

      
      
      _connection!.connect();
      
      return completer.future;
    } catch (e, st) {
      debugPrint('Ошибка подключения XMPP: $e\n$st');
      if (!completer.isCompleted) completer.complete(false);
      return false;
    }
  }

  
  Future<void> disconnect() async {
    try {
      await _stateSub?.cancel();
      _stateSub = null;

      if (_connection != null) {
        if (_connection!.state != xmpp.XmppConnectionState.Closed) {
          _connection!.close();
        }
        _connection = null;
      }
    } catch (e) {
      debugPrint('Ошибка при отключении: $e');
    }
  }
}