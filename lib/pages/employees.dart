import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Employees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Center(child: Text("EmpData", style: TextStyle(letterSpacing: 2.0, fontSize: 22.0, fontWeight: FontWeight.bold))),
      ),
      body: Column(children: [
        SizedBox(height: 50.0,),
        Text("Employee Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,),),
        SizedBox(height: 20.0,),
        SafeArea(
        child: SingleChildScrollView(
          child: Row(
            children: [
              FixedColumn(),
              EmployeeList(),
            ],
          ),
        )
      )
        ]
      )
    );
  }
}

class EmployeeList extends StatefulWidget {
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Map<String, dynamic>> employees = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  void getEmployeeData() async {
    try {
      final data = await db.collection("employees").get();
      List<Map<String, dynamic>> temp = [];
      for (final doc in data.docs) {
        int timeDiff = DateTime.now().difference(DateTime.parse(doc.data()["DOJ"])).inDays;
        Map<String, dynamic> entry = doc.data();
        if (timeDiff > 1825 && entry["isActive"] == "active") {
          entry.addEntries({"mark": "true"}.entries);
        } else {
          entry.addEntries({"mark" : "false"}.entries);
        }

        temp.add(entry);
      }
      setState(() {
        employees = temp;
      });
      print(employees);
    } catch(e) {
     print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.green[100]),
            columnSpacing: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            columns: [
              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Date of Joining', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('isActive', style: TextStyle(fontWeight: FontWeight.bold),)),
            ],
            rows: [
              ...employees
                  .map((employee) => DataRow(
                color: employee["mark"] == "true" ? MaterialStateProperty.all(Colors.greenAccent) : MaterialStateProperty.all(Colors.white),
                cells: [
                  DataCell(
                      Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            employee["name"] != null ? employee["name"] : "",
                          ))),
                  DataCell(
                      Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(employee["phone_number"] != null ? employee["phone_number"] : ""))),
                  DataCell(
                      Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(employee["department"] != null ? employee["department"] : ""))),
                  DataCell(
                      Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(employee["DOJ"] != null ? employee["DOJ"] : ""))),
                  DataCell(
                      Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(employee["isActive"] != null ? employee["isActive"] : ""))),
                ],
              ))
            ]),
      ),
    );
  }
}

// This is the fixed Column widget
class FixedColumn extends StatefulWidget {
  @override
  State<FixedColumn> createState() => _FixedColumnState();
}

class _FixedColumnState extends State<FixedColumn> {
  List<Map<String, String>> employeeIDWithMarkStatus = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  void getEmployeeData() async {
    try {
      final data = await db.collection("employees").get();
      List<Map<String, String>> temp = [];
      for (final doc in data.docs) {
        int timeDiff = DateTime.now().difference(DateTime.parse(doc.data()["DOJ"])).inDays;
        temp.add({"id": doc.data()["id"], "mark": timeDiff >= 1825 && doc.data()["isActive"] == "active" ? "true" : "false"});
      }
      setState(() {
        employeeIDWithMarkStatus = temp;
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 10,
      headingRowColor: MaterialStateProperty.all(Colors.green[100]),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      columns: [
        DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold),)),
      ],
      rows: [
        ...employeeIDWithMarkStatus.map((element) => DataRow(
          color: element["mark"] == "true" ? MaterialStateProperty.all(Colors.greenAccent) : MaterialStateProperty.all(Colors.white),
          cells: [
            DataCell(Text(
              element["id"]!,
            )),
          ],
        ))
      ],
    );
  }
}