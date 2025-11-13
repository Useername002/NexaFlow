import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexaflow/Addproducts_page.dart';
import 'package:nexaflow/DataBase/remote/firebaseauth.dart';

import 'package:nexaflow/homepage.dart';
import 'create_account.dart';
import 'forgot_password.dart';

class Login_UI extends StatefulWidget {
  @override
  State<Login_UI> createState() => _Login_UIState();
}

class _Login_UIState extends State<Login_UI> {
  bool _isLoading = false;
  bool passwordhidden = true;

  var emailController = TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 70),
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 55,
                    color: Colors.purple[600],
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter Username/Email",
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
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
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
                    hintText: "Enter Password",
                    labelText: "Password",
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    elevation: 3,
                    shadowColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final String email = emailController.text.trim();
                          final String password = passwordController.text
                              .trim();
                          if (email.isEmpty || password.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.purple[50],
                                title: Text("Missing Information"),
                                content: Text("Please fill both the fields"),
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
                          setState(() {
                            _isLoading = true;
                          });
                          final (userData, errorMsg) = await RemoteDb.instance
                              .loginUser(email: email, password: password);
                          final userRole=userData?['role'];
                          setState(() {
                            _isLoading = false;
                          });
                          if (errorMsg != null) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.purple[50],
                                title: Row(
                                  children: [
                                    Text("Login Failed"),
                                    SizedBox(width: 5,),
                                    Icon(Icons.cancel),
                                  ],
                                ),
                                content: Text(errorMsg),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if(userRole=="user")
                              {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomePage(
                                      userName: userData?["name"] ?? "User",
                                      phoneNumber: userData?["phone"] ?? "Null",
                                      profileUrl: userData?["profileUrl"] ?? " ",
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Logged in as:${userData?["email"] ?? "E-Mail"}",
                                    ),
                                  ),
                                );
                              }
                            else
                              {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>Addproducts()
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Admin logged in as:${userData?["email"] ?? "E-Mail"}",
                                    ),
                                  ),
                                );
                              }
                          }
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text("Login failed")),
                          //   );
                          // }
                          // if (email.isEmpty || password.isEmpty) {
                          //   showDialog(
                          //     context: context,
                          //     builder: (_) => AlertDialog(
                          //       title: Text("Error"),
                          //       content: Text("Please enter both Email and Password",style: TextStyle(fontSize: 15,),),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () => Navigator.pop(context),
                          //           child: Text("OK",style: TextStyle(fontSize: 25,),),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          //   return;
                          // }
                          //
                          // bool valid = await DbHelper.instance.validateuser(
                          //   email,
                          //   password,
                          // );
                          //
                          // if (valid) {
                          //   Map<String, dynamic>?user = await DbHelper.instance
                          //       .getUserByemail(email);
                          //   if (user != null) {
                          //     String userName = user[DbHelper.USERNAME];
                          //
                          //     await DbHelper.instance.setLogin(userName);
                          //     // User validated successfully
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(content: Text("Login Successful!")),
                          //     );
                          //
                          //     // Navigate to home screen or wherever
                          //     Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(builder: (context) =>
                          //           HomePage(userName: userName)
                          //       ),
                          //     );
                          //   }
                          // }else {
                          //   // Invalid credentials
                          //   showDialog(
                          //     context: context,
                          //     builder: (_) => AlertDialog(
                          //       title: Text("Login Failed"),
                          //       content: Text("Invalid email or password.",style: TextStyle(fontSize: 15,),),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () => Navigator.pop(context),
                          //           child: Text("OK",style: TextStyle(fontSize: 25,),),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }
                        },
                  child: _isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(0, 0),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    emailController.clear();
                    passwordController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      decorationThickness: 2,
                      height: 2,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    emailController.clear();
                    passwordController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccount()),
                    );
                  },
                  child: Text(
                    "New User? create account",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      decorationThickness: 2,
                      height: 2,
                    ),
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
