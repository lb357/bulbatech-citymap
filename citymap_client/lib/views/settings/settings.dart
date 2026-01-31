import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:flutter_application_1/views/login/widgets/selection_menu.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SelectionMenu(disabledButton: 3),
      backgroundColor: client.theme.getColor("bg2"),
      body: SafeArea(
          child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                          width: ScreenInfo.screenWidth * ScreenInfo.getWidthFactor(),
                          constraints: BoxConstraints(
                            maxWidth: 500, 
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenInfo.getAdaptiveValue(16),
                            vertical: ScreenInfo.getAdaptiveValue(32),
                          ),
                          padding: EdgeInsets.all(ScreenInfo.getAdaptiveValue(20)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                            color: client.theme.getColor('bg'),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: client.theme.getColor("text1"),
                                    size: ScreenInfo.getAdaptiveValue(21),
                                  ),
                                  SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                                  Text(
                                    'Профиль',
                                    style: TextStyle(
                                      fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                      fontFamily: 'Eloqia',
                                      fontWeight: FontWeight.bold,
                                      color: client.theme.getColor("heading"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                                            
                              Text(
                                "${client.firstname} ${client.lastname} ${client.patronymic}",
                                style: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveFontSize(18),     
                                  fontFamily: 'Eloqia',
                                  fontWeight: FontWeight.bold,
                                  color: client.theme.getColor("text4")
                                )
                              ),
                              SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                              Padding(
                                padding: EdgeInsets.only(right: ScreenInfo.getAdaptiveValue(200)),
                                child: Text(
                                  "Личные данные",
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(14),     
                                    fontFamily: 'Eloqia',
                                    fontWeight: FontWeight.bold,
                                    color: client.theme.getColor("text2")
                                  )
                                )
                              ),
                              SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                                            
                              SizedBox(
                                width: ScreenInfo.getAdaptiveValue(350),
                                height: ScreenInfo.getAdaptiveValue(50),
                                child: TextFormField(
                                  style: TextStyle(color: client.theme.getColor("text4")),
                                  initialValue: client.birthdate,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    labelText: 'Дата рождения',
                                    prefixIcon: Icon(Icons.calendar_month, color: client.theme.getColor("iconInActive")),
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      textBaseline: TextBaseline.alphabetic,
                                      color: client.theme.getColor("text1")
                                    )
                                  ),
                                )
                              ),
                              SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                              SizedBox(
                                width: ScreenInfo.getAdaptiveValue(350),
                                height: ScreenInfo.getAdaptiveValue(50),
                                child: TextFormField(
                                  style: TextStyle(color: client.theme.getColor("text4")),
                                  initialValue: client.snils,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    labelText: "СНИЛС",
                                    prefixIcon: Icon(Icons.article, color: client.theme.getColor("iconInActive")),
                                    labelStyle: TextStyle(
                                      fontSize: 13,
                                      textBaseline: TextBaseline.alphabetic,
                                      color: client.theme.getColor("text1")
                                    )
                      
                                  ),
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenInfo.getAdaptiveValue(50), right: ScreenInfo.getAdaptiveValue(225)),
                                child: Text(
                                  "Параметры",
                                  style: TextStyle(
                                    fontSize: 14,     
                                    fontFamily: 'Eloqia',
                                    fontWeight: FontWeight.bold,
                                    color: client.theme.getColor("text2")
                                  )
                                ),
                              ),
                              
                              SizedBox(
                                width: ScreenInfo.screenWidth * 0.9,
                                height: ScreenInfo.screenHeight * 0.08,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color.fromARGB(255, 240, 253, 250)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Icon(
                                          Icons.shield_rounded,
                                          size: ScreenInfo.getAdaptiveValue(20),
                                          color: client.theme.getColor("iconActive")
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: ScreenInfo.getAdaptiveValue(14)),
                                      child: Text(
                                        'Политика конфиденциальности',
                                        style: TextStyle(
                                          fontSize: ScreenInfo.getAdaptiveFontSize(14),     
                                          fontFamily: 'Eloqia',
                                          fontWeight: FontWeight.bold,
                                          color: client.theme.getColor("text4")
                                        )
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(//to do - изменить на IconButton() и добавить функц.
                                      Icons.arrow_forward_ios_rounded,
                                      color: client.theme.getColor("text4"),
                                      size:  ScreenInfo.getAdaptiveValue(24)
                                    )
                                    
                                  ],
                                )
                              ),
                              SizedBox(
                                width: ScreenInfo.screenWidth * 0.9,
                                height: ScreenInfo.screenHeight * 0.08,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color.fromARGB(255, 240, 253, 250)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Icon(
                                          Icons.dark_mode,
                                          size: ScreenInfo.getAdaptiveValue(20),
                                          color: client.theme.getColor("iconActive")
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: ScreenInfo.getAdaptiveValue(14)),
                                      child: Text(
                                        'Тёмная тема',
                                        style: TextStyle(
                                          fontSize:  ScreenInfo.getAdaptiveFontSize(14),     
                                          fontFamily: 'Eloqia',
                                          fontWeight: FontWeight.bold,
                                          color: client.theme.getColor("text4")
                                        )
                                      ),
                                    ),
                                    Spacer(),
                                    Transform.scale(
                                      scale:  ScreenInfo.getAdaptiveFontSize(0.65),
                                      child: Switch(
                                        value: client.theme.dark,
                                        onChanged: (_) =>setState(() {
                                          client.theme.dark = !client.theme.dark;
                                          
                                        }),
                                        activeTrackColor: Color.fromARGB(255, 17, 94, 89),
                                        
                                      ),
                                    ),
                                                        
                                  ],
                                )
                              ),
                              SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                              Container(
                                height: ScreenInfo.screenHeight * 0.0015,
                                width: ScreenInfo.screenWidth * 0.8,
                                color: Color.fromARGB(255, 243, 243, 245)
                              ),
                              SizedBox(height:ScreenInfo.getAdaptiveValue(30)),
                              GestureDetector(
                                onTap:() => {
                                  Server.clearAllCookies(),
                                  Navigator.pop(context),
                                  Navigator.push(context, RoutingController.createRoute(Login(), true))
                                },
                                child: Container(
                                  width: ScreenInfo.getAdaptiveValue(315),
                                  height: ScreenInfo.getAdaptiveValue(75),
                                  decoration: BoxDecoration(
                                    color: client.theme.getColor("text2"),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        color: client.theme.getColor("text3"),
                                        size: ((ScreenInfo.screenHeight + ScreenInfo.screenWidth)/2) * 0.03
                                      ),
                                      SizedBox(width: ScreenInfo.screenWidth * 0.01),
                                      Text(
                                        "Выйти из аккаунта",
                                        style: TextStyle(
                                          fontSize: ScreenInfo.getAdaptiveFontSize(14), 
                                          color: client.theme.getColor("text3"), 
                                          fontFamily: 'Eloqia',
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            ],
                          )
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