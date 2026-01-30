import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/request_schemes.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/views/community_feed/community_feed.dart';
import 'package:flutter_application_1/views/forgot_password/forgot_password.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/views/reg/reg.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool badLoginPassword = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextFormField passwordTextFormField;
  late TextFormField emailTextFormField;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {


    super.initState();
    _emailController = TextEditingController();


    _passwordController = TextEditingController();
    _initializeWidgets();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Пожалуйста, введите почту.";
    }

    if (badLoginPassword) {
      return "Неверный логин или пароль!";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (badLoginPassword) {
      badLoginPassword = false;
      return "Неверный логин или пароль!";
    }

    if (value == null || value.isEmpty) {
      return "Пожалуйста, введите пароль.";
    }
    return null;
  }

  void _initializeWidgets() {
    passwordTextFormField = TextFormField(
      validator: (value) => validatePassword(value),
      controller: _passwordController,
      style: TextStyle(color: client.theme.getColor("text4")),
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        labelText: 'Пароль',
        prefixIcon: Icon(Icons.lock, size: 18, color: client.theme.getColor("iconInActive")),
        labelStyle: TextStyle(
          fontSize: 10,
          textBaseline: TextBaseline.alphabetic,
          color: client.theme.getColor("text2")
        )
      ),
    );

    emailTextFormField = TextFormField(
      validator: (value) => _validateEmail(value),
      controller: _emailController,
      style: TextStyle(
        color: client.theme.getColor("text4"),
        fontSize: ScreenInfo.getAdaptiveFontSize(14),
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenInfo.getAdaptiveValue(16),
          vertical: ScreenInfo.getAdaptiveValue(14),
        ),
        labelText: 'Почта',
        prefixIcon: Icon(
          Icons.email,
          size: ScreenInfo.getAdaptiveValue(18),
          color: client.theme.getColor("iconInActive")
        ),
        labelStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
          color: client.theme.getColor("text2")
        ),
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState!.validate() && !badLoginPassword) {
      bool status = await Server.login(UserLoginData(
        email: _emailController.text, 
        password: _passwordController.text
      ));

      if (!status) {
        badLoginPassword = true;
        _formKey.currentState?.validate();
        return;
      }

      ClientController.init();
      RoutingController.deltePreviousViewAndGoto(CommunityFeed(), context,  false);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: client.theme.getColor('bg2'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: ScreenInfo.screenWidth * ScreenInfo.getWidthFactor(),
                    constraints: BoxConstraints(maxWidth: 500),
                    margin: EdgeInsets.symmetric(
                      horizontal: ScreenInfo.getAdaptiveValue(16),
                      vertical: ScreenInfo.getAdaptiveValue(20),
                    ),
                    padding: EdgeInsets.all(ScreenInfo.getAdaptiveValue(20)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                      color: client.theme.getColor('bg'),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.door_front_door_sharp,
                                color: client.theme.getColor("text1"),
                                size: ScreenInfo.getAdaptiveValue(21),
                              ),
                              SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                              Text(
                                'Вход',
                                style: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                  
                                  fontWeight: FontWeight.bold,
                                  color: client.theme.getColor("heading"),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(30)),

                          Icon(
                            Icons.rocket_launch,
                            size: ScreenInfo.getAdaptiveValue(64),
                            color: client.theme.getColor("heading"),
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(10)),

                          Text(
                            'Давайте войдем!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ScreenInfo.getAdaptiveFontSize(24),
                              
                              fontWeight: FontWeight.bold,
                              color: client.theme.getColor("heading"),
                            ),
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(10)),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenInfo.getAdaptiveValue(10),
                            ),
                            child: Text(
                              'Чтобы войти в аккаунт, введите свою почту и пароль.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                
                                fontWeight: FontWeight.w200,
                                color: client.theme.getColor("text2"),
                              ),
                            ),
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(30)),

                          SizedBox(
                            width: double.infinity,
                            child: emailTextFormField,
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(30)),

                          SizedBox(
                            width: double.infinity,
                            child: passwordTextFormField,
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(15)),

                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  RoutingController.createRoute(ForgotPassword(), true)
                                );
                              },
                              child: Text(
                                'Забыли пароль?',
                                style: TextStyle(
                                  fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                  
                                  fontWeight: FontWeight.bold,
                                  color: client.theme.getColor("heading"),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(30)),

                          GestureDetector(
                            onTap: _validateAndSubmit,
                            child: Container(
                              width: double.infinity,
                              height: ScreenInfo.getAdaptiveValue(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                                color: Color.fromARGB(255, 66, 153, 162),
                              ),
                              child: Center(
                                child: Text(
                                  'Войти',
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                    
                                    color: client.theme.getColor("text3"),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(30)),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color.fromARGB(255, 207, 211, 214),
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenInfo.getAdaptiveValue(10),
                                ),
                                child: Text(
                                  "У вас нет аккаунта?",
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                    
                                    fontWeight: FontWeight.w200,
                                    color: Color.fromARGB(255, 153, 154, 158),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: client.theme.getColor("text2"),
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: ScreenInfo.getAdaptiveValue(15)),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                RoutingController.createRoute(
                                  
                                  Registration(),
                                  true,
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: ScreenInfo.getAdaptiveValue(50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                                color: client.theme.getColor("text2"),
                              ),
                              child: Center(
                                child: Text(
                                  'Создать аккаунт',
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                    
                                    color: client.theme.getColor("text3"),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
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