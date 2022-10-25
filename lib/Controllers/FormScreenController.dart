import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Utilities.dart';

class FormScreenController extends GetxController{

  CollectionReference users =
  FirebaseFirestore.instance.collection('usersRecords');
  final utilities = Utilities();
  var dt = DateTime.now();
  var progress = false.obs;

  Future<void> setUserData({String? description, String? remarks}){

    /// set list for searching
    int studentDescriptionCount = description!.length;
    List data = [];
    String temp = "";
    for(int i=0; i<studentDescriptionCount; i++){
      temp = temp + description[i].toLowerCase();
      data.add(temp);
    }

    progress.value = true;
    return users.add({
      "date": "${dt.day}/${dt.month}/${dt.year}--${dt.hour}:${dt.minute}:${dt.millisecond}",
      "description": description,
      "remarks": remarks,
      "descriptionForSearch" : data
    }).then((value){
      users.doc(value.id).update({"id" : value.id});
      utilities.showSuccessSnackBar(title: "Success",description: "Data Ad Successfully");
      progress.value = false;
    }).catchError((error){utilities.showSnackBar(title: "Error",description: error.toString());progress.value = false;});
  }

}