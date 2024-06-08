import 'package:flutter/material.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/user/common_user_drawer.dart';

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
      drawer: CommonUserDrawer(),
      body: Center(child: Text("Tobeto'ya Hoşgeldiniz")),
    );
  }
}
