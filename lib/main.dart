import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/pages/home_page.dart';
import 'package:getx/utils.dart';

void main() async {
  await registerServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/home",
      routes: {
        "/home": (context) => const HomePage(),
      },
    );
  }
}
