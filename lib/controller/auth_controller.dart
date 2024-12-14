import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:omoda/views/profile_settings.dart';

import '../views/homescreen.dart';

class AuthController extends GetxController {
  var userUid = ''.obs;
  var verId = ''.obs;
  var resendTokenId = 0.obs;
  var phoneAuthCheck = false.obs;
  dynamic credentials;
  var isProfileUploading = false.obs;

  get myUser => null;

   phoneAuth(String phone) async {
    try {
      credentials = null;
      phoneAuthCheck.value = true;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Verification completed');
          credentials = credential;
          userUid.value = (await FirebaseAuth.instance.signInWithCredential(credential)).user?.uid ?? '';
          phoneAuthCheck.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          log('Verification failed');
          phoneAuthCheck.value = false;
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          } else {
            debugPrint('Verification failed: ${e.message}');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent to $phone');
          verId.value = verificationId;
          resendTokenId.value = resendToken ?? 0;
          phoneAuthCheck.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('Auto retrieval timeout');
          verId.value = verificationId;
        },
        forceResendingToken: resendTokenId.value,
      );
    } catch (e) {
      log("Error occurred: $e");
      phoneAuthCheck.value = false;
    }
  }

   verifyOtp(String otpNumber) async {
    try {
      log("Verifying OTP");
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
        verificationId: verId.value,
        smsCode: otpNumber,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      userUid.value = userCredential.user?.uid ?? '';
      log("Logged in successfully with UID: ${userUid.value}");
    } catch (e) {
      log("Error in OTP verification: $e");
    }
  }



  decideRoute() {
    ///step 1- Check user login?
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      /// step 2- Check whether user profile exists?

      ///isLoginAsDriver == true means navigate it to the driver module

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {

        ///isLoginAsDriver == true means navigate it to driver module

          if (value.exists) {
            Get.to(() => const ProfileSettingScreen());
          } else {
            Get.to(() => const ProfileSettingScreen());
          }

      });
    }
  }

}
