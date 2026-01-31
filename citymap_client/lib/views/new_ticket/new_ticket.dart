///to-do new widget + bottom text + pencils + add Rows to each elem and change Paddings
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/file_picker_manager.dart';
import 'package:flutter_application_1/utils/image_picker_manager.dart';
import 'package:flutter_application_1/utils/osm_place.dart';
import 'package:flutter_application_1/utils/request_schemes.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/map/map.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget_data.dart';

import 'package:flutter_application_1/views/new_ticket/widgets/ticket_category_row.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewTicket extends StatefulWidget {
  NewTicket({
    super.key,
    this.showOnlyTicketWidgetData,
    this.onClosedCallback
  });

  TicketWidgetData? showOnlyTicketWidgetData;
  Function? onClosedCallback;

  @override
  State<NewTicket> createState() => _NewTicketState();
}

class _NewTicketState extends State<NewTicket> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late CategorySelector categorySelector;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _officialCommentsController;

  File? selectedPhoto;
  File? selectedDoc;

  
  LatLng? pointOutput;
  String? address;
  

  late bool showOnly;

  @override
  void initState(){
    super.initState();

    showOnly = widget.showOnlyTicketWidgetData != null;

    _titleController = TextEditingController();
    _descController = TextEditingController();
    _officialCommentsController = TextEditingController();
    categorySelector = CategorySelector();

    if(showOnly){

      _titleController.text = widget.showOnlyTicketWidgetData!.ticketTitle;
      _descController.text = widget.showOnlyTicketWidgetData!.ticketDesc;
      _officialCommentsController.text = widget.showOnlyTicketWidgetData!.officialComment ?? "";
     

     

    }

  }


  void onPointChanged(LatLng point, String? selectedAddress){

    pointOutput = point;
    address = selectedAddress;

    setState(() {
      
    });

  }

  @override
  void dispose(){
    super.dispose();

    _titleController.dispose();
    _descController.dispose();

  }

  String? _validateNotEmpty(String? value){

    if(value == null || value == ""){
      return "Это поле не может быть пустым!";
    }

    return null;

  }

  void _validateAndSubmit() async{
    if(_formKey.currentState!.validate() && pointOutput != null && selectedDoc != null && selectedPhoto != null){

      bool status = await Server.newTicket(TicketData(
        title: _titleController.text, 
        category: categorySelector.ticketType!.typeIndex, 
        text: _descController.text,
        point: [pointOutput!.latitude, pointOutput!.longitude]
        ),
        [selectedPhoto!, selectedDoc!]
      );

      if(status){

        Navigator.pop(context);

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: client.theme.getColor("bg2"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: ScreenInfo.screenWidth * ScreenInfo.getWidthFactor(),
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenInfo.getAdaptiveValue(16),
                    vertical: ScreenInfo.getAdaptiveValue(20),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                    color: client.theme.getColor("bg"),
                  ),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: ScreenInfo.getAdaptiveValue(24),
                                ),
                                onPressed: (){
                                  widget.onClosedCallback?.call();
                                  Navigator.pop(context);
                                },
                                color: client.theme.getColor("heading"),
                              ),
                              SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                              Expanded(
                                child: Text(
                                  (!showOnly) ? "Создать новый тикет":"Тикет #${widget.showOnlyTicketWidgetData?.ticketId}",
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                    fontFamily: 'Eloqia',
                                    fontWeight: FontWeight.bold,
                                    color: client.theme.getColor("heading"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(24)),
                          Padding(
                            padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(247)),
                            child: Text(
                              "Категория",
                              style: TextStyle(
                                fontFamily: 'Eloqia',
                                fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                color: client.theme.getColor("text4"),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(7)),
                          (!showOnly) ? categorySelector:
                            CategoryWidget(
                              ticketType: widget.showOnlyTicketWidgetData!.ticketType, 
                              isActive: true, 
                              single: true,
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(25)),
                          SizedBox(
                            width: ScreenInfo.getAdaptiveValue(334),
                            child: TextFormField(
                              readOnly: showOnly,
                              validator: (value) => _validateNotEmpty(value),
                              controller: _titleController,
                              maxLength: 20,
                              buildCounter: (context,
                                  {required currentLength, required isFocused, required maxLength}) {
                                return Text(
                                  isFocused ? "$currentLength/$maxLength" : "",
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(12),
                                  ),
                                );
                              },
                              style: TextStyle(
                                fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                color: client.theme.getColor("text4"),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(10)),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: "Заголовок",
                                labelStyle: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveValue(17),
                                  textBaseline: TextBaseline.alphabetic,
                                  color: client.theme.getColor("text1"),
                                ),
                                hintText: 'например - "Сломанный фонарь"',
                                hintStyle: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveValue(14),
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(5)),
                          SizedBox(
                            width: ScreenInfo.getAdaptiveValue(334),
                            child: TextFormField(
                              readOnly: showOnly,
                              validator: (value) => _validateNotEmpty(value),
                              controller: _descController,
                              maxLength: 500,
                              buildCounter: (context,
                                  {required currentLength, required isFocused, maxLength}) {
                                return Text(
                                  isFocused ? "$currentLength/$maxLength" : "",
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(12),
                                  ),
                                );
                              },
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                color: client.theme.getColor("text4"),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(10)),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: "Описание",
                                labelStyle: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveValue(17),
                                  textBaseline: TextBaseline.alphabetic,
                                  color: client.theme.getColor("text1"),
                                ),
                                hintText: 'Опишите вашу проблему детальнее',
                                hintStyle: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveValue(14),
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                            ),
                          ),
                          (selectedPhoto != null || showOnly) ? SizedBox(
                            height: ScreenInfo.screenWidth - ScreenInfo.getAdaptiveValue(128),
                            width: ScreenInfo.screenWidth - ScreenInfo.getAdaptiveValue(128),

                            child: (selectedPhoto != null) ? Image.file(selectedPhoto!) : (widget.showOnlyTicketWidgetData != null) ? Image.network(Server.connectUrl + "/" + widget.showOnlyTicketWidgetData!.files[0]) : SizedBox()

                          )
                            
                          : SizedBox(),
                          Padding(
                            padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(267), top: ScreenInfo.getAdaptiveValue(3)),
                            child: Text(
                              "Локация",
                              style: TextStyle(
                                fontFamily: 'Eloqia',
                                fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                color: client.theme.getColor("text4"),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(7)),
                           GestureDetector(
                            onTap: (widget.showOnlyTicketWidgetData != null)  ? ()=>{
                              Navigator.push(
                                context,
                                RoutingController.createRoute(MapWidget(showTickets: false, showOnly: true, onPointChanged: (point, address)=>{}, selectedPoint: LatLng(widget.showOnlyTicketWidgetData?.point[0], widget.showOnlyTicketWidgetData?.point[1]), address: ""), true)
                              )
                            } :() async {
                               await Navigator.push(
                                context,
                                RoutingController.createRoute(MapWidget(showTickets: false, showOnly: false, onPointChanged: onPointChanged, selectedPoint: pointOutput, address: address), true)
                              );
                              setState(() {
                                
                              });
                            },
                            child: Container(
                              height: ScreenInfo.getAdaptiveValue(100),
                              width: ScreenInfo.getAdaptiveValue(334),
                              decoration: BoxDecoration(
                                color: client.theme.getColor("bg"),
                                borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(10)),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 121, 116, 126),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: ScreenInfo.getAdaptiveValue(15)),
                                  Container(
                                    height: ScreenInfo.getAdaptiveValue(64),
                                    width: ScreenInfo.getAdaptiveValue(43),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45),
                                      color: const Color.fromARGB(255, 232, 240, 241),
                                    ),
                                    child: const Icon(
                                      Icons.map_rounded,
                                      color: Color.fromARGB(255, 30, 111, 114),
                                    ),
                                  ),
                                  SizedBox(width: ScreenInfo.getAdaptiveValue(15)),
                                  Expanded(
                                    child: Text(
                                      softWrap: true,
                                      address ?? widget.showOnlyTicketWidgetData?.point.toString() ?? "Укажите на карте",
                                      style: TextStyle(
                                        fontFamily: 'Eloqia',
                                        fontSize: ScreenInfo.getAdaptiveFontSize(18),
                                        color: client.theme.getColor("text4"),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(8)),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: client.theme.getColor("text2"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                          Padding(
                            padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(255)),
                            child: Text(
                              "Вложения",
                              style: TextStyle(
                                fontFamily: 'Eqolia',
                                fontSize: ScreenInfo.getAdaptiveValue(16),
                                color: client.theme.getColor("text4"),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(10)),
                          GestureDetector(
                            onTap: () async{
                              File? photo = await ImagePickerManager.pickImageFromGallery();

                              if(photo != null){
                                selectedPhoto = photo;
                              };

                              setState((){});
                            },
                            child: (!showOnly) ? Container(
                              height: ScreenInfo.getAdaptiveValue(60),
                              width: ScreenInfo.getAdaptiveValue(ScreenInfo.screenWidth - ScreenInfo.getAdaptiveValue(50)),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 232, 240, 241),
                                borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 30, 111, 114),
                                  width: ScreenInfo.getAdaptiveValue(2),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(3)),
                                    child: const Icon(
                                      Icons.add_a_photo_rounded,
                                      color: Color.fromARGB(255, 30, 111, 114),
                                    ),
                                  ),
                                  Text(
                                    selectedPhoto?.path.split("/").last ?? "Добавить фото",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ScreenInfo.getAdaptiveValue(12),
                                      fontFamily: 'Eloqia',
                                      color: const Color.fromARGB(255, 30, 111, 114),
                                    ),
                                  ),
                                ],
                              ),
                            ): SizedBox()
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(7)),
                          GestureDetector(
                            onTap: () async {

                              if(showOnly) {

                                launchUrlString("${Server.connectUrl}/" + widget.showOnlyTicketWidgetData!.files[1]);
                                return;
                              }

                              selectedDoc = await FilePickerManager.selectFile();

                              if(selectedDoc != null){
                                setState(() {
                                  
                                });
                              }

                            },
                            child: Container(
                              height: ScreenInfo.getAdaptiveValue(60),
                              width: ScreenInfo.getAdaptiveValue(ScreenInfo.screenWidth - ScreenInfo.getAdaptiveValue(50)),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 232, 240, 241),
                                borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 30, 111, 114),
                                  width: ScreenInfo.getAdaptiveValue(2),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(3)),
                                    child: const Icon(
                                      Icons.upload_file_rounded,
                                      color: Color.fromARGB(255, 30, 111, 114),
                                    ),
                                  ),
                                  Text(
                                    (!showOnly) ? (selectedDoc != null) ? "Перевыбрать файл" : "Добавить файл" : "Скачать файл",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ScreenInfo.getAdaptiveValue(12),
                                      fontFamily: 'Eloqia',
                                      color: const Color.fromARGB(255, 30, 111, 114),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(20)),

                          (showOnly) ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => {
                              
                                  Server.vote(widget.showOnlyTicketWidgetData!.ticketId!, false),
                                  
                                  
                                  Navigator.pop(context)
                                  
                                },
                                child: Container(
                                  height: ScreenInfo.getAdaptiveValue(67),
                                  width: ScreenInfo.getAdaptiveValue(90),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 232, 63, 63),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.thumb_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: ScreenInfo.getAdaptiveValue(20)),

                              GestureDetector(
                                onTap: () => {

                                  Server.vote(widget.showOnlyTicketWidgetData!.ticketId!, true),
                              
                                  Navigator.pop(context)

                                  
                                },
                                child: Container(
                                  height: ScreenInfo.getAdaptiveValue(67),
                                  width: ScreenInfo.getAdaptiveValue(90),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 87, 162, 253),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.thumb_up,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              

                            ],
                            
                          ) : SizedBox(),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                          (_officialCommentsController.text != "") ? SizedBox(
                            width: ScreenInfo.getAdaptiveValue(334),
                            child: TextFormField(
                              readOnly: showOnly,
                              validator: (value) => _validateNotEmpty(value),
                              controller: _officialCommentsController,
                              maxLength: 1000,
                              buildCounter: (context,
                                  {required currentLength, required isFocused, maxLength}) {
                                return Text(
                                  isFocused ? "$currentLength/$maxLength" : "",
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(12),
                                  ),
                                );
                              },
                              maxLines: 10,
                              style: TextStyle(
                                fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                color: client.theme.getColor("text4"),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(10)),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: "Официальный комментарий",
                                labelStyle: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveValue(17),
                                  textBaseline: TextBaseline.alphabetic,
                                  color: client.theme.getColor("text1"),
                                ),
                                hintText: 'Опишите вашу проблему детальнее',
                                hintStyle: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveValue(14),
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                            ),
                          ): SizedBox(),
                          (showOnly) ? SizedBox() : GestureDetector(
                            onTap: () => {

                              _validateAndSubmit()
                              
                            },
                            child: Container(
                              height: ScreenInfo.getAdaptiveValue(67),
                              width: ScreenInfo.getAdaptiveValue(365),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 30, 111, 114),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: ScreenInfo.getAdaptiveValue(15)),
                                  Text(
                                    "Отправить тикет",
                                    style: TextStyle(
                                      fontSize: ScreenInfo.getAdaptiveFontSize(20),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: ScreenInfo.getAdaptiveValue(15)),
                                  const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(7)),
                          (showOnly)? SizedBox() :Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenInfo.getAdaptiveValue(10),
                            ),
                            child: Text(
                              'Отправляя этот тикет, вы соглашаетесь с пользовательским соглашением',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                fontFamily: 'Eloqia',
                                fontWeight: FontWeight.w200,
                                color: client.theme.getColor("text2"),
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenInfo.getAdaptiveValue(7)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}


