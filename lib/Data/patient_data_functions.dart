//A file made to facilitate certain actions performed to get data from PatientData
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final patientData = FirebaseFirestore.instance.collection('patientData');

class Datafunction {
  String uid;

  Datafunction(this.uid);

  String getbgFormat() {
    return 'MG,MMOL,-date';
  }

  String getbpFormat() {
    return 'systolic,diastolic,-date';
  }

  String gethrFormat() {
    return 'heartRate,-date';
  }

  Future<int> getSize(String subcollection) async {
    //returns the size of the specified subcollection
    CollectionReference subcol = patientData.doc(uid).collection(subcollection);
    DocumentSnapshot snap = await subcol.doc('Last 100 Recordings').get();
    int lasthundred = 0;
    int hundreds = 0;
    if (snap.exists) {
      //if Last 100 Recordings doesn't exist, there will be no Recordings (hundreds)
      lasthundred = snap.get('Data Entries').toInt();
      DocumentSnapshot docsnap = await patientData.doc(uid).get();
      if (docsnap.exists) {
        hundreds = docsnap.get("$subcollection Recordings (hundreds)").toInt();
      }
    }
    return lasthundred +
        hundreds *
            99; //99 recordings for each hundred, and add the amount in the last 100 recordings
  }

  // Future<List?> getFromDates (String date1, String date2) async { //returns a list of all values between two specific dates

  // }

  Future<List?> getAmount(int amount, String subcollection) async {
    //function designed to get the required amount of values from a certain subcollection in order from oldest to newest
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
    //function designed to get a certain amount of recordings from a collection that has no last 100 recordings in order from oldest to newest, should only be called through getAmount
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
