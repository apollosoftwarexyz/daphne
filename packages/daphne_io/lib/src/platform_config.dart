// Import IO libraries if the IO library is available.
import 'package:daphne_io/src/io_stub.dart' if (dart.library.io) 'dart:io';
import 'package:daphne_io/src/io_client_stub.dart'
    if (dart.library.io) 'package:http/io_client.dart';

import 'package:daphne/daphne.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'platform_config.freezed.dart';

/// When a certificate fails to be authenticated, this callback is called.
/// If it returns true, the connection is allowed to proceed as normal.
/// If it returns false, the connection is terminated and the request fails.
typedef BadCertificateCallback = bool Function(
  X509Certificate cert,
  String host,
  int port,
);

/// A factory for creating a [SecurityContext] for use with a client.
/// This is simply a function that returns a [SecurityContext] instance.
typedef SecurityContextFactory = SecurityContext Function();

/// A [SecurityContextFactory] that returns the default [SecurityContext].
SecurityContext defaultSecurityContextFactory() =>
    SecurityContext.defaultContext;

/// A [SecurityContextFactory] that returns an empty [SecurityContext] with no
/// trusted certificates. This is useful for more custom approaches to
/// certificate pinning and validation, as you can then use
/// [NativePlatformConfig.onBadCertificate] to override the behavior
/// programmatically.
/// Alternatively, consider defining your own [SecurityContextFactory] that
/// includes your own trusted certificates in the [SecurityContext].
SecurityContext emptySecurityContextFactory() =>
    SecurityContext(withTrustedRoots: false);

/// A [SecurityContextFactory] that returns a [SecurityContext] with the
/// specified trusted certificates.
///
/// If [includeSystemRoots] is true, the system root certificates will also be
/// included in the [SecurityContext].
///
/// [certificates] is the bytes for an X509 certificate (usually a root CA) in
/// either PEM or PKCS12 format. **NOTE THAT ON iOS, YOU MUST INSTEAD USE DER,
/// SEE BELOW.**
/// [password] is the password for the certificate, if any (only applicable for
/// PKCS12 certificates).
///
/// ## iOS Support
///
/// The certificate format is ordinarily PKCS12 or PEM and multiple
/// certificates may be specified within the file. On iOS, the certificate
/// format is DER, and only a single certificate may be specified. As such,
/// we recommend doing the following:
///
/// 1. Convert your certificate to a PEM file.
/// 2. Convert your PEM file(s) to DER file(s).
/// ```bash
/// openssl x509 -outform der -in cert.pem -out cert.der
/// ```
/// 3. Add the PEM file and DER file(s) to the application in some way. This
/// could be hardcoded in the source text, or loaded from an asset, etc.,.
/// 4. Specify the single PEM file as [certificates] and the list of DER
/// files as [derCertificates] (if you only have one DER file, simply place it
/// in a single-element list).
///
/// This factory then automatically selects the correct set of certificates for
/// the platform and automatically adds the full set of DER certificates to the
/// context on iOS.
///
/// If [derCertificates] is omitted, nothing is added to the context on iOS.
///
/// N.B., the [certificates] parameter is passed directly to
/// [SecurityContext.setTrustedCertificatesBytes] on all platforms except iOS
/// so if you wish to use a format other than PEM or DER, you can do so by
/// passing the bytes into [certificates].
SecurityContext securityContextWithTrustedRoots({
  required final List<int> certificates,
  final List<List<int>>? derCertificates,
  final String? password,
  final bool includeSystemRoots = false,
}) {
  final context = SecurityContext(withTrustedRoots: includeSystemRoots);

  if (Platform.isIOS) {
    // On iOS, if the derCertificates have been specified, apply each of them
    // with setTrustedCertificatesBytes.
    if (derCertificates != null) {
      for (final derCertificate in derCertificates) {
        context.setTrustedCertificatesBytes(derCertificate);
      }
    } else {
      // TODO: warn about use of non-DER certificates on iOS (they are ignored)
    }
  } else {
    // On all other platforms, just apply the certificates directly.
    context.setTrustedCertificatesBytes(certificates, password: password);
  }

  return context;
}

/// A [PlatformConfig] for native platforms (i.e., platforms with dart:io
/// support).
///
/// This will throw a [DaphneUnsupportedPlatformError] if the platform is not
/// supported (e.g., web).
///
/// This is not necessary to use on any platform, but for options that are only
/// available on native platforms, this can be used to specify those options.
@freezed
@immutable
class NativePlatformConfig
    with _$NativePlatformConfig
    implements PlatformConfig {
  const NativePlatformConfig._();

  const factory NativePlatformConfig({
    /// A callback handler for when a certificate fails to be authenticated.
    /// This callback has the opportunity to perform additional checks on the
    /// certificate and then make an ultimate judgement on whether the request
    /// should be allowed to proceed.
    final BadCertificateCallback? onBadCertificate,

    /// A factory for creating a [SecurityContext] to use for this client.
    /// If this is null, the default [SecurityContext] will be used.
    final SecurityContextFactory? securityContextFactory,

    /// A list of ALPN protocols (application-layer protocol negotiation)
    /// to use for this client. These are passed into the initialized
    /// [SecurityContext] from the [securityContextFactory] which will
    /// cause the underlying dart:io [HttpClient] to negotiate the specified
    /// protocols with the server at the TLS layer.
    ///
    /// This is a convenience method for setting the protocols on the
    /// [SecurityContext] and will override any protocols set on the
    /// [SecurityContext] by the [securityContextFactory] if it is specified.
    final List<String>? alpnProtocols,

    /// The default user agent to use for requests. The default is
    /// `"Daphne (Dart) (dart:io)"`.
    ///
    /// This will override the User Agent header if one is specified.
    /// This may be set to null to disable the default user agent.
    @Default("Daphne (Dart) (dart:io)") final String? userAgent,

    /// Optionally, a function that returns the proxy PAC script to use for
    /// a given URL. You may use this to specify a proxy for a given URL.
    /// If this is null, no proxy will be used (`"DIRECT"`).
    /// You can also choose from [findProxyFromEnvironment] or
    /// [useProxy] to use the system proxy settings or a specific proxy.
    ///
    /// This is ignored on platforms that do not support proxy configuration.
    final FindProxyCallback? configureProxy,
  }) = _NativePlatformConfig;

  /// Whether the [NativePlatformConfig] has a
  /// [securityContextFactory] specified. If it does, it will be used to create
  /// a [SecurityContext] for the underlying client.
  bool get hasSecurityContextFactory => securityContextFactory != null;

  @override
  BaseClient createClient() {
    // Create a security context from the factory, or use the default.
    // We initialize it here either way to ensure that we're able to set
    final securityContext = hasSecurityContextFactory
        ? securityContextFactory!()
        : SecurityContext.defaultContext;

    // Set the ALPN protocols if specified.
    if (alpnProtocols != null) {
      securityContext.setAlpnProtocols(alpnProtocols!, false);
    }

    // Initialize the inner HttpClient from dart:io with all specified options.
    final httpClient = HttpClient(context: securityContext);
    if (onBadCertificate != null) {
      httpClient.badCertificateCallback = onBadCertificate;
    }

    // Set the proxy configuration function if specified.
    if (configureProxy != null) {
      httpClient.findProxy = configureProxy;
    }

    // Set the user agent if specified.
    httpClient.userAgent = userAgent;

    // Then wrap the inner client with an IOClient (which is a BaseClient).
    return IOClient(httpClient);
  }
}
