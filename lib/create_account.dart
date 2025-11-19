import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexaflow/DataBase/remote/firebaseauth.dart';
import 'package:nexaflow/login_UI.dart';

class CreateAccount extends StatefulWidget {
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool isLoading = false;
  bool passwordhidden = true;
  //for phone no. exceeding ,more than 10 digits
String? phoneError;
String?passwordError;//for password related errors
//text editing controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NexaFlow",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 250,
            child: Column(
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 55,
                    color: Colors.purple[600],
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter Your Name",
                    labelText: "Name",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email ID",
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value){
                    setState(() {
                      if(value.length>10)
                        {
                          phoneError="Phone no. should be of 10 digits";
                        }
                      else if(value.length<10&&value.isNotEmpty)
                        {
                          phoneError="Phone number must be of 10 digit";
                        }
                      else
                        {
                          phoneError=null;
                        }
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Phone no.",
                    labelText: "Phone",
                    counterText: "",
                    errorText: phoneError,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.purple),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2,color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.red),
                      borderRadius: BorderRadius.circular(11.0),
                    )
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: passwordhidden,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordhidden = !passwordhidden;
                        });
                      },
                      icon: Icon(
                        passwordhidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    hintText: "Create Password",
                    labelText: "Password",
                    errorText: passwordError,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                      borderSide: BorderSide(width: 2, color: Colors.purple),
                    ),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11.0),
                    borderSide: BorderSide(color: Colors.red,width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:BorderSide(color: Colors.red,width: 2),
                      borderRadius: BorderRadius.circular(11.0),
                    )
                  ),
                  onChanged:(value){
                    setState((){
                      if(value.length<6&&value.isNotEmpty)
                        {
                          passwordError="Password must have at least 6 characters";
                        }
                      else
                        {
                          passwordError=null;
                        }
                    });
                  }
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    elevation: 3,
                    fixedSize: const Size(200, 50),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          String name = nameController.text.trim();
                          String email = emailController.text.trim();
                          String phone = phoneController.text.trim();
                          String password = passwordController.text.trim();
                          if (name.isEmpty ||
                              email.isEmpty ||
                              phone.isEmpty ||
                              password.isEmpty) {
                            setState(() => isLoading = false);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.purple[50],
                                title: Text("Error"),
                                content: Text("Fill all the required fields"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                          //local db
                          // bool exists = await DbHelper.instance.userexists(email);
                          // if (exists) {
                          //   showDialog(
                          //     context: context,
                          //     builder: (_) => AlertDialog(
                          //       title: Text("User exists"),
                          //       content: Text("User already exists",style: TextStyle(fontSize: 15,),),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () => Navigator.pop(context),
                          //           child: Text("ok",style: TextStyle(fontSize: 25,),),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          //   return;
                          // }
                          // bool success = await DbHelper.instance.adduser(
                          //   uEmail: email,
                          //   uName: name,
                          //   uPhone: phone,
                          //   uPassword: password,
                          // );
                          // if (success) {
                          //   nameController.clear();
                          //   emailController.clear();
                          //   phoneController.clear();
                          //   passwordController.clear();
                          //   showDialog(
                          //     context: context,
                          //     builder: (_) => AlertDialog(
                          //       title: Text("Success"),
                          //       content: Text("Account created Successfully",style: TextStyle(fontSize: 15,),),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //             Navigator.pop(context);
                          //           },
                          //           child: Text("ok",style: TextStyle(fontSize: 25,),),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // } else {
                          //   showDialog(
                          //     context: context,
                          //     builder: (_) => AlertDialog(
                          //       title: Text("Error"),
                          //       content: Text("Failed to create account. Try again.",style: TextStyle(fontSize: 15,),),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () => Navigator.pop(context),
                          //           child: Text("ok",style: TextStyle(fontSize: 25,),),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }
                          //firebase
                          final (user, errorMsg) = await RemoteDb.instance
                              .Createuser(
                                name: name,
                                email: email,
                                phone: phone,
                                password: password,
                              );
                          setState(() => isLoading = false);
                          if (user != null) {
                            nameController.clear();
                            emailController.clear();
                            phoneController.clear();
                            passwordController.clear();
                            //success dialog box
                            final firstname = name.trim().split(" ").first;
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.purple[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11.0),
                                  side: BorderSide(
                                    color: Colors.purple.shade300,
                                    width: 2,
                                  ),
                                ),
                                title: Text(
                                  "Welcome,${firstname.isEmpty ? "User" : firstname}!",
                                ),
                                content: Text(
                                  "Your account has been created successfully.\nWe're excited to have you on NexaFlow 💜\nPlease login to continue",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Login_UI(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              ),
                            );
                          } else if (errorMsg != null) {
                            showDialog(
                              barrierDismissible:false,
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.purple[50],
                                title: Text("Error"),
                                content: Text(errorMsg),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(0,0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: ()=> Navigator.pushAndRemoveUntil(
                      context,
                          MaterialPageRoute(builder:(_)=>Login_UI()),
                          (route)=>false,
                    ),
                    child: Text(
                      "Already a user? Login",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 2,
                        height: 2
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
