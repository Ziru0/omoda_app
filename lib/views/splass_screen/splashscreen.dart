import 'dart:async';

import 'package:flutter/material.dart';

import '../../tabpages/home_tab.dart';
import '../login_screen.dart';

// import 'package:omograb_app/authentication/signup_screen.dart';
// import 'package:omograb_app/mainScreens/main_screen.dart';

class MySplashScreen extends StatefulWidget
{
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen>
{

  startTimer()
  {
    Timer(const Duration(seconds: 8), () async {
      //send user to main screen
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeTabPage()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset("assets/omoda1.png"),

              const Text(
                  "Stay road-ready we take care of your ride",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
