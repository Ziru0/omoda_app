import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omoda/controller/auth_controller.dart';
import 'package:omoda/widgets/green_Intro_Widget.dart';

import '../utils/app_colors.dart';
import '../widgets/otp_verification_widget.dart';

class OtpVerificationScreen extends StatefulWidget {

  String phoneNumber;
  OtpVerificationScreen(this.phoneNumber);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {


  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.phoneAuth(widget.phoneNumber);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              children: [
                greenIntroWidget(),

                Positioned(
                  top: 70,
                  left: 20,
                  child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      //ang arrow
                      child: const Icon(Icons.arrow_back, color: AppColors.greenColor,size: 20,),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(
              height: 50,
            ),

            otpVerificationWidget()

          ],
        ),
      ),
    );
  }
}
