import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_state.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_type.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget_data.dart';
import 'package:flutter_application_1/views/new_ticket/new_ticket.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/request_schemes.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

class Server {
  static ClientController? clientController; 
  static final String connectUrl = "";
  static late PersistCookieJar cookieJar;
  static bool _initialized = false;

  static const int VERSION = 26011; 
  
  static String officialPlace = "<REGION>";

  static Future<void> init() async {
    if (_initialized) return;
    
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = "${appDocDir.path}/.cookies/";
      
      cookieJar = PersistCookieJar(
        storage: FileStorage(cookiePath),
        ignoreExpires: true, 
        persistSession: true, 
      );
      
      _initialized = true;
      debugPrint("✅ CookieJar initialized at: $cookiePath");
      
      
      await _checkSavedCookies();
      
    } catch (e) {
      debugPrint("❌ Error initializing CookieJar: $e");
      
      cookieJar = PersistCookieJar();
      _initialized = true;
      debugPrint("⚠️ Using memory cookie jar as fallback");
    }

    Server.checkVersion();
  }


  static Future<void> _checkSavedCookies() async {
    try {
      final uri = Uri.parse(connectUrl);
      final cookies = await cookieJar.loadForRequest(uri);
      debugPrint("📦 Found ${cookies.length} saved cookies for server");
      
      for (var cookie in cookies) {
        debugPrint("🍪 ${cookie.name}=${cookie.value} (expires: ${cookie.expires})");
      }
    } catch (e) {
      debugPrint("❌ Error checking saved cookies: $e");
    }
  }

  static Future<Map<String, String>> _getDefaultHeaders() async {
    await _ensureInitialized();
    
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'Flutter-App/1.0.0',
    };
    
    
    try {
      final cookieHeader = await _getCookieHeader();
      if (cookieHeader.isNotEmpty) {
        headers['Cookie'] = cookieHeader;
      }
    } catch (e) {
      debugPrint("⚠️ Error getting cookies for headers: $e");
    }
    
    return headers;
  }

  static Future<String> _getCookieHeader() async {
    final uri = Uri.parse(connectUrl);
    final cookies = await cookieJar.loadForRequest(uri);
    
    if (cookies.isEmpty) return "";
    
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }

  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  static Future<String?> user() async {
    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl/api/user");
    
    try {
      final headers = await _getDefaultHeaders();
      
      final resp = await http.post(
        requestUrl,
        headers: headers,
      );

      if (resp.statusCode == 200) {
        debugPrint("✅ User request successful");
        debugPrint(resp.body);
        
        
        await _saveCookiesFromResponse(requestUrl, resp);
        debugPrint("#######");

        debugPrint(resp.body);
        
        return resp.body;
      } else {
        debugPrint("❌ User request failed with status: ${resp.statusCode}");
        debugPrint("Response: ${resp.body}");
      }
    } catch (e) {
      debugPrint("❌ Error in user request: $e");
    }

    return null;
  }

  static Future<Map<LatLng, TicketWidgetData>?> getPoints() async {
    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl/api/points");
    final Map<LatLng, TicketWidgetData> _result = {};
    
    try {
      final headers = await _getDefaultHeaders();
      
      final resp = await http.get(
        requestUrl,
        headers: headers,
      );

      if (resp.statusCode == 200) {
        debugPrint("✅ Points request successful");

        debugPrint(jsonDecode(resp.body)["points"].toString());
        
        
        for (List<dynamic> data in jsonDecode(resp.body)["points"]){
          debugPrint(data[0].toString());
          debugPrint(data[1].toString());


          TicketWidgetData ticketData = await Server.ticketJsonToTicketWidgetData(data[1]);

          LatLng point = LatLng(data[0][0], data[0][1]);

          _result[point] = ticketData;


        }

        return _result;

      } else {
        debugPrint("❌ Points request failed with status: ${resp.statusCode}");
        debugPrint("Response: ${resp.body}");
      }
    } catch (e) {
      debugPrint("❌ Error in points request: $e");
    }

    return null;
  }


  static Future<List<TicketWidgetData>?> getTicketsFromFeed(int page, int category) async {
    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl/api/feed?page=$page&category=$category");
    final List<TicketWidgetData> _result = [];
    
    try {
      final headers = await _getDefaultHeaders();
      
      final resp = await http.get(
        requestUrl,
        headers: headers,
      );

      if (resp.statusCode == 200) {
        debugPrint("✅ Feed request successful");

        debugPrint(jsonDecode(resp.body)["tickets"].toString());
        
        
        for (Map<dynamic, dynamic> data in jsonDecode(resp.body)["tickets"]){

          TicketWidgetData ticketData = await Server.ticketJsonToTicketWidgetData(data["ticket_id"]);

          _result.add(ticketData);

        }

        return _result;

      } else {
        debugPrint("❌ Feed request failed with status: ${resp.statusCode}");
        debugPrint("Response: ${resp.body}");
      }
    } catch (e) {
      debugPrint("❌ Error in feed request: $e");
    }

    return null;
  }

  static Future<bool> login(UserLoginData userLoginData) async {
    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl/api/login");

    final Map<String, String> requestBody = {
      "email": userLoginData.email,
      "password": userLoginData.password
    };

    try {
      
      final headers = await _getDefaultHeaders();
      
      final resp = await http.post(
        requestUrl,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      if (resp.statusCode == 200) {
        final responseData = jsonDecode(resp.body);
        
        if (responseData["success"] == true) {
          debugPrint("✅ Login successful");
          
          
          await _saveCookiesFromResponse(requestUrl, resp);
          
          
          await _checkSavedCookies();
          
          return true;
        } else {
          debugPrint("❌ Login failed: ${responseData['message'] ?? 'Unknown error'}");
        }
      } else {
        debugPrint("❌ Login request failed with status: ${resp.statusCode}");
        debugPrint("Response: ${resp.body}");
      }
    } catch (e) {
      debugPrint("❌ Error in login request: $e");
    }

    return false;
  }

  static Future<bool> register(UserRegisterData userRegisterData) async {
    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl/api/signup");

    final Map<String, String?> requestBody = {
      "email": userRegisterData.email,
      "password": userRegisterData.password,
      "patronymic": userRegisterData.patronymic ?? "",
      "firstname": userRegisterData.name,
      "lastname": userRegisterData.surname,
      "snils": userRegisterData.snils,
      "birthdate": userRegisterData.birthday
    };

    try {
      final headers = await _getDefaultHeaders();
      
      final resp = await http.post(
        requestUrl,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      if (resp.statusCode == 200) {
        final responseData = jsonDecode(resp.body);
        
        if (responseData["success"] == true) {
          debugPrint("✅ Registration successful");
          
          
          await _saveCookiesFromResponse(requestUrl, resp);
          
          return true;
        } else {
          debugPrint("❌ Registration failed: ${responseData['message'] ?? 'Unknown error'}");
        }
      } else {
        debugPrint("❌ Registration request failed with status: ${resp.statusCode}");
        debugPrint("Response: ${resp.body}");
      }
    } catch (e) {
      debugPrint("❌ Error in registration request: $e");
    }

    return false;
  }


  static Future<bool> newTicket(TicketData ticketData, List<File> files) async{

    final Uri requestUrl = Uri.parse("$connectUrl/api/new");


    final req = http.MultipartRequest("POST", requestUrl);

    req.files.add(
      await http.MultipartFile.fromPath(
        "picture",
        files[0].path,
      )
    );

    req.files.add(
      await http.MultipartFile.fromPath(
        "file",
        files[1].path,
      )
    );

    final Map<String, String> requestBody = {
      "title": ticketData.title,
      "text": ticketData.text,
      "category": ticketData.category.toString(),
      "icon": ticketData.icon.toString(),
      "point": ticketData.point.toString(),
    };


    req.fields.addAll(requestBody);

    try {
        final headers = await _getDefaultHeaders();

        req.headers.addAll(headers);
        req.headers['Content-Type'] = 'multipart/form-data';
        
        final resp = await req.send();

        if (resp.statusCode == 200) {
          final responseData = jsonDecode(await resp.stream.bytesToString());

          debugPrint("JSON$responseData");
          
          if (responseData["success"] == true) {
            debugPrint("✅ New Ticket Added");
            
            return true;
          } else {
            debugPrint("❌ NewTicket failed: ${responseData['message'] ?? 'Unknown error'}");
          }
        } else {
          debugPrint("❌ NewTicket failed with status: ${resp.statusCode}");
        }
      } catch (e) {
        debugPrint("❌ Error in NewTicket request: $e");
      }

      return false;
  }

    static Future<dynamic> ticket(int ticketId) async{

    final Uri requestUrl = Uri.parse("$connectUrl/api/ticket?ticket_id=$ticketId");

    try {
        final headers = await _getDefaultHeaders();
        
        final resp = await http.get(
          requestUrl,
          headers: headers,
        );

        if (resp.statusCode == 200) {
          final responseData = jsonDecode(resp.body);
            
          return responseData;
        } else {
          debugPrint("❌ Registration request failed with status: ${resp.statusCode}");
          debugPrint("Response: ${resp.body}");
        }
      } catch (e) {
        debugPrint("❌ Error in getting ticket: $e");
      }

      return false;
  }

  static Future<TicketWidgetData> ticketJsonToTicketWidgetData(int ticketId) async{

      Map<dynamic, dynamic> _data = await Server.ticket(ticketId);

      String dateUpload = DateFormat("yyyy-MM-dd | HH:mm", "ru_RU").format(DateTime.fromMillisecondsSinceEpoch(_data["timestamp"]*1000) );


      debugPrint("😂CATEGORY${_data["category"]}");
    
      TicketWidgetData ticketData = TicketWidgetData(
        ticketTitle: _data["title"], 
        ticketDesc: _data["text"], 
        ticketDateUploaded: dateUpload, 
        ticketsLikes: _data["likes"] - _data["dislikes"], 
        ticketState: (_data["official_comment"] != null && _data["official_comment"] != "") ? TicketState.approved : TicketState.onReview, 
        ticketType: TicketType.values[_data["category"]],
        ticketId: _data["ticket_id"],
        point: _data["point"],
        files: _data["files_json"],
        officialComment: _data["official_comment"]
      );

      return ticketData;
  }

  static Future<List<TicketWidgetData>?> getMyTickets(int page) async{

    final Uri requestUrl = Uri.parse("$connectUrl/api/tickets?page=$page");

    try {
        final headers = await _getDefaultHeaders();
        
        final resp = await http.get(
          requestUrl,
          headers: headers,
        );

        if (resp.statusCode == 200) {

          final responseData = jsonDecode(resp.body);
          debugPrint(responseData.toString());
          final List<TicketWidgetData> myTicketsData = [];

          final myTickets = responseData["tickets"];

          for(Map<dynamic, dynamic> ticket in myTickets){

            TicketWidgetData ticketData = await Server.ticketJsonToTicketWidgetData(ticket["ticket_id"]);

            myTicketsData.add(ticketData);

          }
 
          return myTicketsData;


        } else {
          debugPrint("❌ Registration request failed with status: ${resp.statusCode}");
          debugPrint("Response: ${resp.body}");
        }
      } catch (e) {
        debugPrint("❌ Error in getting my tickets: $e");
      }

      return null;
  }



  static Future<void> _saveCookiesFromResponse(Uri uri, http.Response response) async {
    try {
      
      final setCookieHeader = response.headers['set-cookie'];
      
      if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
        final cookies = _parseSetCookieHeader(setCookieHeader);
        
        if (cookies.isNotEmpty) {
          await cookieJar.saveFromResponse(uri, cookies);
          debugPrint("💾 Saved ${cookies.length} cookies from response");
          
          for (var cookie in cookies) {
            debugPrint("   ${cookie.name}=${cookie.value}");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error saving cookies: $e");
    }
  }

  static List<Cookie> _parseSetCookieHeader(String setCookieHeader) {
    try {
      
      final cookieStrings = _splitCookieString(setCookieHeader);
      final cookies = <Cookie>[];

      for (var cookieStr in cookieStrings) {
        try {
          final cookie = Cookie.fromSetCookieValue(cookieStr.trim());
          cookies.add(cookie);
        } catch (e) {
          debugPrint('⚠️ Error parsing cookie string: "$cookieStr" - $e');
        }
      }

      return cookies;
    } catch (e) {
      debugPrint('❌ Error parsing Set-Cookie header: $e');
      return [];
    }
  }

  static List<String> _splitCookieString(String cookieString) {
    final cookies = <String>[];
    var currentCookie = StringBuffer();
    var inExpires = false;
    
    for (var i = 0; i < cookieString.length; i++) {
      final char = cookieString[i];
      
      if (char == ',' && !inExpires) {
        
        cookies.add(currentCookie.toString().trim());
        currentCookie.clear();
      } else {
        currentCookie.write(char);
        
        
        if (char.toLowerCase() == 'e' && 
            cookieString.substring(i, i + 8).toLowerCase() == 'expires=') {
          inExpires = true;
        }
        
        if (inExpires && char == ';' && i > 0 && cookieString[i-1] != ';') {
          inExpires = false;
        }
      }
    }
    
    
    if (currentCookie.isNotEmpty) {
      cookies.add(currentCookie.toString().trim());
    }
    
    return cookies;
  }
    static Future<String?> getAccessToken() async {
    await _ensureInitialized();
    
    try {
      final uri = Uri.parse(connectUrl);
      final cookies = await cookieJar.loadForRequest(uri);
      
      
      final accessTokenCookie = cookies.firstWhere(
        (cookie) => cookie.name == 'access_token',
        orElse: () => throw Exception('Access token not found'),
      );
      
      return accessTokenCookie.value;
    } catch (e) {
      debugPrint("⚠️ Access token not found: $e");
      return null;
    }
  }

  

  
  static Future<List<Cookie>> getAllCookies() async {
    await _ensureInitialized();
    
    try {
      final uri = Uri.parse(connectUrl);
      return await cookieJar.loadForRequest(uri);
    } catch (e) {
      debugPrint("❌ Error getting cookies: $e");
      return [];
    }
  }

  
  static Future<void> clearAllCookies() async {
    await _ensureInitialized();
    
    try {
      await cookieJar.deleteAll();
      debugPrint("✅ All cookies cleared");
    } catch (e) {
      debugPrint("❌ Error clearing cookies: $e");
    }
  }

  
  static Future<bool> hasCookies() async {
    await _ensureInitialized();
    
    final cookies = await getAllCookies();
    return cookies.isNotEmpty;
  }

  
  static Future<void> printCookieInfo() async {
    await _ensureInitialized();
    
    final cookies = await getAllCookies();
    debugPrint("📋 Total cookies: ${cookies.length}");
    
    for (var i = 0; i < cookies.length; i++) {
      final cookie = cookies[i];
      debugPrint("${i + 1}. ${cookie.name}=${cookie.value}");
      debugPrint("   Domain: ${cookie.domain}");
      debugPrint("   Path: ${cookie.path}");
      debugPrint("   Expires: ${cookie.expires}");
      debugPrint("   Secure: ${cookie.secure}");
      debugPrint("   HttpOnly: ${cookie.httpOnly}");
      debugPrint("");
    }
  }

  
  static Future<http.Response> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool includeCookies = true,
  }) async {
    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl$endpoint");
    
    try {
      
      final defaultHeaders = await _getDefaultHeaders();
      
      
      final requestHeaders = {
        ...defaultHeaders,
        ...(headers ?? {}),
      };
      
      
      if (!includeCookies) {
        requestHeaders.remove('Cookie');
      }
      
      http.Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(requestUrl, headers: requestHeaders);
          break;
        case 'POST':
          response = await http.post(
            requestUrl,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            requestUrl,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(requestUrl, headers: requestHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      
      
      if (includeCookies) {
        await _saveCookiesFromResponse(requestUrl, response);
      }
      
      return response;
      
    } catch (e) {
      debugPrint("❌ Error in $method request to $endpoint: $e");
      rethrow;
    }
  }


  static Future<bool?> vote(int ticketId, bool like) async{

    await _ensureInitialized();
    
    String requestUrl = "$connectUrl/api/";

    if (like) {
      requestUrl += "like?ticket_id=$ticketId";
    } else {
      requestUrl += "dislike?ticket_id=$ticketId";
    }
    
    try {
      final headers = await _getDefaultHeaders();
      
      final resp = await http.get(
        Uri.parse(requestUrl),
        headers: headers,
      );

      if (resp.statusCode == 200) {
        debugPrint("✅ Vote request successful");
        
        
        await _saveCookiesFromResponse(Uri.parse(requestUrl), resp);
        
        return true;
      } else {
        debugPrint("❌ Vote request failed with status: ${resp.statusCode}");
        debugPrint("Response: ${resp.body}");
      }
    } catch (e) {
      debugPrint("❌ Error in vote request: $e");
    }

    return null;

  }  

  static Future<void> checkVersion() async{

    await _ensureInitialized();
    
    final Uri requestUrl = Uri.parse("$connectUrl/api/status");
    
    final resp = await http.get(
      requestUrl,
    );

    final int serverVersion = jsonDecode(resp.body)['version'];
    officialPlace = jsonDecode(resp.body)['official_place'];


    if (resp.statusCode == 200) {
      debugPrint("CLEINT_VERSION=$VERSION\nSERVER_VERSION=$serverVersion");
 
      if (serverVersion != VERSION) debugPrint("MIGHT NEED TO UPGRADE");
    
    }
        
  }

}
