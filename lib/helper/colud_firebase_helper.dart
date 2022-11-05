import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFireStoreHelper{
  CloudFireStoreHelper._();

  static final CloudFireStoreHelper cloudFireStoreHelper = CloudFireStoreHelper._();

  static FirebaseFirestore firestore = FirebaseFirestore.instance;


  CollectionReference vot = FirebaseFirestore.instance.collection('voting');
 // CollectionReference Counter = FirebaseFirestore.instance.collection('counter');

  //TODO : insertData
  insertData({required String name,required String books})async{
    // await note.doc(id).set({'title' :title,'note': notes});
    await vot.doc().set({'name' :name,'books': books});

  }
  //TODO : fetchData
  Stream<QuerySnapshot> fetchData(){
      Stream<QuerySnapshot> stream = vot.snapshots();

      return stream;
   }
  updateData({required String id, required int voting}) async {
    await vot.doc(id).update({

      "vote": voting,
    });
  }
//TODO : deleteData
  deleteData({required id })async{
    await vot.doc(id).delete();


  }
}