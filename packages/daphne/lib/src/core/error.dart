/// Allows for specifying the behavior of a parser when it encounters an error.
enum ParserErrorBehavior {
  /// Return null if the input is invalid or missing (e.g., null).
  /// Completely masks all errors and returns null.
  ///
  /// Use this when loading data as a convenience or best-effort measure, but
  /// not when the data is required and where it is not a problem that invalid
  /// data will be masked and ignored.
  ///
  /// **If null is to be returned when a type is not nullable, an 'empty' value
  /// for that type will be constructed and returned instead.**
  returnNull,

  /// Throw an exception if the input is invalid, but return null if the input
  /// is missing (e.g., null). This means if the data wasn't present in the
  /// first place, the result will be null, but if the data was present but
  /// invalid, we'll throw an exception.
  ///
  /// This should generally be the default behavior.
  ///
  /// Use this when the data is nullable and isn't guaranteed to be present.
  /// If you need to guarantee the data is present, use [throwExceptionStrong].
  ///
  /// **If null is to be returned when a type is not nullable, an 'empty' value
  /// for that type will be constructed and returned instead.**
  throwException,

  /// Throw an exception if the input is invalid or missing (e.g., null).
  ///
  /// Use this when loading data that is important, mustn't be null and
  /// where **stronger** guarantees are needed than [throwException].
  strongThrowException,
}

/// Thrown at runtime when a platform-specific Daphne feature or implementation
/// is used on an unsupported platform.
///
/// Core parts of Daphne should not throw this error. This is expected to be
/// used by extension packages that implement platform-specific features.
class DaphneUnsupportedPlatformError {
  /// A human-readable message explaining the error.
  final String message;

  DaphneUnsupportedPlatformError(this.message);
}

/// A base [Error] class for all Daphne-specific errors.
///
/// ## Errors vs Exceptions
///
/// This is detailed in Dart's official documentation, and most developers are
/// likely already familiar with the difference between an error and an
/// exception.
///
/// [Error]s are thrown at runtime when Daphne is misused. Errors indicate
/// programming errors that should be fixed, regardless of the specific
/// cause of the error.
///
/// [Exception]s, conversely, are thrown at runtime when Daphne is unable to
/// perform an operation, e.g., because of a specific cause that might not be
/// fixable or predictable by the programmer (like a network failure).
/// That is, they indicate conditions that a reasonable application might want
/// to catch, but that the programmer might not have been able to predict and
/// thus avoid.
///
/// For example, a [DaphneError] might be thrown if a method is called on a
/// class that isn't initialized yet, or if a method is passed an argument
/// that doesn't make sense. Whilst a [DaphneException] might be thrown if
/// a network failure prevented a request from being made or completed. In the
/// former case, the programmer should fix the code to avoid the error, but in
/// the latter case, the programmer should handle the exception and provide
/// appropriate feedback to the user.
class DaphneError extends Error {
  final String message;

  DaphneError(this.message);
}

/// A base [Exception] class for all Daphne-specific exceptions.
/// Note the difference between an error and an exception, as detailed in
/// [DaphneError].
class DaphneException implements Exception {
  final String message;

  const DaphneException(this.message);
}

class DaphneRequestCancellation extends DaphneException {
  const DaphneRequestCancellation(super.message);
}
