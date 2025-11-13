class ProductModel{
  final String productId;
  final String productName;
  final String category;
  final double price;
  final String description;
  final double stock;
  final String imageUrl;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.category,
    required this.price,
    required this.description,
    required this.stock,
    required this.imageUrl,
});
  factory ProductModel.fromMap(Map<String, dynamic>data)
  {
    return ProductModel(productId:data['productId']??" ",
        productName: data['productName']??" ",
        category: data['category']??' ',
        price: (data['price']??0).toDouble(),
        description: data['description']??" ",
        stock: (data['stock']??0).toDouble(),
        imageUrl: data['imageUrl']??' ',
    );
  }
}