import 'package:awkum_projects/Controllers/FormScreenController.dart';
import 'package:awkum_projects/pdfApi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Utilities.dart';


class AllRecords extends StatefulWidget {
  @override
  _AllRecordsState createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('usersRecords').snapshots();
  CollectionReference reference = FirebaseFirestore.instance.collection('usersRecords');
  TextEditingController searchController = TextEditingController();


  List lst = [];
  final utilities = Get.put(Utilities());

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('usersRecords')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          lst.add(doc.data());
        });
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          padding: const EdgeInsets.only(top: 30),
          onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.green,),),
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(top: 30),
          child: const Text(
            "All RECORDS",
            style: TextStyle(color: Colors.black,fontSize: 27),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              padding: const EdgeInsets.only(top: 30),
              onPressed: () async {
                final pdfFile = await PdfApi.generateCenteredText(lst);
                PdfApi.openFile(pdfFile);
              }, icon: const Icon(Icons.picture_as_pdf,color: Colors.green,))
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            utilities.myTextFieldForSearch(hintTxt: "Search here",controller: searchController),
            Expanded(
              child: Obx(() => StreamBuilder<QuerySnapshot>(
                stream: utilities.query.isEmpty ? FirebaseFirestore.instance
                    .collection("usersRecords")
                    .snapshots() :
                FirebaseFirestore.instance
                    .collection("usersRecords").where("descriptionForSearch",arrayContains: utilities.query.toString())
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<
                            String,
                            dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(top: 10,left: 20,bottom: 10,right: 10),
                          width: double.infinity,

                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Description. ${data["description"]}"),
                                    Text("Remarks. ${data["remarks"]}",),
                                    Text("Date. ${data["date"]}"),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(onTap: (){
                                    // reference.doc(data["id"]).delete();
                                    utilities.showDeleteDialog(id: data["id"],title: "DELETE",titleColor: Colors.red);
                                  }, child: const Text("Delete",style: TextStyle(color: Colors.red),)),
                                  SizedBox(height: 10,),
                                  InkWell(onTap: (){
                                    utilities.showUpdateDialog(
                                        title: "UPDATE",
                                        titleColor: Colors.green,
                                        description: data["description"],
                                        id: data["id"],
                                      remarks: data["remarks"]
                                    );
                                  }, child: const Text("Update",style: TextStyle(color: Colors.green),)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),)
            ),
          ],
        ),
      ),
    );
  }
}

