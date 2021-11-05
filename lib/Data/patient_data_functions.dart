//A file made to facilitate certain actions performed to get data from PatientData
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final patientData = FirebaseFirestore.instance.collection('patientData');

class Datafunction {
  String uid;

  Datafunction(this.uid);

  Future<List?> getAmount(int amount, String subcollection) async {
    //function designed to get the required amount of values from a certain subcollection in order from most recent to oldest
    var list = <String>[];
    CollectionReference subcol = patientData.doc(uid).collection(subcollection);
    DocumentSnapshot snap = await subcol.doc('Last 100 Recordings').get();
    int remainder;
    if (snap.exists) {
      //if the user has a last 100 Recordings document, get the maximum amount of recordings from the document that you can
      int size = snap.get('Data Entries').toInt();
      remainder = amount - size;
      if (remainder < 1) {
        //if the last 100 Recordings has more recordings than the amount specified, get the amount of recordings
        for (int i = size - amount + 1; i < size + 1; i++) {
          if (i < 10) {
            list.add(snap.get('Data Submission 0$i'));
          } else {
            list.add(snap.get('Data Submission $i'));
          }
        }
        return list;
      } else {
        var listtoadd = await getAmountHundreds(remainder,
            subcollection); //create a list to add the remaining recordings
        if (listtoadd != null) {
          for (int i = 0; i < listtoadd.length; i++) {
            //add the remaining recordings to the list
            list.add(listtoadd[i]);
          }
        }
        for (int i = 1; i < size + 1; i++) {
          if (i < 10) {
            list.add(snap.get('Data Submission 0$i'));
          } else {
            list.add(snap.get('Data Submission $i'));
          }
        }
        return list;
      }
    } else {
      return getAmountHundreds(amount, subcollection);
    }
  }

  Future<List?> getAmountHundreds(int amount, String subcollection) async {
    //function designed to get a certain amount of recordings from a collection that has no last 100 recordings in order from newest to oldest
    var list = <String>[];
    CollectionReference subcol = patientData.doc(uid).collection(subcollection);
    DocumentSnapshot collectionsnap = await patientData.doc(uid).get();
    if (collectionsnap.exists) {
      num hundreds = collectionsnap.get("$subcollection Recordings (hundreds)");
      if (hundreds > 0) {
        //if the user has atleast 100 recordings stored, go get their most recent hundred documents
        num bottom = (hundreds - 1) * 100;
        num top = hundreds * 100;
        String document =
            bottom.toString() + "~" + top.toString() + " Recordings";
        DocumentSnapshot hundredsnap = await subcol.doc(document).get();
        int size = hundredsnap
            .get('Data Entries')
            .toInt(); //just incase the '100' submissions are less than 100 recordings take the size
        for (int i = size - amount + 1; i < size + 1; i++) {
          if (i < 10) {
            list.add(hundredsnap.get('Data Submission 0$i'));
          } else {
            list.add(hundredsnap.get('Data Submission $i'));
          }
        }
        return list;
      } else {
        //if they have less than 100 recordings and no recent recordings return null
        return null;
      }
    } else {
      // if this patient does not have a patientData document, return null
      return null;
    }
  }
}
