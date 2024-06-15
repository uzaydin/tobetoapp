import 'package:flutter/material.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';

// kullanıcı giriş yapınca yönlendirilen anasayfa

class Platform extends StatefulWidget {
  const Platform({super.key});

  @override
  State<Platform> createState() => _PlatformState();
}

class _PlatformState extends State<Platform> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(),
      drawer: DrawerManager(),
      body: Center(child: Text("Tobeto'ya Hoşgeldiniz")),
    );
  }
}
