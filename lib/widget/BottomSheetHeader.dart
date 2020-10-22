import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final bool showBackBtn;

  BottomSheetHeader({@required this.title, this.showBackBtn = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            this.showBackBtn
                ? InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        BotigaIcons.arrowBack,
                        color: AppTheme.color100,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            this.showBackBtn
                ? SizedBox(
                    width: 16,
                  )
                : SizedBox.shrink(),
            Text(
              '$title',
              style: AppTheme.textStyle.size(22).w700.color100,
            ),
          ],
        ),
      ],
    );
  }
}
