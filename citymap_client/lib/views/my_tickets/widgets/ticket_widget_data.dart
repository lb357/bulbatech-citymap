import 'package:flutter_application_1/views/my_tickets/widgets/ticket_state.dart';
import 'package:flutter_application_1/views/my_tickets/widgets/ticket_type.dart';

class TicketWidgetData {

  final String ticketTitle;
  final String ticketDesc;
  final String ticketDateUploaded;
  final int? ticketsLikes;
  final TicketState ticketState;
  final TicketType ticketType;
  final List<dynamic> point;
  final List<dynamic> files;
  
  String? officialComment;
  int? ticketId;
  


  TicketWidgetData({
    required this.ticketTitle,
    required this.ticketDesc,
    required this.ticketDateUploaded,
    required this.ticketsLikes,
    required this.ticketState,
    required this.point,
    required this.ticketType,
    required this.files,
    this.ticketId,
    this.officialComment
  });

}