import 'package:awkum_projects/Controllers/FormScreenController.dart';
import 'package:awkum_projects/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AllRecords.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  final formScreenController = Get.put(FormScreenController());
  final utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          Get.to(()=>AllRecords());
        },
        child: const Center(child: Icon(Icons.all_inbox,color: Colors.white,),),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          margin: EdgeInsets.only(top: 30),
          child: const Text(
            "USER DATA",
            style: TextStyle(color: Colors.black,fontSize: 27),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              utilities.myTextField(hintTxt: "Enter Description",controller: descriptionController),
              utilities.myTextField(hintTxt: "Enter Remarks",controller: remarksController),
              const SizedBox(
                height: 30,
              ),
              Obx(() => formScreenController.progress == true ? utilities.progressInd() : utilities.button(
                  txt: "Save",
                  onPressed: () {
                    if(checkFields() == "ok"){
                      var result = formScreenController.setUserData(description: descriptionController.text, remarks: remarksController.text);
                      if(!result.isNull){
                        descriptionController.clear();
                        remarksController.clear();
                      }
                    }
                  }),),
            ],
          ),
        ),
      ),
    );
  }

  checkFields() {
    if (descriptionController.text.isEmpty) {
      utilities.showSnackBar(title: "Error",description: "Enter description");
    } else {
      if(remarksController.text.isEmpty){
        utilities.showSnackBar(title: "Error",description: "Enter Remarks");
      }else{
        return "ok";
      }
    }
  }

}
