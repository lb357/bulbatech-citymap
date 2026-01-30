import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_widget_data.dart';
import 'package:flutter_application_1/views/new_ticket/new_ticket.dart';


class BuildTicketWithData extends StatefulWidget {
   BuildTicketWithData({
      super.key,
      required this.context,
      required this.ticketWidgetData,
      required this.isOnFeed,
      required this.isLiked,
      this.onClosedCallback

    });

    final BuildContext context;
    final TicketWidgetData ticketWidgetData;
    final bool isOnFeed;
    bool isLiked;

    Function? onClosedCallback;
  @override
  State<BuildTicketWithData> createState() => _BuildTicketWithDataState();
}

class _BuildTicketWithDataState extends State<BuildTicketWithData> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:() async {
          await Navigator.push(
            context,
            RoutingController.createRoute(
              NewTicket(onClosedCallback: widget.onClosedCallback, showOnlyTicketWidgetData: widget.ticketWidgetData),
              true
            )
          );

        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
          child: Card(
            color: widget.isOnFeed ? client.theme.getColor("bg") : client.theme.getColor("bg2"),
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
              
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Row(
                    children: [
                      Text(
                        widget.ticketWidgetData.ticketTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: client.theme.getColor("heading"),
                        ),
                      ),
                      Spacer(),
                      Container(
                        
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.ticketWidgetData.ticketType.bgColor
                        ),
                        child: Center(
                          child: Text(
                            widget.ticketWidgetData.ticketType.icon,
                            style: TextStyle(
                              fontSize: 24
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
        
                  const SizedBox(height: 8),
                  
                  
                  Text(
                    widget.ticketWidgetData.ticketDesc,
                    style: TextStyle(
                      fontSize: 16,
                      color: client.theme.getColor("text2"),
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 16),


                  
                 Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal:  12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.ticketWidgetData.ticketState.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.ticketWidgetData.ticketState.textIconColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.ticketWidgetData.ticketState.icon,
                          color: widget.ticketWidgetData.ticketState.textIconColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.ticketWidgetData.ticketState.text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: widget.ticketWidgetData.ticketState.textIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: client.theme.getColor("text2"),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.ticketWidgetData.ticketDateUploaded,
                            style: TextStyle(
                              fontSize: 14,
                              color: client.theme.getColor("text2"),
                            ),
                          ),
                        ],
                      ),
                      
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            (widget.isOnFeed) ? IconButton(
                              onPressed: () {
                                
                              },
                              icon: Icon(Icons.thumb_up),
                              color: widget.isLiked ? Colors.blue[700] : Colors.grey,
                              iconSize: ScreenInfo.getAdaptiveValue(18) 
                            ) : Icon(
                              Icons.thumb_up,
                              color: Colors.blue[700],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.ticketWidgetData.ticketsLikes}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: widget.isLiked ? Colors.blue[700] : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      }
}

// Widget buildTicketWithData(BuildContext context, TicketWidgetData ticketWidgetData, bool isOnFeed){
  
    

