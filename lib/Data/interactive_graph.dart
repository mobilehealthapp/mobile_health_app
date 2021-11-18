import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/Drawers/drawers.dart';
import 'package:mobile_health_app/Machine_Learning/predictive_graph.dart';
import 'package:mobile_health_app/Data/patient_data_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
final uid = user!.uid;

class InteractiveGraph extends StatefulWidget {
  InteractiveGraph({Key? key, text}) : super(key: key);
  @override
  InteractiveGraphState createState() => InteractiveGraphState();
}

class InteractiveGraphState extends State<InteractiveGraph> {
  bool patientsloaded = false; //becomes true when doctorPatients list is loaded
  bool inserttab =
      false; //becomes true when doctor has selected first three data points

  bool haspatients = true; //turns true if the doctor has patients
  String? chosenpatient; //patient currently selected in the dropdownmenu
  var patientList = ['']; //list of patient names
  int index = -1; //marks what index the current patient is in the list
  var uidList = []; //list of uids

  var dataTypeList = ['Blood Glucose', 'Blood Pressure', 'Heart Rate'];
  String? chosendatatype;

  int amountdateindex = -1;
  var amountdateList = ['Date', 'Amount'];
  String? amountdate;

  bool threeselected = false;

  int amount = 5; //default amount of measurements for amount
  var amountList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
  ];

  String dateunit = 'Days';
  var dateunitList = ['Days', 'Weeks', 'Months'];
  var dateamountList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  final CollectionReference doctorPatientsCollection = FirebaseFirestore
      .instance
      .collection('doctorprofile')
      .doc(uid)
      .collection('doctorPatients');

  String? subcol; //subcollection name
  String? patientuid; //patient uid
  var subcollection; //subcollection reference
  var graphlist;
  var graphdata;

  initState() {
    super.initState();
    getPatientList();
  }

  getPatientList() async {
    int firstspot = 0;
    var list = [''];
    await doctorPatientsCollection.get().then((docSnapshot) => {
          //if the doctor has patients, put them in a list
          if (docSnapshot.size > 0)
            {
              docSnapshot.docs.forEach((DocumentSnapshot doc) {
                String first = doc.get('first name');
                String last = doc.get('last name');
                if (first == "" && last == "") {
                  return;
                }
                String full = ("$first $last");
                if (firstspot == 0) {
                  list[0] = full;
                  firstspot++;
                } else {
                  list.add(full);
                }
                String patientid = doc.get('patientUID');
                uidList.add(patientid);
              }),
            }
        });
    if (list == ['']) {
      haspatients = false;
    }
    patientsloaded = true;
    patientList = list;
    setState(() {});
  }

  getSubcollection(String? subdropdown) {
    if (subdropdown == null) {
      return;
    }
    subdropdown = subdropdown.replaceFirst(' ', '');
    subdropdown = subdropdown.substring(0, 1).toLowerCase() +
        subdropdown.substring(1, subdropdown.length);
    subcol = subdropdown;
  }

  checkSelected() {
    if (subcol != null && patientuid != null && amountdate != null) {
      subcollection = FirebaseFirestore.instance
          .collection('patientData')
          .doc(patientuid)
          .collection(
              subcol!); //makes me null check this even though I null checked it already;
      inserttab = true;
    }
  }

  Future createList(int amount, String? datetype) async {
    Datafunction datafunc = Datafunction(patientuid!);
    if (datetype == null) {
      graphlist = await datafunc.getAmount(amount, subcol!);
      createGraph(datetype, graphlist);
    } else {
      double startdate =
          double.parse(getStartDate(amount, datetype).toStringAsFixed(4));
      graphlist = await datafunc.getFromToday(startdate, subcol!);
      createGraph(datetype, graphlist);
    }
  }

  double getStartDate(int amount, String datetype) {
    //TODO: person can't ask for more than 12 months or errors can happen...
    Datafunction datafunc = Datafunction('');
    String today = '-' + DateTime.now().toUtc().toString();
    double date = datafunc.getDate(today);
    double day = datafunc.getDay(today) * 0.0001;
    double month = datafunc.getMonth(today) * 0.01;
    double subtract;
    if (datetype == "Days") {
      //find amount we are subtracting by
      subtract = 0.0001 * amount;
    } else if (datetype == "Weeks") {
      subtract = 0.0001 * 7 * amount;
    } else {
      subtract = 0.01 * amount;
    }
    if (day > subtract) {
      //if the subtracted amount of days is less than the days in this month
      return date - subtract;
    } else {
      if (subtract % 0.01 != 0 && subtract < 0.01) {
        //if the person is subtracting days/weeks and those days/weeks are not covered in this month
        double daysremaining = (subtract * 10000 % 30).toDouble();
        int months = subtract *
            10000 ~/
            30; //find how many full months can be covered by the remaining subtract amount after subtracting days+1
        if (daysremaining * 0.0001 < day) {
          date -= daysremaining * 0.0001;
        } else {
          date += (30 - daysremaining) * 0.0001;
          months++;
        }
        subtract = months * 0.01;
      }
      //if the person is trying to subtract months
      if (month > subtract) {
        return date -
            subtract; //if the subtract amount of months is less than the months remaining in this year
      } else {
        return date - 0.88 - subtract;
      }
    }
  }

  createGraph(String? datetype, var graphlist) {
    Datafunction datafunc = Datafunction('');
    if (datetype == 'null') {
      //if this is an amount graph
      int amount = 0;
      if (subcol == 'bloodPressure') {
        //if there is two values per measurement to be displayed on ther graph
        for (int i = 0; i < graphlist.length; i++) {
          graphdata.add(new BloodPressure(datafunc.getSys(graphlist[i]),
              datafunc.getDia(graphlist[i]), amount));
          amount++;
        }
      } else if (subcol == 'bloodGlucose') {
        //if there is one value to display on the graph
        for (int i = 0; i < graphlist.length; i++) {
          graphdata
              .add(new OneVariable(datafunc.getMMOL(graphlist[i]), amount));
          amount++;
        }
      }
    } else {}
  }

  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (patientsloaded && haspatients) {
      return Scaffold(
        drawer: PhysicianDrawers(),
        appBar: AppBar(
          title: Text("Patient Data"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              alignment: Alignment.center,
              child: Text(
                'Select a patient, measurement type, and sorting type (sort by date or amount)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text("Patient"),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 22,
                        isExpanded: true,
                        value: chosenpatient,
                        items: patientList.map(buildItem).toList(),
                        onChanged: (value) {
                          setState(() {
                            chosenpatient = value;
                            index = patientList.indexOf(value!);
                            patientuid = uidList[index];
                            checkSelected();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text("Measurement Type",
                          style: TextStyle(fontSize: 15.0)),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 22,
                      isExpanded: true,
                      value: chosendatatype,
                      items: dataTypeList.map(buildItem).toList(),
                      onChanged: (value) {
                        setState(() {
                          chosendatatype = value;
                          getSubcollection(chosendatatype);
                          checkSelected();
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  child: Container(
                    width: 90,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text("Date or Amount",
                            style: TextStyle(fontSize: 15.0)),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 22,
                        isExpanded: true,
                        value: amountdate,
                        items: amountdateList.map(buildItem).toList(),
                        onChanged: (value) {
                          setState(() {
                            amountdate = value;
                            checkSelected();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            tab(),
          ],
        ),
      );
    } else if (patientsloaded && !haspatients) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Patient Data"),
          centerTitle: true,
        ),
        body: Center(
          child: Text('No Patients Found'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Patient Data"),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Loading Patients...'),
        ),
      );
    }
  }

  Widget tab() {
    if (inserttab) {
      if (amountdate == 'Date') {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Last',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 15,
                    isExpanded: true,
                    value: amount.toString(),
                    items: dateamountList.map(buildItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        amount = int.parse(value!);
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 80,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 15,
                    isExpanded: true,
                    value: dateunit,
                    items: dateunitList.map(buildItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        dateunit = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 25),
              child: Container(
                width: 45,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        alignment: Alignment(0.0, 0.0)),
                    child: Icon(FontAwesomeIcons.redoAlt,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      createList(amount, dateunit);
                      //navigate to predicted graph page with data
                    }),
              ),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Last',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 15,
                    isExpanded: true,
                    value: amount.toString(),
                    items: amountList.map(buildItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        amount = int.parse(value!);
                      });
                    },
                  ),
                ),
              ),
            ),
            Text('Measurements',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Container(
                width: 45,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        alignment: Alignment(0.0, 0.0)),
                    child: Icon(FontAwesomeIcons.redoAlt,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      createList(amount, null);
                      //navigate to predicted graph page with data
                    }),
              ),
            ),
          ],
        );
      }
    } else {
      return Text('');
    }
  }
}

class OneVariable {
  //for bg and hr
  final num day;
  final num vari;
  OneVariable(this.vari, this.day);
}

class BloodPressure {
  final num dia;
  final num sys;
  final num day;
  BloodPressure(this.dia, this.sys, this.day);
}
