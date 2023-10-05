import 'package:meta/meta.dart';
import 'package:http/http.dart';

/// Stub for a platform-specific config.
/// Platform-specific configs provide additional options that are passed to the
/// underlying HTTP client on supported platforms.
@immutable
abstract class PlatformConfig {
  /// Initializes an [HttpClient] with the security configuration.
  BaseClient createClient();
}
