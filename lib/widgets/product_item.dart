import 'package:flutter/material.dart';
import 'package:flutter_assigment/models/product_model.dart';
import 'package:flutter_assigment/widgets/star_rating.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  final ValueChanged<ProductModel> onEditClick;
  final ValueChanged<ProductModel> onDeleteClick;

  const ProductItem({
    required this.productModel,
    required this.onEditClick,
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  productModel.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                )),
                SizedBox.fromSize(
                  size: const Size(35, 35), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: GestureDetector(
                        key: UniqueKey(),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onEditClick(productModel),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.edit,
                            ), // icon
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox.fromSize(
                    size: const Size(35, 35), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.red, // button color
                        child: GestureDetector(
                          key: UniqueKey(),
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onDeleteClick(productModel),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ), // icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: Text(
              productModel.launchedAt,
              style: const TextStyle(color: Colors.white),
            )),
            StarRating(
              rating: productModel.popularity,
              onRatingChanged: (rating) {
                productModel.popularity = rating;
              },
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
