import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/constants.dart';
import '../../../providers/Store/Product/ProductProvider.dart';
import '../../../models/Store/Product/ProductByCategory.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _isLoading = false;
  bool _isError = false;
  bool _isInit = false;
  List<ProductByCategory> _products;

  @override
  void initState() {
    super.initState();
  }

  void fetchProducts() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      _isError = false;
      _isLoading = true;
    });
    productProvider.fetchProducts().then((_) {
      setState(() {
        _isLoading = false;
        _products = productProvider.allProducts;
      });
    }).catchError((err) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      fetchProducts();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isError
            ? Center(
                child: Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: ListView(
                    children: <Widget>[
                      // TextField(
                      //   style: TextStyle(
                      //     fontSize: 15.0,
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.normal,
                      //   ),
                      //   decoration: InputDecoration(
                      //     fillColor: Theme.of(context).backgroundColor,
                      //     filled: true,
                      //     contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                      //     suffixIcon: Icon(
                      //       Icons.search,
                      //       color: Color(0xff121715),
                      //     ),
                      //     hintText: "Search...",
                      //     enabledBorder: const OutlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      ..._products.map((productWithCategory) {
                        return getTile(context, productWithCategory);
                      })
                    ],
                  ),
                ),
              );
  }
}

Widget getTile(BuildContext context, ProductByCategory productWithCategory) {
  final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent);
  final totalProducts = productWithCategory.products.length < 10
      ? '0${productWithCategory.products.length}'
      : '${productWithCategory.products.length}';
  return Column(
    children: <Widget>[
      Theme(
        data: theme,
        child: ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: ExpansionTile(
            title: RichText(
              text: TextSpan(
                text: '$totalProducts',
                style: AppTheme.textStyle.w600.size(12).color50.letterSpace(1),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ',
                    style: AppTheme.textStyle.letterSpace(20),
                  ),
                  TextSpan(
                    text: '${productWithCategory.name.toUpperCase()}',
                    style: AppTheme.textStyle.w600
                        .size(12)
                        .color100
                        .letterSpace(1),
                  ),
                ],
              ),
            ),
            children: [
              Column(
                children: [
                  Divider(
                    color: AppTheme.color100,
                    thickness: 1,
                    indent: 0,
                    endIndent: 285,
                  ),
                  ...productWithCategory.products.asMap().entries.map((entry) {
                    int idx = entry.key;
                    if (idx == productWithCategory.products.length - 1) {
                      return ProductItemRow(entry.value);
                    }
                    return Column(
                      children: [
                        ProductItemRow(entry.value),
                        Divider(
                          color: AppTheme.dividerColor,
                          thickness: 1.2,
                        ),
                      ],
                    );
                  })
                ],
              )
            ],
          ),
        ),
      ),
      Divider(
        color: AppTheme.dividerColor,
        thickness: 1.2,
      ),
    ],
  );
}

class ProductItemRow extends StatefulWidget {
  final Product product;
  ProductItemRow(this.product);
  @override
  _ProductItemRowState createState() => _ProductItemRowState();
}

class _ProductItemRowState extends State<ProductItemRow> {
  bool _switchValue = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _switchValue = widget.product.available;
    });
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;

    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.spendwithpennies.com/wp-content/uploads/2015/10/Chocolate-Ganache-22.jpg')),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${product.name}',
                              style: AppTheme.textStyle.color100.size(15).w500,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${product.size} .${Constants.rupeeSymbol}${product.price}',
                              style: AppTheme.textStyle.color50
                                  .size(13)
                                  .w500
                                  .letterSpace(0.5),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            _switchValue
                                ? Text(
                                    "Available",
                                    style: AppTheme.textStyle.color100
                                        .size(12)
                                        .w500
                                        .letterSpace(0.2),
                                  )
                                : Text(
                                    "Not Available",
                                    style: AppTheme.textStyle.color100
                                        .size(12)
                                        .w500
                                        .letterSpace(0.2),
                                  ),
                            Transform.scale(
                              alignment: Alignment.topRight,
                              scale: 0.75,
                              child: CupertinoSwitch(
                                value: _switchValue,
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      _switchValue = value;
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          (product.description != null && product.description != '')
              ? Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${product.description}',
                      style: AppTheme.textStyle.color100
                          .size(12)
                          .w500
                          .letterSpace(0.2),
                    ),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
