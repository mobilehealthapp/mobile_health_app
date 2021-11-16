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

  int getHR(String recording) {
    return int.parse(recording.split(',')[0]);
  }

  double getSys(String recording) {
    return double.parse(recording.split(',')[0]);
  }

  double getDia(String recording) {
    return double.parse(recording.split(',')[1]);
  }

  double getMg(String recording) {
    return double.parse(recording.split(',')[0]);
  }

  double getMMOL(String recording) {
    return double.parse(recording.split(',')[1]);
  }

  double getDate(String recording) {
    double year = double.parse(recording.split('-')[1]);
    double month = double.parse(recording.split('-')[2]) * 0.01;
    double day = double.parse(recording.split('-')[3].substring(0, 2)) * 0.0001;
    return year + month + day;
  }

  double getYear(String recording) {
    return double.parse(recording.split('-')[1]);
  }

  double getMonth(String recording) {
    return double.parse(recording.split('-')[2]);
  }

  double getDay(String recording) {
    return double.parse(recording.split('-')[3].substring(0, 2));
  }

  double getTime(String recording) {
    //the higher the double value the later the recording was during the day
    String time = recording.split(' ')[1].substring(0, 8);
    double hour = double.parse(time.substring(0, 2));
    double minute = double.parse(time.substring(3, 5)) * 0.01;
    double second = double.parse(time.substring(6, 8)) * 0.0001;
    return hour + minute + second;
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

  Future<List?> getFromToday(double startdate, String subcollection) async {
    //returns a list of all values between the specified date and today
    // //for dates, the higher the date the more recent it is
    CollectionReference subcol = patientData.doc(uid).collection(subcollection);
    DocumentSnapshot snap = await subcol.doc('Last 100 Recordings').get();
    if (snap.exists) {
      int size = snap.get('Data Entries').toInt();
      double oldestdate = getDate(' -' + snap.get('Oldest Date'));
      if (oldestdate < startdate) {
        print('yoyo!');
        print(startdate);
        //if the last 100 recordings covers the time period
        for (int i = size; i > 1; i--) {
          double date;
          String measurement;
          if (i < 10) {
            measurement = snap.get('Data Submission 0$i');
          } else {
            measurement = snap.get('Data Submission $i');
          }
          date = getDate(measurement);
          if (date < startdate) {
            //this returns the first date if the first date is older then the startdate...
            return await getAmount(size - i,
                subcollection); //return all dates that were after the specified date
          }
        }
      } else {
        //if the last 100 recordings' oldest date is more recent than the enddate
        DocumentSnapshot collectionsnap = await patientData.doc(uid).get();
        if (collectionsnap.exists) {
          num hundreds =
              collectionsnap.get("$subcollection Recordings (hundreds)");
          bool dateacquired = false;
          int hundredcount = 0;
          int lasthundredamount = 0;
          while (!dateacquired) {
            if (hundreds > 0) {
              num bottom = (hundreds - 1) * 100;
              num top = hundreds * 100;
              String document =
                  bottom.toString() + "~" + top.toString() + " Recordings";
              DocumentSnapshot hundredsnap = await subcol.doc(document).get();
              double oldestdate = getDate('-' + hundredsnap.get('Oldest Date'));
              if (oldestdate < startdate) {
                //if the date is in this set of a hundred measurements count the amount of measurements that are after this date
                for (int i = 99; i > 1; i--) {
                  double date;
                  String measurement;
                  if (i < 10) {
                    measurement = snap.get('Data Submission 0$i');
                  } else {
                    measurement = snap.get('Data Submission $i');
                  }
                  date = getDate(measurement);
                  if (date < startdate) {
                    lasthundredamount = 99 -
                        i; //return all dates that were after the specified date
                    return await getAmount(
                        size + hundredcount * 99 + lasthundredamount,
                        subcollection);
                  }
                }
              } else {
                //if this hundred values doesn't have the date check the next hundred
                if (hundreds - 1 > 0) {
                  hundredcount++;
                  hundreds--;
                } else {
                  //if there is no next hundred return the list
                  return await getAmount(
                      size + hundredcount * 99, subcollection);
                }
              }
            } else {
              return await getAmount(size,
                  subcollection); //return the last 100 recordings if there are no hundreds stored
            }
          }
        }
      }
    } else {
      return null;
    }
  }

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
            subcollection); //create a list to add the remainder recordings
        if (listtoadd != null) {
          for (int i = 0; i < listtoadd.length; i++) {
            //add the remainder recordings to the list
            list.add(listtoadd[i]);
          }
        }
        for (int i = 1; i < size + 1; i++) {
          //add the recordings from the last 100 recordings
          if (i < 10) {
            list.add(snap.get('Data Submission 0$i'));
          } else {
            list.add(snap.get('Data Submission $i'));
          }
        }
        return list;
      }
    } else {
      //return getAmountHundreds(amount, subcollection);
      return null;
    }
  }

  Future<List?> getAmountHundreds(int amount, String subcollection) async {
    //function designed to get a certain amount of recordings from a collection that has no last 100 recordings in order from oldest to newest, should only be called through getAmount
    //getAmountHundreds is currently not recursive so an amount no greater than what is covered in last 100 recordings +99 should be called
    int hundredsdepth = amount ~/ 99;
    var list = <String>[];
    CollectionReference subcol = patientData.doc(uid).collection(subcollection);
    DocumentSnapshot collectionsnap = await patientData.doc(uid).get();
    if (collectionsnap.exists) {
      int hundreds =
          collectionsnap.get("$subcollection Recordings (hundreds)").toInt();
      if (hundreds > 0) {
        if (hundredsdepth >= hundreds) {
          for (int j = 1; j < hundreds + 1; j++) {
            int hundred =
                j; //if the amount is greater than total amount of insertions for the user grab all of their hundreds measurements
            num bottom = (hundred - 1) * 100;
            num top = hundred * 100;
            String document =
                bottom.toString() + "~" + top.toString() + " Recordings";
            DocumentSnapshot hundredsnap = await subcol.doc(document).get();
            for (int i = 1; i < 100; i++) {
              if (i < 10) {
                list.add(hundredsnap.get('Data Submission 0$i'));
              } else {
                list.add(hundredsnap.get('Data Submission $i'));
              }
            }
          }
          return list;
        } else {
          int lasthundredamount = amount %
              99; //how many entries need to be grabbed from the last hundreds doc
          int lasthundred = hundreds - hundredsdepth;
          for (int j = lasthundred; j < hundreds + 1; j++) {
            num bottom = (hundreds - 1) * 100;
            num top = hundreds * 100;
            String document =
                bottom.toString() + "~" + top.toString() + " Recordings";
            DocumentSnapshot hundredsnap = await subcol.doc(document).get();
            if (j == lasthundred) {
              for (int i = 100 - lasthundredamount; i < 100; i++) {
                if (i < 10) {
                  list.add(hundredsnap.get('Data Submission 0$i'));
                } else {
                  list.add(hundredsnap.get('Data Submission $i'));
                }
              }
            } else {
              for (int i = 1; i < 100; i++) {
                if (i < 10) {
                  list.add(hundredsnap.get('Data Submission 0$i'));
                } else {
                  list.add(hundredsnap.get('Data Submission $i'));
                }
              }
            }
          }
          return list;
        }
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
