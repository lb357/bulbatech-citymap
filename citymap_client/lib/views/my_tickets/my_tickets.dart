import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/login/widgets/selection_menu.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_state.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_type.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget_data.dart';
import 'package:flutter_application_1/views/new_ticket/new_ticket.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  final ScrollController _scrollController = ScrollController();
  late List<TicketWidgetData>? myTicketsData;

  int page = 0;
  bool _isLoading = true; 

  Future<void> loadMyTickets() async {
    try {
      final tickets = await Server.getMyTickets(page);

      setState(() {
        myTicketsData = tickets;
        _isLoading = false;
      });
    } catch (e) {
      
      setState(() {
        _isLoading = false;
      });
      
      print('Ошибка загрузки тикетов: $e');
    }
  }

  @override 
  void initState(){
    super.initState();



    loadMyTickets();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      bottomNavigationBar: SelectionMenu(disabledButton: 2),
      backgroundColor: client.theme.getColor("bg2"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                
                Expanded(
                  child: Container(
                    width: ScreenInfo.screenWidth * ScreenInfo.getWidthFactor(),
                    constraints: BoxConstraints(
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
                    child: Column(
                      children: [
                        
                        Padding(
                          padding: EdgeInsets.all(ScreenInfo.getAdaptiveValue(12)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.theaters,
                                color: client.theme.getColor("text1"),
                                size: ScreenInfo.getAdaptiveValue(24),
                              ),
                              SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                              Text(
                                'Мои тикеты',
                                style: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                  fontFamily: 'Eloqia',
                                  fontWeight: FontWeight.bold,
                                  color: client.theme.getColor("heading"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: ScreenInfo.getAdaptiveValue(15)),
                        
                        
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenInfo.getAdaptiveValue(20),
                          ),
                          child: GestureDetector(
                            onTap: () async{
                              await Navigator.push(
                                context,
                                RoutingController.createRoute(NewTicket(), true),
                              );

                              await loadMyTickets();
                              setState(() {
                                
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: ScreenInfo.getAdaptiveValue(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                                color: const Color.fromARGB(255, 66, 153, 162),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: ScreenInfo.getAdaptiveValue(24),
                                      height: ScreenInfo.getAdaptiveValue(24),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: client.theme.getColor("text3"),
                                          width: 2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                            color: client.theme.getColor("text3"),
                                            fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                                    Text(
                                      'Создать Новый Тикет',
                                      style: TextStyle(
                                        fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Eloqia',
                                        color: client.theme.getColor("text3"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: ScreenInfo.getAdaptiveValue(15)),
                        
                        
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenInfo.getAdaptiveValue(0),
                            ),
                            child: _buildTicketsList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTicketsList() {
    
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: client.theme.getColor("text1"),
        ),
      );
    }

    
    if (myTicketsData == null || myTicketsData!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: ScreenInfo.getAdaptiveValue(64),
              color: client.theme.getColor("text2").withOpacity(0.5),
            ),
            SizedBox(height: ScreenInfo.getAdaptiveValue(16)),
            Text(
              'Тикетов пока нет',
              style: TextStyle(
                fontSize: ScreenInfo.getAdaptiveFontSize(16),
                fontFamily: 'Eloqia',
                color: client.theme.getColor("text2"),
              ),
            ),
            SizedBox(height: ScreenInfo.getAdaptiveValue(8)),
            Text(
              'Создайте свой первый тикет',
              style: TextStyle(
                fontSize: ScreenInfo.getAdaptiveFontSize(14),
                fontFamily: 'Eloqia',
                fontWeight: FontWeight.w200,
                color: client.theme.getColor("text2"),
              ),
            ),
          ],
        ),
      );
    }

    
    return ListView.separated(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: ScreenInfo.getAdaptiveValue(20)),
      itemCount: myTicketsData!.length ,
      separatorBuilder: (context, index) => SizedBox(height: ScreenInfo.getAdaptiveValue(12)),
      itemBuilder: (context, index) {
        return BuildTicketWithData(context: context, ticketWidgetData: myTicketsData![index], isOnFeed: false, isLiked: false);
      },
    );
  }
}