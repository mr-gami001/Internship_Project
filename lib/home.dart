import 'package:flutter/material.dart';


const List<String> list = <String>['Student', 'Institute', 'Parents'];

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  String dropdownValue = list.first;
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.height*0.7,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: DropdownButton(
                underline: SizedBox(),
                value: dropdownValue,
               alignment: Alignment.center,
               onChanged: (String? value){
                  setState(() {
                    dropdownValue = value!;
                  });
               },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 20,top: 0,right: 20,bottom: 20),
              width: MediaQuery.of(context).size.height*0.7,
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: "Enter Name",
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              )
            ),

            Container(
                margin: EdgeInsets.only(left: 20,top: 0,right: 20,bottom: 20),
                width: MediaQuery.of(context).size.height*0.7,
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                )
            ),
            
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: (){
                  print("name : "+name.toString()
                  );
                  print("Pass :"+password.toString());
                  setState(() {
                    if(name == null || password == null){

                    }
                    else{
                      showDialog(context: context, builder: (context)=>AlertDialog(icon: Icon(Icons.error,size: 100,),iconColor: Colors.red,));
                    }
                  });
                },
              ),
            )

          ],
        ),
      )),
    );
  }
}
