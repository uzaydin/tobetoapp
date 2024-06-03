import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/screens/mainpage.dart';
import 'package:tobetoapp/screens/password_reset.dart';


class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({super.key});

  @override
  State<LoginOrSignUp> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool _registerPage = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _lastName.dispose();
    super.dispose();
  }

  void _submit() {
    _registerPage ? _signUp() : _login();
  }

  void _signUp() {
    context.read<AuthBloc>().add(AuthSignUp(
        name: _name.text,
        lastName: _lastName.text,
        email: _email.text,
        password: _password.text));
  }

  void _login() {
    context
        .read<AuthBloc>()
        .add(AuthLogin(email: _email.text, password: _password.text));
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Gösterge göster
            showDialog(
              context: context,
              builder: (context) => Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );
            Navigator.of(context).pop();
          }
          if (state is AuthFailure) {
            print("GIRIS DENEMESSSSSSSSII : $state");
            // Hata mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Giriş yapılamadı: ${state.message}")),
            );
            Navigator.of(context).pop();
          }
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
          }
          if (state is Unauthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginOrSignUp(),
            ));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  SvgPicture.network('https://tobeto.com/_next/static/media/tobeto-logo.29b55e1c.svg', height: 100), // Logo ekleyin
                  SizedBox(height: 20),
                  Text(
                    "Hoşgeldiniz",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildToggleButton(),
                  SizedBox(height: 20),
                  _buildForm(),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                  Text("Ya da"),
                  SizedBox(height: 20),
                  _buildGoogleSignInButton(), // Google kayit butonu
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage(),));
                    },
                    child: Text(
                      "Şifremi Unuttum",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _registerPage = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: !_registerPage ? Colors.grey.shade200 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Giriş Yap",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !_registerPage ? Colors.purple : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _registerPage = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: _registerPage ? Colors.grey.shade200 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Kayıt Ol",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _registerPage ? Colors.purple : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        if (_registerPage)
          Column(
            children: [
              _buildTextField(_name, Icons.person, "Ad"),
              SizedBox(height: 10),
              _buildTextField(_lastName, Icons.person, "Soyad"),
              SizedBox(height: 10),
            ],
          ),
        _buildTextField(_email, Icons.email, "E-Posta Adresi"),
        SizedBox(height: 10),
        _buildTextField(_password, Icons.lock, "Şifre", obscureText: true),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hintText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        _registerPage ? "Kayıt Ol" : "Giriş Yap",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: (){context.read<AuthBloc>().add(AuthGoogleSignIn());},
      //icon: Image.asset("lib/images/google.png"),
      label: Text("Google ile Giriş Yap"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(color: Colors.grey),
      ),
    );
  }
}
