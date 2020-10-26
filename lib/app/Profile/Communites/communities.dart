import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../models/Profile/Profile.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart';
import '../../../providers/Profile/ProfileProvider.dart';

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  bool isLoading = false;

  void setApartmentStatus(String aptId, bool value) {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.setApartmentStatus(aptId, value).then((value) {
      profileProvider.fetchProfile().then((_) {
        setState(() {
          isLoading = false;
        });
        Toast(message: '$value', iconData: Icons.check_circle).show(context);
      }).catchError((err) {
        Toast(message: '$err', iconData: Icons.error_outline).show(context);
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Toast(message: '$err', iconData: Icons.error_outline).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Apartment> apartments =
        Provider.of<ProfileProvider>(context, listen: false).allApartment;
    if (apartments.length == 0) {
      return BrandingTile(
        'Thriving communities, empowering people',
        'Made by awesome team of Botiga',
      );
    }
    return LoaderOverlay(
      isLoading: isLoading,
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: ListView.builder(
          itemCount: apartments.length,
          itemBuilder: (context, index) {
            return CommunityTile(apartments[index], setApartmentStatus);
          },
        ),
      ),
    );
  }
}

class CommunityTile extends StatefulWidget {
  final Apartment apt;
  final Function setApartmentStatus;
  CommunityTile(this.apt, this.setApartmentStatus);
  @override
  _CommunityTileState createState() => _CommunityTileState();
}

class _CommunityTileState extends State<CommunityTile> {
  bool _switchValue;
  @override
  void initState() {
    super.initState();
    setState(() {
      _switchValue = widget.apt.live;
    });
  }

  void _handleSwitchChage(bool value) {
    setState(() {
      _switchValue = value;
    });
    widget.setApartmentStatus(widget.apt.id, value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(widget.apt.apartmentName,
              style: AppTheme.textStyle.w600.size(16).lineHeight(1.3).color100),
          subtitle: Text(
            widget.apt.apartmentArea,
            style: AppTheme.textStyle.lineHeight(1.5),
          ),
          trailing: Transform.scale(
            alignment: Alignment.centerRight,
            scale: 0.75,
            child: CupertinoSwitch(
              value: _switchValue,
              onChanged: (bool value) {
                this._handleSwitchChage(value);
              },
            ),
          ),
        ),
        Divider(
          color: AppTheme.dividerColor,
          thickness: 1.2,
        )
      ],
    );
  }
}
