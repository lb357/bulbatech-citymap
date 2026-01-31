import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/views/community_feed/community_feed.dart';
import 'package:flutter_application_1/views/map/map.dart';
import 'package:flutter_application_1/views/my_tickets/my_tickets.dart';
import 'package:flutter_application_1/views/settings/settings.dart';

class SelectionMenu extends StatelessWidget {


  final int disabledButton;

  const SelectionMenu({
    super.key,
    required this.disabledButton
  });


    @override
    Widget build(BuildContext context) {
      return BottomAppBar(
        color: client.theme.getColor("bg"),
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: ScreenInfo.getAdaptiveValue(60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SelectionMenuButton(
                controller: this, 
                title: "Главная",
                icon: Icons.home_outlined,
                ind: 0,
                route: CommunityFeed()
              ),
              SelectionMenuButton(
                controller: this, 
                title: "Карта",
                icon: Icons.map,
                ind: 1,
                route: MapWidget(showTickets: true, showOnly: true)
              ),
              SelectionMenuButton(
                controller: this, 
                title: "Мои тикеты",
                icon: Icons.theaters,
                ind: 2,
                route: MyTickets()
              ),
              SelectionMenuButton(
                controller: this, 
                title: "Профиль",
                icon: Icons.person,
                ind: 3,
                route: Settings()
              ),
            ],
          ),
        ),
      );
    }
  }

class SelectionMenuButton extends StatelessWidget {

  final SelectionMenu controller;
  final String title;
  final IconData icon;
  final int ind;
  final Widget route;


  const SelectionMenuButton({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
    required this.ind,
    required this.route
  });

  @override
  Widget build(BuildContext context) {

    bool isActive = controller.disabledButton == ind;

    return Column(
      children: [
        
        IconButton(
          onPressed: ()=>{
            if(!isActive){
              RoutingController.deltePreviousViewAndGoto(route, context, false)
            }
          },
          icon: Icon(icon),
          color: (isActive) ? client.theme.getColor("iconActive") : client.theme.getColor("iconInActive"),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Eloqia',
            fontWeight: FontWeight.w200,
            color: (isActive)? Color.fromARGB(255, 66, 153, 162) : client.theme.getColor("selectionMenuText"),
            ),  
          ),
      ],
    );
  }
}


