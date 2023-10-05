import 'package:daphne/src/core/common.dart';
import 'package:http/http.dart';

import 'package:daphne/src/core/config.dart';
import 'package:daphne/src/core/request.dart';
import 'package:daphne/src/core/response.dart';

part 'package:daphne/src/daphne_impl.dart';

/// A [DaphneResponse] (unparsed response) that was made in response to a
/// [DaphneRequest] (unparsed request).
typedef UnparsedResponse = DaphneResponse<DaphneRequest>;

/// A [ParsedDaphneResponse] that was made in response to a
/// [ParsedDaphneRequest].
typedef ParsedResponse<RequestBody, ResponseBody>
    = ParsedDaphneResponse<ResponseBody, ParsedDaphneRequest<RequestBody>>;

/// The underlying base class for all Daphne clients.
abstract class DaphneBase {
  // TODO: consider whether the configuration should be changeable or not.

  /// The current configuration ([DaphneConfig]) for this [Daphne] client.
  /// The value returned by this getter is the current configuration of the
  /// client but if any setters are currently in progress, the value returned
  /// by this getter may be out of date.
  ///
  /// Use this if you know the configuration is not being changed (e.g.,
  /// because you only ever set the configuration once at the start of your
  /// application). If you need to be sure that the configuration is up to
  /// date, use [getConfig] instead.
  DaphneConfig get cachedConfig;

  /// Fetches the current configuration ([DaphneConfig]) for this [Daphne]
  /// client.
  ///
  /// If there are any setters currently in progress, this method will
  /// wait for them to complete before returning the current configuration.
  Future<DaphneConfig> getConfig();

  /// Sets the current configuration ([DaphneConfig]) for this [Daphne] client.
  ///
  /// Changing the configuration will affect requests made after the change.
  ///
  /// Changing the platform configuration or other options that affect the
  /// underlying HTTP client will cause the client to be recreated
  /// automatically.
  ///
  /// Note that this method is asynchronous because it may need to wait for
  /// any pending requests to complete before changing the configuration.
  Future<void> setConfig(final DaphneConfig config);

  //<editor-fold desc="Instance Management">

  /// Clean up the HTTP client.
  void dispose();

  //</editor-fold>

  // TODO: Add convenience methods for download and upload.
  //<editor-fold desc="Convenience Methods (Not Yet Implemented)">

  // Future<void> download(
  //   final String pathOrUrl,
  //   final String filePath, {
  //   final Method method = Method.get,
  //   final DaphneRequestConfig request = const DaphneRequestConfig(),
  // }) =>
  //     throw UnimplementedError();
  //
  // Future<void> upload(
  //   final String pathOrUrl,
  //   final String filePath, {
  //   final Method method = Method.post,
  //   final DaphneRequestConfig request = const DaphneRequestConfig(),
  // }) =>
  //     throw UnimplementedError();

  //</editor-fold>

  //<editor-fold desc="Core HTTP Methods">
  /// Performs an HTTP request using the given parameters.
  Future<UnparsedResponse> fetch(
    final Method method,
    final String pathOrUrl, {
    final String? body,
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  });

  /// Performs a general network request which can be fully configured and
  /// applies no per-method defaults, with full automatic parsing of the
  /// request and response bodies.
  ///
  /// If you want partial or custom parsing, use [fetch] instead. You can
  /// 'opt in' to parsing a response from an unparsed request made with [fetch]
  /// by using [DaphneResponse.parse].
  ///
  /// If you do not wish to specify a request body, leave [body] as null (you
  /// may specify the [RequestBody] type as `void` if you wish), otherwise
  /// supply a [DaphneRequestBody] to [body] which sets the [ContentType] that
  /// will parse the request body.
  ///
  /// You are forced to specify a [ContentType] for the response body, as the
  /// whole point of a parsed request is to parse the response body into an
  /// expected and known format.
  ///
  /// If [ResponseBody] is nullable, then null values will be used as specified
  /// by the [DaphneResponseConfig]'s [ParserErrorBehavior] (default is to
  /// throw an error on invalid response bodies and return null on empty
  /// response bodies).
  ///
  /// Otherwise, if [ResponseBody] is not nullable, then the
  /// [ParserErrorBehavior] will be used as described above, except instead of
  /// returning null on empty response bodies, the [responseType]'s default
  /// (empty) value will be used instead. ([responseType.defaultValueFactory]).
  Future<ParsedResponse<RequestBody, ResponseBody>>
      fetchWithParsing<RequestBody, ResponseBody>(
    final Method method,
    final String pathOrUrl, {
    required final ContentType<ResponseBody> responseType,
    final DaphneRequestBody<RequestBody>? body,
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  });
  //</editor-fold>
}

/// The [Daphne] HTTP client.
abstract class Daphne extends DaphneBase {
  factory Daphne([final DaphneConfig config = defaultDaphneConfig]) =>
      _DaphneImpl(config);
}

/// A mixin that provides convenience functions for all common HTTP methods on
/// [DaphneBase].
mixin DaphneConvenienceMethods on DaphneBase {
  /// See [fetch].
  Future<UnparsedResponse> get(
    final String pathOrUrl, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.get,
        pathOrUrl,
        request: request,
        response: response,
      );

  /// See [fetch].
  Future<UnparsedResponse> post(
    final String pathOrUrl,
    final String body, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.post,
        pathOrUrl,
        body: body,
        request: request,
        response: response,
      );

  /// See [fetch].
  Future<UnparsedResponse> put(
    final String pathOrUrl,
    final String body, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.put,
        pathOrUrl,
        body: body,
        request: request,
        response: response,
      );

  /// See [fetch].
  Future<UnparsedResponse> patch(
    final String pathOrUrl,
    final String body, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.patch,
        pathOrUrl,
        body: body,
        request: request,
        response: response,
      );

  /// See [fetch].
  Future<UnparsedResponse> delete(
    final String pathOrUrl,
    final String body, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.delete,
        pathOrUrl,
        body: body,
        request: request,
        response: response,
      );

  /// See [fetch].
  Future<UnparsedResponse> head(
    final String pathOrUrl, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.head,
        pathOrUrl,
        request: request,
        response: response,
      );

  /// See [fetch].
  Future<UnparsedResponse> options(
    final String pathOrUrl, {
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) =>
      fetch(
        Method.options,
        pathOrUrl,
        request: request,
        response: response,
      );
}
