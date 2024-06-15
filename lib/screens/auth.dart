import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/screens/user/platform.dart';
import 'package:tobetoapp/screens/user/reset_password.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/password_suffix_icon.dart';
import 'package:tobetoapp/widgets/validation_video_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isPasswordVisible = false;
  bool _isLoginPage = true;
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _lastName.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: const DrawerManager(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );
            //Navigator.of(context).pop();
          } else if (state is AuthFailure) {
            print("Giriş Denemesi: $state");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Giriş yapılamadı: ${state.message}")),
            );
            Navigator.of(context).pop();
          } else if (state is AuthSuccess) {
            context.read<AuthProviderDrawer>().login();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Platform(),
                ));
          } else if (state is Unauthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Auth(),
            ));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingXLarge,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                OutlineGradientButton(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  strokeWidth: 3,
                  radius: Radius.circular(AppConstants.br30),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.tobetoMoru,
                      Color.fromARGB(209, 255, 255, 255),
                      Color.fromARGB(178, 255, 255, 255),
                      AppColors.tobetoMoru,
                    ],
                    stops: [0.0, 0.5, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      SizedBox(
                        width: AppConstants.screenWidth * 0.6,
                        height: AppConstants.screenHeight * 0.1,
                        child: Image.asset(
                          'assets/logo/tobetologo.PNG',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      Text("Hoşgeldiniz",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.w300)),
                      SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                      ToggleSwitch(
                        minWidth: AppConstants.screenWidth * 0.35,
                        minHeight: AppConstants.screenHeight * 0.08,
                        cornerRadius: AppConstants.br30,
                        activeBgColors: const [
                          [Color.fromARGB(255, 120, 98, 180)],
                          [Color.fromARGB(255, 120, 98, 180)]
                        ],
                        activeBgColor: const [Colors.white],
                        inactiveBgColor: Colors.grey[200],
                        inactiveFgColor:
                            const Color.fromARGB(255, 120, 98, 180),
                        initialLabelIndex: _isLoginPage ? 0 : 1,
                        totalSwitches: 2,
                        labels: const ["Giriş Yap", "Kayıt Ol"],
                        onToggle: (index) {
                          setState(() {
                            _isLoginPage = index == 0;
                          });
                        },
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: "E-Posta",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.br20),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validation(
                            value, "Lütfen bir e-posta adresi giriniz."),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          suffixIcon: PasswordSuffixIcon(
                            isPasswordVisible: _isPasswordVisible,
                            onToggleVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.br20),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                        autocorrect: false,
                        obscureText: !_isPasswordVisible,
                        validator: (value) =>
                            validation(value, "Lütfen bir şifre giriniz"),
                        onChanged: (value) {
                          setState(() {
                            _password.text = value.trim();
                          });
                          /*
                        if (!_isLoginPage) {
                          passNotifier.value =
                              PasswordStrength.calculate(text: value);
                        }
                      },                                      
                       */
                        },
                      ),
                      //SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      //if (!_isLoginPage)
                      //PasswordStrengthChecker(strength: passNotifier),

                      SizedBox(height: AppConstants.sizedBoxHeightMedium),

                      if (!_isLoginPage) ...[
                        TextFormField(
                          controller: _confirmPassword,
                          decoration: InputDecoration(
                            labelText: "Şifre Tekrar",
                            suffixIcon: PasswordSuffixIcon(
                              isPasswordVisible: _isPasswordVisible,
                              onToggleVisibility: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.br20),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                          ),
                          autocorrect: false,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Lütfen bir şifreyi doğrulayın";
                            }
                            if (value != _password.text) {
                              return "Şifreler eşleşmiyor";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: "Ad",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.br20),
                            ),
                            prefixIcon:
                                const Icon(Icons.assignment_ind_rounded),
                          ),
                          autocorrect: false,
                          validator: (value) =>
                              validation(value, "Lütfen adınızı giriniz."),
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Soyad",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.br20),
                            ),
                            prefixIcon:
                                const Icon(Icons.assignment_ind_rounded),
                          ),
                          autocorrect: false,
                          validator: (value) =>
                              validation(value, "Lütfen soyadınızı giriniz."),
                        ),
                      ],
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tobetoMoru,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.br20),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.screenWidth * 0.2,
                              vertical: AppConstants.screenHeight * 0.025,
                            ),
                          ),
                          child: Text(
                            _isLoginPage ? "Giriş Yap" : "Kayıt Ol",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      if (_isLoginPage) ...[
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(AuthGoogleSignIn());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 2,
                                width: 50,
                                color: Colors.black,
                              ),
                              SizedBox(width: AppConstants.sizedBoxWidthSmall),
                              const Text("Ya da"),
                              SizedBox(width: AppConstants.sizedBoxWidthSmall),
                              Container(
                                height: 2,
                                width: 50,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (const FaIcon(FontAwesomeIcons.google)),
                            SizedBox(width: AppConstants.sizedBoxWidthMedium),
                            const Text("Google ile Giriş Yap"),
                          ],
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
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
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                const CommonFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isLoginPage) {
        _login();
      } else {
        _signUp();
      }
    }
  }

  void _login() {
    context
        .read<AuthBloc>()
        .add(AuthLogin(email: _email.text, password: _password.text));
  }

  void _signUp() {
    context.read<AuthBloc>().add(AuthSignUp(
        name: _name.text,
        lastName: _lastName.text,
        email: _email.text,
        password: _password.text));
  }
}
