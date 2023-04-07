

import 'package:flutter/material.dart';
import 'package:let_me_check/Services/loginservice.dart';

class forgetpass extends StatefulWidget {
  const forgetpass({Key? key}) : super(key: key);

  @override
  State<forgetpass> createState() => _forgetpassState();
}

class _forgetpassState extends State<forgetpass> {

  TextEditingController email =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Forget Passeword'),centerTitle: true,backgroundColor: Colors.red,),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height*0.25, 10, 0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Email',
                  labelText: 'Email'
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: ()async{
                  String check = await Forgetpass(email.text);
                  if(check == 'okay'){
                    print('okk');
                    await showDialog(context: context, builder: (context) => AlertDialog(title: Text('Password Reset Email Sended!!'),icon: Icon(Icons.done),));
                    await Navigator.of(context).pushNamed('/');
                  }else{
                    print(check);
                    await showDialog(context: context, builder: (context) => AlertDialog(title: Text(check),icon: Icon(Icons.error),));
                    email.clear();

                  }
                },
                child: Text('Forget password'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
