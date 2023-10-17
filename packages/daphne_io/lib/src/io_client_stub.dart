import 'package:daphne_http/http.dart';
import 'io_stub.dart';

class IOClient extends BaseClient {
  IOClient([final HttpClient? httpClient]) {
    throw DaphneIOUnsupportedPlatformError();
  }

  @override
  Future<StreamedResponse> send(final BaseRequest request) {
    throw DaphneIOUnsupportedPlatformError();
  }
}
