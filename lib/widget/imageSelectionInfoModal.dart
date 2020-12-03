import 'package:flutter/material.dart';

import '../theme/index.dart';
import '../util/keyStore.dart';
import 'buttons/activeButton.dart';

class ImageSelectionInfoModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        padding: EdgeInsets.all(30),
        height: 403,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 84,
                        child: Image.asset(
                          "assets/images/landscape.png",
                          height: 68,
                          width: 121,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            margin: const EdgeInsets.only(right: 4.0),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: AppTheme.backgroundColor,
                            ),
                          ),
                          Text("Landscape",
                              style: AppTheme.textStyle.w500
                                  .colored(AppTheme.primaryColor)
                                  .size(14)
                                  .lineHeight(1.5)),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 84,
                        child: Image.asset(
                          "assets/images/portrait.png",
                          height: 84,
                          width: 48,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width: 16.0,
                              height: 16.0,
                              margin: const EdgeInsets.only(right: 4.0),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cancel,
                                size: 16,
                                color: AppTheme.backgroundColor,
                              )),
                          Text("Portrait",
                              style: AppTheme.textStyle.w500
                                  .colored(AppTheme.errorColor)
                                  .size(14)
                                  .lineHeight(1.5)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Text(
              "Upload Photo in Landscape",
              style: AppTheme.textStyle.size(20).lineHeight(1.33).w700.color100,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            ActiveButton(
              height: 52,
              title: "OK",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                onPressed: () async {
                  await KeyStore.setDontShowImageInfoModal();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Don’t show again",
                  style: AppTheme.textStyle.w600.size(15).color50,
                ))
          ],
        ),
      ),
    );
  }
}
