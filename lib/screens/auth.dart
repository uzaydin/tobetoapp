import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:tobetoapp/screens/user/reset_password.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/common_drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/password_suffix_icon.dart';
import 'package:tobetoapp/widgets/validation_video_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final bool _isPasswordVisible = false;
  bool _isLoginPage = true;
  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  // ignore: unused_field
  String _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: const CommonAppBar(),
      drawer: const CommonDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 163, 77, 233),
                        blurRadius: 15.0,
                        spreadRadius: 3.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 190.0,
                        height: 100.0,
                        child: Image.asset(
                          'assets/logo/tobetologo.PNG',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Text(
                        "Hoşgeldiniz",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      ToggleSwitch(
                        minWidth: 150.0,
                        cornerRadius: 20.0,
                        activeBgColors: const [
                          [Color.fromARGB(255, 204, 160, 233)],
                          [Color.fromARGB(255, 204, 160, 233)]
                        ],
                        activeBgColor: const [Colors.white],
                        inactiveBgColor: Colors.grey[200],
                        inactiveFgColor: Colors.black,
                        initialLabelIndex: _isLoginPage ? 0 : 1,
                        totalSwitches: 2,
                        labels: const ["Giriş Yap", "Kayıt Ol"],
                        onToggle: (index) {
                          setState(() {
                            _isLoginPage = index == 0;
                          });
                        },
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "E-Posta",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validation(
                            value, "Lütfen bir e-posta adresi giriniz."),
                        onSaved: (newValue) {
                          _email = newValue!;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          suffixIcon: const PasswordSuffixIcon(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                        autocorrect: false,
                        obscureText: !_isPasswordVisible,
                        validator: (value) =>
                            validation(value, "Lütfen bir şifre giriniz"),
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });

                          if (!_isLoginPage) {
                            passNotifier.value =
                                PasswordStrength.calculate(text: value);
                          }
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _password = newValue!.trim();
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      if (!_isLoginPage)
                        PasswordStrengthChecker(strength: passNotifier),
                      const SizedBox(height: 20.0),
                      if (!_isLoginPage) ...[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Şifre Tekrar",
                            suffixIcon: const PasswordSuffixIcon(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                          ),
                          autocorrect: false,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Lütfen bir şifreyi doğrulayın";
                            }
                            if (value != _password) {
                              return "Şifreler eşleşmiyor";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _password = value.trim();
                            });
                          },
                          onSaved: (newValue) {
                            setState(() {
                              _confirmPassword = newValue!.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ad",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon:
                                const Icon(Icons.assignment_ind_rounded),
                          ),
                          autocorrect: false,
                          validator: (value) =>
                              validation(value, "Lütfen adınızı giriniz."),
                          onSaved: (newValue) {
                            _firstName = newValue!;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Soyad",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon:
                                const Icon(Icons.assignment_ind_rounded),
                          ),
                          autocorrect: false,
                          validator: (value) =>
                              validation(value, "Lütfen soyadınızı giriniz."),
                          onSaved: (newValue) {
                            _lastName = newValue!;
                          },
                        ),
                      ],
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // ...
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 163, 77, 233),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 15.0,
                            ),
                          ),
                          child: Text(
                            _isLoginPage ? "Giriş Yap" : "Kayıt Ol",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      if (_isLoginPage) ...[
                        GestureDetector(
                          onTap: () {
                            // google ile giriş yapma işlemleri
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 2,
                                width: 50,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 10),
                              const Text("Ya da"),
                              const SizedBox(width: 10),
                              Container(
                                height: 2,
                                width: 50,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (FaIcon(FontAwesomeIcons.google)),
                            SizedBox(width: 15),
                            Text("Google ile Giriş Yap"),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPassword()));
                          },
                          child: const Text("Şifremi Unuttum"),
                        ),
                      ],
                    ],
                  ),
                ),
                const CommonFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
