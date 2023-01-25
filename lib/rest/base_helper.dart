import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:melb_car_park_app/rest/constants.dart';

import 'api_exception.dart';

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = jsonDecode(response.body.toString());
      return responseJson;
    case 400:
      return jsonDecode(response.body.toString());
    case 401:
    case 403:
      return jsonDecode(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Failed to load the parking list ${response.statusCode}');
    // return FetchDataException(
    //     'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

class ApiBaseHelper {
  Future<Map<String, dynamic>> delete(String url) async {
    var apiResponse;
    try {
      final response = await http.delete(Uri.parse(url));
      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return apiResponse;
  }

  Future<Map<String, dynamic>> get(String path) async {
    String url = apiConstants["url_base"]! + path;
    Map<String, dynamic> responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = _returnResponse(response) as Map<String, dynamic>;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    var responseJson;
    try {
      final response = await http.put(Uri.parse(url), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }
}
