import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:getx_state_mgmt/pages/home_page.dart';
import 'package:getx_state_mgmt/utils.dart';
import 'package:google_fonts/google_fonts.dart';

void main(List<String> args) async {
  await dotenv.load(fileName: ".env");
  await registerServices();
  await registerControllers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => HomePage(),
      },
      initialRoute: "/home",
    );
  }
}
