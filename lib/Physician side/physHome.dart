import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Drawers/PhysDrawer.dart';
import 'package:mobile_health_app/Constants.dart';
import 'input_file.dart';

var loggedInUser;
var uid;

class PhysHome extends StatefulWidget {
  @override
  _PhysHomeState createState() => _PhysHomeState();
}

class _PhysHomeState extends State<PhysHome> {
  List _allResults = [];
  List _resultsList = [];
  var resultsloaded;
  TextEditingController _searchcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _searchcontroller.addListener(onsearchchange);
  }

  @override
  void dispose() {
    _searchcontroller.removeListener(onsearchchange());
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsloaded = getpatientsnapshots();
  }

  onsearchchange() {
    searchresults();
  }

  searchresults() {
    var showresults = [];
    if (_searchcontroller.text != '') {
      for (var patientsnapshot in _allResults) {
        var patientname =
            getpatientnames(patientsnapshot).toString().toLowerCase();
        if (patientname.contains(_searchcontroller.text.toLowerCase())) {
          showresults.add(patientsnapshot);
        }
      }
    } else {
      showresults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showresults;
    });
  }

  Future<void> getpatientsnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('doctorprofile')
        .doc(uid)
        .collection('doctorPatients')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchresults();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        uid = user.uid.toString(); //convert to string in this method
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      drawer: PhysDrawers(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InputFile()));
            },
          )
        ],
        title: Text('Physician Home Page'),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: TextField(
              controller: _searchcontroller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Patient Name'),
              style: TextStyle(fontSize: 20),
            ),
          ),
          RefreshIndicator(
            onRefresh: getpatientsnapshots,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return buildPatientCard(context, _resultsList[index]);
                },
                itemCount: _resultsList.length),
          ),
        ],
      ),
    );
  }

  getpatientnames(DocumentSnapshot snapshot) {
    String fullpatientname =
        '${snapshot['first name']} ${snapshot['last name']}';
    return fullpatientname;
  }
}

class PatientCard extends StatelessWidget {
  PatientCard({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: OutlinedButton(
        onPressed: () {},
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        name,
                        style: kTextLabel1,
                      ),
                      Container(
                          child: ElevatedButton(
                        onPressed: () {},
                        child: Text(''),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ))
                    ]),
                SizedBox(
                  height: 10.0,
                ),
                // Text(
                //   email,
                //   style: kTextLabel2,
                // ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text("Average Blood Press : "),
                    Text(''),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildPatientCard(BuildContext context, DocumentSnapshot document) {
  final name = '${document['first name']} ${document['last name']}';
  final email = document['email'];

  return PatientCard(name: name, email: email);
}
