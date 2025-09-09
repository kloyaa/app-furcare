import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (kDebugMode) {
      print('📍 NAVIGATED TO: ${route.settings.name ?? 'Unknown'}');
    }
    if (previousRoute != null) {
      if (kDebugMode) {
        print('📍 FROM: ${previousRoute.settings.name ?? 'Unknown'}');
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (kDebugMode) {
      print('📍 POPPED: ${route.settings.name ?? 'Unknown'}');
    }
    if (previousRoute != null) {
      if (kDebugMode) {
        print('📍 BACK TO: ${previousRoute.settings.name ?? 'Unknown'}');
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (kDebugMode) {
      print(
        '📍 REPLACED: ${oldRoute?.settings.name} → ${newRoute?.settings.name}',
      );
    }
  }
}
