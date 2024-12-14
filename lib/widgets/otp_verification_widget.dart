import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omoda/utils/app_constants.dart';
import 'package:omoda/views/otp_verification_screen.dart';
import 'package:omoda/widgets/pinput_widget.dart';
import 'package:omoda/widgets/text_widget.dart';
import 'package:google_fonts/google_fonts.dart';

Widget otpVerificationWidget(){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Column(
      crossAxisAlignment:  CrossAxisAlignment.start,

      children: <Widget>[
        textWidget (text: AppConstants.phoneVerification),
        textWidget (text: AppConstants.enterOtp,fontSize: 24, fontWeight: FontWeight.bold),

        const SizedBox(
          height: 40,
        ),


        Container(

            width: Get.width,
            height: 70,
            child: RoundedWithShadow()),

        const SizedBox(
          height: 40,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 12),
                children: [
                  const TextSpan(
                    text: "${AppConstants.resendCode} " ,
                  ),

                  TextSpan(
                      text: " 10 seconds",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                  ),

                ]
            ),
          ),
        ),

      ],
    ),
  );
}