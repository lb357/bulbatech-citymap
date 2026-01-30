import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OSMGeocoder {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';
  
 
  static Future<List<OSMPlace>> searchAddress(String query, {String countryCode = 'ru'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?format=json&q=$query&countrycodes=$countryCode&limit=10'),
      headers: {'User-Agent': 'YourAppName/1.0'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => OSMPlace.fromJson(item)).toList();
    }
    throw Exception('Ошибка поиска: ${response.statusCode}');
  }
  
 
  static Future<OSMPlace?> reverseGeocode(LatLng point) async {
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1'),
      headers: {'User-Agent': 'YourAppName/1.0'},
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return OSMPlace.fromReverseJson(data);
    }
    return null;
  }
}

/// Модель места OSM
class OSMPlace {
  final double lat;
  final double lon;
  final String displayName;
  final String type;
  
  OSMPlace({
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.type,
  });
  
  LatLng get point => LatLng(lat, lon);
  
  factory OSMPlace.fromJson(Map<String, dynamic> json) {
    return OSMPlace(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: json['display_name'],
      type: json['type'] ?? json['class'] ?? 'unknown',
    );
  }
  
  factory OSMPlace.fromReverseJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>;
    String displayName = '';
    
   
    if (address['road'] != null) displayName += '${address['road']}, ';
    if (address['house_number'] != null) displayName += '${address['house_number']}, ';
    if (address['city'] != null) displayName += '${address['city']}, ';
    
    if (displayName.endsWith(', ')) {
      displayName = displayName.substring(0, displayName.length - 2);
    }
    
    return OSMPlace(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: displayName.isEmpty ? json['display_name'] : displayName,
      type: json['type'] ?? json['class'] ?? 'unknown',
    );
  }
}