import "package:flutter/material.dart";
import "package:flutter_application_1/utils/screen_info.dart";
import "package:flutter_application_1/views/my_tickets/widgets/ticket_type.dart";

class CategoryWidget extends StatefulWidget {
  CategoryWidget({
    super.key,
    required this.ticketType,
    required this.isActive,
    this.onTap,
    this.single
  });

  final TicketType ticketType;
  final bool isActive;
  bool? single;
  Function(CategoryWidget)? onTap;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {

  late bool single;

  @override
  void initState(){
    super.initState();

    single = widget.single ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(widget),
      child: Container(
        height: ScreenInfo.getAdaptiveValue(77),
        width: (!single)? ScreenInfo.getAdaptiveValue(77): ScreenInfo.getAdaptiveValue(ScreenInfo.screenWidth - ScreenInfo.getAdaptiveValue(50)),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 240, 241),
          borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(10)),
          border: Border.all(
            color: widget.isActive
                ? const Color.fromARGB(255, 30, 111, 114)
                : const Color.fromARGB(255, 223, 230, 238),
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
                color: widget.isActive
                    ? Color.fromARGB(255, 30, 111, 114)
                    : const Color.fromARGB(255, 156, 163, 175),
              ),
            ),
            Text(
              widget.ticketType.alias,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenInfo.getAdaptiveValue(12),
                fontFamily: 'Eloqia',
                color: widget.isActive
                    ? const Color.fromARGB(255, 30, 111, 114)
                    : const Color.fromARGB(255, 156, 163, 175),
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CategorySelector extends StatefulWidget {
  CategorySelector({super.key, this.ticketType});

  TicketType? ticketType;
  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<CategoryWidget> categories = [];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
   
    categories = TicketType.values
        .map((ticketType) => CategoryWidget(
              ticketType: ticketType,
              isActive: false,
              onTap: (widget) => _handleCategoryTap(widget),
            ))
        .toList();
    
   
    if (categories.isNotEmpty) { 
      categories[0] = CategoryWidget(
        ticketType: categories[0].ticketType,
        isActive: true,
        onTap: (widget) => _handleCategoryTap(widget),
      );
    }
    widget.ticketType = TicketType.sport;
  }

  void _handleCategoryTap(CategoryWidget tappedWidget) {
    setState(() {
     
      categories = categories.map((widget) {
        return CategoryWidget(
          ticketType: widget.ticketType,
          isActive: false,
          onTap: (widget) => _handleCategoryTap(widget),
        );
      }).toList();
      
     
      final index = categories.indexWhere(
          (w) => w.ticketType == tappedWidget.ticketType);
      if (index != -1) {
        categories[index] = CategoryWidget(
          ticketType: tappedWidget.ticketType,
          isActive: true,
          onTap: (widget) => _handleCategoryTap(widget),
        );
        activeIndex = index;
        widget.ticketType = tappedWidget.ticketType;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenInfo.getAdaptiveValue(75),
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







//
//

//
//
//

// class CategorySelector extends StatelessWidget {
  
//   final List<_CategoryWidgetState> states = []; 
//   late List<CategoryWidget> categories = [];
//   _CategoryWidgetState activatedWidget = _CategoryWidgetState();
  
//    void addWidgetState(_CategoryWidgetState categoryWidgetState){
//     states.add(categoryWidgetState);
//   }

//   void setActive(_CategoryWidgetState categoryWidget){
//     if (activatedWidget != _CategoryWidgetState()){
//       activatedWidget?.setActive(false);
//     }
//     categoryWidget.setActive(true);
//     activatedWidget = categoryWidget;
//   }

//   @override
//   Widget build(BuildContext context) {
//       categories = [];
//       for (TicketType ticketType in TicketType.values){
//         categories.add(CategoryWidget(ticketType : ticketType, controller: this));
//       }
//       states[0].setActive(true);
//       activatedWidget = states[0];
//       return SizedBox(
//         height: ScreenInfo.getAdaptiveValue(75),
//         child: ListView.separated(
//           controller: ScrollController(),
//           scrollDirection: Axis.horizontal, 
//           physics: const BouncingScrollPhysics(),
//           padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(20)),
//           itemCount: 6, 
//           separatorBuilder: (context, index) => 
//             SizedBox(width: ScreenInfo.getAdaptiveValue(12)),
//           itemBuilder: (context, index) {
//             return categories[index];
//           }
//         ),
//       );
//   }
      
    
//   }




//

//
//
//
//
//
//
//
  
//
//
//
//
//
//
//
  


//
//
//
//
//
//
//
//
//
//
//

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
    
//
//
//
//