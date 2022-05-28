import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

//my imports
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/models/customer.dart';
import 'package:illustrashirt/myWidgets/form_helper.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/myWidgets/validator_service.dart';
import 'package:illustrashirt/myWidgets/ProgressHUD.dart';

import 'LogInScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  bool ishide = true;

  @override
  void initState() {
    apiService = new APIService();
    model = new CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: KbackgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: ProgressHUD(
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            withh: withScreen,
            heightt: heightScreen,
            child: Form(
              key: globalKey,
              child: Column(
                children: [

                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 8.0),
                        child: Image.asset("assets/images/background_login.png"),
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: KprimaryColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "We don't disapoint.",
                          style: TextStyle(
                            color: KsecondaryColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  // Forms , Name :
                  FormCustomName(),

                  SizedBox(
                    height: 10,
                  ),

                  // Forms , Email :
                  FormCustomEmail(),

                  SizedBox(
                    height: 10,
                  ),

                  // Forms , Password :
                  FormCustomPassword(),

                  SizedBox(
                    height: 50,
                  ),

                  // button for Sign Up :
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 23),
                    child: FlatButton(
                      height: 70,
                      color: KsecondaryColor,
                      onPressed: () {
                        if (validateAndSave()) {
                          setState(() {
                            isApiCallProcess = true;
                          });

                          apiService.createCustomer(model).then(
                           (ret) {
                             setState(() {
                               isApiCallProcess = false;
                             });
                            if(ret){
                              FormHelper.showMessage(context, 'IllustraTeam', 'success', 'done', (){
                                Navigator.of(context).pop();
                              });

                            }else{
                              FormHelper.showMessage(context, 'IllustraTeam', 'Already With us', 'done', (){
                                Navigator.of(context).pop();
                              });
                            }
                          });

                        }
                      },
                      child: Center(
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: KbackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Already have an account ? :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Color(0xFF2D2E49),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => LogInScreen()));
                        },
                        child: Text(
                          ' LOG IN',
                          style: TextStyle(
                            color: KprimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget FormCustomEmail() {
    return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Kbordercolor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.email_outlined,
                          color: KprimaryColor,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 35,
                        color: Kbordercolor,
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: KprimaryColor,
                          showCursor: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            this.model.email = value;
                          },
                          validator: (value) {
                            if (value.toString().isNotEmpty && !value.toString().isValidEmail()) {
                              return "Please enter a valide Email..";
                            }
                            if (value.toString().isEmpty) {
                              return "Please enter your Email..";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                );
  }

  Widget FormCustomName() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: Kbordercolor,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.person_outline,
                  color: KprimaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 35,
                color: Kbordercolor,
                margin: EdgeInsets.only(right: 10),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: KprimaryColor,
                  showCursor: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (String value) {
                    this.model.name = value;
                  },
                  validator: (value) {
                    if (value.toString().isEmpty ) {
                      return "Please enter your Name..";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        );
  }

  Widget FormCustomPassword() {
    return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Kbordercolor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.lock_outline,
                          color: KprimaryColor,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 35,
                        color: Kbordercolor,
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: TextFormField(
                          obscureText: ishide,
                          keyboardType: TextInputType.text,
                          cursorColor: KprimaryColor,
                          showCursor: false,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                ishide ? Icons.visibility_off : Icons.visibility,
                                color: KprimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  ishide = !ishide;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            this.model.password = value;
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Please enter your Password..";
                            }
                            if (value.toString().length < 6) {
                              return "Password is less than 6!";
                            }
                            if (value.toString().length > 20) {
                              return "Password is more than 20";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}


/* Widget MyCustomForm(
      String inputText,
      IconData icon,
      TextInputType inputType,
      Function isValide,
      Function onChange,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 23,vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Kbordercolor,
          width: 1,
        ),
      ),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: Icon(icon,color: KprimaryColor,),
          ),

          Container(width: 1,height: 35,color: Kbordercolor,margin: EdgeInsets.only(right: 10),),

          Expanded(
            child: TextFormField(
              cursorColor: KprimaryColor,
              keyboardType: inputType,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: inputText ,
                labelStyle: TextStyle(color: Colors.black54),
                focusedBorder:InputBorder.none,
              ),
              onChanged: (String value){return onChange(value);},
              validator:  (value){
               return isValide(value);
              },
            ),
          ),
        ],
      ),
    );
  }
*/