import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/regex_validator.dart';
import 'package:flutter_application_1/utils/request_schemes.dart';
import 'package:flutter_application_1/utils/routing_controller.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/utils/server.dart';
import 'package:flutter_application_1/views/community_feed/community_feed.dart';
import 'package:flutter_application_1/widgets/password_picker.dart';
import 'package:flutter_application_1/widgets/birthday_picker.dart';
import 'package:flutter_application_1/widgets/snils_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late TextEditingController _emailController;
  late TextEditingController _birthDayPickerController;
  late TextEditingController _passwordController;
  late TextEditingController _snilsPickerController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _patronymicController;
  late PasswordTextFormField passwordTextFormField;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _snilsFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController= TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _surnameController = TextEditingController();
    _patronymicController = TextEditingController();
    _birthDayPickerController = TextEditingController();
    _snilsPickerController = TextEditingController();
    passwordTextFormField = PasswordTextFormField(controller: _passwordController);
    
    _dateFocusNode.addListener(() {
      if (_dateFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Scrollable.ensureVisible(
            _dateFocusNode.context!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    FocusNode? focusNode,
    bool isOptional = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
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
        labelText: isOptional ? '$label (Необязательно)' : label,
        prefixIcon: Icon(
          icon,
          size: ScreenInfo.getAdaptiveValue(18),
          color: client.theme.getColor("iconInActive"),
        ),
        labelStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
          color: client.theme.getColor("text2"),
        ),
        errorStyle: TextStyle(
          fontSize: ScreenInfo.getAdaptiveFontSize(10),
        ),
      ),
    );
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      
      bool status = await Server.register(UserRegisterData(
        email: _emailController.text, 
        password: _passwordController.text,
        patronymic: _patronymicController.text,
        snils: _snilsPickerController.text,
        birthday: _birthDayPickerController.text,
        name: _nameController.text,
        surname: _surnameController.text
      ));

      if(status){
        ClientController.init();
        RoutingController.deltePreviousViewAndGoto(CommunityFeed(), context,  false);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите email';
    }
    if (!RegexValidator.isEmail(value)) {
      return 'Введите корректный email';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: client.theme.getColor("bg2"),
      body: SafeArea(
        bottom: false, 
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          
                          Container(
                            width: ScreenInfo.screenWidth * ScreenInfo.getWidthFactor(),
                            constraints: BoxConstraints(
                              maxWidth: 500,
                              minHeight: constraints.maxHeight * 0.9,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenInfo.getAdaptiveValue(16),
                              vertical: ScreenInfo.getAdaptiveValue(20),
                            ),
                            padding: EdgeInsets.all(ScreenInfo.getAdaptiveValue(20)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                              color: client.theme.getColor("bg"),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: ScreenInfo.getAdaptiveValue(24),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: client.theme.getColor("heading"),
                                    ),
                                    SizedBox(width: ScreenInfo.getAdaptiveValue(8)),
                                    Expanded(
                                      child: Text(
                                        'Создание аккаунта',
                                        style: TextStyle(
                                          fontSize: ScreenInfo.getAdaptiveFontSize(16),
                                          fontFamily: 'Eloqia',
                                          fontWeight: FontWeight.bold,
                                          color: client.theme.getColor("heading"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                Icon(
                                  Icons.rocket_launch,
                                  size: ScreenInfo.getAdaptiveValue(64),
                                  color: client.theme.getColor("heading"),
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(10)),
                                
                                
                                Text(
                                  'Давайте Начнем!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ScreenInfo.getAdaptiveFontSize(24),
                                    fontFamily: 'Eloqia',
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
                                    'Введите свою почту, имя, фамилию, дату рождения, СНИЛС и придумайте пароль.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                      fontFamily: 'Eloqia',
                                      fontWeight: FontWeight.w200,
                                      color: client.theme.getColor("text2"),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                                
                                
                                _buildTextField(
                                  label: 'Почта',
                                  icon: Icons.email,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                passwordTextFormField,
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                _buildTextField(
                                  label: 'Имя',
                                  icon: Icons.face,
                                  controller: _nameController,
                                  validator: (value) => _validateRequired(value, 'имя'),
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                _buildTextField(
                                  label: 'Фамилия',
                                  icon: Icons.face,
                                  controller: _surnameController,
                                  validator: (value) => _validateRequired(value, 'фамилию'),
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                _buildTextField(
                                  label: 'Отчество',
                                  icon: Icons.face,
                                  controller: _patronymicController,
                                  isOptional: true,
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                BirthDayPicker(
                                  focusNode: _dateFocusNode,
                                  controller: _birthDayPickerController,
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(30)),

                                SnilsPicker(
                                  focusNode: _snilsFocusNode,
                                  controller: _snilsPickerController,
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(30)),
                                
                                
                                GestureDetector(
                                  onTap: _validateAndSubmit,
                                  child: Container(
                                    width: double.infinity,
                                    height: ScreenInfo.getAdaptiveValue(50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(ScreenInfo.getAdaptiveValue(20)),
                                      color: const Color.fromARGB(255, 66, 153, 162),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Создать аккаунт',
                                        style: TextStyle(
                                          fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                          fontFamily: 'Eloqia',
                                          color: client.theme.getColor("text3"),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(10)),
                                GestureDetector(
                                  onTap: () {
                                    launchUrlString(Server.connectUrl + "/legal");
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenInfo.getAdaptiveValue(10),
                                    ),
                                    child: Text(
                                      'Создавая аккаунт и пользуясь настоящим сервисом, вы выражаете согласие с правилами пользования сервисом и политикой обработки персональных данных',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ScreenInfo.getAdaptiveFontSize(14),
                                        fontFamily: 'Eloqia',
                                        fontWeight: FontWeight.w200,
                                        color: client.theme.getColor("text2"),
                                        decoration: TextDecoration.underline,
                                        decorationColor: client.theme.getColor("text2"),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

