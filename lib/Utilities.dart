import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controllers/FormScreenController.dart';

class Utilities extends GetxController{

  CollectionReference reference = FirebaseFirestore.instance.collection('usersRecords');
  var query = "".obs;
  var dt = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  Widget myTextField({String? hintTxt, TextEditingController? controller}){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "$hintTxt",
          ),
        ),
      ),
    );
  }

  Widget myTextFieldForSearch({String? hintTxt, TextEditingController? controller}){
    return Container(
      margin: const EdgeInsets.only(top: 20,right: 10,left: 10),
      padding: const EdgeInsets.only(right: 5,left: 20,top: 10,bottom: 10),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "$hintTxt",
            suffixIcon: IconButton(onPressed: (){query.value = "";controller!.clear();},icon: Icon(Icons.cancel,color: Colors.green,),)
          ),
          onChanged: (value){
            query.value = value;
          },
        ),
      ),
    );
  }

  Widget button({String? txt, VoidCallback? onPressed, Color? color}){
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: color.isNull ? Colors.green : color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text("$txt",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  progressInd(){
    return Container(
      width: 30,
        height: 30,
        child: Center(child: CircularProgressIndicator(color: Colors.green,)));
  }

  showSnackBar({String? title, String? description}){
    return Get.snackbar(
     margin: EdgeInsets.only(top: 20),
      colorText: Colors.white,
        backgroundColor: Colors.red.withOpacity(0.4),
        "$title", "$description"
    );
  }

  showSuccessSnackBar({String? title, String? description}){
    return Get.snackbar(
        margin: EdgeInsets.only(top: 20),
        colorText: Colors.black,
        backgroundColor: Colors.green.withOpacity(0.4),
        "$title", "$description");
  }

  showUpdateDialog({String? id, String? title, Color? titleColor,String? description, String? remarks}){
    return  Get.defaultDialog(
        backgroundColor: Colors.white,
        radius: 15,
        title: "$title",
        titlePadding: const EdgeInsets.only(top: 10),
        contentPadding: const EdgeInsets.all(15),
        titleStyle: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 25),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            myTextField(hintTxt: description,controller: descriptionController),
            myTextField(hintTxt: remarks,controller: remarksController),
            SizedBox(height: 20,),
            button(txt: "Save",onPressed: (){

              /// set list for searching
              int studentDescriptionCount = descriptionController.text.isEmpty ? description!.length : descriptionController.text.length;
              String? descriptionall = descriptionController.text.isEmpty ? description : descriptionController.text;
              List data = [];
              String temp = "";
              for(int i=0; i<studentDescriptionCount; i++){
                temp = temp + descriptionall![i].toLowerCase();
                data.add(temp);
              }

              reference.doc(id).update({
                "date": "${dt.day}/${dt.month}/${dt.year}--${dt.hour}:${dt.minute}:${dt.millisecond}",
                "description": descriptionController.text.isEmpty ? description : descriptionController.text,
                "remarks": remarksController.text.isEmpty ? remarks : remarksController.text,
                "descriptionForSearch" : data
              }).then((value){Get.back();}).catchError((onError){print(onError);});

            })
          ],
        ));
  }

  showDeleteDialog({String? id, String? title, Color? titleColor}){
    return  Get.defaultDialog(
        backgroundColor: Colors.white,
        radius: 15,
        title: "$title",
        titlePadding: const EdgeInsets.only(top: 10),
        contentPadding: const EdgeInsets.all(15),
        titleStyle: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 17),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            button(color: Colors.red,txt: "Delete",onPressed: (){
              reference.doc(id).delete().then((value){Get.back();}).catchError((onError){showSnackBar(title: "Error",description: onError);});

            }),
            const SizedBox(height: 20,),
            button(txt: "Cancel",onPressed: (){Get.back();})
          ],
        ));
  }

}