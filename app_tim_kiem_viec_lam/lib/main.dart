import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'core/providers/app.provider.dart';
import 'core/routes/routes.dart';

void main() {
  runApp(Core());
}

class Core extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: MotChill(),
    );
  }
}

class MotChill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SplashRoutes,
      // color: HexColor("#B1B6B7"),
      theme: ThemeData.light(),
      routes: AppRoutes.routes,
    );
  }
}
