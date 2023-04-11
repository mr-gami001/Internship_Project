import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/bloc/Institute_bloc/add_bus_data.dart';




class addbus extends StatefulWidget {
  const addbus({Key? key}) : super(key: key);

  @override
  State<addbus> createState() => _addbusState();
}

class _addbusState extends State<addbus> {

  TextEditingController busno = TextEditingController();
  TextEditingController UserId = TextEditingController();
  TextEditingController password = TextEditingController();

  bool obsecuretext = true;
  IconData obsecureicon = Icons.visibility_off;

  Bus bus = Bus();

  Widget elevatedbutton = Text('Add Data',style: TextStyle(color: Colors.black),);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Bus Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: busno,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Bus No',
                  hintText: "Enter Bus No.",
                  border: OutlineInputBorder(),
                ),

              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: UserId,
                decoration: InputDecoration(
                    labelText: 'Usr Id',
                    hintText: "Enter Bus User Id",
                    border: OutlineInputBorder()
                ),

              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: password,
                obscureText: obsecuretext,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(obsecureicon),
                    onPressed: ()async {
                      setState(() {
                        if(obsecuretext == true){
                          obsecuretext = false;
                          obsecureicon = Icons.visibility;
                        }
                        else{
                          obsecuretext=true;
                          obsecureicon = Icons.visibility_off;
                        }
                      });

                    },
                  ),
                    labelText: 'Password',
                    hintText: "Enter Password",
                    border: OutlineInputBorder()
                ),

              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height*0.075,
              width: MediaQuery.of(context).size.width*0.5,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0 ),

              child: ElevatedButton(
                child: elevatedbutton,
                onPressed: ()async{

                  print(busno.toString());

                  if(busno.text == "" || UserId == "" || password == ""){
                    await showDialog(context: context, builder: (context)=>AlertDialog(title: Text("Fill the data !!"),icon: Icon(Icons.add_alert),));
                  }

                  else {
                    String check = await bus.adddata(int.parse(busno.text), UserId.text, password.text);
                    print(check);
                    if (check == 'Added') {
                      await showDialog(context: context,
                          builder: (context) =>
                              AlertDialog(title: Text('Data Added'), icon: Icon(
                                  CupertinoIcons.person_add_solid),));
                      await Navigator.popAndPushNamed(context, '/bus');
                    }

                    else if (check == 'Already') {
                      setState(() {
                        elevatedbutton = Text(
                          'Save', style: TextStyle(color: Colors.black),);
                      });
                      await showDialog(context: context, builder: (context) =>
                          AlertDialog(
                            icon: Icon(Icons.account_circle_sharp),
                            title: Text("User Id Already in use !"),
                          ));
                    }

                    else {
                      setState(() {
                        elevatedbutton = Text(
                          'Save', style: TextStyle(color: Colors.black),);
                      });
                      await showDialog(context: context, builder: (context) =>
                          AlertDialog(title: Text(check),));
                    }
                  }

                },

              ),

            )

          ],
        ),
      ),
    );
  }
}
