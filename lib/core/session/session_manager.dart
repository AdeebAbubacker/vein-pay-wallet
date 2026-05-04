import 'package:flutter/foundation.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionManager extends ValueNotifier<SessionStatus> {
  SessionManager() : super(SessionStatus.unknown);

  void setAuthenticated() => value = SessionStatus.authenticated;

  void setUnauthenticated() => value = SessionStatus.unauthenticated;
}
