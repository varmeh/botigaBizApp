import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/profile/index.dart';
import '../../../providers/index.dart' show ProfileProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart' show Http;
import '../../../widget/index.dart';
import 'communityTile.dart';

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  bool isLoading = false;
  bool _switchValue = false;

  @override
  void initState() {
    _setAllApartmentsStatus();
    super.initState();
  }

  void _setAllApartmentsStatus() {
    List<Apartment> apartments =
        Provider.of<ProfileProvider>(context, listen: false).allApartment;

    _switchValue =
        apartments.firstWhere((apt) => apt.live == true, orElse: () => null) !=
            null;
  }

  @override
  Widget build(BuildContext context) {
    List<Apartment> apartments =
        Provider.of<ProfileProvider>(context, listen: true).allApartment;
    if (apartments.length == 0) {
      return BrandingTile(
        'Thriving communities, empowering people',
        'Made by awesome team of Botiga',
      );
    }

    return LoaderOverlay(
      isLoading: isLoading,
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10,
        ),
        child: ListView.builder(
          itemCount: apartments.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'All Apartments Live Status',
                            style: AppTheme.textStyle.w500
                                .size(18)
                                .lineHeight(1.33)
                                .color100,
                          ),
                        ),
                        BotigaSwitch(
                          handleSwitchChange: (bool value) async {
                            setState(() => _switchValue = value);
                            setAllApartmentStatus(value);
                          },
                          switchValue: _switchValue,
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(
                      thickness: 1,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              );
            }
            return CommunityTile(
              apartments[index - 1],
              setApartmentStatus,
              updateDeliverySchedule,
            );
          },
        ),
      ),
    );
  }

  void setApartmentStatus(String aptId, bool value, Function onFail) async {
    setState(() {
      isLoading = true;
    });
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.setApartmentStatus(aptId, value);
      await profileProvider.fetchProfile();
      Toast(
        message: 'Community status updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
      _setAllApartmentsStatus();
    } catch (err) {
      onFail();
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setAllApartmentStatus(bool value) async {
    setState(() => isLoading = true);
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.setAllApartmentStatus(value);
      await profileProvider.fetchProfile();
      Toast(
        message: 'Communities status updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      setState(() => _switchValue = !_switchValue);
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void updateDeliverySchedule(String _apartmentId, String _deliveryType,
      int _day, List<bool> _schedule, String _slot) async {
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await profileProvider.updateApartmentDeliveryScheduled(
        apartmentId: _apartmentId,
        deliveryType: _deliveryType,
        day: _day,
        schedule: _schedule,
        slot: _slot,
      );
      await profileProvider.fetchProfile();

      Navigator.of(context).popUntil((route) => route.isFirst);

      Toast(
        message: 'Delivery scheduled updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
