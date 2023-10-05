import 'package:daphne/daphne.dart';

class DaphneIOUnsupportedPlatformError extends DaphneUnsupportedPlatformError {
  DaphneIOUnsupportedPlatformError()
      : super("daphne_io is not supported on this platform");
}

// --------------------------------------------------------------

abstract class X509Certificate {}

class Platform {
  static bool get isIOS => throw DaphneIOUnsupportedPlatformError();
}

class SecurityContext {
  SecurityContext({required final bool withTrustedRoots}) {
    throw DaphneIOUnsupportedPlatformError();
  }

  void setTrustedCertificatesBytes(final List<int> certificates,
      {final String? password}) {
    throw DaphneIOUnsupportedPlatformError();
  }

  void setAlpnProtocols(final List<String> protocols, final bool isServer) {
    throw DaphneIOUnsupportedPlatformError();
  }

  static SecurityContext get defaultContext {
    throw DaphneIOUnsupportedPlatformError();
  }
}

class HttpClient {
  HttpClient({final SecurityContext? context}) {
    throw DaphneIOUnsupportedPlatformError();
  }

  set badCertificateCallback(
    final void Function(X509Certificate, String, int)? callback,
  ) {
    throw DaphneIOUnsupportedPlatformError();
  }

  set findProxy(final String Function(Uri)? callback) {
    throw DaphneIOUnsupportedPlatformError();
  }

  set userAgent(final String? userAgent) {
    throw DaphneIOUnsupportedPlatformError();
  }
}
