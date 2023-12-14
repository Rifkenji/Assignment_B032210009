import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestController {
  String path;
  String server = '';
  String? storedServer;
  http.Response? _res;
  final Map<dynamic, dynamic> _body = {};
  final Map<String, String> _headers = {};
  dynamic _resultData;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    String? urlipaddres = prefs.getString('ipaddress');
    if (urlipaddres != null) {
      if (!urlipaddres.startsWith('http://') && !urlipaddres.startsWith('https://')) {
        urlipaddres = 'http://' + urlipaddres;
      }
      server = urlipaddres;
    } else {
      print("IP Address is not valid or not found");
    }
  }



  RequestController({required this.path, this.server = "urlipaddres"});


  setBody(Map<String, dynamic> data) {
    _body.clear();
    _body.addAll(data);
    _headers["Content-Type"] = "application/json; charset=UTF-8";
  }
  Future<void> post() async {
    try {
      await init();
      _res = await http.post(
        Uri.parse(server + path),
        headers: _headers,
        body: jsonEncode(_body),
      );
      _parseResult();
    } catch (e) {
      // Handle any exception during the POST request
      print("Exception during POST request: $e");
      _handleError();
    }
  }

  Future<void> get() async {
    try {
      await init();
      _res = await http.get(
        Uri.parse(server + path),
        headers: _headers,
      );
      _parseResult();
    } catch (e) {
      // Handle any exception during the GET request
      print("Exception during GET request: $e");
      _handleError();
    }
  }


  Future<void> put(Map<String, dynamic> requestBody) async {
    try {
      await init();
      _res = await http.put(
        Uri.parse(server + path),
        headers: _headers,
        body: jsonEncode(requestBody), // Pass the payload here
      );
      _parseResult();
    } catch (e) {
      // Handle any exception during the PUT request
      print("Exception during PUT request: $e");
      _handleError();
    }
  }

  Future<void> delete(Map<String, dynamic> requestBody) async {
    try {
      await init();
      _res = await http.delete(
        Uri.parse(server + path),
        headers: _headers,
        body: jsonEncode(requestBody), // Include the request body directly
      );
      _parseResult();
    } catch (e) {
      // Handle any exception during the DELETE request
      print("Exception during DELETE request: $e");
      _handleError();
    }
  }

  Future<void> _parseResult() async {
    //parse result into json structure if possible
    await init();
    try {
      print("raw response: ${_res?.body}");
      _resultData = jsonDecode(_res?.body ?? "");
    } catch (ex) {
      //otherwise the response body will be stored as is
      _resultData = _res?.body;
      print("exception in http result parsing $ex");
    }
  }

  void _handleError() {
    // You can customize this method to handle errors in a way that suits your application
    // For example, you can show a user-friendly error message or log the error for debugging
    print("Error occurred during the HTTP request");
  }

  dynamic result(){
    return _resultData;
  }
  int status() {
    return _res?.statusCode ?? 0;
  }
}