import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


Widget greenIntroWidget(){
  return Container(
    width: Get.width,
    decoration: const BoxDecoration(
        image:  DecorationImage(
            //background dri
            image: AssetImage('assets/mask.png'),
            fit: BoxFit.cover
        )
    ),
    height: Get.height*0.6,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            //logo dri alisdan
        SvgPicture.asset('assets/leaf icon.svg'),

        const SizedBox(
          height: 20,
        ),
        // PNG image with custom size
        Image.asset(
          'assets/omoda.png',
          width: 300.0, // Set desired width
          fit: BoxFit.contain, // Optional: fit style for how it scales
        ),
      ],
    ),
  );
}

Widget greenIntroWidgetWithoutLogos({String title = "Profile Settings",String? subtitle}){
  return Container(
    width: Get.width,
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mask.png'),
            fit: BoxFit.fill
        )
    ),
    height: Get.height*0.3,
    child: Container(
        height: Get.height*0.1,
        width: Get.width,
        margin: EdgeInsets.only(bottom: Get.height*0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
            if(subtitle != null) Text(subtitle,style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white),),

          ],
        )),

  );
}