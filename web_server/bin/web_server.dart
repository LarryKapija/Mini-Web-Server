import 'dart:async';
import 'dart:io';

Map<int, String> dataList = {}..addAll({1: 'Hola', 2: 'Mundo'});

Future main() async {
  const PORT = 8008;
  Stream<HttpRequest> server;
  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, PORT);
    print('Listening on localhost: $PORT');
  } catch (e) {
    print('Couldnt bind to port $PORT: $e');
    exit(-1);
  }

  server.listen((HttpRequest request) {
    print(request.uri);

    request.response.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');

    switch (request.method) {
      case 'GET':
        handleGetRequest(request);
        break;
      case 'POST':
        handlePostRequest(request);
        break;
      case 'PUT':
        handlePutRequest(request);
        break;
      case 'DELETE':
        handleDeletetRequest(request);
        break;
      default:
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..write({'Unsupported request': '${request.method}'})
          ..close();
    }
  });
}

void handleGetRequest(HttpRequest request) {
  if (request.uri.path.toString().toLowerCase().startsWith('/messages')) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write(dataList)
      ..close();
  } else {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('BadRequest: ${request.response.statusCode}')
      ..close();
  }
}

void handlePostRequest(HttpRequest request) {
  if (request.uri.path.toLowerCase().toString().contains('/messages')) {
    var uri = Uri.parse(request.uri.toString());
    if (uri.queryParametersAll.length > 20) {
      request.response
        ..statusCode = HttpStatus.requestUriTooLong
        ..write('Uri Too Long: ${request.response.statusCode}')
        ..close();
    } else {
      uri.queryParametersAll.forEach((key, value) {
        dataList.addAll(
            {dataList.keys.last + 1: uri.queryParameters[key].toString()});
      });

      request.response
        ..statusCode = HttpStatus.created
        ..write(request.response.statusCode)
        ..close();
    }
  } else {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('BadRequest: ${request.response.statusCode}')
      ..close();
  }
}

void handlePutRequest(HttpRequest request) {
  if (request.uri.path.toString().toLowerCase().startsWith('/messages')) {
    var uri = Uri.parse(request.uri.toString());
    if (uri.queryParametersAll.length > 20) {
      request.response
        ..statusCode = HttpStatus.requestUriTooLong
        ..write('Uri Too Long: ${request.response.statusCode}')
        ..close();
    } else {
      uri.queryParametersAll.forEach((key, value) {
        dataList.update(int.parse(key), (mapValue) => uri.queryParameters[key]);
      });
      request.response
        ..statusCode = HttpStatus.ok
        ..write(request.response.statusCode)
        ..close();
    }
  } else {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('BadRequest: ${request.response.statusCode}')
      ..close();
  }
}

void handleDeletetRequest(HttpRequest request) {
  if (request.uri.path.toString().toLowerCase().startsWith('/messages')) {
    var uri = Uri.parse(request.uri.toString());
    if (uri.queryParametersAll.length > 20) {
      request.response
        ..statusCode = HttpStatus.requestUriTooLong
        ..write('Uri Too Long: ${request.response.statusCode}')
        ..close();
    } else {
      uri.queryParametersAll.forEach((key, value) {
        dataList.remove(int.parse(key));
      });
      request.response
        ..statusCode = HttpStatus.ok
        ..write(request.response.statusCode)
        ..close();
    }
  } else {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('BadRequest: ${request.response.statusCode}')
      ..close();
  }
}
