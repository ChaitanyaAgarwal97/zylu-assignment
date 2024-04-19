import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Center(child: Text("EmpData", style: TextStyle(letterSpacing: 2.0, fontSize: 22.0, fontWeight: FontWeight.bold))),
      ),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          SizedBox(height: 50.0,),
          EmployeeForm(),
        ],
      ),
      ),
    );
  }
}

enum IsActive { active, inactive }

final IS_ACTIVE = ["active", "inactive"];

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});

  @override
  EmployeeFormState createState() {
    return EmployeeFormState();
  }
}

class EmployeeFormState extends State<EmployeeForm> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form values state
  IsActive? employeeIsActive = IsActive.active;
  final employeeIDController = TextEditingController();
  final employeeNameController = TextEditingController();
  final employeePhoneNumberController = TextEditingController();
  final employeeDOJController = TextEditingController();
  final employeeDepartmentController  = TextEditingController();


  submitButtonHandler({required BuildContext context}) async {
    try {
      final data = await db.collection("employees").doc(employeeIDController.text).get();
      if (data.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Employee Exists. ID for every employee should be unique.")));
        return;
      }

      if (_formKey.currentState!.validate() == false) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter corrct details.")));
        return;
      }

      print(employeeIsActive!.index);
      final employee = <String, String>{
        "id": employeeIDController.text,
        "name": employeeNameController.text,
        "phone_number": employeePhoneNumberController.text,
        "department": employeeDepartmentController.text,
        "DOJ": employeeDOJController.text,
        "isActive": IS_ACTIVE[employeeIsActive!.index],
      };

      await db.collection("employees").doc(employeeIDController.text).set(employee);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Employee Added")));

      print("Employee Added");
    }
    catch (error) {
      print(error);
    }
  }

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(1950),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    employeeDOJController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: Text("Enter Employee Data:",  style: TextStyle(fontSize: 20.0, letterSpacing: 2.0, fontWeight: FontWeight.bold),)),
          SizedBox(height: 30.0,),
          TextFormField(
              controller: employeeIDController,
              decoration: InputDecoration(hintText: "Enter employee's ID", hintStyle: TextStyle(fontWeight: FontWeight.w300), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              }
          ),
          SizedBox(height: 30.0,),
          TextFormField(
            controller: employeeNameController,
            decoration: InputDecoration(hintText: "Enter employee's name", hintStyle: TextStyle(fontWeight: FontWeight.w300), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter employee's name";
              }
              return null;
            }
          ),
          SizedBox(height: 30.0,),
          TextFormField(
            controller: employeePhoneNumberController,
              decoration: InputDecoration(hintText: "Enter employee's phone number",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (value.length != 10) {
                  return 'Phone number is of incorrect length';
                }
                return null;
              }
          ),
          SizedBox(height: 30.0,),
          TextField(
            controller: employeeDOJController,
            readOnly: true,
            decoration:
            InputDecoration(hintText: "Enter employee's joining date", hintStyle: TextStyle(fontWeight: FontWeight.w300), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3.0)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3.0))),
            onTap: () => onTapFunction(context: context),
          ),
          SizedBox(height: 30.0,),
          TextFormField(
            controller: employeeDepartmentController,
              decoration: InputDecoration(hintText: "Enter employee's department", hintStyle: TextStyle(fontWeight: FontWeight.w300), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 2.0), borderRadius: BorderRadius.circular(3))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter department';
                }
                return null;
              }
          ),
          SizedBox(height: 30.0,),
          Text("Employment Status:", style: TextStyle(fontSize: 16.0),),
          ListTile(
            title: const Text('Active'),
            leading: Radio<IsActive>(
              activeColor: Colors.greenAccent,
              focusColor: Colors.greenAccent,
              hoverColor: Colors.greenAccent,
              value: IsActive.active,
              groupValue: employeeIsActive,
              onChanged: (IsActive? value) {
                setState(() {
                  employeeIsActive = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Inactive'),
            leading: Radio<IsActive>(
              activeColor: Colors.greenAccent,
              focusColor: Colors.greenAccent,
              hoverColor: Colors.greenAccent,
              value: IsActive.inactive,
              groupValue: employeeIsActive,
              onChanged: (IsActive? value) {
                setState(() {
                  employeeIsActive = value;
                });
              },
            ),
          ),
          SizedBox(height: 50.0,),
          Center(child: OutlinedButton(onPressed: () => submitButtonHandler(context: context), child: Text("Submit", style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),), style: ButtonStyle(side: MaterialStateProperty.all(BorderSide(color: Colors.greenAccent)), fixedSize: MaterialStateProperty.all(Size(150, 20))),)),
          SizedBox(height: 10.0,),
          Center(child: ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/employees');
          }, child: Text("Show Employees", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.greenAccent))),)
        ],
      )
      ),
    );
  }
}



