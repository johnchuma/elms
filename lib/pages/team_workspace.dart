import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/message_controller.dart';
import 'package:elms/pages/edit_user.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/time_ago.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class TeamWorkspace extends StatefulWidget {
  TeamWorkspace({super.key});

  @override
  State<TeamWorkspace> createState() => _TeamWorkspaceState();
}

class _TeamWorkspaceState extends State<TeamWorkspace> {
TextEditingController messsageController = TextEditingController();
GroupController groupController = Get.find();
ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: defaultAppbar("${groupController.selectedGroup.value?.name} Team Workspace"),
      body: GetX<MessageController>(
        init: MessageController(),
        builder: (find) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: ListView(
                       controller: scrollController,
                       reverse: true,
                        children: find.messages.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Builder(
                            builder: (context) {
                              bool isMe = e.userId == userController.loggedInAs!.id;
                              return Container(
                                width: MediaQuery.of(context).size.width -100,
                                child: Align(
                                  alignment: isMe?Alignment.centerRight:Alignment.centerLeft,
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: isMe?50:0,right: isMe?0:50),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            color: isMe?AppColors.primaryColor:Colors.grey.withOpacity(0.2),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  heading("@${e.userName}",fontSize: 13,color: isMe?Colors.white:textColor),
                                                  paragraph(e.message,color: isMe?Colors.white:textColor),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                    mutedText(timeAgo(e.createdAt.toDate()))
                                    
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        )).toList(),),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    left: 0,
                    child: TextFormField(
                      controller: messsageController,
                      decoration:  InputDecoration(hintText: "Send a message",
                       
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GestureDetector(
                          onTap: (){
                            find.addMessage(message: messsageController.text);
                              messsageController.text = "";
                          },
                          child: ClipOval(
                            child: Container(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              child: Icon(Icons.send)),
                          )),
                      )),))
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
