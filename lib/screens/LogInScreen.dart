import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//my imports
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/myWidgets/ProgressHUD.dart';
import 'package:illustrashirt/myWidgets/validator_service.dart';
import 'package:illustrashirt/screens/SignUpScreen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/myWidgets/form_helper.dart';


class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String username;
  String password;
  APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
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
            heightt: heightScreen,
            withh: withScreen,
            child: Form(
              key: globalKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 8.0),
                        child: Image.asset("assets/images/background_login.png"),
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:30.0),
                    child: Column(
                      children: [
                        Text("Login",style: TextStyle(
                          color: KprimaryColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                        ),),
                        SizedBox(height: 5,),
                        Text("Hey! Welcome back",style: TextStyle(
                          color: KsecondaryColor,
                          fontSize: 15,
                        ),),
                      ],
                    ),
                  ),

                  SizedBox(height: 50,),

                  // UserName :
                  Container(
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
                              setState(() {
                                this.username = value;
                              });
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
                  ),


                  SizedBox(height: 40,),

                  // Password :
                  Container(
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
                            showCursor: false,
                            obscureText: hidePassword,
                            keyboardType: TextInputType.text,
                            cursorColor: KprimaryColor,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword ? Icons.visibility_off : Icons.visibility,
                                  color: KprimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (String value) {
                              setState(() {
                                this.password = value;
                              });
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
                  ),

                  SizedBox(height: 10,),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 0),
                    alignment: Alignment.centerRight,
                    child: Text("Forgot password?",style: TextStyle(color: KprimaryColor),),
                  ),

                  SizedBox(height: 50,),


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
                          apiService.loginCustomer(username, password.toString()).then(
                                  (ret) {
                                    if(ret != null){
                                      FormHelper.showMessage(
                                        context,
                                        "IllustraShirt",
                                        "Login sucess",
                                        "G_G",
                                            (){
                                              setState(() {
                                                isApiCallProcess = false;
                                              });
                                              Navigator.pop(context);

                                            },
                                      );
                                    }else{
                                      FormHelper.showMessage(
                                        context,
                                        "IllustraShirt",
                                        "Login invalid",
                                        "G_G",
                                            (){
                                              setState(() {
                                                isApiCallProcess = false;
                                              });
                                          Navigator.pop(context);
                                            },
                                      );
                                    }

                                  });
                        }
                      },
                      child: Center(
                        child: Text(
                          "LOG IN",
                          style: TextStyle(
                            color: KbackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color(0xFF2D2E49),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                        },
                        child: Text(
                          ' SIGN UP',
                          style: TextStyle(
                            color: KprimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),
        ),
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

