import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexaflow/DataBase/remote/firebaseauth.dart';
import 'package:nexaflow/homepage.dart';
import 'package:nexaflow/underconstruction.dart';
import 'package:path/path.dart';
import 'package:nexaflow/login_UI.dart';

class Addproducts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddproductsState();
}

class AddproductsState extends State<Addproducts> {

  Future<void>MoveToHome(BuildContext context)async
  {
   // await Future.delayed(Duration(milliseconds: 100));
    final user =RemoteDb.instance.getCurrentUser();
    if(user==null) return;
    try{
      final doc= await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if(!doc.exists) return;

      final userData = doc.data()!;
      final userName = userData['name'] ?? "User";
      final userPhone = userData['phone'] ?? "Not available";
      final profileUrl = userData["profileUrl"] ?? " ";
      if (!context.mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(builder:(_)=>HomePage(
              userName: userName,
              phoneNumber: userPhone,
              profileUrl: profileUrl
          )
          ));

    }
        catch(e){
      print("Error in MoveToHome():$e");
        }


  }


  bool isAdding = false;

  @override
  Widget build(BuildContext context) {

    //trending and popular controller

    //controllers for add products dialog box
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final urlController = TextEditingController();
    final stockController = TextEditingController();
    //controllers for billing
    final numberController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NexaFlow",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              //default size~200
              decoration: BoxDecoration(color: Colors.purple[300]),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Admin!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.currency_exchange),
              title: Text("Start billing"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    title: Row(
                      children: [
                        Text("Authenticate"),
                        SizedBox(width: 2),
                        Icon(Icons.lock),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: numberController,
                            decoration: InputDecoration(
                              hintText: "Customer's phone no.",
                              labelText: "Phone",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11.0),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "OR",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Verify"),
                                  content: Icon(Icons.fingerprint, size: 100),
                                ),
                              );
                            },
                            child: Text(
                              "Use biometric",
                              style: TextStyle(
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
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ok"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.view_carousel),
              title: Text("Change carousel image(s)"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible:false,
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Update carousel"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(),
                          TextField(),
                          TextField(),
                          TextField(),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: ()=>Navigator.pop(context),child: Text("Cancel")),
                      TextButton(onPressed: ()=>Navigator.pop(context),child: Text("Update")),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading:Icon(Icons.home),
              title: Text("View home page"),
              onTap:(){
                Navigator.pop(context);
                MoveToHome(context);
              }

            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log out"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.purple[50],
                    title: Text("Log out"),
                    content: Text("Are you sure want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await RemoteDb.instance.logoutUser();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Logged out successfully"),
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Login_UI()),
                                (route) => false,
                          );
                        },
                        child: Text("Log out"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 50),
            backgroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey,
          ),
          onPressed: () {
            showDialog(

              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.purple.shade300, width: 3),
                ),
                title: Row(
                  children: [
                    Text("Add products"),
                    SizedBox(width: 5),
                    Icon(Icons.add_circle_outline),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Enter product Name",
                          labelText: "Product Name",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.0),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: categoryController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter product Category",
                          labelText: "Category",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.0),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: descController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter product Description",
                          labelText: "Description",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.0),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter product Price(₹)",
                          labelText: "Price(₹)",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.0),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: urlController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          hintText: "Enter product Image(URL)",
                          labelText: "Image URL",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.0),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter product Quantity",
                          labelText: "Stock",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11.0),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),

                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      nameController.clear();
                      categoryController.clear();
                      descController.clear();
                      priceController.clear();
                      urlController.clear();
                      stockController.clear();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: isAdding
                        ? null
                        : () async {
                            final name = nameController.text.trim();
                            final category = categoryController.text.trim();
                            final description = descController.text.trim();
                            final price =
                                double.tryParse(priceController.text.trim()) ??
                                0;
                            final imgUrl = urlController.text.trim();
                            final stock =
                                double.tryParse(stockController.text.trim()) ??
                                0;
                            if (name.isEmpty || price == 0 || stock <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please enter valid product details",
                                  ),
                                ),
                              );
                              return;
                            } else {
                              setState(() => isAdding = true);
                              final (success, errorMsg) = await RemoteDb
                                  .instance
                                  .addProducts(
                                    name: name,
                                    price: price,
                                    description: description,
                                    imageUrl: imgUrl,
                                    category: category,
                                    stock: stock,
                                  );
                              setState(() => isAdding = false);
                              if (success) {
                                Navigator.pop(context);
                                nameController.clear();
                                categoryController.clear();
                                descController.clear();
                                priceController.clear();
                                urlController.clear();
                                stockController.clear();
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.purple[50],
                                    title: Row(
                                      children: [
                                        Text("Success"),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    content: Text("Product added successfully"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.purple[50],
                                    title: Row(
                                      children: [
                                        Text("Error"),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      errorMsg ?? "Something went wrong",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                    child: isAdding
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text("Add"),
                  ),
                ],
              ),
            );
          },
          child: Text(
            "Add Products",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.purple.shade800,
            ),
          ),
        ),
      ),
    );
  }
}
