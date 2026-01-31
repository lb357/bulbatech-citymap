import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/community_feed/community_feed.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ru_RU", null);

  await Server.init();


  if(await ClientController.init()){

    runApp(const MainApp(homeView: CommunityFeed()));

  }else{
    runApp(const MainApp());

  }
}

class MainApp extends StatelessWidget {

  final Widget? homeView;

  const MainApp(
    {
      super.key,
      this.homeView
    }
  );

  @override
  Widget build(BuildContext context) {
    ScreenInfo.init(context);
    return MaterialApp(
      color: client.theme.getColor('bg2'),
      debugShowCheckedModeBanner: false,
      title : "Активный гражданин",
      home: homeView ?? Login()
    );
  }

}