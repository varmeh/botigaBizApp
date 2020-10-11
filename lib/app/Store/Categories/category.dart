import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import '../../../providers/Store/Category/CategoryProvider.dart';
import '../../../models/Store/Category/StoreCategory.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<StoreCategory> categories =
        Provider.of<CategoryProvider>(context, listen: false).allCategories;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            ...categories.map((category) {
              return getTile(context, category);
            })
          ],
        ),
      ),
    );
  }
}

Widget getTile(BuildContext context, StoreCategory category) {
  return Column(
    children: <Widget>[
      ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: RichText(
          text: TextSpan(
            text: '00',
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
        trailing: GestureDetector(
          child: Icon(
            Icons.delete_sharp,
            color: AppTheme.color100,
          ),
          onTap: () {
            final categoryProvide =
                Provider.of<CategoryProvider>(context, listen: false);
            categoryProvide.deleteCategory(category.id).then((value) {
              Flushbar(
                maxWidth: 335,
                backgroundColor: Color(0xff2591B2),
                messageText: Text(
                  'Deleted',
                  style: AppTheme.textStyle
                      .colored(AppTheme.surfaceColor)
                      .w500
                      .size(15),
                ),
                icon: Icon(Icons.check_circle_outline_sharp,
                    size: 30, color: AppTheme.surfaceColor),
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: Duration(seconds: 3),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                borderRadius: 8,
              ).show(context);
              categoryProvide.fetchCategories();
            }).catchError((error) {
              Flushbar(
                maxWidth: 335,
                backgroundColor: Theme.of(context).errorColor,
                messageText: Text(
                  '$error',
                  style: AppTheme.textStyle
                      .colored(AppTheme.surfaceColor)
                      .w500
                      .size(15),
                ),
                icon: Icon(Icons.error_outline_outlined,
                    size: 30, color: AppTheme.surfaceColor),
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: Duration(seconds: 3),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                borderRadius: 8,
              ).show(context);
            });
          },
        ),
      ),
      Divider(
        color: AppTheme.backgroundColor,
        thickness: 1.2,
      ),
    ],
  );
}
