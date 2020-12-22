import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';

import '../../../providers/index.dart';
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart'
    show
        PolicyWebiewScreen,
        Toast,
        LoaderOverlay,
        WhatsappIconButton,
        CallIconButton,
        InviteTile;
import '../../auth/index.dart' show Welcome;
import 'index.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isProcessing = false;
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    this._updateBuildInfo();
  }

  _updateBuildInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    setState(() {
      appVersion = version;
    });
  }

  _handleLogout() async {
    try {
      setState(() {
        isProcessing = true;
      });
      await Provider.of<ProfileProvider>(context, listen: false).logout();
      await Provider.of<ProductProvider>(context, listen: false).resetProduct();
      await Provider.of<CategoryProvider>(context, listen: false)
          .resetCategory();
      await Provider.of<OrdersProvider>(context, listen: false).resetOrder();
      await Provider.of<DeliveryProvider>(context, listen: false)
          .resetDelivery();
      await Provider.of<ProfileProvider>(context, listen: false).restProfile();
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        isProcessing = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Welcome.routeName, (route) => false);
    }
  }

  Widget build(BuildContext context) {
    final profileInfo =
        Provider.of<ProfileProvider>(context, listen: false).profileInfo;
    final arrowIcon = Icon(
      Icons.chevron_right,
      color: AppTheme.color50,
      size: 20,
    );

    return LoaderOverlay(
      isLoading: isProcessing,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(BussinessDetails.routeName);
                        },
                        leading: Icon(
                          BotigaIcons.suitcase,
                          color: AppTheme.color100,
                          size: 25,
                        ),
                        contentPadding: EdgeInsets.only(left: 0, right: 0),
                        title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text(
                            'Business details',
                            style: AppTheme.textStyle.color100.size(15).w500,
                          ),
                        ),
                        trailing: arrowIcon,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(StoreDeatils.routeName);
                        },
                        leading: Image.asset(
                          'assets/images/store_details.png',
                          width: 25,
                        ),
                        contentPadding: EdgeInsets.only(left: 0, right: 0),
                        title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text('Store details',
                              style: AppTheme.textStyle.color100.size(15).w500),
                        ),
                        trailing: arrowIcon,
                      ),
                      ListTile(
                        leading: Icon(
                          BotigaIcons.money,
                          color: AppTheme.color100,
                          size: 25,
                        ),
                        contentPadding: EdgeInsets.only(left: 0, right: 0),
                        title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text(
                            'Bank Details',
                            style: AppTheme.textStyle.color100.size(15).w500,
                          ),
                        ),
                        trailing: arrowIcon,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(BankDetails.routeName);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppTheme.dividerColor,
                  thickness: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 24, bottom: 24),
                  child: InviteTile(),
                ),
                Divider(
                  color: AppTheme.dividerColor,
                  thickness: 8,
                ),
                profileInfo != null
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/chat.png',
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Need help?",
                                  style: AppTheme.textStyle.w700.color100
                                      .size(17)
                                      .lineHeight(1.5),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Any queries or concerns. We are always available to help you out.",
                              style: AppTheme.textStyle.w500.color50
                                  .size(13)
                                  .lineHeight(1.3),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monday - Friday',
                                      style: AppTheme.textStyle.w500.color100
                                          .size(15)
                                          .lineHeight(1.3),
                                    ),
                                    Text(
                                      '10 AM to 6 PM',
                                      style: AppTheme.textStyle.w500.color50
                                          .size(15)
                                          .lineHeight(1.3),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    WhatsappIconButton(
                                      number: profileInfo.contact.whatsapp,
                                    ),
                                    SizedBox(width: 16.0),
                                    CallIconButton(
                                      number: profileInfo.contact.phone,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Divider(
                    color: AppTheme.dividerColor,
                    thickness: 1.2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      _policyTile(
                        'Cancellation Policy',
                        'https://s3.ap-south-1.amazonaws.com/products.image.prod/cancellationPolicy.html',
                      ),
                      _policyDivider(),
                      _policyTile(
                        'Privacy Policy',
                        'https://s3.ap-south-1.amazonaws.com/products.image.prod/privacyPolicy.html',
                      ),
                      _policyDivider(),
                      _policyTile(
                        'Terms & Conditions',
                        'https://s3.ap-south-1.amazonaws.com/products.image.prod/termsAndConditions.html',
                      ),
                      _policyDivider(),
                      _policyTile(
                        'Frequently Asked Questions',
                        'https://s3.ap-south-1.amazonaws.com/products.image.prod/faqMerchants.html',
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: AppTheme.dividerColor,
                        thickness: 8,
                      ),
                      ListTile(
                        onTap: () {
                          this._handleLogout();
                        },
                        title: Text('Logout',
                            style: AppTheme.textStyle.color100.size(15).w500),
                        trailing: Icon(
                          BotigaIcons.exit,
                          color: AppTheme.color50,
                          size: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 100),
                        child: Center(
                          child: Text(appVersion,
                              style: AppTheme.textStyle.color50.size(13).w500),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _policyTile(String title, String url) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PolicyWebiewScreen(url),
          ),
        );
      },
      title: Text(title, style: AppTheme.textStyle.color100.size(15).w500),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.color50,
        size: 20,
      ),
    );
  }

  Widget _policyDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Divider(
        color: AppTheme.dividerColor,
        thickness: 1.2,
      ),
    );
  }
}
