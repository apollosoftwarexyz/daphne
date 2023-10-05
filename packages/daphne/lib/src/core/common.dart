// Internal common classes and methods used within Daphne.

import 'dart:async';
import 'dart:typed_data';

import 'package:daphne/daphne.dart';

/// Implements shared methods for requests and responses that have a body.
mixin Body {
  String get rawBody;

  Uint8List get rawBodyBytes;

  /// Checks whether the request has a body (that is not empty).
  bool get hasBody => rawBodyBytes.isNotEmpty;

  /// This is always false for the base [DaphneRequest] or [DaphneResponse]
  /// classes.
  ///
  /// Subclasses that parse the request body should instead extend the
  /// [ParsedDaphneRequest] or [ParsedDaphneResponse] classes which will
  /// override this getter and enforce correct typing for its `parsedBody`
  /// property.
  ///
  /// This getter is provided for convenience and for those who need to perform
  /// duck typing on a [DaphneRequest] or [DaphneResponse] object.
  bool get hasParsedBody => false;
}

/// Trivial implementation of a Mutex to ensure values are not used whilst
/// being updated.
///
/// For instance, consider the case where the [DaphneConfig] of a [Daphne]
/// client is being updated. If the [DaphneConfig] needs to change the
/// underlying HTTP client then the old client needs to be disposed of and a
/// new one created. This process is not instant because the old client needs
/// to shut down and the requests need to be completed or cancelled.
///
/// If a request were made whilst the client was being updated then the
/// configuration used would be undefined. This mutex ensures that the
/// configuration is not used whilst the client is being changed because it
/// can be defined as the critical section for [setValue].
class DaphneMutex<T> {
  T _value;

  /// Returns the current value of the mutex.
  T get immediate => _value;

  /// Empty completer just to keep track of whether a value setter is currently
  /// executing.
  Completer<void>? _completer;

  /// Initializes a [DaphneMutex] with an initial value.
  DaphneMutex(this._value);

  /// Fetches the internal value of the mutex.
  ///
  /// This method waits for any critical sections of [setValue] to complete
  /// before returning the value.
  Future<T> getValue() async {
    // If there's a completer that's not null then we're currently updating the
    // value. Wait for the completer to complete and return the value.
    await _completer?.future;
    return _value;
  }

  /// Sets the value of the mutex.
  ///
  /// [valueSetter] is a function which can be used to execute the critical
  /// section of code and then return the new value of the mutex to be set.
  ///
  /// [valueSetter] is executed and its return value assigned to the internal
  /// value of the mutex as an atomic operation. If a previous [valueSetter]
  /// is already executing then this method will wait for it to complete before
  /// executing the new [valueSetter].
  ///
  /// If [valueSetter] throws an error then the value of the mutex is not
  /// changed.
  Future<void> setValue(final T Function() valueSetter) async {
    // Wait for any previous value setters to complete.
    await _completer?.future;

    // Create a new completer to wait for this value setter to complete.
    _completer = Completer();

    try {
      // Execute the value setter and assign the result to the internal value.
      _value = valueSetter();
    } catch (e) {
      // If the value setter throws an error then complete the completer with
      // the error and rethrow the error.
      _completer!.completeError(e);
      rethrow;
    }

    // Complete the completer with the new value.
    _completer!.complete();
  }
}
