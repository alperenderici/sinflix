import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform utility class for checking device platform
class PlatformUtils {
  PlatformUtils._();

  /// Check if the current platform is iOS
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Check if the current platform is Android
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Check if the current platform is Web
  static bool get isWeb => kIsWeb;

  /// Check if the current platform is Desktop (Windows, macOS, Linux)
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Check if Apple Sign In should be shown
  /// Apple Sign In is only available on iOS devices
  static bool get shouldShowAppleSignIn => isIOS;
}
