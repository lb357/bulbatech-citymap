import "package:flutter/material.dart";
import "package:flutter_application_1/utils/screen_info.dart";
import "package:flutter_application_1/views/my_tickets/widgets/ticket_type.dart";

class PinnedUpdatesWidget extends StatefulWidget {
  const PinnedUpdatesWidget({
    super.key,
    required this.ticketType,
    required this.onTap,
  });

  final TicketType ticketType;
  final Function(PinnedUpdatesWidget) onTap;

  @override
  State<PinnedUpdatesWidget> createState() => _PinnedUpdatesWidgetState();
}

class _PinnedUpdatesWidgetState extends State<PinnedUpdatesWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget),
      child: Container(
        height: ScreenInfo.getAdaptiveValue(285),
        width: ScreenInfo.getAdaptiveValue(200),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 240, 241),
          borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(10)),
          border: Border.all(
            color:  const Color.fromARGB(255, 30, 111, 114),
            width: ScreenInfo.getAdaptiveValue(2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: ScreenInfo.getAdaptiveValue(10)),
            Padding(
              padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(3)),
              child: Icon(
                widget.ticketType.iconData,
                color: Color.fromARGB(255, 30, 111, 114),
              ),
            ),
            Text(
              widget.ticketType.alias,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenInfo.getAdaptiveValue(12),
                fontFamily: 'Eloqia',
                color: 
                     const Color.fromARGB(255, 30, 111, 114),
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class PinnedUpdatesInit extends StatefulWidget {
  PinnedUpdatesInit({super.key, this.ticketType});

  TicketType? ticketType;
  @override
  State<PinnedUpdatesInit> createState() => _PinnedUpdatesInitState();
}

class _PinnedUpdatesInitState extends State<PinnedUpdatesInit> {
  late List<PinnedUpdatesWidget> categories = [];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    // Инициализируем категории
    categories = TicketType.values
        .map((ticketType) => PinnedUpdatesWidget(
              ticketType: ticketType,
              onTap: (widget) => (),
            ))
        .toList();
    
    
   
    widget.ticketType = TicketType.culture;
  }

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenInfo.getAdaptiveValue(150),
      
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenInfo.getAdaptiveValue(29)),
        child: ListView.separated(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(20)),
          itemCount: categories.length,
          separatorBuilder: (context, index) =>
              SizedBox(width: ScreenInfo.getAdaptiveValue(12)),
          itemBuilder: (context, index) {
            return categories[index];
          },
        ),
      ),
    );
  }
}