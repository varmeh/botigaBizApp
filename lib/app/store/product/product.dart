import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/store/index.dart';
import '../../../providers/index.dart' show ProductProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart' show Http;
import '../../../widget/index.dart';
import 'index.dart' show EditProduct;
import 'productItemRow.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _isApiInProgress;
  String _query;
  Map _imageStatus = Map();

  @override
  void initState() {
    super.initState();
    _query = '';
    _isApiInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setApiInProgressStatus(bool status) {
    setState(() {
      _isApiInProgress = status;
    });
  }

  _setNetworkImageStatus(String productId, bool status) {
    _imageStatus[productId] = status;
  }

  @override
  Widget build(BuildContext context) {
    final _products =
        Provider.of<ProductProvider>(context, listen: true).allProducts;
    if (_products.length == 0) {
      return BrandingTile(
        'Add your wonderful products here',
        'Make sure to add categories in Category tab before adding any products',
      );
    }
    return SafeArea(
      child: LoaderOverlay(
        isLoading: _isApiInProgress,
        child: GestureDetector(
          onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: SearchBar(
                    placeholder: 'Search by product name...',
                    onClear: () => setState(() => _query = ''),
                    onChange: (value) => setState(() => _query = value),
                    onSubmit: (_) {},
                  ),
                ),
                (_query != '' && _query != null)
                    ? Expanded(
                        child: ListView(
                          children: [
                            ..._products.map((productWithCategory) {
                              return getProductTile(
                                  context,
                                  productWithCategory,
                                  this._setApiInProgressStatus,
                                  _query,
                                  this._setNetworkImageStatus,
                                  _imageStatus);
                            })
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          children: [
                            ..._products.map((productWithCategory) {
                              return getTile(
                                context,
                                productWithCategory,
                                this._setApiInProgressStatus,
                                this._setNetworkImageStatus,
                                _imageStatus,
                              );
                            })
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget getTile(BuildContext context, ProductByCategory productWithCategory,
    Function setApiStatus, Function setImageStatus, Map imageStatus) {
  void setProductAvilablity(
      Product product, bool availabelStatus, Function onFail) async {
    try {
      setApiStatus(true);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      await productProvider.updateProductStatus(
        productWithCategory.categoryId,
        product,
        availabelStatus,
      );

      await productProvider.fetchProducts();

      Toast(
        message: 'Product status updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (error) {
      onFail();
      Toast(message: Http.message(error)).show(context);
    } finally {
      setApiStatus(false);
    }
  }

  final theme = Theme.of(context).copyWith(
    accentColor: AppTheme.color100,
    dividerColor: Colors.transparent,
    unselectedWidgetColor: AppTheme.color100,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
  );

  final totalProducts = productWithCategory.products.length < 10
      ? '0${productWithCategory.products.length}'
      : '${productWithCategory.products.length}';

  return Column(
    children: [
      Theme(
        data: theme,
        child: ListTileTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: AppTheme.color100,
                      thickness: 1,
                      indent: 0,
                      endIndent: 285,
                    ),
                  ),
                  ...productWithCategory.products.asMap().entries.map((entry) {
                    return Column(
                      children: [
                        OpenContainer(
                          closedElevation: 0.0,
                          transitionDuration: Duration(milliseconds: 300),
                          closedBuilder: (context, openContainer) =>
                              ProductItemRow(entry.value, setProductAvilablity,
                                  openContainer, setImageStatus),
                          openBuilder: (_, __) => EditProduct(
                            productId: entry.value.id,
                            categoryId: productWithCategory.categoryId,
                            categoryName: productWithCategory.name,
                          ),
                        ),
                        entry.key != productWithCategory.products.length - 1
                            ? Divider(
                                color: AppTheme.dividerColor,
                                thickness: 1.2,
                              )
                            : Container(),
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

Widget getProductTile(
    BuildContext context,
    ProductByCategory productWithCategory,
    Function setApiStatus,
    String _query,
    Function setImageStatus,
    Map imageStatus) {
  void setProductAvilablity(
      Product product, bool availabelStatus, Function onFail) async {
    try {
      setApiStatus(true);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.updateProductStatus(
          productWithCategory.categoryId, product, availabelStatus);
      await productProvider.fetchProducts();
      Toast(
        message: 'Product status updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (error) {
      onFail();
      Toast(message: Http.message(error)).show(context);
    } finally {
      setApiStatus(false);
    }
  }

  return Column(
    children: [
      ...productWithCategory.products
          .where((product) =>
              product.name.toLowerCase().contains(_query.toLowerCase()))
          .map((product) {
        return Column(
          children: [
            OpenContainer(
              closedElevation: 0.0,
              transitionDuration: Duration(milliseconds: 300),
              closedBuilder: (context, openContainer) => ProductItemRow(
                  product, setProductAvilablity, openContainer, setImageStatus),
              openBuilder: (_, __) => EditProduct(
                productId: product.id,
                categoryId: productWithCategory.categoryId,
                categoryName: productWithCategory.name,
              ),
            ),
            Divider(
              color: AppTheme.dividerColor,
              thickness: 1.2,
            ),
          ],
        );
      })
    ],
  );
}
