import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchState();
}

class SearchState extends State<Search> {
  //search controller
  final searchController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
        isSearching = searchQuery.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  hint: Text("Search here..."),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            if (isSearching) ...[
              buildSearchResult(),
            ] else ...[
              SizedBox(height: 50),
              //popular section
              buildPopularProducts(),
              SizedBox(height: 30),
              //trending section
              buildTrendingProducts(),
              SizedBox(height: 30),
              //Buttons
              OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    BorderSide(color: Colors.purple.shade200, width: 2),
                  ),
                ),
                onPressed: () {},
                child: Text("Offers", style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(height: 10,),
              OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    BorderSide(color: Colors.purple.shade200, width: 2),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Explore more",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 50),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildPopularProducts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No product(s) matches your search");
        }
        final docs = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Popular products", style: TextStyle(fontSize: 20)),
                Icon(Icons.shopping_bag),
              ],
            ),
            SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: data['imageUrl'] != null
                                ? DecorationImage(
                                    image: NetworkImage(data['imageUrl']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Text(
                          data['name'] ?? ' ',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildTrendingProducts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy("createdAt", descending: true)
          .limit(7)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No product(s) available");
        }

        final docs = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Trending Now", style: TextStyle(fontSize: 20)),
                Icon(Icons.trending_up),
              ],
            ),
            SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: data['imageUrl'] != null
                                ? DecorationImage(
                                    image: NetworkImage(data['imageUrl']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Text(
                          data['name'] ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSearchResult() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('productName', isGreaterThanOrEqualTo: searchQuery)
          .where('productName', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No products(s) found for\"$searchQuery\""),
          );
        }
        final results = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: product['imageUrl'] != null
                  ? Image.network(
                      product['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.image),
              title: Text(product['productName'] ?? 'name'),
              subtitle: Text("₹${product['price'] ?? '--'}"),
            );
          },
        );
      },
    );
  }
}
