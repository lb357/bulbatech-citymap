import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/login/widgets/selection_menu.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_type.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget_data.dart';

class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {

  

  List<TicketWidgetData> ticketWidgetDatas = [];


  int page = 1;
  int category = -1;
  bool loadedTickets = false;


  Future<void> loadTickets() async {

    loadedTickets = false;

    ticketWidgetDatas = await Server.getTicketsFromFeed(page, category) ?? [];

    loadedTickets = true;

    setState(() {
      
    });

  } 

  @override
  void initState(){

    super.initState();

    loadTickets();

  }

  Widget buildFeeldTickets(List<TicketWidgetData> ticketWidgetDatas){
  return ListView.separated(
      shrinkWrap: true,
      controller: ScrollController(),
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: ScreenInfo.getAdaptiveValue(20)),
      itemCount:  ticketWidgetDatas.length,
      separatorBuilder: (context, index) => SizedBox(height: ScreenInfo.getAdaptiveValue(12)),
      itemBuilder: (context, index) {
        return BuildTicketWithData(onClosedCallback: loadTickets, context: context, ticketWidgetData: ticketWidgetDatas[index], isOnFeed: true, isLiked: false);
      },
    );
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: SelectionMenu(disabledButton: 0),
      backgroundColor: client.theme.getColor('bg2'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: ScreenInfo.getAdaptiveValue(10), left: ScreenInfo.getAdaptiveValue(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                      Text(
                        'Лента событий',
                        style: TextStyle(
                          fontSize: ScreenInfo.getAdaptiveFontSize(24),
                          fontFamily: 'Eloqia',
                          fontWeight: FontWeight.bold,
                          color: client.theme.getColor("text1"),
                        ),
                      ),
                    ],
                  ),
                ),
                                    Padding(
                padding: EdgeInsets.only(left: ScreenInfo.getAdaptiveValue(10)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                      Text(
                        'Город ${Server.officialPlace}',
                        style: TextStyle(
                          fontSize: ScreenInfo.getAdaptiveFontSize(12),
                          fontFamily: 'Eloqia',
                          fontWeight: FontWeight.w100,
                          color: client.theme.getColor("heading"),
                        ),
                      ),
                    ],
                  ),
                  ),
                  Divider(),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: ()=>{
                        if(page != 1) {page-=1,
                        setState(() {
                          loadTickets();
                        })}
                      }, 
                      
                      icon: Icon(Icons.arrow_back)),
                      Text(page.toString()),
                      IconButton(onPressed: ()=>{
                        if(ticketWidgetDatas.length == 30) {page+=1,
                        setState(() {
                          loadTickets();
                          
                        })}
                      }, 
                      icon: Icon(Icons.arrow_forward)),
                    ],
                  ),
                  
                  Row(
                children: [
                  SizedBox(width: ScreenInfo.getAdaptiveValue(33)),
                  Text(
                    "Активные тикеты",
                    style: TextStyle(
                      fontSize: ScreenInfo.getAdaptiveFontSize(16),
                      fontFamily: "Eloqia",
                      fontWeight: FontWeight.w600,
                      color: client.theme.getColor("heading")
                    )
                  ),
                  SizedBox(width: ScreenInfo.getAdaptiveValue(ScreenInfo.screenWidth - ScreenInfo.getAdaptiveValue(350))),
                  GestureDetector(
                    onTap: () => {
                      if(category == TicketType.values.length - 1) category = -1
                      else category += 1,
                      setState(() {
                        loadTickets();
                      })
                    },
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list_rounded,
                            size: ScreenInfo.getAdaptiveValue(15),
                            color: client.theme.getColor("text2")
                          ),
                          Text(
                          (category == -1) ? "Фильтр по: Всем" : "Фильтр по: ${TicketType.values[category].alias}",
                          style: TextStyle(
                            fontFamily: 'Eloqia',
                            fontSize: ScreenInfo.getAdaptiveFontSize(11),
                            fontWeight: FontWeight.w600,
                            color: client.theme.getColor("text2")
                          )
                        ),
                      
                        ]
                      ),
                    ),
                  ),
                      
                ]
                ),
                (!loadedTickets) ? LinearProgressIndicator() : Expanded(
                child: SizedBox(
                    width: ScreenInfo.getAdaptiveValue(475),
                    child: buildFeeldTickets(ticketWidgetDatas)
                ),
                ),
               
              ],
            );
          }
        ),
      )
    );
  }
}

