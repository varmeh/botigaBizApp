import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/store/index.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart';

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
    String statusText = _switchValue ? 'Available' : 'Not Available';
    return GestureDetector(
      onTap: () => widget.onOpen(),
      child: Container(child: this.getProductRow(product, statusText)),
    );
  }

  Widget getProductRow(Product product, String statusText) {
    if (product.imageUrl != null &&
        product.imageUrl != '' &&
        product.imageUrl.startsWith('https://')) {
      return getRowWithProductImage(product, statusText);
    } else {
      return getRowWithoutProductImage(product, statusText);
    }
  }

  Widget getRowWithProductImage(Product product, String statusText) {
    widget.setImageStatus(product.id, true);
    final _hasTag = product.tag != null && product.tag.isNotEmpty;
    final _hasMrp = product.mrp != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
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
                      ),
                    ),
                    _hasTag
                        ? Positioned(
                            top: -14,
                            child: _tag(),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                              '${product.size}',
                              style: AppTheme.textStyle.color50
                                  .size(13)
                                  .lineHeight(1.33)
                                  .w500
                                  .letterSpace(0.5),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                _hasMrp
                                    ? Text(
                                        '₹${product.mrp}',
                                        style: AppTheme.textStyle.color50
                                            .size(13)
                                            .lineHeight(1.33)
                                            .w500
                                            .letterSpace(0.5)
                                            .lineThrough,
                                      )
                                    : Container(),
                                Text(
                                  '₹${product.price}',
                                  style: AppTheme.textStyle.color100
                                      .size(13)
                                      .lineHeight(1.33)
                                      .w500
                                      .letterSpace(0.5),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 90),
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
                                BotigaSwitch(
                                  handleSwitchChage: (bool value) {
                                    setState(() => _switchValue = value);
                                    widget.setProductAvilablity(
                                        widget.product, value, () {
                                      setState(() => _switchValue = !value);
                                    });
                                  },
                                  switchValue: _switchValue,
                                  alignment: Alignment.centerRight,
                                ),
                              ],
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
      ),
    );
  }

  Widget getRowWithoutProductImage(Product product, String statusText) {
    widget.setImageStatus(product.id, false);
    final _hasTag = product.tag != null && product.tag.isNotEmpty;

    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hasTag
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _tag(),
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 180),
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
                                '${product.size} ・ ₹${product.price}',
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
                          BotigaSwitch(
                            handleSwitchChage: (bool value) {
                              setState(
                                () {
                                  _switchValue = value;
                                },
                              );
                              widget.setProductAvilablity(widget.product, value,
                                  () {
                                setState(() {
                                  _switchValue = !value;
                                });
                              });
                            },
                            switchValue: _switchValue,
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      )
                    ],
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
      ),
    );
  }

  Widget _tag() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Color(0xffffd953),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 6.0,
      ),
      child: Text(
        widget.product.tag.toUpperCase(),
        style: AppTheme.textStyle.w600.color100
            .size(12)
            .lineHeight(1.3)
            .letterSpace(0.2),
      ),
    );
  }
}
