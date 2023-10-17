import 'dart:typed_data';

import 'package:daphne/daphne.dart';
import 'package:daphne/src/core/common.dart';
import 'package:daphne_http/http.dart';

/// A [DaphneBaseRequest] is a wrapper around some [BaseRequest] object from
/// the [http](https://pub.dev/packages/http) package. It augments the options
/// and functionality from the underlying request (from the HTTP package) with
/// additional options and functionality from Daphne and adjusting the API
/// to be more ergonomic, as seen as appropriate.
abstract class DaphneBaseRequest<UnderlyingRequest extends BaseRequest> {
  /// The underlying [Request] object from package:http.
  ///
  /// Created internally by the [_createRequest] factory, overridden in every
  /// subclass. This has to be late as we use the factory to initialize the
  /// request class and the factory needs to be accessed before the request
  /// object is created so [_request] cannot be set in the constructor's
  /// initializer list. (We need to enforce [_createRequest] to ensure
  /// subclasses set the necessary final fields on the correct request class.)
  late final UnderlyingRequest _request;

  /// A factory to create the underlying request object for a Daphne
  /// request class.
  UnderlyingRequest _createRequest(
    final String method,
    final Uri url, {
    final RequestController? controller,
  });

  /// Whether the underlying request has been 'finalized'.
  /// When true, all mutable fields will throw on modification.
  /// In other words, once the request has been [finalized], do not attempt to
  /// modify any fields.
  /// The request will be [finalized] before it is sent.
  bool get finalized => _request.finalized;

  /// The HTTP [Method] of the request.
  final Method method;

  /// The URL the request should be made to.
  final String url;
  Uri get parsedUrl => _request.url;

  /// The [DaphneRequestConfig] for this request.
  final DaphneRequestConfig config;

  // TODO: headers are currently final, are there any use cases for modifying
  // headers after the request has been created?

  /// Initializes a [DaphneRequest] for the specified [method], [url] and
  /// [DaphneRequestConfig] (`config`). The [config] is optional and defaults
  /// to [defaultRequestConfig]. You can use [withHeaders] as a shorthand if
  /// you only want to set custom headers instead of changing the entire
  /// configuration.
  ///
  /// Note that the headers from [config] will have the header name (key)
  /// normalized to lowercase. This is necessary because the HTTP package
  /// implements the headers as a [Map] and thus lacks the ability to perform
  /// case-insensitive lookups.
  DaphneBaseRequest(
    this.method,
    this.url, {
    this.config = defaultRequestConfig,
  }) {
    _request = _createRequest(
      method.verb,
      Uri.parse(url),
      controller: config.controller,
    )
      ..headers.addAll(config.headers ?? {})
      ..followRedirects = config.followRedirects ?? true
      ..maxRedirects = config.maxRedirects ?? 5;
  }

  /// Returns the underlying request object.
  /// This is useful for when you need to pass the request to a function that
  /// expects the underlying request object from the HTTP package.
  ///
  /// Note that this will throw a [StateError] if the request has been
  /// finalized. This is because the underlying request object is immutable
  /// once finalized and thus cannot be modified so we suspect that calling
  /// this once the request has been finalized is in error. If you believe
  /// this is not the case, please open an issue on GitHub and describe your
  /// use case.
  UnderlyingRequest toUnderlyingRequest() {
    if (finalized) {
      throw StateError(
        'Cannot convert a finalized request to an underlying request.',
      );
    }

    return _request;
  }
}

/// [DaphneRequest], by default, wraps a [Request] object from the
/// [http](https://pub.dev/packages/http) package. This is for parity with the
/// HTTP package and to allow for easy interoperability with the HTTP package.
class DaphneRequest extends DaphneBaseRequest<Request> with Body {
  @override
  Request _createRequest(
    final String method,
    final Uri url, {
    final RequestController? controller,
  }) =>
      Request(method, url, controller: controller);

  /// The body of the request, as a string.
  /// For binary payloads, use [bodyBytes].
  @override
  String get rawBody => _request.body;
  set rawBody(final String body) => _request.body = body;

  /// The bytes for the [rawBody] of the request.
  @override
  Uint8List get rawBodyBytes => _request.bodyBytes;
  set rawBodyBytes(final Uint8List bodyBytes) => _request.bodyBytes = bodyBytes;

  /// The content length of the request body, in bytes.
  /// (Computed from [rawBodyBytes] per the HTTP package.)
  int get contentLength => _request.contentLength;

  DaphneRequest(super.method, super.url, {super.config});

  /// Clears the request body.
  void clearBody() => _request.bodyBytes = Uint8List(0);
}

/// A [DaphneRequest] where the body is a known [ContentType] and, thus, can be
/// automatically parsed and (de-)serialized by Daphne.
///
/// [ParsedDaphneRequest] aims to validate as much as possible at compile time
/// and within Daphne itself to ensure that the request body is valid for the
/// given [contentType]. If you need more flexibility, use [DaphneRequest]
/// instead.
///
/// This is primarily intended for code generation but may also be used
/// directly if you wish to make use of Daphne's automatic parsing and
/// serialization without code generation.
class ParsedDaphneRequest<BodyType> extends DaphneRequest {
  /// The [ContentType] of the request. This includes the MIME type and
  /// character encoding that must be set (see [ContentType]) as well as the
  /// Dart type that the body will be parsed to and serialized from when
  /// [parsedBody] is used.
  final ContentType<BodyType> contentType;

  /// See the constructor for [DaphneRequest]. This constructor overwrites the
  /// content-type to match that which is provided and also includes the
  /// [parsedBody] getter and setter to facilitate working the request body
  /// in data structures native to Dart (which are then automatically converted
  /// behind the scenes within Daphne).
  ///
  /// The [contentType] parameter specifies the Content-Type header, and
  /// encoding that must be set (see [ContentType]) as well as the Dart type
  /// that the body will be parsed to and serialized from.
  ///
  /// Optionally, you may provide [body]. If specified, it will be set as the
  /// [parsedBody] of the request. If not specified, the default value for the
  /// [contentType] will be used instead or null if [BodyType] is nullable.
  ///
  /// **If you set [rawBody] or [rawBodyBytes] directly, it will be parsed and
  /// checked for correctness. If it is not valid, an exception will be
  /// thrown. Empty bodies are not considered valid unless the body type on
  /// the [ParsedDaphneRequest] is nullable.**
  ParsedDaphneRequest(
    super.method,
    super.url, {
    super.config,
    required this.contentType,
    final BodyType? body,
  }) {
    if (contentType.mimeType.isEmpty) return;

    // Set the body (or a default if none was provided).
    parsedBody = body ??
        (null is BodyType
            ? null as BodyType
            : contentType.defaultValueFactory());

    // Overwrite the content-type header.
    _request.headers.remove('content-type');
    _request.headers['content-type'] = contentType.contentTypeHeader;
  }

  /// Clears the request body by replacing it with a new instance of the
  /// default value for the [contentType].
  @override
  void clearBody() => parsedBody = contentType.defaultValueFactory();

  /// Check a given [parsedBody] for validity with the [contentType] for this
  /// request.
  bool isValidParsedBody(final BodyType parsedBody) =>
      contentType.isValidValue(parsedBody);

  /// Check a given [rawBody] for validity with the [contentType] for this
  /// request.
  bool isValidRawBody(final String rawBody) =>
      contentType.isValidRawValue(rawBody);

  @override
  set rawBody(final String body) {
    if (!isValidRawBody(body)) {
      throw ArgumentError.value(
        body,
        'body',
        'The provided body is not valid for the specified content type of this request (${contentType.name}).',
      );
    }
    _request.body = body;
  }

  @override
  set rawBodyBytes(final Uint8List bodyBytes) {
    if (!isValidRawBody(contentType.characterEncoding.decode(bodyBytes))) {
      throw ArgumentError.value(
        bodyBytes,
        'bodyBytes',
        'The provided body bytes do not constitute a valid body for the specified content type of this request (${contentType.name}).',
      );
    }
    _request.bodyBytes = bodyBytes;
  }

  // TODO: should caching be implemented for parsed bodies?
  // TODO: for now, avoided for simplicity.

  /// The parsed body of the request.
  /// This is automatically parsed from the [rawBody] of the request when read
  /// and serialized to the [rawBody] when set.
  ///
  /// This value is not currently cached for simplicity and because the
  /// performance impact is negligible for most use cases. If caching is
  /// important to you, please open an issue on GitHub. For now, you can simply
  /// read and write the raw body directly (or perform the parsing and
  /// serialization with the [contentType] and cache the result yourself) as a
  /// workaround.
  BodyType get parsedBody => contentType.decode(rawBody);
  set parsedBody(final BodyType parsedBody) {
    if (!isValidParsedBody(parsedBody)) {
      throw ArgumentError(
        'The provided body is not valid for the specified content type of this request (${contentType.name}).',
      );
    }

    rawBody = contentType.encode(parsedBody);
  }
}

/// A convenience class that wraps [ParsedDaphneRequest] for those who wish to
/// make JSON requests with automatic parsing and serialization but do not
/// wish to use code generation.
///
/// NOTE TO IMPLEMENTORS: Do not use for code generation. Use
/// [ParsedDaphneRequest] instead for consistency.
class DaphneJsonRequest extends ParsedDaphneRequest<JsonMap> {
  static const _contentType = ContentType.json;

  @override
  ContentType<JsonMap> get contentType => _contentType;

  /// A [ParsedDaphneRequest] that is specifically for making JSON requests.
  DaphneJsonRequest(
    super.method,
    super.url, {
    super.config,
    super.body,
  }) : super(contentType: _contentType);

  /// This is always true for a [DaphneJsonRequest]. JSON is handled behind the
  /// scenes and the [parsedBody] is always a [JsonMap].
  @override
  bool get hasParsedBody => true;
}

/// A [DaphneRequest] specifically for making url-encoded form requests.
/// Exposes the [parsedBody] and [bodyFields] properties to facilitate working
/// with form data.
class DaphneFormRequest extends ParsedDaphneRequest<Map<String, String>> {
  static const _contentType = ContentType.urlEncodedForm;

  @override
  ContentType<Map<String, String>> get contentType => _contentType;

  /// A [ParsedDaphneRequest] that is specifically for making url-encoded form
  /// requests. This exposes the [parsedBody] and [bodyFields] properties which
  /// are inherited from the HTTP package's [Request] class to provide
  /// form-specific parsing and functionality.
  DaphneFormRequest(
    super.method,
    super.url, {
    super.config,
    super.body,
  }) : super(contentType: _contentType);

  /// This is always true for a [DaphneFormRequest]. Forms are handled behind
  /// the scenes by the Dart http package.
  @override
  bool get hasParsedBody => true;

  @override
  bool isValidParsedBody(final Map<String, String> parsedBody) {
    try {
      // Source: package:http/src/utils.dart
      // Trivial implementation of the encoding algorithm.
      //
      // This is essentially just going to check that the map is valid and the
      // values can be serialized as a string, but the best way to check that
      // is to just do it.
      //
      // If performance warrants it, we can implement a more efficient
      // algorithm later.
      var pairs = <List<String>>[];
      parsedBody.forEach((final key, final value) => pairs.add([
            Uri.encodeQueryComponent(key,
                encoding: _contentType.characterEncoding),
            Uri.encodeQueryComponent(value,
                encoding: _contentType.characterEncoding)
          ]));
      pairs.map((final pair) => '${pair[0]}=${pair[1]}').join('&');

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  bool isValidRawBody(final String rawBody) {
    try {
      Uri.splitQueryString(rawBody, encoding: _contentType.characterEncoding);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// A key-value mapping of the fields in the body of the request.
  /// See [Request.bodyFields].
  ///
  /// You mustn't modify this map directly and [parsedBody] therefore returns
  /// an unmodifiable map. Instead, clone and modify the map and then set it
  /// using [parsedBody] to update the request.
  ///
  /// ([bodyFields] is simply an alias for [parsedBody] for convenience and
  /// greater similarity to the HTTP package's [Request] class.)
  @override
  Map<String, String> get parsedBody => Map.unmodifiable(_request.bodyFields);

  @override
  set parsedBody(final Map<String, String> parsedBody) =>
      _request.bodyFields = parsedBody;

  /// An alias for [parsedBody].
  Map<String, String> get bodyFields => parsedBody;

  set bodyFields(final Map<String, String> bodyFields) =>
      parsedBody = bodyFields;
}
