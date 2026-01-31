import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/client_controller.dart';
import 'package:flutter_application_1/utils/regex_validator.dart';
import 'package:flutter_application_1/utils/screen_info.dart';
import 'package:flutter_application_1/widgets/password_picker.dart';
import 'package:flutter_application_1/widgets/snils_picker.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailController;
  late TextEditingController _surnameController;
  late TextEditingController _snilsPickerController;
  late PasswordTextFormField passwordTextFormField;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _dateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _surnameController = TextEditingController();
    _snilsPickerController = TextEditingController();
    passwordTextFormField = PasswordTextFormField();
    
    
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

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      
      //Отправлять на сервер
      
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
                                        'Восстановление пароля',
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
                                  'Давайте Восстановим!',
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
                                    'Введите свою почту, фамилию, дату рождения и СНИЛС.',
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
                                
                                
                                
                                _buildTextField(
                                  label: 'Фамилия',
                                  icon: Icons.face,
                                  controller: _surnameController,
                                  validator: (value) => _validateRequired(value, 'фамилию'),
                                ),
                                
                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),
                                
                                
                                
                                SnilsPicker(
                                  focusNode: _dateFocusNode,
                                  controller: _snilsPickerController,
                                ),


                                SizedBox(height: ScreenInfo.getAdaptiveValue(20)),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenInfo.getAdaptiveValue(10),
                                  ),
                                  child: Text(
                                    'На этапе прототипа функция НЕ ДОСТУПНА.',
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
                                        'Восстановить пароль',
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

