import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/index.dart';
import '../../../providers/Store/Category/CategoryProvider.dart';
import '../../../providers/Store/Product/ProductProvider.dart';
import '../../../models/Store/Category/StoreCategory.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool _isProcessing = false;

  void setStatus(bool status) {
    setState(() {
      _isProcessing = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<StoreCategory> categories =
        Provider.of<CategoryProvider>(context, listen: false).allCategories;
    return (categories == null || categories.length == 0)
        ? EmptyOrders()
        : SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView(
                    children: <Widget>[
                      ...categories.map((category) {
                        return getTile(context, category, this.setStatus);
                      })
                    ],
                  ),
                ),
                _isProcessing ? Loader() : SizedBox.shrink()
              ],
            ),
          );
  }
}

Widget getTile(
    BuildContext context, StoreCategory category, Function setStatus) {
  final productProvider = Provider.of<ProductProvider>(context, listen: false);
  final productCount = productProvider.productCountForCategory(category.id);
  final countDispaly = productCount < 10 ? '0$productCount' : productCount;
  return Column(
    children: <Widget>[
      ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: RichText(
          text: TextSpan(
            text: '$countDispaly',
            style: AppTheme.textStyle.color50.w600.size(12).letterSpace(1),
            children: <TextSpan>[
              TextSpan(
                text: ' ',
                style: AppTheme.textStyle.letterSpace(20),
              ),
              TextSpan(
                text: '${category.name.toUpperCase()}',
                style: AppTheme.textStyle.color100.w600.size(12).letterSpace(1),
              ),
            ],
          ),
        ),
        trailing: productCount != 0
            ? Icon(
                Icons.delete_sharp,
                color: AppTheme.color50,
              )
            : GestureDetector(
                child: Icon(
                  Icons.delete_sharp,
                  color: AppTheme.color100,
                ),
                onTap: () {
                  setStatus(true);
                  final categoryProvide =
                      Provider.of<CategoryProvider>(context, listen: false);
                  categoryProvide.deleteCategory(category.id).then((value) {
                    categoryProvide.fetchCategories().then((value) {
                      setStatus(false);
                    }).catchError((error) {
                      setStatus(false);
                    });
                    Toast(message: '$value', iconData: BotigaIcons.truck)
                        .show(context);
                  }).catchError((error) {
                    setStatus(false);
                    Toast(
                            message: '$error',
                            iconData: Icons.error_outline_sharp)
                        .show(context);
                  });
                },
              ),
      ),
      Divider(
        color: AppTheme.dividerColor,
        thickness: 1.2,
      ),
    ],
  );
}
