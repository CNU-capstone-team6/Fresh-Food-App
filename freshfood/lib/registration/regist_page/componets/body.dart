import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshfood/registration/contract_linking.dart';
import 'package:freshfood/registration/registmain/components/background.dart';
import 'package:freshfood/widget/icon_rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:freshfood/registration/regist_page/componets/regist_after.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class QrCode {
  final int _output;

  QrCode(this._output);
}
class Body extends StatefulWidget{
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body>{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController originController = TextEditingController();

  // final TextEditingController authorController = TextEditingController();
  int _output= -1;
  List<ParseObject> results = <ParseObject>[];
  String author ="none";
  bool isCheck = false;
  void doUserQuery() async {
    // final QueryBuilder<ParseUser> queryUsers =
    // QueryBuilder<ParseUser>(ParseUser.currentUser() as ParseUser);
    final  currentUser = await ParseUser.currentUser();
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject('_User'));

    parseQuery..whereContains('objectId', currentUser.objectId);

    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      setState(() {
        results = apiResponse.results as List<ParseObject>;
      });
    } else {
      results = [];
    }
    author = results[0]['companyname'];

    isCheck = true;
  }
  // void getAuthor() async {
  //   print(author);
  // }
  @override
  Widget build(BuildContext context) {
    if (isCheck == false){
      doUserQuery();
    }

    print("author $author");
    print("유저정보 ${results.length}");
    var contractLink = Provider.of<ContractLinking>(context);
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 29),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Food Name",
                        hintText: "Food Name",
                        icon: Icon(Icons.drive_file_rename_outline)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 29),
                  child: TextFormField(
                    controller: originController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Food Origin",
                        hintText: "Food Origin",
                        icon: Icon(Icons.drive_file_rename_outline)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),

                  child: ElevatedButton(
                    child: Text(
                      '등록',
                      style: TextStyle(fontSize: 30),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: ()  async {
                      // var number =contractLink.addFood(nameController.text,originController.text);
                      int number = await contractLink.addFood(nameController.text, originController.text, author);
                      // BigInt number = await contractLink.getNumber();

                      // List<String> foodlist = await contractLink.getFood(BigInt.from(number));
                      // print("foodlist");
                      // print(foodlist);

                      // _output = number;
                      nameController.clear();
                      originController.clear();
                      // var result = contractLink.getFood(BigInt.from(3));
                      // print(result);
                      // _output = 1;
                      Timer(Duration(seconds: 2),(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:(context)=>RegistAfterPage( qrCode:_output),
                          ),
                        );// calling a function when user click on button
                      },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}