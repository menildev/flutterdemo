import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assigment/models/product_model.dart';
import 'package:flutter_assigment/utils/free_functions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatefulWidget {
  final bool isEdit;
  final int isIndex;

  const AddProductScreen({Key? key, required this.isEdit, required this.isIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddProductScreenState();
  }
}

class AddProductScreenState extends State<AddProductScreen> {
  double _screenSize = 0;

  final nameController = TextEditingController();
  final launchedAtController = TextEditingController();
  final launchSiteController = TextEditingController();
  late double ratingCount = 0;

  late SharedPreferences sharedPreferences;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.isEdit) {
      getProductData();
    }

    super.initState();
  }

  void getProductData() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString('product') != null) {
        var product_json = sharedPreferences.getString('product');
        List data = await json.decode(product_json!);
        data.asMap().forEach((index, jsonData) {
          if (widget.isIndex == index) {
            setState(() {
              nameController.text = jsonData['name'];
              launchedAtController.text = jsonData['launchedAt'];
              launchSiteController.text = jsonData['launchSite'];
              ratingCount = jsonData['popularity'];
            });
          }
        });
      }
    } catch (Excepetion) {
      debugPrint(Excepetion.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() => _screenSize = screenWidth(context: context));
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.isEdit ? 'Edit Product' : 'Add Product',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: Container(
        padding: _screenSize >= 600
            ? EdgeInsets.symmetric(vertical: 30.0, horizontal: MediaQuery.of(context).size.width * 0.30)
            : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextFormField(
                controller: nameController,
                onChanged: (value) {},
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: launchedAtController,
                  enabled: true,
                  autofocus: false,
                  focusNode: new AlwaysDisabledFocusNode(),
                  onChanged: (value) {},
                  onTap: () {
                    _selectDate();
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Launched At',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: launchSiteController,
                  onChanged: (value) {},
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter launch site';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Launch Site',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text("Popularity", style: TextStyle(color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RatingBar.builder(
                  initialRating: ratingCount,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingCount = rating;
                    });
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO submit
                        if (widget.isEdit) {
                          updateProduct();
                        } else {
                          saveProduct();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  saveProduct() async {
    List<dynamic> insertList = [];
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString('product') != null) {
      var product_json = sharedPreferences.getString('product');
      await json.decode(product_json!).asMap().forEach((index, jsondata) {
        ProductModel levelModel = ProductModel(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
        insertList.add(json.encode(levelModel.toMap()));
      });
    }

    ProductModel productModel = ProductModel(nameController.text, launchedAtController.text, launchSiteController.text, ratingCount);
    insertList.add(json.encode(productModel.toMap()));

    sharedPreferences.setString('product', insertList.toString()).then((value) {
      Navigator.pop(context, "update");
    });
  }

  updateProduct() async {
    List<dynamic> insertList = [];
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('product') != null) {
      var product_json = sharedPreferences.getString('product');
      await json.decode(product_json!).asMap().forEach((index, jsondata) {
        if (widget.isIndex == index) {
          ProductModel productModel = ProductModel(nameController.text, launchedAtController.text, launchSiteController.text, ratingCount);
          insertList.insert(widget.isIndex, json.encode(productModel.toMap()));
        } else {
          ProductModel levelModel = ProductModel(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
          insertList.add(json.encode(levelModel.toMap()));
        }
      });
    }

    sharedPreferences.setString('product', insertList.toString()).then((value) {
      Navigator.pop(context, "update");
    });
  }

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        launchedAtController.text = formattedDate;
      });
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
