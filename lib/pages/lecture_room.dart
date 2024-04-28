import 'package:dyte_uikit/dyte_uikit.dart';
import 'package:elms/pages/video_call.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/muted.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class LectureRoom extends StatelessWidget {

 LectureRoom({super.key});

  final meetingInfo = DyteMeetingInfoV2(
                    authToken: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IjFhNmVhYzljLTRlZWMtNGMyZC05NmVjLTE4YTA3NDVhMWI0NCIsIm1lZXRpbmdJZCI6ImJiYjdlZGQwLWM0ZjAtNDM1Yi05NmNlLWJjNzVlZjE4MjFjMCIsInBhcnRpY2lwYW50SWQiOiJhYWE2M2E2NC1lYjliLTRiOWItODBiZS0wYzExNDllN2RlOTYiLCJwcmVzZXRJZCI6IjIzNTY2OWNmLTlhZDYtNDU3OC1iM2I3LTMwNjE3YmVjZTNjOCIsImlhdCI6MTcxNDE5NzgzOCwiZXhwIjoxNzIyODM3ODM4fQ.SYNS8gmU_h5dLsFSADbi4YmzYDhm__T_4vw4GIXJi4Ymh1ttsakEIqYzTySW3rQz6WUTOOYo5k6F6h7IGvSOTi_oonnZpKsSuAgILX27Hys5brGTtUPfOzUbSbydaIbnCSEi5IRtBAsIq7ICmzHt5t66kTwUzbpvJNHiBOKzEZvFSK-OEHsnJ0GeK7r4XpiPeUhAZMyLYbE9hCyUWpLwOPVLjsNorjBq2xgPsLRxcUeS_kV-7t-ybaN_muTEFgfdWhuCt3rzmpn30Oi9QNMROQRv0c7CLfh-m24GYqYh9wNrjc1-Tcxa0UHip8Q3mSmhtQAQvrdll6c_SW51zeyIZA',
                    baseUrl: 'https://api.dyte.io/v2',      // optional argument, if you want to pass your own baseUrl
                    enableAudio: true,                     // optional argument, to enable or disable audio in the meeting
                    enableVideo: true,                     // optional argument, to enable or disable video in the meeting
                  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: defaultAppbar("Lecture Room"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const SizedBox(
            height: 10,
          ),
        Icon(ZondIcons.video_camera,color: Colors.orange[600],size: 50,),
         const SizedBox(height: 20,),
         mutedText("Welcome to live lecture room, join room by clicking the button below",textAlign: TextAlign.center),
         const SizedBox(height: 20,),
          customButton("Join room",onClick: (){
            final uikitInfo = DyteUIKitInfo(
                  meetingInfo,
                  designToken: DyteDesignTokens(
                    colorToken: DyteColorToken(
                      brandColor:AppColors.primaryColor,
                      backgroundColor: Colors.black,
                      textOnBackground: Colors.white,
                      textOnBrand: Colors.white,
                    ),
                  ),
                );

          final uiKit = DyteUIKitBuilder.build(uiKitInfo: uikitInfo);
          Get.to(()=>VideoCall(uiKit));
          })
        ]),
      ),
    );
  }
}
