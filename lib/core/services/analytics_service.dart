import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Обгортка над Firebase Analytics. На платформах без підтримки
/// (Windows, Linux) та в тестах працює як заглушка.
class AnalyticsService {
  final FirebaseAnalytics? _analytics;

  const AnalyticsService._(this._analytics);

  const AnalyticsService.disabled() : this._(null);

  factory AnalyticsService.create() =>
      AnalyticsService._(isSupported ? FirebaseAnalytics.instance : null);

  static bool get isSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  /// Автоматично надсилає `screen_view` при переходах між маршрутами.
  List<NavigatorObserver> get navigatorObservers => [
    if (_analytics case final analytics?)
      FirebaseAnalyticsObserver(analytics: analytics),
  ];

  Future<void> logLogin({String method = 'password'}) async =>
      _analytics?.logLogin(loginMethod: method);

  Future<void> logSignUp() async =>
      _analytics?.logSignUp(signUpMethod: 'password');

  Future<void> logScreen(String name) async =>
      _analytics?.logScreenView(screenName: name);

  Future<void> logEvent(String name) async => _analytics?.logEvent(name: name);

  Future<void> setUserId(String? uid) async => _analytics?.setUserId(id: uid);
}
