import 'dart:convert';

import 'package:daphne/src/core/error.dart';
import 'package:daphne/src/core/request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:daphne/src/platform/platform_config.dart';
import 'package:daphne_http/http.dart';

part 'config.freezed.dart';

/// The type of HTTP method.
/// - [crud] (create-read-update-delete) indicates that a resource is being
/// fetched or manipulated in some way.
/// - [meta] indicates that the request is for information about the server or
/// the request itself.
enum MethodType { crud, meta }

/// HTTP method (verb).
enum Method {
  /// HTTP PUT (create or update)
  ///
  /// ## About PUT
  ///
  /// HTTP PUT is a bit of a misnomer, as it can be used for both creating and
  /// updating a resource as with POST. If the resource does not exist, it
  /// will be created. If it does exist, it will be updated.
  ///
  /// If the resource is not idempotent, use POST instead.
  ///
  /// The difference between POST and PUT is that PUT is idempotent, meaning
  /// that there should be no (adverse) side effects from calling it multiple
  /// times.
  ///
  /// So, for example, PUT might be used when saving a text document to a
  /// server, but POST might be used when performing a transaction.
  ///
  /// In the former case, it is predictable that the document will be saved
  /// to the same location each time, and the document will be overwritten if
  /// it exists. Neither the first request, nor any subsequent PUT requests
  /// have side effects like altering other documents or data.
  ///
  /// Conversely, in the latter case, performing multiple POST requests may
  /// result in multiple copies of the same transaction being performed.
  ///
  /// The significance then, is that because PUT is idempotent, it is safe to
  /// retry a PUT request on failure.
  put(
    'PUT',
    MethodType.crud,
    canHaveBody: true,
    idempotent: true,
    safe: false,
  ),

  /// HTTP POST (create)
  ///
  /// ## About POST
  ///
  /// See also [Method.put].
  post(
    'POST',
    MethodType.crud,
    canHaveBody: true,
    idempotent: false,
    safe: false,
  ),

  /// HTTP GET (read)
  ///
  /// ## About GET
  ///
  /// Used to read a resource, or a collection of resources. GET requests
  /// are both [idempotent] and [safe] and can thus be retried or
  /// pre-emptively requested. Browsers use GET for all navigation and
  /// resource requests.
  get(
    'GET',
    MethodType.crud,
    canHaveBody: false,
    idempotent: true,
    safe: true,
  ),

  /// HTTP PATCH (update)
  ///
  /// ## About PATCH
  ///
  /// Used to modify a resource, or a collection of resources. PATCH requests
  /// are not necessarily [idempotent] and are therefore assumed not to be.
  ///
  /// PATCH (as opposed to PUT) is considered a partial update, meaning that
  /// it holds a set of instructions for how to modify a resource, rather than
  /// the entire new resource itself.
  patch(
    'PATCH',
    MethodType.crud,
    canHaveBody: true,
    idempotent: false,
    safe: false,
  ),

  /// HTTP DELETE (delete)
  ///
  /// ## About DELETE
  ///
  /// Used to delete a resource, or a collection of resources. DELETE requests
  /// are [idempotent] but are not [safe] because they specify a resource to be
  /// deleted but calling it multiple times won't delete additional resources.
  /// It is safe to retry a DELETE request on failure, but not to pre-emptively
  /// request it.
  delete(
    'DELETE',
    MethodType.crud,
    canHaveBody: true,
    idempotent: true,
    safe: false,
  ),

  /// HTTP HEAD (request headers only for a given GET request)
  /// Useful for checking the size or presence of a resource, without actually
  /// downloading it.
  ///
  /// ## About HEAD
  ///
  /// HEAD acts like a GET request but returns only the headers without the
  /// body. This is useful to check metadata about a resource without having
  /// to download the entire file. For instance, it can be used to check the
  /// size of a file before downloading it.
  head(
    'HEAD',
    MethodType.meta,
    canHaveBody: false,
    idempotent: true,
    safe: true,
  ),

  /// HTTP OPTIONS (request permitted communication options)
  /// Useful for checking what methods are allowed on a given resource.
  /// This is generally only relevant for a web browser context.
  ///
  /// ## About OPTIONS
  ///
  /// Typically used by browsers to check the CORS policy of a resource with
  /// the pre-flight request. This is not relevant for most applications but
  /// might return useful information about what is supported or expected by
  /// the server. For instance, it might return a list of supported methods.
  /// Its existence and behavior are not guaranteed.
  ///
  /// This might be more useful than HEAD in some cases (such as the above)
  /// because it explicitly asks the server for detailed or full information
  /// about policies, whereas the server might ordinarily try to send the
  /// minimum amount of headers and information possible for bandwidth reasons.
  options(
    'OPTIONS',
    MethodType.meta,
    canHaveBody: false,
    idempotent: true,
    safe: true,
  );

  /// The HTTP verb (capitalized and written per the RFC).
  final String verb;

  /// The type of method (CRUD or meta).
  /// This is used to determine the purpose of the request and certain
  /// behaviors or defaults to apply.
  final MethodType type;

  /// Whether or not the method typically has a request body by convention.
  /// Response bodies are not considered here because they are not sent by
  /// the client.
  ///
  /// This is used to determine, for example, default behavior of the client.
  /// For instance, POST and PUT are intended for use with a body and almost
  /// always have one, so this is `true` for them and Daphne or a middleware
  /// may choose to set a default one based on this, for example. On the other
  /// hand, GET and HEAD are not expected to have a body.
  ///
  /// The semantics for GET having a body are undefined and HEAD is explicitly
  /// defined as not having a body.
  /// DELETE is not necessarily expected to have a body, but some applications
  /// may make use of it and are at liberty to do so.
  ///
  /// Values have been checked against MDN
  /// (https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods).
  final bool canHaveBody;

  /// Whether or not the method is 'idempotent' (as defined in RFC 9110).
  /// https://httpwg.org/specs/rfc9110.html#method.properties
  ///
  /// A method is idempotent if it can be called multiple times without
  /// changing the result of the call. See the notes on [put] for more
  /// information.
  ///
  /// **This semantic cannot be enforced on the client side, and can only be
  /// enforced on the server side by the application.** It should first be
  /// checked that the server is RFC 9110 compliant before relying on this
  /// semantic.
  ///
  /// Requests that are [idempotent] can be retried on failure.
  final bool idempotent;

  /// Whether or not the method is 'safe' (as defined in RFC 9110).
  /// https://httpwg.org/specs/rfc9110.html#method.properties
  ///
  /// A method is safe if its semantics may be considered 'read-only'. That is,
  /// it is only querying information, rather than changing it.
  ///
  /// **This semantic cannot be enforced on the client side, and can only be
  /// enforced on the server side by the application.** It should first be
  /// checked that the server is RFC 9110 compliant before relying on this
  /// semantic.
  ///
  /// Safe methods do not burden the server with any processing to determine
  /// a new state and do not intend to trigger any changes or side effects on
  /// the server-side.
  ///
  /// Given [safe] methods are read-only, they are also [idempotent], this
  /// means safe is a stronger claim than idempotent. Safe also means that
  /// requests can be preemptively sent by the client at will without concern
  /// for the state of the server.
  final bool safe;

  const Method(
    this.verb,
    this.type, {
    required this.canHaveBody,
    required this.idempotent,
    required this.safe,
  });
}

/// A factory that returns a new default value for a given [BodyType].
typedef DefaultValueFactory<BodyType> = BodyType Function();

/// Converts a specified [String] value to a [BodyType] value.
/// The Character [Encoding] is provided in case it is relevant to the
/// conversion.
typedef ContentTypeEncoder<BodyType> = String Function(
  BodyType,
  Encoding,
);

/// Converts a specified [BodyType] value to a [String] value.
/// (i.e., the reverse of [ContentTypeEncoder]).
typedef ContentTypeDecoder<BodyType> = BodyType Function(
  String,
  Encoding,
);

/// An encoder that does nothing. It simply returns the input value.
String contentTypeEncoderNoOp(final dynamic input, final _) => '';

/// An alias for [contentTypeEncoderNoOp] for consistency.
/// (Since it does nothing, it is also a decoder.)
const contentTypeDecoderNoOp = contentTypeEncoderNoOp;

/// Convenience alias for a JSON [Map] object (`Map<String, dynamic>`) in Dart.
typedef JsonMap = Map<String, dynamic>;

String _jsonContentTypeEncoder(final JsonMap input, final _) =>
    jsonEncode(input);
JsonMap _jsonContentTypeDecoder(final String input, final _) =>
    jsonDecode(input) as JsonMap;

void _defaultVoidFactory() {}
JsonMap _defaultJsonValueFactory() => {};
Map<String, String> _defaultUrlEncodedFormValueFactory() => {};

// TODO: refactor encoder and decoder to be serializer and parser.

/// [ContentType]s are used to indicate the type of data being sent or received
/// in an HTTP request or response. Any defined on [ContentType] are
/// automatically understood and handled by Daphne.
///
/// In Daphne, [ContentType] is specifically implemented as a mapping between
/// a [String] body and a [BodyType] body. This is because the [String] body
/// is the raw data that is sent over the network, and the [BodyType] body is
/// the data that is used by the application once decoded, or before encoding.
///
/// **NOTE:** The serializer and parser functions are currently known as
/// the encoder and decoder functions, respectively. This will be changed in
/// the future.
@immutable
class ContentType<BodyType> {
  static const none = ContentType._(
    name: 'none',
    mimeType: '',
    // ignore: avoid_returning_null_for_void
    defaultValueFactory: _defaultVoidFactory,
    encoder: contentTypeEncoderNoOp,
    decoder: contentTypeDecoderNoOp,
  );

  /// The JSON Content Type.
  /// https://www.json.org/
  static const json = ContentType.named(
    'json',
    'application/json',
    defaultValueFactory: _defaultJsonValueFactory,
    encoder: _jsonContentTypeEncoder,
    decoder: _jsonContentTypeDecoder,
  );

  /// The URL-encoded form type. (`application/x-www-form-urlencoded`).
  /// https://datatracker.ietf.org/doc/html/rfc1866#section-8.2.1
  /// https://datatracker.ietf.org/doc/html/rfc3986
  ///
  /// This is a placeholder with [isDelegated] set to true. It is not handled
  /// by Daphne, but is delegated to the request or response object.
  ///
  /// This exists just for consistency with other content types.
  static const ContentType<Map<String, String>> urlEncodedForm = ContentType._(
    name: 'form-urlencoded',
    mimeType: 'application/x-www-form-urlencoded',
    defaultValueFactory: _defaultUrlEncodedFormValueFactory,
    isDelegated: true,
  );

  /// If the [ContentType] encoding and decoding is delegated to another
  /// part of Daphne (e.g., performed on the request or response object
  /// itself).
  ///
  /// See the notes on [encoder] for more information (specifically,
  /// "Nullability of [encoder] and [decoder]").
  final bool isDelegated;

  /// See [isDelegated].
  bool get isNotDelegated => !isDelegated;

  /// Whether the [ContentType] is able to serialize the specified type.
  bool canSerialize(final Type type) => type is BodyType;

  /// The human-readable name (key) of the content type.
  final String? name;

  /// The MIME type (or the value that would be used for the leading portion
  /// of the `Content-Type` header - that is, without the character encoding).
  ///
  /// So, for example, a `Content-Type` header for a JSON payload might be
  /// `application/json; charset=utf-8`. In this case, the [mimeType] would
  /// be `application/json`.
  ///
  /// Alternatively, if the `Content-Type` header was `application/json`, then
  /// the [mimeType] would still be `application/json`.
  final String mimeType;

  /// Returns the full `Content-Type` header value for this content type.
  /// This includes the [mimeType] and the [characterEncoding].
  /// This is the value that would be used for the `Content-Type` header.
  /// So, for example, [contentTypeHeader] for a JSON payload might be
  /// `application/json; charset=utf-8`.
  String get contentTypeHeader {
    if (mimeType.isEmpty) {
      if (this != none) {
        throw StateError(
          'The $name content type has no MIME type, but is not the '
          'none content type. You must specify a MIME type or use '
          'ContentType.none.',
        );
      } else {
        throw UnsupportedError(
          "The none content type has no MIME type. You shouldn't need to "
          "obtain the content type header for the none content type. "
          "It is intended for requests with no body so, instead, just omit "
          "the content type header.",
        );
      }
    }

    return '$mimeType; charset=${characterEncoding.name}';
  }

  /// The character encoding to use for this content type.
  /// This is not used internally, but is left here for external use with
  /// custom [encoder] and [decoder] functions or custom [ContentType]s.
  ///
  /// This is the encoding that would be used for the trailing portion of the
  /// `Content-Type` header. So, for example, a `Content-Type` header for a
  /// JSON payload might be `application/json; charset=utf-8`. In this case,
  /// the [characterEncoding] would be `utf-8` (or specifically, the [Encoding]
  /// class for `utf-8`, which is [utf8]).
  final Encoding characterEncoding;

  /// A factory function that creates a new empty instance of a [BodyType]
  /// value.
  final DefaultValueFactory<BodyType> defaultValueFactory;

  /// The encoder for this content type.
  /// This serializes the body from a [BodyType] value to a [String] value
  /// ready for transmission.
  ///
  /// We recommend using [encode] instead of calling this directly.
  ///
  /// ## Nullability of [encoder] and [decoder]
  ///
  /// **Preface:** This is a long explanation that most users can ignore as
  /// [encoder] and [decoder] shouldn't be null, but if you're extending
  /// Daphne or using it in a way that requires encoding or decoding all
  /// content types, then you should read this.
  ///
  /// For any content type that [isNotDelegated], this is guaranteed to be
  /// non-null, so a null-check is performed on it internally.
  ///
  /// Note then, that you must check [isDelegated] if you think there is a
  /// possibility that it is delegated. It is expected that this would be
  /// a rare case, however as this mechanism is only used for types that are
  /// known to be handled by the request or response object itself.
  ///
  /// **You should also note that Daphne does not contain encoders and
  /// decoders for delegated ([isDelegated]) content types.**
  ///
  /// We perform the null-check internally because any custom content types
  /// or types handled by Daphne internally are guaranteed to have an encoder
  /// and decoder as that is the point of defining a content type class and
  /// therefore for the significant majority of uses of this class, the
  /// null-check is unnecessary.
  ///
  /// However, for consistency we also provide the opportunity to 'shim' in
  /// a content type that a request or response object can handle itself
  /// (notably the URL-encoded form content type and perhaps in future a
  /// multipart form content type). In this case, the null-check is necessary.
  ///
  /// Daphne, internally, does not even need to check [isDelegated] because
  /// any delegated content types have their own class (e.g.,
  /// [DaphneFormRequest]) which override `parsedBody` and thus do not even
  /// access the content type's encoder or decoder.
  ///
  /// (Note that [isDelegated] can never be set outside of Daphne itself, so
  /// if you are using a custom content type, you can be sure that it will
  /// have an encoder and decoder).
  ContentTypeEncoder<BodyType> get encoder => _encoder!;

  final ContentTypeEncoder<BodyType>? _encoder;

  /// Convenience alias to call [encoder] with the [characterEncoding] and
  /// additional handling for empty strings or null values.
  ///
  /// See notes on [encoder] about the nullability of [encoder] and [decoder].
  String encode(final BodyType value) {
    // If the value is null, return an empty string.
    // We know that BodyType is nullable if it's null (naturally), so we
    // needn't check for nullability here.
    if (value == null) return '';

    // Check that Daphne has an encoder for this content type.
    if (_encoder == null) {
      throw StateError(
        'Encoder is null. Daphne does not '
        'provide encoders for delegated content types (in this case, $name).',
      );
    }

    return _encoder!(value, characterEncoding);
  }

  /// The decoder for this content type.
  /// Parses a [String] value received from the network into a [BodyType]
  /// ready for use by the application.
  ///
  /// We recommend using [decode] instead of calling this directly.
  ///
  /// See the notes on [encoder] for more information and a caution about the
  /// internal null-check performed on this property.
  ContentTypeDecoder<BodyType> get decoder => _decoder!;

  final ContentTypeDecoder<BodyType>? _decoder;

  /// Convenience alias to call [decoder] with the [characterEncoding] and
  /// additional handling for empty strings or null values.
  ///
  /// See notes on [encoder] about the nullability of [encoder] and [decoder].
  BodyType decode(final String value) {
    // If the value is an empty string, return null if BodyType is nullable,
    // otherwise throw an error.
    if (value.isEmpty) {
      if (null is BodyType) {
        return null as BodyType;
      } else {
        throw ArgumentError(
          'Cannot decode an empty string to a non-nullable type.',
        );
      }
    }

    // Check that Daphne actually has a decoder for this content type.
    if (_decoder == null) {
      throw StateError(
        'Decoder is null. Daphne does not '
        'provide encoders for delegated content types (in this case, $name).',
      );
    }

    return _decoder!(value, characterEncoding);
  }

  const ContentType._({
    required this.name,
    required this.mimeType,
    required this.defaultValueFactory,
    final ContentTypeEncoder<BodyType>? encoder,
    final ContentTypeDecoder<BodyType>? decoder,
    this.characterEncoding = utf8,
    this.isDelegated = false,
  })  : _encoder = encoder,
        _decoder = decoder;

  /// Represents a custom content type.
  /// [mimeType] is the MIME type (or the value that would be used for the
  /// `Content-Type` header).
  const ContentType(
    final String mimeType, {
    required final DefaultValueFactory<BodyType> defaultValueFactory,
    required final ContentTypeEncoder<BodyType> encoder,
    required final ContentTypeDecoder<BodyType> decoder,
    final Encoding characterEncoding = utf8,
  }) : this._(
          name: null,
          mimeType: mimeType,
          defaultValueFactory: defaultValueFactory,
          encoder: encoder,
          decoder: decoder,
          characterEncoding: characterEncoding,
        );

  /// Represents a named (predefined) content type.
  /// [name] is a human-readable name of the content type.
  /// [mimeType] is the MIME type (or the value that would be used for the
  /// `Content-Type` header).
  const ContentType.named(
    final String? name,
    final String mimeType, {
    required final DefaultValueFactory<BodyType> defaultValueFactory,
    required final ContentTypeEncoder<BodyType> encoder,
    required final ContentTypeDecoder<BodyType> decoder,
    final Encoding characterEncoding = utf8,
  }) : this._(
          name: name,
          mimeType: mimeType,
          defaultValueFactory: defaultValueFactory,
          encoder: encoder,
          decoder: decoder,
          characterEncoding: characterEncoding,
        );

  /// Whether the content type satisfies the content type as defined in an HTTP
  /// header. [contentType] is the value of the `Content-Type` header.
  /// Returns true if this content type is a match for the header value and
  /// will be able to process the body of the request or response.
  bool satisfies(final String contentType) {
    // Process the MIME type from the current [ContentType] object.
    final thisContentTypeParts = this.mimeType.split('/');
    if (thisContentTypeParts.length != 2) {
      throw ArgumentError(
          'Invalid MIME type (${this.mimeType}) for Daphne content type ($name).');
    }

    // Process the specified content type header value.
    final contentTypeParts = contentType.split(';');
    final contentTypeHasParams = contentTypeParts.length > 1;

    final mimeTypeParts = contentTypeParts[0].trim().split('/');
    if (mimeTypeParts.length != 2) {
      throw ArgumentError('Invalid MIME type.');
    }

    // Check that the second part of the MIME type matches.
    // e.g., text/json == application/json or text/json == text/json
    bool formatMatches = mimeTypeParts[1] == contentTypeParts[1];
    if (!formatMatches) return false;

    // Now, return a response based on whether the encoding is specified
    // and, if it is, whether it matches.
    if (contentTypeHasParams) {
      // If encoding is specified, also check for a match.
      Map<String, String> contentTypeParams =
          Uri.splitQueryString(contentTypeParts[1]);

      // If encoding is not specified, return true as we've already checked
      // that the format matches.
      if (!contentTypeParams.containsKey('encoding')) return true;

      String encodingStr = contentTypeParams['encoding']!;

      // Add mapping for unsupported but common formatting of utf-8 as utf8.
      if (encodingStr == 'utf8') encodingStr = 'utf-8';

      return Encoding.getByName(encodingStr)?.name == characterEncoding.name;
    } else {
      // If no encoding is specified, return true as we've already checked
      // that the format matches.
      return true;
    }
  }

  /// Creates a new [ContentType] with the same [mimeType] but with a
  /// specified [characterEncoding].
  ContentType<BodyType> withEncoding(final Encoding characterEncoding) =>
      ContentType<BodyType>._(
        name: name,
        mimeType: mimeType,
        defaultValueFactory: defaultValueFactory,
        encoder: encoder,
        decoder: decoder,
        characterEncoding: characterEncoding,
      );

  /// Checks whether the specified [BodyType] value is valid for this content
  /// type (i.e., whether it can be encoded into a [String] by this
  /// [ContentType]'s [encoder]).
  bool isValidValue(final BodyType value) {
    try {
      encoder(value, characterEncoding);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Checks whether the specified raw value is valid for this content type,
  /// (i.e., whether it can be decoded into a [BodyType] by this
  /// [ContentType]'s [decoder]).
  bool isValidRawValue(final String value) {
    // Shortcut to process empty bodies.
    // If it's empty, it's valid if and only if the BodyType is nullable.
    if (value.isEmpty) return null is BodyType;

    // Otherwise, attempt to decode the raw body as a BodyType. If this fails,
    // the body is not valid.
    try {
      decoder(value, characterEncoding);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// A function, given a [url] that returns a PAC (proxy auto-config)
/// script-style string to use as a proxy URL. Use either:
/// ```javascript
/// "DIRECT"
/// ```
/// for a direct connection, or:
/// ```javascript
/// "PROXY host:port"
/// ```
/// for a proxy connection.
///
/// Multiple options can be specified by separating them with a semicolon:
/// ```javascript
/// "PROXY host1:port1; PROXY host2:port2; DIRECT"
/// ```
///
/// Note that this function MUST return a string, but the default behavior is
/// simply `DIRECT` to perform a direct connection, so you may return this as
/// a default if you do not wish to use a proxy.
typedef FindProxyCallback = String Function(Uri url);

/// A function, given the [host] and [port] of a proxy, returns a PAC script to
/// use for that proxy, regardless of the URL being requested.
FindProxyCallback useProxy(final String host, final int port) =>
    (final Uri url) => "PROXY $host:$port";

/// Some options may be specified on both the [DaphneConfig] to apply globally
/// to all requests, and/or on a [DaphneRequestConfig] to apply to a single
/// request. The options specified on the [DaphneRequestConfig] will override
/// those specified on the [DaphneConfig] (except for [headers] which will be
/// merged with duplicates being overridden by the request config).
///
/// This class defines the options that can be specified on both the
/// [DaphneConfig] and the [DaphneRequestConfig] to allow them to be adaptively
/// merged.
abstract class DaphneHierarchicalConfigOptions {
  /// The global timeout applied to the entire request.
  Duration? get timeout;

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  PartialTimeouts? get partialTimeouts;

  /// The set of headers to add to the request.
  DaphneRequestHeaders? get headers;

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  bool? get followRedirects;

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  int? get maxRedirects;

  factory DaphneHierarchicalConfigOptions.from(
    final DaphneHierarchicalConfigOptions options,
  ) =>
      _DaphneHierarchicalConfigOptions(
        timeout: options.timeout,
        partialTimeouts: options.partialTimeouts,
        headers: options.headers,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
      );

  factory DaphneHierarchicalConfigOptions.merge({
    required final DaphneHierarchicalConfigOptions global,
    required final DaphneHierarchicalConfigOptions request,
  }) =>
      _DaphneHierarchicalConfigOptions(
        timeout: request.timeout ?? global.timeout,
        partialTimeouts: request.partialTimeouts ?? global.partialTimeouts,
        headers: global.headers != null || request.headers != null
            ? {
                ...global.headers ?? {},
                ...request.headers ?? {},
              }
            : null,
        followRedirects:
            request.followRedirects ?? global.followRedirects ?? true,
        maxRedirects: request.maxRedirects ?? global.maxRedirects ?? 5,
      );
}

class _DaphneHierarchicalConfigOptions
    implements DaphneHierarchicalConfigOptions {
  @override
  final Duration? timeout;
  @override
  final PartialTimeouts? partialTimeouts;
  @override
  final DaphneRequestHeaders? headers;
  @override
  final bool? followRedirects;
  @override
  final int? maxRedirects;

  const _DaphneHierarchicalConfigOptions({
    required this.timeout,
    required this.partialTimeouts,
    required this.headers,
    required this.followRedirects,
    required this.maxRedirects,
  });
}

@freezed
@immutable
class DaphneConfig
    with _$DaphneConfig
    implements DaphneHierarchicalConfigOptions {
  const DaphneConfig._();

  const factory DaphneConfig({
    /// The base URL for the Daphne client.
    /// All requests to relative URLs will be made relative to this base URL.
    /// (That is, [baseUrl] is used unless the URL specified for a request is
    /// itself absolute.)
    final String? baseUrl,

    /// The timeout, after which a request should be cancelled if a connection
    /// has not yet been established.
    /// If not specified, no timeout will be applied.
    ///
    /// If a [DaphneRequestConfig] with a controller is used, this timeout will
    /// be ignored and managed by the controller instead.
    final Duration? timeout,

    /// The timeouts for different stages of a request. Timeouts are only used
    /// if they are specified. See [PartialTimeouts] for details.
    /// Default is not specified.
    ///
    /// If a [DaphneRequestConfig] with a controller is used, this timeout will
    /// be ignored and managed by the controller instead.
    final PartialTimeouts? partialTimeouts,

    /// The default set of headers to set for all requests made with this
    /// client.
    /// These headers can be overridden by setting headers in a request config.
    final DaphneRequestHeaders? headers,

    /// Whether redirects should be followed automatically.
    /// Default is true, meaning that redirects will be followed. If false,
    /// redirects will be returned as a normal response.
    final bool? followRedirects,

    /// The maximum number of redirects to follow before returning a response.
    /// Default is 5.
    /// This is ignored if [followRedirects] is false.
    final int? maxRedirects,

    /// The default behavior of a parser if it encounters an error for all
    /// responses.
    /// This is currently only applicable for a response parser.
    ///
    /// The default is [ParserErrorBehavior.throwException], which will throw
    /// an exception if an error is encountered whilst parsing a returned
    /// response but not if no response is returned.
    @Default(ParserErrorBehavior.throwException)
    final ParserErrorBehavior parserErrorBehavior,

    /// Whether the server is compliant with RFC 9110.
    /// https://httpwg.org/specs/rfc9110.html
    ///
    /// Specifically, with respect to section 9.2 (Common Method Properties),
    /// such that the server has correct semantics for [Method.idempotent] and
    /// [Method.safe].
    ///
    /// For now, this is assumed to be true, but if you are using a server that
    /// you know is non-compliant with the above semantics, you should set this
    /// to false and likewise if you are using a server that you know is
    /// compliant, you should set this to true as the default behavior may
    /// change in the future.
    @Default(true) final bool serverIsRfc9110Compliant,

    /// Optionally, a [PlatformConfig] to use for this client.
    /// If this is null, the default [PlatformConfig] will be used.
    /// On native platforms, you may use [NativePlatformConfig].
    ///
    /// Options or configurations that are not supported on the current
    /// platform will be ignored.
    final PlatformConfig? platformConfig,
  }) = _DaphneConfig;

  /// Whether this configuration has a [platformConfig] set.
  bool get hasPlatformConfig => platformConfig != null;
}

/// The default configuration for a Daphne request client.
/// This is used if no configuration is specified.
const DaphneConfig defaultDaphneConfig = DaphneConfig();

// These typedefs might be replaced with objects in the future, but for now
// they are just convenience aliases.

/// A convenience alias for a set of query parameters.
typedef DaphneQueryParameters = Map<String, String>;

/// A convenience alias for a set of request headers.
typedef DaphneRequestHeaders = Map<String, String>;

/// A convenience alias for a set of response headers.
typedef DaphneResponseHeaders = Map<String, String>;

/// A convenience alias to obtain a request config that sets only the specified
/// headers.
///
/// Note that this is not a const function, so if const is required, use:
/// ```dart
/// const DaphneRequestConfig(headers: headers);
/// ```
///
/// In contexts where [headers] is being set dynamically (e.g., from a
/// variable) the request config cannot be const (which is most likely the
/// case), so this can be used without concern.
DaphneRequestConfig withHeaders(final DaphneRequestHeaders headers) =>
    DaphneRequestConfig(headers: headers);

/// The configuration for a request.
@freezed
@immutable
class DaphneRequestConfig
    with _$DaphneRequestConfig
    implements DaphneHierarchicalConfigOptions {
  const factory DaphneRequestConfig({
    final RequestController? controller,

    /// The set of request-specific headers to set for this request.
    final DaphneRequestHeaders? headers,

    /// The set of request-specific query parameters to set for this request.
    @Default({}) final DaphneQueryParameters queryParameters,

    /// The timeout, after which a request should be cancelled if a connection
    /// has not yet been established.
    ///
    /// If a [controller] is specified, this is ignored.
    final Duration? timeout,

    /// The timeouts for different stages of a request. Timeouts are only used
    /// if they are specified. See [PartialTimeouts] for details.
    /// Default is not specified.
    ///
    /// If a [controller] is specified, this is ignored.
    final PartialTimeouts? partialTimeouts,

    /// Whether redirects should be followed automatically.
    /// Default is true, meaning that redirects will be followed. If false,
    /// redirects will be returned as a normal response.
    final bool? followRedirects,

    /// The maximum number of redirects to follow before returning a response.
    /// Default is 5.
    /// This is ignored if [followRedirects] is false.
    final int? maxRedirects,
  }) = _DaphneRequestConfig;
}

/// The default request configuration for a Daphne request.
/// This is used if no request configuration is specified.
const DaphneRequestConfig defaultRequestConfig = DaphneRequestConfig();

// The configuration for a response.
@freezed
@immutable
class DaphneResponseConfig with _$DaphneResponseConfig {
  const factory DaphneResponseConfig({
    /// The behavior of a parser if it encounters an error.
    ///
    /// The default is [ParserErrorBehavior.throwException], which will throw
    /// an exception if an error is encountered whilst parsing a returned
    /// response but not if no response is returned.
    @Default(ParserErrorBehavior.throwException)
    final ParserErrorBehavior parserErrorBehavior,
  }) = _DaphneResponseConfig;
}

/// The default response configuration for a Daphne request.
/// This is used if no response configuration is specified.
const DaphneResponseConfig defaultResponseConfig = DaphneResponseConfig();

/// The configuration for a parsed request body.
/// This is primarily intended for code generation.
@freezed
@immutable
class DaphneRequestBody<BodyType> with _$DaphneRequestBody<BodyType> {
  const factory DaphneRequestBody({
    /// The content type to parse and serialize the [body] with.
    required final ContentType<BodyType> contentType,

    /// The request body.
    required final BodyType body,
  }) = _DaphneRequestBody<BodyType>;
}
