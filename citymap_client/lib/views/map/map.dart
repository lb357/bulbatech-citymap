import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/osm_place.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/login/widgets/selection_menu.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget_data.dart';
import 'package:flutter_application_1/views/new_ticket/new_ticket.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  Function? onPointChanged;
  String? address;
  LatLng? selectedPoint;
  bool? showOnly;
  bool? showTickets;
  
  MapWidget({
    super.key,
    this.initialCenter = const LatLng(55.7558, 37.6176),
    this.initialZoom = 13.0,
    this.address,
    this.selectedPoint,
    this.onPointChanged,
    this.showTickets,
    this.showOnly
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _mapController;
  final List<Marker> _markers = [];
  final TextEditingController _searchController = TextEditingController();
  LatLng? _lastPoint;
  
  Map<LatLng, TicketWidgetData>? tickets;
  String? address;
  bool loadingAddress = false;
  List<OSMPlace> _searchResults = [];


  void loadTickets() async{

    tickets = await Server.getPoints();

    createTicketsMarkers();

    setState(() {
      
    });


  }

  void createTicketsMarkers(){
    tickets?.forEach((point, ticketData){

      _addMarker(point, context, ticketData);
      setState(() {
        
      });
    });
  }

  @override 
  void initState() {
    super.initState();

    if(widget.showTickets != null && widget.showTickets == true){
      loadTickets();
    }
    
   
    _mapController = MapController();
    
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  void _initializeMap() {
    if (widget.selectedPoint != null && widget.address != null) {
      _searchController.text = widget.address!;
      _centerOnPlace(OSMPlace(
        lat: widget.selectedPoint!.latitude, 
        lon: widget.selectedPoint!.longitude, 
        displayName: widget.address!,
        type: 'unknown',
      ));
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _centerOnPlace(OSMPlace place) {
   

    
    _mapController.move(place.point, 16);
    
    setState(() {
      _markers.clear();
      _addMarker(place.point, null, null);
    });
  }

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    
    try {
      final results = await OSMGeocoder.searchAddress(query);
      setState(() {
        _searchResults = results;
        if (results.isNotEmpty) {
          _searchController.text = results[0].displayName;
        }
      });
      
      if (results.isNotEmpty) {
        _centerOnPlace(results.first);
      }
    } catch (e) {
      print('Ошибка поиска: $e');
    } 
  }
  
  Future<void> _reverseGeocode(LatLng point) async {    
    try {
      final place = await OSMGeocoder.reverseGeocode(point);
      if (place != null) {
        setState(() {
          address = place.displayName;
          loadingAddress = false;
        });
      }
    } catch (e) {
      print('Ошибка обратного геокодирования: $e');
    } 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: (widget.showTickets!) ? SelectionMenu(disabledButton: 1) : null,
        body: Stack(
          children: [
           
                FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: widget.initialCenter,
                      initialZoom: widget.initialZoom,
                      onTap: (tapPosition, point) async {
                        await _addPoint(tapPosition, point);
                      },
                      interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: (client.theme.dark) ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png' : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                        userAgentPackageName: 'com.example.map',
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  ),

            (widget.showOnly!) ? SizedBox() : Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(ScreenInfo.getAdaptiveValue(16)),
                  child: Container(
                    height: ScreenInfo.getAdaptiveValue(80),
                    child: TextFormField(
                      controller: _searchController,
                      style: TextStyle(
                        color: client.theme.getColor("text4"),
                        fontSize: ScreenInfo.getAdaptiveFontSize(14),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: client.theme.getColor("bg"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenInfo.getAdaptiveValue(16),
                          vertical: ScreenInfo.getAdaptiveValue(14),
                        ),
                        labelText: 'Улица',
                        prefixIcon: Icon(
                          Icons.search,
                          size: ScreenInfo.getAdaptiveValue(18),
                          color: client.theme.getColor("iconInActive"),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _searchAddress,
                          icon: Icon(Icons.search, size: 20),
                        ),
                        labelStyle: TextStyle(
                          fontSize: ScreenInfo.getAdaptiveFontSize(10),
                          color: client.theme.getColor("text2"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            if (_lastPoint != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildLastPointInfo(),
              ),
          ],
        ),
        floatingActionButton: (_lastPoint != null)
            ? FloatingActionButton(
                onPressed: () => submitPoint(context),
                child: const Icon(Icons.check),
              )
            : null,
      ),
    );
  }

  void submitPoint(BuildContext context) {
    if (_lastPoint != null) {
      widget.onPointChanged?.call(_lastPoint, address);
      Navigator.pop(context, _lastPoint);
    }
  }

  Widget _buildLastPointInfo() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenInfo.getAdaptiveValue(28)),
      child: Container(
        height: ScreenInfo.getAdaptiveValue(64),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: client.theme.getColor("text3"), width: 0),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Выбрана точка:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  loadingAddress
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          address ?? 'Адрес не определен',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPoint(TapPosition? tapPosition, LatLng point) async {
    if(widget.showOnly != null && widget.showOnly!) return; 
    setState(() {
      loadingAddress = true;
      _markers.clear();
      _lastPoint = point;
      _addMarker(point, null, null);
    });

    await _reverseGeocode(point);
  }

  void _addMarker(LatLng point, BuildContext? context, TicketWidgetData? ticket) {
    _markers.add(
      Marker(
        point: point,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => (context != null) ? {
            Navigator.push(
              context,
              RoutingController.createRoute(NewTicket(showOnlyTicketWidgetData: ticket), true)
            )
          } : {},
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 54, 143, 244),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}