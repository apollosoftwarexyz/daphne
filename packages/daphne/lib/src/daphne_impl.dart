part of 'package:daphne/src/daphne.dart';

class _DaphneImpl extends DaphneBase
    with DaphneConvenienceMethods
    implements Daphne {
  /// The underlying HTTP client from the Dart HTTP package.
  late final Client _client;

  final DaphneMutex<DaphneConfig> _config;

  @override
  DaphneConfig get cachedConfig => _config.immediate;

  _DaphneImpl(final DaphneConfig config) : _config = DaphneMutex(config) {
    // Store the configuration locally and create a new underlying HTTP client.
    _createClient(config);
  }

  //<editor-fold desc="Instance Management">

  @override
  Future<DaphneConfig> getConfig() async => _config.getValue();

  @override
  Future<void> setConfig(final DaphneConfig config) async {
    await _config.setValue(() {
      // Initialize a new client based on the new configuration.
      _disposeClient();
      _createClient(config);

      // Return the new configuration.
      return config;
    });
  }

  @override
  void dispose() {
    _disposeClient();
  }

  /// Creates a new underlying HTTP client ([_client]) based on the specified
  /// configuration ([config]).
  void _createClient(final DaphneConfig config) {
    if (config.hasPlatformConfig) {
      _client = config.platformConfig!.createClient();
    } else {
      _client = Client();
    }
  }

  /// Disposes of the underlying HTTP client ([_client]).
  ///
  /// Isolating this into its own method allows for it to be replaced with a
  /// new client based on the current configuration once this method has been
  /// called without fear of introducing regressions as the code evolves - for
  /// example to allow for the distinction between [dispose] which disposes the
  /// entire client and [disposeClient] which only disposes of the underlying
  /// HTTP client.
  void _disposeClient() {
    // TODO: terminate any pending requests.
    _client.close();
  }

  //</editor-fold>

  //<editor-fold desc="Core HTTP Methods">

  /// Resolves a given [pathOrUrl] against the current configuration's
  /// [DaphneConfig.baseUrl] if it is a path, or returns the [pathOrUrl]
  /// parsed as a [Uri] if it is an absolute URL.
  Future<Uri> _resolveUri(
    final String pathOrUrl, {
    final Map<String, String>? queryParameters,
  }) async {
    final config = await getConfig();

    // If pathOrUrl is a URL, return it as is.
    if (pathOrUrl.contains('://') || pathOrUrl.startsWith('//')) {
      return Uri.parse(pathOrUrl)
        ..queryParameters.addAll(queryParameters ?? {});
    }
    // Otherwise, we'll assume it is a path and resolve it against the base
    // URL if there is one specified. If there isn't, we'll just attempt to
    // parse it as a URL and return it as is.
    else {
      if (config.baseUrl == null) {
        return Uri.parse(pathOrUrl)
          ..queryParameters.addAll(queryParameters ?? {});
      } else {
        return Uri.parse(config.baseUrl!).resolve(pathOrUrl)
          ..queryParameters.addAll(queryParameters ?? {});
      }
    }
  }

  //</editor-fold>

  //<editor-fold desc="Core HTTP Methods">

  @override
  Future<UnparsedResponse> fetch(
    final Method method,
    final String pathOrUrl, {
    final String? body,
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) async {
    final mergedConfig = DaphneHierarchicalConfigOptions.merge(
      global: await getConfig(),
      request: request,
    );

    final controller = request.controller ??
        RequestController(
          timeout: mergedConfig.timeout,
          partialTimeouts: mergedConfig.partialTimeouts,
        );

    final daphneRequest = DaphneRequest(
      method,
      (await _resolveUri(
        pathOrUrl,
        queryParameters: request.queryParameters,
      ))
          .toString(),
      config: request.copyWith(
        controller: controller,
        headers: mergedConfig.headers,
        timeout: mergedConfig.timeout,
        partialTimeouts: mergedConfig.partialTimeouts,
        followRedirects: mergedConfig.followRedirects,
        maxRedirects: mergedConfig.maxRedirects,
      ),
    );

    final innerStreamedResponse =
        await _client.send(daphneRequest.toUnderlyingRequest());
    final innerResponse = await Response.fromStream(innerStreamedResponse);

    return DaphneResponse(
      innerResponse,
      request: daphneRequest,
      config: response,
    );
  }

  @override
  Future<ParsedResponse<RequestBody, ResponseBody>>
      fetchWithParsing<RequestBody, ResponseBody>(
    final Method method,
    final String pathOrUrl, {
    required final ContentType<ResponseBody> responseType,
    final DaphneRequestBody<RequestBody>? body,
    final DaphneRequestConfig request = defaultRequestConfig,
    final DaphneResponseConfig response = defaultResponseConfig,
  }) async {
    final mergedConfig = DaphneHierarchicalConfigOptions.merge(
      global: await getConfig(),
      request: request,
    );

    final controller = request.controller ??
        RequestController(
          timeout: mergedConfig.timeout,
          partialTimeouts: mergedConfig.partialTimeouts,
        );

    // Identify the request URL.
    final requestUrl = (
      await _resolveUri(
        pathOrUrl,
        queryParameters: request.queryParameters,
      ),
    ).toString();

    // Apply the merged configuration fragment to the request configuration.
    final requestConfig = request.copyWith(
      controller: controller,
      headers: mergedConfig.headers,
      timeout: mergedConfig.timeout,
      partialTimeouts: mergedConfig.partialTimeouts,
      followRedirects: mergedConfig.followRedirects,
      maxRedirects: mergedConfig.maxRedirects,
    );

    // Formulate the request depending on whether a body is specified.
    // (i.e., don't bother with ParsedDaphneRequest if there is no body to
    // parse).
    late final ParsedDaphneRequest<RequestBody> daphneRequest;
    if (body != null) {
      daphneRequest = ParsedDaphneRequest(
        method,
        requestUrl,
        contentType: body.contentType,
        config: requestConfig,
        body: body.body,
      );
    } else {
      if (null is! RequestBody) {
        throw ArgumentError(
          'A request body must be specified if the request body type is not '
          'nullable or void. The request body type is '
          '${RequestBody.runtimeType} but no request body was specified.',
        );
      }

      daphneRequest = ParsedDaphneRequest(
        method,
        requestUrl,
        contentType: ContentType.none as ContentType<RequestBody>,
        config: requestConfig,
      );
    }

    // Obtain an 'inner response' from the underlying HTTP client.
    final innerStreamedResponse =
        await _client.send(daphneRequest.toUnderlyingRequest());
    final innerResponse = await Response.fromStream(innerStreamedResponse);

    // Now create a parsed response from the inner response.
    return ParsedDaphneResponse(
      innerResponse,
      contentType: responseType,
      request: daphneRequest,
      config: response,
    );
  }

  //</editor-fold>
}
