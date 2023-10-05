import 'dart:typed_data';

import 'package:daphne/daphne.dart';
import 'package:daphne/src/core/common.dart';
import 'package:http/http.dart';

abstract class DaphneBaseResponse<ForRequest extends DaphneBaseRequest,
    UnderlyingResponse extends BaseResponse> {
  /// The underlying [Response] object from package:http.
  late final UnderlyingResponse _response;

  /// The request that triggered this response.
  final ForRequest request;

  /// The content length, in bytes, of the response body.
  /// This might be null if the size of the response body is not known in
  /// advance.
  int? get contentLength => _response.contentLength;

  /// The headers returned by the server with this response.
  DaphneResponseHeaders get headers => _response.headers;

  /// Whether there was a redirect before reaching this response (i.e., whether
  /// this response is a redirect).
  bool get isRedirect => _response.isRedirect;

  /// Whether the server requested that a persistent connection be maintained.
  bool get persistentConnectionRequested => _response.persistentConnection;

  /// The phrase given with the status code to indicate the status of
  /// this response.
  /// e.g., "OK" (with 200) or "Not Found" (with 404).
  ///
  /// The status phrase is optional and may not be given by the server, in
  /// which case this will be null.
  String? get statusPhrase => _response.reasonPhrase;

  /// Alias for [statusPhrase].
  String? get reasonPhrase => statusPhrase;

  /// The status code for this response. Typically three digits.
  /// e.g. 200, 404.
  ///
  /// The status code is always non-null.
  ///
  /// Generally, HTTP status codes can be grouped into these classes:
  /// - 1xx: Informational
  /// - 2xx: Success
  /// - 3xx: Redirection
  /// - 4xx: Client Error
  /// - 5xx: Server Error
  ///
  /// Some servers such as IIS (Internet Information Services) may return
  /// non-standard codes in non-standard formats (such as a decimal value
  /// like 400.1 "Invalid Destination Header"). This is non-standard and not
  /// supported by Dart's HTTP stack.
  ///
  /// The HTTP specification states that unknown status codes are to be treated
  /// as being equivalent to the x00 status code of that class (i.e.,
  /// truncated) so you can expect that, for example, 400.1 will be treated
  /// as 400. 401.1, might be treated as 401 or 400 per the specification, but
  /// you could reasonably expect it to be treated as 401.
  int get statusCode => _response.statusCode;

  /// The [DaphneResponseConfig] used to create this response.
  final DaphneResponseConfig config;

  DaphneBaseResponse(
    final UnderlyingResponse response, {
    required this.request,
    this.config = defaultResponseConfig,
  }) {
    _response = response;
  }

  /// Returns the underlying response object.
  UnderlyingResponse get response => _response;
}

class DaphneResponse<ForRequest extends DaphneBaseRequest>
    extends DaphneBaseResponse<ForRequest, Response> with Body {
  DaphneResponse(
    super.response, {
    required super.request,
    super.config,
  });

  /// The body of the response as a string.
  @override
  String get rawBody => _response.body;

  /// The bytes comprising the body of this response.
  @override
  Uint8List get rawBodyBytes => _response.bodyBytes;

  /// Promotes the [DaphneResponse] to a [DaphneResponse] with a parsed body,
  /// using the specified [contentType] if it is supported.
  ParsedDaphneResponse<BodyType, ForRequest> parse<BodyType>({
    required final ContentType<BodyType> contentType,
  }) {
    return ParsedDaphneResponse<BodyType, ForRequest>(
      _response,
      contentType: contentType,
      request: request,
      config: config,
    );
  }
}

/// A [DaphneResponse] that parses the raw body into a Dart object. This is
/// useful for responses that have a known content type.
class ParsedDaphneResponse<BodyType, ForRequest extends DaphneBaseRequest>
    extends DaphneResponse<ForRequest> {
  /// The [ContentType] of the response. This includes the MIME type and
  /// character encoding that were set on the response.
  final ContentType<BodyType> contentType;

  /// The parsed response body.
  /// This is automatically parsed from the [rawBody] of the response once it
  /// has been read from the server.
  late final BodyType parsedBody;

  /// A [DaphneResponse] that parses the raw body into a Dart object. This is
  /// useful for responses that have a known content type and allows additional
  /// validation to be performed before attempting to use the response and for
  /// the benefits of type safety.
  ParsedDaphneResponse(
    super.response, {
    required this.contentType,
    required super.request,
    super.config,
  }) {
    // Check the content type of the response. If it is not the expected type,
    // throw an error.
    if (!super.response.headers.containsKey('content-type') ||
        !contentType.satisfies(super.response.headers['content-type']!)) {
      throw ArgumentError.value(
        super.response.headers['content-type']!,
        'content-type',
        'The content type of the response is missing or does not match the expected type (${contentType.mimeType}.',
      );
    }

    // The, decode the response body with the given content type.
    bool isResponseNullable = null is BodyType;
    clearBody() {
      parsedBody = isResponseNullable
          ? null as BodyType
          : contentType.defaultValueFactory();
    }

    if (rawBodyBytes.isEmpty) {
      // If the raw body is empty, check the error behavior to see the
      // appropriate action to take.
      // Return null (or an empty response) unless strongThrowException is
      // selected which specifies that we should throw an exception if the
      // value is EITHER missing OR invalid (as opposed to just invalid).
      switch (config.parserErrorBehavior) {
        case ParserErrorBehavior.returnNull:
        case ParserErrorBehavior.throwException:
          clearBody();
          break;
        case ParserErrorBehavior.strongThrowException:
          throw ArgumentError.value(
            rawBody,
            'rawBody',
            'The raw body of the response is empty.',
          );
      }
    } else {
      // If the raw body is not empty, attempt to decode it.
      try {
        if (!contentType.isValidRawValue(rawBody)) {
          throw ArgumentError.value(
            rawBody,
            'rawBody',
            'The raw body of the response is not valid for the given content type (${contentType.mimeType}).',
          );
        }
      } catch (_) {
        // Throw an exception UNLESS returnNull is selected which specifies
        // that we should suppress the error and return null (or an empty
        // response) instead.
        switch (config.parserErrorBehavior) {
          case ParserErrorBehavior.returnNull:
            clearBody();
            break;
          case ParserErrorBehavior.throwException:
          case ParserErrorBehavior.strongThrowException:
            rethrow;
        }
      }
    }

    // If we're here the raw body is now valid, so we can decode (parse) it.
    parsedBody = contentType.decode(rawBody);
  }
}
