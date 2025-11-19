import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexaflow/Cart.dart';
import 'package:nexaflow/DataBase/remote/firebaseauth.dart';
import 'package:nexaflow/billing_page.dart';
import 'package:nexaflow/login_UI.dart';
import 'package:nexaflow/search_page.dart';
import 'package:nexaflow/DataBase/local/db_helper.dart';
import 'package:nexaflow/underconstruction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexaflow/models/productModel.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String profileUrl;
  HomePage({
    required this.userName,
    required this.phoneNumber,
    required this.profileUrl,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRolMqJPkwobHreSrM7P2_lLvztZCOT8sem-w&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVyV2Ncmx02i_bUYrUOYFHQdodIxuR4oiPVQ&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOSOMQ1hWcUnqhdqac8CdsLDTw1TMLQIPT4g&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt1NOI5QkaGE3S2GkTUT5PbSKcAJLp4YEFlw&s",
    ];

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
              //default size ~200
              decoration: BoxDecoration(color: Colors.purple[300]),

              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //user image
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: widget.profileUrl.trim().isNotEmpty
                          ? NetworkImage(widget.profileUrl)
                          : AssetImage('lib/assets/images/default_avatar.jpeg')
                                as ImageProvider,
                    ),
                    //user details
                    SizedBox(height: 5),
                    Text(
                      widget.userName,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.phoneNumber,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            icon: Icon(Icons.expand_more, color: Colors.black),
                            underline:
                                Container(), //removes the default underline
                            items: <String>["Edit Profile", "Change Password"]
                                .map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (value) {
                              if (value == "Edit Profile") {
                                Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (_)=>underconstruction()));
                              } else if (value == "Change Password") {
                                Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder:(_)=>underconstruction()));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.search_outlined),
              title: Text("Search"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Search()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Cart"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => cart()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => underconstruction()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Past orders"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => billing()),
                );
              },
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome back,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1),
            Text(
              "${widget.userName}!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 180.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          autoPlayInterval: Duration(seconds: 5),
                        ),
                        items: imageUrls.map((url) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        color: Colors.grey,
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey[700],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Image not available",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Error loading products"),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("No product available"),
                          );
                        }
                        final products = snapshot.data!.docs
                            .map(
                              (doc) => ProductModel.fromMap(
                                doc.data() as Map<String, dynamic>,
                              ),
                            )
                            .toList();
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount;
                            if (constraints.maxWidth >= 900) {
                              crossAxisCount = 4;
                            } else if (constraints.maxWidth >= 600) {
                              crossAxisCount = 3;
                            } else {
                              crossAxisCount = 2;
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.75,
                                  ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => underconstruction(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                            child:
                                                product.imageUrl
                                                    .trim()
                                                    .isNotEmpty
                                                ? Image.network(
                                                    product.imageUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (c, e, s) =>
                                                        Center(
                                                          child: Icon(
                                                            Icons.broken_image,
                                                          ),
                                                        ),
                                                  )
                                                : Container(
                                                    color: Colors.grey,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.productName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "₹${product.price.toStringAsFixed(2)}",
                                              ),
                                              SizedBox(height: 8),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Add"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.purple[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Divider(thickness: 2, color: Colors.purple[100]),
                          SizedBox(height: 8),
                          Text(
                            "thank you,",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "for shopping with us!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "© 2025 NexaFlow Inc.",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
