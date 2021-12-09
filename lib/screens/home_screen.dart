import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_assigment/models/product_model.dart';
import 'package:flutter_assigment/utils/free_functions.dart';
import 'package:flutter_assigment/widgets/product_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    initialGetSaved();
    super.initState();
  }

  final List<ProductModel> list = List<ProductModel>.empty(growable: true);

  bool isEmpty = true;

  void initialGetSaved() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString('product') != null) {
        var productJson = sharedPreferences.getString('product');
        List data = await json.decode(productJson!);
        list.clear();
        data.asMap().forEach((index, jsonData) {
          ProductModel levelModel = ProductModel(jsonData['name'], jsonData['launchedAt'], jsonData['launchSite'], jsonData['popularity']);
          setState(() {
            list.add(levelModel);
          });
        });
        if (list.isEmpty && list.length == 0) {
          setState(() {
            isEmpty = true;
          });
        } else {
          setState(() {
            isEmpty = false;
          });
        }
      }
    } catch (Excepetion) {
      debugPrint(Excepetion.toString());
    }
  }

  String layout = 'grid';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Flutter Assignment ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddProductScreen(
                          isEdit: false,
                          isIndex: 0,
                        )),
              );
              if (result == "update") {
                initialGetSaved();
              }
            },
          )
        ],
        backgroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: screenWidth(context: context),
              child: isEmpty
                  ? Center(child: const Text("No Products Available"))
                  : Column(
                      children: [
                        Visibility(
                          visible: screenWidth(context: context) >= 600 && kIsWeb == true ? true : false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    this.layout = 'list';
                                  });
                                },
                                icon: Icon(
                                  Icons.format_list_bulleted,
                                  color: this.layout == 'list' ? Colors.black : Theme.of(context).focusColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    this.layout = 'grid';
                                  });
                                },
                                icon: Icon(
                                  Icons.apps,
                                  color: this.layout == 'grid' ? Colors.black : Theme.of(context).focusColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (screenWidth(context: context) >= 600)
                                  ? layout == "grid"
                                      ? 3
                                      : 1
                                  : 1,
                              childAspectRatio: (screenWidth(context: context) >= 600)
                                  ? layout == "grid"
                                      ? screenWidth(context: context) / (screenHeight(context: context) / 2)
                                      : screenWidth(context: context) / (screenHeight(context: context) / 6)
                                  : screenWidth(context: context) / (screenHeight(context: context) / 6),
                            ),
                            itemCount: list.length,
                            itemBuilder: (_, index) {
                              return ProductItem(
                                productModel: list[index],
                                onDeleteClick: (value) {
                                  showAlertDialog(context, index);
                                },
                                onEditClick: (value) async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddProductScreen(
                                              isEdit: true,
                                              isIndex: index,
                                            )),
                                  );
                                  if (result == "update") {
                                    initialGetSaved();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, int isIndex) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget deleteButton = TextButton(
      child: Text("Delete"),
      onPressed: () async {
        List<dynamic> insertList = [];
        sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.getString('product') != null) {
          var product_json = sharedPreferences.getString('product');
          await json.decode(product_json!).asMap().forEach((index, jsondata) {
            if (isIndex == index) {
              ProductModel levelModel =
                  ProductModel(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
              insertList.remove(levelModel);
            } else {
              ProductModel levelModel =
                  ProductModel(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
              insertList.add(json.encode(levelModel.toMap()));
            }
          });
        }
        sharedPreferences.setString('product', insertList.toString()).then((value) {
          initialGetSaved();
          Navigator.pop(context);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: const Text("Are you sure want to delete.?"),
      actions: [cancelButton, deleteButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
