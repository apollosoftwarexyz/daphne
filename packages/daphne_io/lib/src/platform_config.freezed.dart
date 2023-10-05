// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NativePlatformConfig {
  /// A callback handler for when a certificate fails to be authenticated.
  /// This callback has the opportunity to perform additional checks on the
  /// certificate and then make an ultimate judgement on whether the request
  /// should be allowed to proceed.
  BadCertificateCallback? get onBadCertificate =>
      throw _privateConstructorUsedError;

  /// A factory for creating a [SecurityContext] to use for this client.
  /// If this is null, the default [SecurityContext] will be used.
  SecurityContextFactory? get securityContextFactory =>
      throw _privateConstructorUsedError;

  /// A list of ALPN protocols (application-layer protocol negotiation)
  /// to use for this client. These are passed into the initialized
  /// [SecurityContext] from the [securityContextFactory] which will
  /// cause the underlying dart:io [HttpClient] to negotiate the specified
  /// protocols with the server at the TLS layer.
  ///
  /// This is a convenience method for setting the protocols on the
  /// [SecurityContext] and will override any protocols set on the
  /// [SecurityContext] by the [securityContextFactory] if it is specified.
  List<String>? get alpnProtocols => throw _privateConstructorUsedError;

  /// The default user agent to use for requests. The default is
  /// `"Daphne (Dart) (dart:io)"`.
  ///
  /// This will override the User Agent header if one is specified.
  /// This may be set to null to disable the default user agent.
  String? get userAgent => throw _privateConstructorUsedError;

  /// Optionally, a function that returns the proxy PAC script to use for
  /// a given URL. You may use this to specify a proxy for a given URL.
  /// If this is null, no proxy will be used (`"DIRECT"`).
  /// You can also choose from [findProxyFromEnvironment] or
  /// [useProxy] to use the system proxy settings or a specific proxy.
  ///
  /// This is ignored on platforms that do not support proxy configuration.
  FindProxyCallback? get configureProxy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NativePlatformConfigCopyWith<NativePlatformConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NativePlatformConfigCopyWith<$Res> {
  factory $NativePlatformConfigCopyWith(NativePlatformConfig value,
          $Res Function(NativePlatformConfig) then) =
      _$NativePlatformConfigCopyWithImpl<$Res, NativePlatformConfig>;
  @useResult
  $Res call(
      {BadCertificateCallback? onBadCertificate,
      SecurityContextFactory? securityContextFactory,
      List<String>? alpnProtocols,
      String? userAgent,
      FindProxyCallback? configureProxy});
}

/// @nodoc
class _$NativePlatformConfigCopyWithImpl<$Res,
        $Val extends NativePlatformConfig>
    implements $NativePlatformConfigCopyWith<$Res> {
  _$NativePlatformConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onBadCertificate = freezed,
    Object? securityContextFactory = freezed,
    Object? alpnProtocols = freezed,
    Object? userAgent = freezed,
    Object? configureProxy = freezed,
  }) {
    return _then(_value.copyWith(
      onBadCertificate: freezed == onBadCertificate
          ? _value.onBadCertificate
          : onBadCertificate // ignore: cast_nullable_to_non_nullable
              as BadCertificateCallback?,
      securityContextFactory: freezed == securityContextFactory
          ? _value.securityContextFactory
          : securityContextFactory // ignore: cast_nullable_to_non_nullable
              as SecurityContextFactory?,
      alpnProtocols: freezed == alpnProtocols
          ? _value.alpnProtocols
          : alpnProtocols // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      configureProxy: freezed == configureProxy
          ? _value.configureProxy
          : configureProxy // ignore: cast_nullable_to_non_nullable
              as FindProxyCallback?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NativePlatformConfigCopyWith<$Res>
    implements $NativePlatformConfigCopyWith<$Res> {
  factory _$$_NativePlatformConfigCopyWith(_$_NativePlatformConfig value,
          $Res Function(_$_NativePlatformConfig) then) =
      __$$_NativePlatformConfigCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BadCertificateCallback? onBadCertificate,
      SecurityContextFactory? securityContextFactory,
      List<String>? alpnProtocols,
      String? userAgent,
      FindProxyCallback? configureProxy});
}

/// @nodoc
class __$$_NativePlatformConfigCopyWithImpl<$Res>
    extends _$NativePlatformConfigCopyWithImpl<$Res, _$_NativePlatformConfig>
    implements _$$_NativePlatformConfigCopyWith<$Res> {
  __$$_NativePlatformConfigCopyWithImpl(_$_NativePlatformConfig _value,
      $Res Function(_$_NativePlatformConfig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onBadCertificate = freezed,
    Object? securityContextFactory = freezed,
    Object? alpnProtocols = freezed,
    Object? userAgent = freezed,
    Object? configureProxy = freezed,
  }) {
    return _then(_$_NativePlatformConfig(
      onBadCertificate: freezed == onBadCertificate
          ? _value.onBadCertificate
          : onBadCertificate // ignore: cast_nullable_to_non_nullable
              as BadCertificateCallback?,
      securityContextFactory: freezed == securityContextFactory
          ? _value.securityContextFactory
          : securityContextFactory // ignore: cast_nullable_to_non_nullable
              as SecurityContextFactory?,
      alpnProtocols: freezed == alpnProtocols
          ? _value._alpnProtocols
          : alpnProtocols // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      configureProxy: freezed == configureProxy
          ? _value.configureProxy
          : configureProxy // ignore: cast_nullable_to_non_nullable
              as FindProxyCallback?,
    ));
  }
}

/// @nodoc

class _$_NativePlatformConfig extends _NativePlatformConfig {
  const _$_NativePlatformConfig(
      {this.onBadCertificate,
      this.securityContextFactory,
      final List<String>? alpnProtocols,
      this.userAgent = "Daphne (Dart) (dart:io)",
      this.configureProxy})
      : _alpnProtocols = alpnProtocols,
        super._();

  /// A callback handler for when a certificate fails to be authenticated.
  /// This callback has the opportunity to perform additional checks on the
  /// certificate and then make an ultimate judgement on whether the request
  /// should be allowed to proceed.
  @override
  final BadCertificateCallback? onBadCertificate;

  /// A factory for creating a [SecurityContext] to use for this client.
  /// If this is null, the default [SecurityContext] will be used.
  @override
  final SecurityContextFactory? securityContextFactory;

  /// A list of ALPN protocols (application-layer protocol negotiation)
  /// to use for this client. These are passed into the initialized
  /// [SecurityContext] from the [securityContextFactory] which will
  /// cause the underlying dart:io [HttpClient] to negotiate the specified
  /// protocols with the server at the TLS layer.
  ///
  /// This is a convenience method for setting the protocols on the
  /// [SecurityContext] and will override any protocols set on the
  /// [SecurityContext] by the [securityContextFactory] if it is specified.
  final List<String>? _alpnProtocols;

  /// A list of ALPN protocols (application-layer protocol negotiation)
  /// to use for this client. These are passed into the initialized
  /// [SecurityContext] from the [securityContextFactory] which will
  /// cause the underlying dart:io [HttpClient] to negotiate the specified
  /// protocols with the server at the TLS layer.
  ///
  /// This is a convenience method for setting the protocols on the
  /// [SecurityContext] and will override any protocols set on the
  /// [SecurityContext] by the [securityContextFactory] if it is specified.
  @override
  List<String>? get alpnProtocols {
    final value = _alpnProtocols;
    if (value == null) return null;
    if (_alpnProtocols is EqualUnmodifiableListView) return _alpnProtocols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// The default user agent to use for requests. The default is
  /// `"Daphne (Dart) (dart:io)"`.
  ///
  /// This will override the User Agent header if one is specified.
  /// This may be set to null to disable the default user agent.
  @override
  @JsonKey()
  final String? userAgent;

  /// Optionally, a function that returns the proxy PAC script to use for
  /// a given URL. You may use this to specify a proxy for a given URL.
  /// If this is null, no proxy will be used (`"DIRECT"`).
  /// You can also choose from [findProxyFromEnvironment] or
  /// [useProxy] to use the system proxy settings or a specific proxy.
  ///
  /// This is ignored on platforms that do not support proxy configuration.
  @override
  final FindProxyCallback? configureProxy;

  @override
  String toString() {
    return 'NativePlatformConfig(onBadCertificate: $onBadCertificate, securityContextFactory: $securityContextFactory, alpnProtocols: $alpnProtocols, userAgent: $userAgent, configureProxy: $configureProxy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NativePlatformConfig &&
            (identical(other.onBadCertificate, onBadCertificate) ||
                other.onBadCertificate == onBadCertificate) &&
            (identical(other.securityContextFactory, securityContextFactory) ||
                other.securityContextFactory == securityContextFactory) &&
            const DeepCollectionEquality()
                .equals(other._alpnProtocols, _alpnProtocols) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.configureProxy, configureProxy) ||
                other.configureProxy == configureProxy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      onBadCertificate,
      securityContextFactory,
      const DeepCollectionEquality().hash(_alpnProtocols),
      userAgent,
      configureProxy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NativePlatformConfigCopyWith<_$_NativePlatformConfig> get copyWith =>
      __$$_NativePlatformConfigCopyWithImpl<_$_NativePlatformConfig>(
          this, _$identity);
}

abstract class _NativePlatformConfig extends NativePlatformConfig {
  const factory _NativePlatformConfig(
      {final BadCertificateCallback? onBadCertificate,
      final SecurityContextFactory? securityContextFactory,
      final List<String>? alpnProtocols,
      final String? userAgent,
      final FindProxyCallback? configureProxy}) = _$_NativePlatformConfig;
  const _NativePlatformConfig._() : super._();

  @override

  /// A callback handler for when a certificate fails to be authenticated.
  /// This callback has the opportunity to perform additional checks on the
  /// certificate and then make an ultimate judgement on whether the request
  /// should be allowed to proceed.
  BadCertificateCallback? get onBadCertificate;
  @override

  /// A factory for creating a [SecurityContext] to use for this client.
  /// If this is null, the default [SecurityContext] will be used.
  SecurityContextFactory? get securityContextFactory;
  @override

  /// A list of ALPN protocols (application-layer protocol negotiation)
  /// to use for this client. These are passed into the initialized
  /// [SecurityContext] from the [securityContextFactory] which will
  /// cause the underlying dart:io [HttpClient] to negotiate the specified
  /// protocols with the server at the TLS layer.
  ///
  /// This is a convenience method for setting the protocols on the
  /// [SecurityContext] and will override any protocols set on the
  /// [SecurityContext] by the [securityContextFactory] if it is specified.
  List<String>? get alpnProtocols;
  @override

  /// The default user agent to use for requests. The default is
  /// `"Daphne (Dart) (dart:io)"`.
  ///
  /// This will override the User Agent header if one is specified.
  /// This may be set to null to disable the default user agent.
  String? get userAgent;
  @override

  /// Optionally, a function that returns the proxy PAC script to use for
  /// a given URL. You may use this to specify a proxy for a given URL.
  /// If this is null, no proxy will be used (`"DIRECT"`).
  /// You can also choose from [findProxyFromEnvironment] or
  /// [useProxy] to use the system proxy settings or a specific proxy.
  ///
  /// This is ignored on platforms that do not support proxy configuration.
  FindProxyCallback? get configureProxy;
  @override
  @JsonKey(ignore: true)
  _$$_NativePlatformConfigCopyWith<_$_NativePlatformConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
