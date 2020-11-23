import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import './index.dart' show EditProduct;
import '../../../widget/index.dart';
import '../../../providers/index.dart' show ProductProvider;
import '../../../models/store/index.dart';
import '../../../theme/index.dart';
import '../../../util/index.dart' show Http;

const rupeeSymbol = '\u20B9';

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
        'Thriving communities, empowering people',
        'Made by awesome team of Botiga',
      );
    }
    return SafeArea(
      child: LoaderOverlay(
        isLoading: _isApiInProgress,
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SearchBar(
                  placeholder: 'Search by product name...',
                  onClear: () {
                    setState(() {
                      _query = '';
                    });
                  },
                  onChange: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  onSubmit: (_) {},
                ),
              ),
              (_query != '' && _query != null)
                  ? Expanded(
                      child: ListView(
                        children: <Widget>[
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
                        children: <Widget>[
                          ..._products.map((productWithCategory) {
                            return getTile(
                                context,
                                productWithCategory,
                                this._setApiInProgressStatus,
                                this._setNetworkImageStatus,
                                _imageStatus);
                          })
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItemRow extends StatefulWidget {
  final Product product;
  final Function setProductAvilablity;
  final Function onOpen;
  final Function setImageStatus;
  ProductItemRow(this.product, this.setProductAvilablity, this.onOpen,
      this.setImageStatus);
  @override
  _ProductItemRowState createState() => _ProductItemRowState();
}

class _ProductItemRowState extends State<ProductItemRow> {
  bool _switchValue = false;
  bool _showWithImage = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _switchValue = widget.product.available;
    });
  }

  Widget getRowWithProductImage(Product product, String statusText) {
    if (_showWithImage == false) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ColorFiltered(
                  colorFilter: _switchValue
                      ? ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : ColorFilter.mode(
                          AppTheme.backgroundColor,
                          BlendMode.saturation,
                        ),
                  child: ProductNetworkAvatar(
                    imageUrl: '${product.imageUrl}',
                    func: () {
                      setState(() {
                        _showWithImage = false;
                      });
                    },
                  )),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 90,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          '${product.name}',
                          style: AppTheme.textStyle.color100
                              .size(15)
                              .lineHeight(1.33)
                              .w500,
                        ),
                        Text(
                          '${product.size}',
                          style: AppTheme.textStyle.color50
                              .size(13)
                              .lineHeight(1.33)
                              .w500
                              .letterSpace(0.5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 60,
                              ),
                              child: Text(
                                '$rupeeSymbol${product.price}',
                                style: AppTheme.textStyle.color100
                                    .size(13)
                                    .lineHeight(1.33)
                                    .w500
                                    .letterSpace(0.5),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 80,
                                  ),
                                  child: Text(
                                    statusText,
                                    textAlign: TextAlign.center,
                                    style: AppTheme.textStyle.color50
                                        .size(12)
                                        .lineHeight(1.33)
                                        .w500
                                        .letterSpace(0.2),
                                  ),
                                ),
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.75,
                                  child: CupertinoSwitch(
                                    value: _switchValue,
                                    onChanged: (bool value) {
                                      setState(
                                        () {
                                          _switchValue = value;
                                        },
                                      );
                                      widget.setProductAvilablity(
                                          widget.product, value, () {
                                        setState(() {
                                          _switchValue = !value;
                                        });
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
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
                      style: AppTheme.textStyle.color50
                          .size(12)
                          .lineHeight(1.5)
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

  Widget getRowWithoutProductImage(Product product, String statusText) {
    if (_showWithImage == true) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 70,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 180,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.name}',
                                style: AppTheme.textStyle.color100
                                    .size(15)
                                    .lineHeight(1.33)
                                    .w500,
                              ),
                              Text(
                                '${product.size} . $rupeeSymbol${product.price}',
                                style: AppTheme.textStyle.color50
                                    .size(13)
                                    .lineHeight(1.33)
                                    .w500
                                    .letterSpace(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 80,
                            ),
                            child: Text(
                              statusText,
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyle.color50
                                  .size(12)
                                  .lineHeight(1.33)
                                  .w500
                                  .letterSpace(0.2),
                            ),
                          ),
                          Transform.scale(
                            alignment: Alignment.centerRight,
                            scale: 0.75,
                            child: CupertinoSwitch(
                              value: _switchValue,
                              onChanged: (bool value) {
                                setState(
                                  () {
                                    _switchValue = value;
                                  },
                                );
                                widget.setProductAvilablity(
                                    widget.product, value, () {
                                  setState(() {
                                    _switchValue = !value;
                                  });
                                });
                              },
                            ),
                          )
                        ],
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
                      style: AppTheme.textStyle.color50
                          .size(12)
                          .lineHeight(1.5)
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

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    String statusText = _switchValue ? "Available" : "Not Available";
    widget.setImageStatus(product.id, _showWithImage);
    return GestureDetector(
      onTap: () {
        widget.onOpen();
      },
      child: Column(
        children: [
          getRowWithProductImage(product, statusText),
          getRowWithoutProductImage(product, statusText)
        ],
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
                      return OpenContainer(
                        closedElevation: 0.0,
                        transitionDuration: Duration(milliseconds: 500),
                        closedBuilder: (context, openContainer) =>
                            ProductItemRow(entry.value, setProductAvilablity,
                                openContainer, setImageStatus),
                        openBuilder: (_, __) => EditProduct(
                            productId: entry.value.id,
                            categoryId: productWithCategory.categoryId,
                            categoryName: productWithCategory.name,
                            showWithImage: imageStatus[entry.value.id]),
                      );
                    }
                    return Column(
                      children: [
                        OpenContainer(
                          closedElevation: 0.0,
                          transitionDuration: Duration(milliseconds: 500),
                          closedBuilder: (context, openContainer) =>
                              ProductItemRow(entry.value, setProductAvilablity,
                                  openContainer, setImageStatus),
                          openBuilder: (_, __) => EditProduct(
                              productId: entry.value.id,
                              categoryId: productWithCategory.categoryId,
                              categoryName: productWithCategory.name,
                              showWithImage: imageStatus[entry.value.id]),
                        ),
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
              transitionDuration: Duration(milliseconds: 500),
              closedBuilder: (context, openContainer) => ProductItemRow(
                  product, setProductAvilablity, openContainer, setImageStatus),
              openBuilder: (_, __) => EditProduct(
                  productId: product.id,
                  categoryId: productWithCategory.categoryId,
                  categoryName: productWithCategory.name,
                  showWithImage: imageStatus[product.id]),
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
