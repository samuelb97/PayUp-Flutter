import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class analyticsController {
  static FirebaseAnalytics _analytics;
  static FirebaseAnalyticsObserver _observer;

  analyticsController(){
    _analytics = FirebaseAnalytics();
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  FirebaseAnalytics get analytics => _analytics;
  FirebaseAnalyticsObserver get observer => _observer;

  Future<Null> currentScreen(String screenName, String screenClassOverride) async{
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride
    );
  }

  void sendAnalytics(String name) async{
    await analytics.logEvent(
      name: name,
      parameters: <String,dynamic>{}
    );
  }
}