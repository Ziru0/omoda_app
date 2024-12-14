import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omoda/controller/auth_controller.dart';
import 'package:omoda/tabpages/home_tab.dart';
import 'package:omoda/tabpages/profile_tab.dart';
import 'package:omoda/tabpages/profilepages/notifications.dart';
import 'package:omoda/views/homescreen.dart';
import 'package:omoda/views/login_screen.dart';
import 'package:omoda/views/mapexample.dart';
import 'package:omoda/views/menupages/ride_history.dart';
import 'package:omoda/views/otp_verification_screen.dart';
import 'package:omoda/views/profile_settings.dart';
import 'package:omoda/views/splass_screen/splashscreen.dart';
import 'firebase_options.dart';
void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    authController.decideRoute();
    final textTheme = Theme.of(context).textTheme;

    return  GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      home:     HomeScreen (),
    );
  }
}
