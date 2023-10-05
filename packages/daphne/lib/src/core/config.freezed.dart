// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DaphneConfig {
  /// The base URL for the Daphne client.
  /// All requests to relative URLs will be made relative to this base URL.
  /// (That is, [baseUrl] is used unless the URL specified for a request is
  /// itself absolute.)
  String? get baseUrl => throw _privateConstructorUsedError;

  /// The timeout, after which a request should be cancelled if a connection
  /// has not yet been established.
  /// If not specified, no timeout will be applied.
  ///
  /// If a [DaphneRequestConfig] with a controller is used, this timeout will
  /// be ignored and managed by the controller instead.
  Duration? get timeout => throw _privateConstructorUsedError;

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  /// Default is not specified.
  ///
  /// If a [DaphneRequestConfig] with a controller is used, this timeout will
  /// be ignored and managed by the controller instead.
  PartialTimeouts? get partialTimeouts => throw _privateConstructorUsedError;

  /// The default set of headers to set for all requests made with this
  /// client.
  /// These headers can be overridden by setting headers in a request config.
  Map<String, String>? get headers => throw _privateConstructorUsedError;

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  bool? get followRedirects => throw _privateConstructorUsedError;

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  int? get maxRedirects => throw _privateConstructorUsedError;

  /// The default behavior of a parser if it encounters an error for all
  /// responses.
  /// This is currently only applicable for a response parser.
  ///
  /// The default is [ParserErrorBehavior.throwException], which will throw
  /// an exception if an error is encountered whilst parsing a returned
  /// response but not if no response is returned.
  ParserErrorBehavior get parserErrorBehavior =>
      throw _privateConstructorUsedError;

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
  bool get serverIsRfc9110Compliant => throw _privateConstructorUsedError;

  /// Optionally, a [PlatformConfig] to use for this client.
  /// If this is null, the default [PlatformConfig] will be used.
  /// On native platforms, you may use [NativePlatformConfig].
  ///
  /// Options or configurations that are not supported on the current
  /// platform will be ignored.
  PlatformConfig? get platformConfig => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DaphneConfigCopyWith<DaphneConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaphneConfigCopyWith<$Res> {
  factory $DaphneConfigCopyWith(
          DaphneConfig value, $Res Function(DaphneConfig) then) =
      _$DaphneConfigCopyWithImpl<$Res, DaphneConfig>;
  @useResult
  $Res call(
      {String? baseUrl,
      Duration? timeout,
      PartialTimeouts? partialTimeouts,
      Map<String, String>? headers,
      bool? followRedirects,
      int? maxRedirects,
      ParserErrorBehavior parserErrorBehavior,
      bool serverIsRfc9110Compliant,
      PlatformConfig? platformConfig});
}

/// @nodoc
class _$DaphneConfigCopyWithImpl<$Res, $Val extends DaphneConfig>
    implements $DaphneConfigCopyWith<$Res> {
  _$DaphneConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = freezed,
    Object? timeout = freezed,
    Object? partialTimeouts = freezed,
    Object? headers = freezed,
    Object? followRedirects = freezed,
    Object? maxRedirects = freezed,
    Object? parserErrorBehavior = null,
    Object? serverIsRfc9110Compliant = null,
    Object? platformConfig = freezed,
  }) {
    return _then(_value.copyWith(
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      partialTimeouts: freezed == partialTimeouts
          ? _value.partialTimeouts
          : partialTimeouts // ignore: cast_nullable_to_non_nullable
              as PartialTimeouts?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      followRedirects: freezed == followRedirects
          ? _value.followRedirects
          : followRedirects // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxRedirects: freezed == maxRedirects
          ? _value.maxRedirects
          : maxRedirects // ignore: cast_nullable_to_non_nullable
              as int?,
      parserErrorBehavior: null == parserErrorBehavior
          ? _value.parserErrorBehavior
          : parserErrorBehavior // ignore: cast_nullable_to_non_nullable
              as ParserErrorBehavior,
      serverIsRfc9110Compliant: null == serverIsRfc9110Compliant
          ? _value.serverIsRfc9110Compliant
          : serverIsRfc9110Compliant // ignore: cast_nullable_to_non_nullable
              as bool,
      platformConfig: freezed == platformConfig
          ? _value.platformConfig
          : platformConfig // ignore: cast_nullable_to_non_nullable
              as PlatformConfig?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DaphneConfigCopyWith<$Res>
    implements $DaphneConfigCopyWith<$Res> {
  factory _$$_DaphneConfigCopyWith(
          _$_DaphneConfig value, $Res Function(_$_DaphneConfig) then) =
      __$$_DaphneConfigCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? baseUrl,
      Duration? timeout,
      PartialTimeouts? partialTimeouts,
      Map<String, String>? headers,
      bool? followRedirects,
      int? maxRedirects,
      ParserErrorBehavior parserErrorBehavior,
      bool serverIsRfc9110Compliant,
      PlatformConfig? platformConfig});
}

/// @nodoc
class __$$_DaphneConfigCopyWithImpl<$Res>
    extends _$DaphneConfigCopyWithImpl<$Res, _$_DaphneConfig>
    implements _$$_DaphneConfigCopyWith<$Res> {
  __$$_DaphneConfigCopyWithImpl(
      _$_DaphneConfig _value, $Res Function(_$_DaphneConfig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = freezed,
    Object? timeout = freezed,
    Object? partialTimeouts = freezed,
    Object? headers = freezed,
    Object? followRedirects = freezed,
    Object? maxRedirects = freezed,
    Object? parserErrorBehavior = null,
    Object? serverIsRfc9110Compliant = null,
    Object? platformConfig = freezed,
  }) {
    return _then(_$_DaphneConfig(
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      partialTimeouts: freezed == partialTimeouts
          ? _value.partialTimeouts
          : partialTimeouts // ignore: cast_nullable_to_non_nullable
              as PartialTimeouts?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      followRedirects: freezed == followRedirects
          ? _value.followRedirects
          : followRedirects // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxRedirects: freezed == maxRedirects
          ? _value.maxRedirects
          : maxRedirects // ignore: cast_nullable_to_non_nullable
              as int?,
      parserErrorBehavior: null == parserErrorBehavior
          ? _value.parserErrorBehavior
          : parserErrorBehavior // ignore: cast_nullable_to_non_nullable
              as ParserErrorBehavior,
      serverIsRfc9110Compliant: null == serverIsRfc9110Compliant
          ? _value.serverIsRfc9110Compliant
          : serverIsRfc9110Compliant // ignore: cast_nullable_to_non_nullable
              as bool,
      platformConfig: freezed == platformConfig
          ? _value.platformConfig
          : platformConfig // ignore: cast_nullable_to_non_nullable
              as PlatformConfig?,
    ));
  }
}

/// @nodoc

class _$_DaphneConfig extends _DaphneConfig {
  const _$_DaphneConfig(
      {this.baseUrl,
      this.timeout,
      this.partialTimeouts,
      final Map<String, String>? headers,
      this.followRedirects,
      this.maxRedirects,
      this.parserErrorBehavior = ParserErrorBehavior.throwException,
      this.serverIsRfc9110Compliant = true,
      this.platformConfig})
      : _headers = headers,
        super._();

  /// The base URL for the Daphne client.
  /// All requests to relative URLs will be made relative to this base URL.
  /// (That is, [baseUrl] is used unless the URL specified for a request is
  /// itself absolute.)
  @override
  final String? baseUrl;

  /// The timeout, after which a request should be cancelled if a connection
  /// has not yet been established.
  /// If not specified, no timeout will be applied.
  ///
  /// If a [DaphneRequestConfig] with a controller is used, this timeout will
  /// be ignored and managed by the controller instead.
  @override
  final Duration? timeout;

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  /// Default is not specified.
  ///
  /// If a [DaphneRequestConfig] with a controller is used, this timeout will
  /// be ignored and managed by the controller instead.
  @override
  final PartialTimeouts? partialTimeouts;

  /// The default set of headers to set for all requests made with this
  /// client.
  /// These headers can be overridden by setting headers in a request config.
  final Map<String, String>? _headers;

  /// The default set of headers to set for all requests made with this
  /// client.
  /// These headers can be overridden by setting headers in a request config.
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  @override
  final bool? followRedirects;

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  @override
  final int? maxRedirects;

  /// The default behavior of a parser if it encounters an error for all
  /// responses.
  /// This is currently only applicable for a response parser.
  ///
  /// The default is [ParserErrorBehavior.throwException], which will throw
  /// an exception if an error is encountered whilst parsing a returned
  /// response but not if no response is returned.
  @override
  @JsonKey()
  final ParserErrorBehavior parserErrorBehavior;

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
  @override
  @JsonKey()
  final bool serverIsRfc9110Compliant;

  /// Optionally, a [PlatformConfig] to use for this client.
  /// If this is null, the default [PlatformConfig] will be used.
  /// On native platforms, you may use [NativePlatformConfig].
  ///
  /// Options or configurations that are not supported on the current
  /// platform will be ignored.
  @override
  final PlatformConfig? platformConfig;

  @override
  String toString() {
    return 'DaphneConfig(baseUrl: $baseUrl, timeout: $timeout, partialTimeouts: $partialTimeouts, headers: $headers, followRedirects: $followRedirects, maxRedirects: $maxRedirects, parserErrorBehavior: $parserErrorBehavior, serverIsRfc9110Compliant: $serverIsRfc9110Compliant, platformConfig: $platformConfig)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DaphneConfig &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.partialTimeouts, partialTimeouts) ||
                other.partialTimeouts == partialTimeouts) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.followRedirects, followRedirects) ||
                other.followRedirects == followRedirects) &&
            (identical(other.maxRedirects, maxRedirects) ||
                other.maxRedirects == maxRedirects) &&
            (identical(other.parserErrorBehavior, parserErrorBehavior) ||
                other.parserErrorBehavior == parserErrorBehavior) &&
            (identical(
                    other.serverIsRfc9110Compliant, serverIsRfc9110Compliant) ||
                other.serverIsRfc9110Compliant == serverIsRfc9110Compliant) &&
            (identical(other.platformConfig, platformConfig) ||
                other.platformConfig == platformConfig));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      baseUrl,
      timeout,
      partialTimeouts,
      const DeepCollectionEquality().hash(_headers),
      followRedirects,
      maxRedirects,
      parserErrorBehavior,
      serverIsRfc9110Compliant,
      platformConfig);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DaphneConfigCopyWith<_$_DaphneConfig> get copyWith =>
      __$$_DaphneConfigCopyWithImpl<_$_DaphneConfig>(this, _$identity);
}

abstract class _DaphneConfig extends DaphneConfig {
  const factory _DaphneConfig(
      {final String? baseUrl,
      final Duration? timeout,
      final PartialTimeouts? partialTimeouts,
      final Map<String, String>? headers,
      final bool? followRedirects,
      final int? maxRedirects,
      final ParserErrorBehavior parserErrorBehavior,
      final bool serverIsRfc9110Compliant,
      final PlatformConfig? platformConfig}) = _$_DaphneConfig;
  const _DaphneConfig._() : super._();

  @override

  /// The base URL for the Daphne client.
  /// All requests to relative URLs will be made relative to this base URL.
  /// (That is, [baseUrl] is used unless the URL specified for a request is
  /// itself absolute.)
  String? get baseUrl;
  @override

  /// The timeout, after which a request should be cancelled if a connection
  /// has not yet been established.
  /// If not specified, no timeout will be applied.
  ///
  /// If a [DaphneRequestConfig] with a controller is used, this timeout will
  /// be ignored and managed by the controller instead.
  Duration? get timeout;
  @override

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  /// Default is not specified.
  ///
  /// If a [DaphneRequestConfig] with a controller is used, this timeout will
  /// be ignored and managed by the controller instead.
  PartialTimeouts? get partialTimeouts;
  @override

  /// The default set of headers to set for all requests made with this
  /// client.
  /// These headers can be overridden by setting headers in a request config.
  Map<String, String>? get headers;
  @override

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  bool? get followRedirects;
  @override

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  int? get maxRedirects;
  @override

  /// The default behavior of a parser if it encounters an error for all
  /// responses.
  /// This is currently only applicable for a response parser.
  ///
  /// The default is [ParserErrorBehavior.throwException], which will throw
  /// an exception if an error is encountered whilst parsing a returned
  /// response but not if no response is returned.
  ParserErrorBehavior get parserErrorBehavior;
  @override

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
  bool get serverIsRfc9110Compliant;
  @override

  /// Optionally, a [PlatformConfig] to use for this client.
  /// If this is null, the default [PlatformConfig] will be used.
  /// On native platforms, you may use [NativePlatformConfig].
  ///
  /// Options or configurations that are not supported on the current
  /// platform will be ignored.
  PlatformConfig? get platformConfig;
  @override
  @JsonKey(ignore: true)
  _$$_DaphneConfigCopyWith<_$_DaphneConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DaphneRequestConfig {
  RequestController? get controller => throw _privateConstructorUsedError;

  /// The set of request-specific headers to set for this request.
  Map<String, String>? get headers => throw _privateConstructorUsedError;

  /// The set of request-specific query parameters to set for this request.
  Map<String, String> get queryParameters => throw _privateConstructorUsedError;

  /// The timeout, after which a request should be cancelled if a connection
  /// has not yet been established.
  ///
  /// If a [controller] is specified, this is ignored.
  Duration? get timeout => throw _privateConstructorUsedError;

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  /// Default is not specified.
  ///
  /// If a [controller] is specified, this is ignored.
  PartialTimeouts? get partialTimeouts => throw _privateConstructorUsedError;

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  bool? get followRedirects => throw _privateConstructorUsedError;

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  int? get maxRedirects => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DaphneRequestConfigCopyWith<DaphneRequestConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaphneRequestConfigCopyWith<$Res> {
  factory $DaphneRequestConfigCopyWith(
          DaphneRequestConfig value, $Res Function(DaphneRequestConfig) then) =
      _$DaphneRequestConfigCopyWithImpl<$Res, DaphneRequestConfig>;
  @useResult
  $Res call(
      {RequestController? controller,
      Map<String, String>? headers,
      Map<String, String> queryParameters,
      Duration? timeout,
      PartialTimeouts? partialTimeouts,
      bool? followRedirects,
      int? maxRedirects});
}

/// @nodoc
class _$DaphneRequestConfigCopyWithImpl<$Res, $Val extends DaphneRequestConfig>
    implements $DaphneRequestConfigCopyWith<$Res> {
  _$DaphneRequestConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = freezed,
    Object? headers = freezed,
    Object? queryParameters = null,
    Object? timeout = freezed,
    Object? partialTimeouts = freezed,
    Object? followRedirects = freezed,
    Object? maxRedirects = freezed,
  }) {
    return _then(_value.copyWith(
      controller: freezed == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as RequestController?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      queryParameters: null == queryParameters
          ? _value.queryParameters
          : queryParameters // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      partialTimeouts: freezed == partialTimeouts
          ? _value.partialTimeouts
          : partialTimeouts // ignore: cast_nullable_to_non_nullable
              as PartialTimeouts?,
      followRedirects: freezed == followRedirects
          ? _value.followRedirects
          : followRedirects // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxRedirects: freezed == maxRedirects
          ? _value.maxRedirects
          : maxRedirects // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DaphneRequestConfigCopyWith<$Res>
    implements $DaphneRequestConfigCopyWith<$Res> {
  factory _$$_DaphneRequestConfigCopyWith(_$_DaphneRequestConfig value,
          $Res Function(_$_DaphneRequestConfig) then) =
      __$$_DaphneRequestConfigCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RequestController? controller,
      Map<String, String>? headers,
      Map<String, String> queryParameters,
      Duration? timeout,
      PartialTimeouts? partialTimeouts,
      bool? followRedirects,
      int? maxRedirects});
}

/// @nodoc
class __$$_DaphneRequestConfigCopyWithImpl<$Res>
    extends _$DaphneRequestConfigCopyWithImpl<$Res, _$_DaphneRequestConfig>
    implements _$$_DaphneRequestConfigCopyWith<$Res> {
  __$$_DaphneRequestConfigCopyWithImpl(_$_DaphneRequestConfig _value,
      $Res Function(_$_DaphneRequestConfig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = freezed,
    Object? headers = freezed,
    Object? queryParameters = null,
    Object? timeout = freezed,
    Object? partialTimeouts = freezed,
    Object? followRedirects = freezed,
    Object? maxRedirects = freezed,
  }) {
    return _then(_$_DaphneRequestConfig(
      controller: freezed == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as RequestController?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      queryParameters: null == queryParameters
          ? _value._queryParameters
          : queryParameters // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      partialTimeouts: freezed == partialTimeouts
          ? _value.partialTimeouts
          : partialTimeouts // ignore: cast_nullable_to_non_nullable
              as PartialTimeouts?,
      followRedirects: freezed == followRedirects
          ? _value.followRedirects
          : followRedirects // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxRedirects: freezed == maxRedirects
          ? _value.maxRedirects
          : maxRedirects // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$_DaphneRequestConfig implements _DaphneRequestConfig {
  const _$_DaphneRequestConfig(
      {this.controller,
      final Map<String, String>? headers,
      final Map<String, String> queryParameters = const {},
      this.timeout,
      this.partialTimeouts,
      this.followRedirects,
      this.maxRedirects})
      : _headers = headers,
        _queryParameters = queryParameters;

  @override
  final RequestController? controller;

  /// The set of request-specific headers to set for this request.
  final Map<String, String>? _headers;

  /// The set of request-specific headers to set for this request.
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// The set of request-specific query parameters to set for this request.
  final Map<String, String> _queryParameters;

  /// The set of request-specific query parameters to set for this request.
  @override
  @JsonKey()
  Map<String, String> get queryParameters {
    if (_queryParameters is EqualUnmodifiableMapView) return _queryParameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_queryParameters);
  }

  /// The timeout, after which a request should be cancelled if a connection
  /// has not yet been established.
  ///
  /// If a [controller] is specified, this is ignored.
  @override
  final Duration? timeout;

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  /// Default is not specified.
  ///
  /// If a [controller] is specified, this is ignored.
  @override
  final PartialTimeouts? partialTimeouts;

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  @override
  final bool? followRedirects;

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  @override
  final int? maxRedirects;

  @override
  String toString() {
    return 'DaphneRequestConfig(controller: $controller, headers: $headers, queryParameters: $queryParameters, timeout: $timeout, partialTimeouts: $partialTimeouts, followRedirects: $followRedirects, maxRedirects: $maxRedirects)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DaphneRequestConfig &&
            (identical(other.controller, controller) ||
                other.controller == controller) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._queryParameters, _queryParameters) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.partialTimeouts, partialTimeouts) ||
                other.partialTimeouts == partialTimeouts) &&
            (identical(other.followRedirects, followRedirects) ||
                other.followRedirects == followRedirects) &&
            (identical(other.maxRedirects, maxRedirects) ||
                other.maxRedirects == maxRedirects));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      controller,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_queryParameters),
      timeout,
      partialTimeouts,
      followRedirects,
      maxRedirects);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DaphneRequestConfigCopyWith<_$_DaphneRequestConfig> get copyWith =>
      __$$_DaphneRequestConfigCopyWithImpl<_$_DaphneRequestConfig>(
          this, _$identity);
}

abstract class _DaphneRequestConfig implements DaphneRequestConfig {
  const factory _DaphneRequestConfig(
      {final RequestController? controller,
      final Map<String, String>? headers,
      final Map<String, String> queryParameters,
      final Duration? timeout,
      final PartialTimeouts? partialTimeouts,
      final bool? followRedirects,
      final int? maxRedirects}) = _$_DaphneRequestConfig;

  @override
  RequestController? get controller;
  @override

  /// The set of request-specific headers to set for this request.
  Map<String, String>? get headers;
  @override

  /// The set of request-specific query parameters to set for this request.
  Map<String, String> get queryParameters;
  @override

  /// The timeout, after which a request should be cancelled if a connection
  /// has not yet been established.
  ///
  /// If a [controller] is specified, this is ignored.
  Duration? get timeout;
  @override

  /// The timeouts for different stages of a request. Timeouts are only used
  /// if they are specified. See [PartialTimeouts] for details.
  /// Default is not specified.
  ///
  /// If a [controller] is specified, this is ignored.
  PartialTimeouts? get partialTimeouts;
  @override

  /// Whether redirects should be followed automatically.
  /// Default is true, meaning that redirects will be followed. If false,
  /// redirects will be returned as a normal response.
  bool? get followRedirects;
  @override

  /// The maximum number of redirects to follow before returning a response.
  /// Default is 5.
  /// This is ignored if [followRedirects] is false.
  int? get maxRedirects;
  @override
  @JsonKey(ignore: true)
  _$$_DaphneRequestConfigCopyWith<_$_DaphneRequestConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DaphneResponseConfig {
  /// The behavior of a parser if it encounters an error.
  ///
  /// The default is [ParserErrorBehavior.throwException], which will throw
  /// an exception if an error is encountered whilst parsing a returned
  /// response but not if no response is returned.
  ParserErrorBehavior get parserErrorBehavior =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DaphneResponseConfigCopyWith<DaphneResponseConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaphneResponseConfigCopyWith<$Res> {
  factory $DaphneResponseConfigCopyWith(DaphneResponseConfig value,
          $Res Function(DaphneResponseConfig) then) =
      _$DaphneResponseConfigCopyWithImpl<$Res, DaphneResponseConfig>;
  @useResult
  $Res call({ParserErrorBehavior parserErrorBehavior});
}

/// @nodoc
class _$DaphneResponseConfigCopyWithImpl<$Res,
        $Val extends DaphneResponseConfig>
    implements $DaphneResponseConfigCopyWith<$Res> {
  _$DaphneResponseConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parserErrorBehavior = null,
  }) {
    return _then(_value.copyWith(
      parserErrorBehavior: null == parserErrorBehavior
          ? _value.parserErrorBehavior
          : parserErrorBehavior // ignore: cast_nullable_to_non_nullable
              as ParserErrorBehavior,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DaphneResponseConfigCopyWith<$Res>
    implements $DaphneResponseConfigCopyWith<$Res> {
  factory _$$_DaphneResponseConfigCopyWith(_$_DaphneResponseConfig value,
          $Res Function(_$_DaphneResponseConfig) then) =
      __$$_DaphneResponseConfigCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ParserErrorBehavior parserErrorBehavior});
}

/// @nodoc
class __$$_DaphneResponseConfigCopyWithImpl<$Res>
    extends _$DaphneResponseConfigCopyWithImpl<$Res, _$_DaphneResponseConfig>
    implements _$$_DaphneResponseConfigCopyWith<$Res> {
  __$$_DaphneResponseConfigCopyWithImpl(_$_DaphneResponseConfig _value,
      $Res Function(_$_DaphneResponseConfig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parserErrorBehavior = null,
  }) {
    return _then(_$_DaphneResponseConfig(
      parserErrorBehavior: null == parserErrorBehavior
          ? _value.parserErrorBehavior
          : parserErrorBehavior // ignore: cast_nullable_to_non_nullable
              as ParserErrorBehavior,
    ));
  }
}

/// @nodoc

class _$_DaphneResponseConfig implements _DaphneResponseConfig {
  const _$_DaphneResponseConfig(
      {this.parserErrorBehavior = ParserErrorBehavior.throwException});

  /// The behavior of a parser if it encounters an error.
  ///
  /// The default is [ParserErrorBehavior.throwException], which will throw
  /// an exception if an error is encountered whilst parsing a returned
  /// response but not if no response is returned.
  @override
  @JsonKey()
  final ParserErrorBehavior parserErrorBehavior;

  @override
  String toString() {
    return 'DaphneResponseConfig(parserErrorBehavior: $parserErrorBehavior)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DaphneResponseConfig &&
            (identical(other.parserErrorBehavior, parserErrorBehavior) ||
                other.parserErrorBehavior == parserErrorBehavior));
  }

  @override
  int get hashCode => Object.hash(runtimeType, parserErrorBehavior);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DaphneResponseConfigCopyWith<_$_DaphneResponseConfig> get copyWith =>
      __$$_DaphneResponseConfigCopyWithImpl<_$_DaphneResponseConfig>(
          this, _$identity);
}

abstract class _DaphneResponseConfig implements DaphneResponseConfig {
  const factory _DaphneResponseConfig(
          {final ParserErrorBehavior parserErrorBehavior}) =
      _$_DaphneResponseConfig;

  @override

  /// The behavior of a parser if it encounters an error.
  ///
  /// The default is [ParserErrorBehavior.throwException], which will throw
  /// an exception if an error is encountered whilst parsing a returned
  /// response but not if no response is returned.
  ParserErrorBehavior get parserErrorBehavior;
  @override
  @JsonKey(ignore: true)
  _$$_DaphneResponseConfigCopyWith<_$_DaphneResponseConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DaphneRequestBody<BodyType> {
  /// The content type to parse and serialize the [body] with.
  ContentType<BodyType> get contentType => throw _privateConstructorUsedError;

  /// The request body.
  BodyType get body => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DaphneRequestBodyCopyWith<BodyType, DaphneRequestBody<BodyType>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaphneRequestBodyCopyWith<BodyType, $Res> {
  factory $DaphneRequestBodyCopyWith(DaphneRequestBody<BodyType> value,
          $Res Function(DaphneRequestBody<BodyType>) then) =
      _$DaphneRequestBodyCopyWithImpl<BodyType, $Res,
          DaphneRequestBody<BodyType>>;
  @useResult
  $Res call({ContentType<BodyType> contentType, BodyType body});
}

/// @nodoc
class _$DaphneRequestBodyCopyWithImpl<BodyType, $Res,
        $Val extends DaphneRequestBody<BodyType>>
    implements $DaphneRequestBodyCopyWith<BodyType, $Res> {
  _$DaphneRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as ContentType<BodyType>,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as BodyType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DaphneRequestBodyCopyWith<BodyType, $Res>
    implements $DaphneRequestBodyCopyWith<BodyType, $Res> {
  factory _$$_DaphneRequestBodyCopyWith(_$_DaphneRequestBody<BodyType> value,
          $Res Function(_$_DaphneRequestBody<BodyType>) then) =
      __$$_DaphneRequestBodyCopyWithImpl<BodyType, $Res>;
  @override
  @useResult
  $Res call({ContentType<BodyType> contentType, BodyType body});
}

/// @nodoc
class __$$_DaphneRequestBodyCopyWithImpl<BodyType, $Res>
    extends _$DaphneRequestBodyCopyWithImpl<BodyType, $Res,
        _$_DaphneRequestBody<BodyType>>
    implements _$$_DaphneRequestBodyCopyWith<BodyType, $Res> {
  __$$_DaphneRequestBodyCopyWithImpl(_$_DaphneRequestBody<BodyType> _value,
      $Res Function(_$_DaphneRequestBody<BodyType>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? body = freezed,
  }) {
    return _then(_$_DaphneRequestBody<BodyType>(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as ContentType<BodyType>,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as BodyType,
    ));
  }
}

/// @nodoc

class _$_DaphneRequestBody<BodyType> implements _DaphneRequestBody<BodyType> {
  const _$_DaphneRequestBody({required this.contentType, required this.body});

  /// The content type to parse and serialize the [body] with.
  @override
  final ContentType<BodyType> contentType;

  /// The request body.
  @override
  final BodyType body;

  @override
  String toString() {
    return 'DaphneRequestBody<$BodyType>(contentType: $contentType, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DaphneRequestBody<BodyType> &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            const DeepCollectionEquality().equals(other.body, body));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, contentType, const DeepCollectionEquality().hash(body));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DaphneRequestBodyCopyWith<BodyType, _$_DaphneRequestBody<BodyType>>
      get copyWith => __$$_DaphneRequestBodyCopyWithImpl<BodyType,
          _$_DaphneRequestBody<BodyType>>(this, _$identity);
}

abstract class _DaphneRequestBody<BodyType>
    implements DaphneRequestBody<BodyType> {
  const factory _DaphneRequestBody(
      {required final ContentType<BodyType> contentType,
      required final BodyType body}) = _$_DaphneRequestBody<BodyType>;

  @override

  /// The content type to parse and serialize the [body] with.
  ContentType<BodyType> get contentType;
  @override

  /// The request body.
  BodyType get body;
  @override
  @JsonKey(ignore: true)
  _$$_DaphneRequestBodyCopyWith<BodyType, _$_DaphneRequestBody<BodyType>>
      get copyWith => throw _privateConstructorUsedError;
}
