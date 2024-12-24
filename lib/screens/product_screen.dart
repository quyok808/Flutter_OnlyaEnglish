import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Product>> productList;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int? currentEditingId;

  @override
  void initState() {
    super.initState();
    productList = apiService.getProducts();
  }

  void _resetForm() {
    currentEditingId = null;
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Product product = Product(
        id: currentEditingId,
        name: nameController.text,
        price: double.parse(priceController.text),
        description: descriptionController.text,
      );

      try {
        if (currentEditingId == null) {
          await apiService.addProduct(product);
        } else {
          await apiService.updateProduct(product);
        }
        setState(() {
          productList = apiService.getProducts();
        });
        _resetForm();
      } catch (e) {
        print(e);
      }
    }
  }

  void _editProduct(Product product) {
    setState(() {
      currentEditingId = product.id;
      nameController.text = product.name;
      priceController.text = product.price.toString();
      descriptionController.text = product.description;
    });
  }

  void _deleteProduct(int id) async {
    try {
      await apiService.deleteProduct(id);
      setState(() {
        productList = apiService.getProducts();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý sản phẩm"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Tên sản phẩm"),
                    validator: (value) =>
                        value!.isEmpty ? "Nhập tên sản phẩm" : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: "Giá sản phẩm"),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Nhập giá sản phẩm" : null,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: "Mô tả"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(currentEditingId == null
                        ? "Thêm sản phẩm"
                        : "Cập nhật sản phẩm"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi tải dữ liệu"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text("Giá: ${product.price}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editProduct(product),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteProduct(product.id!),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
