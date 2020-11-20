import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_settings/app_settings.dart';

import '../theme/index.dart';
import 'botigaBottomModal.dart';
import 'toast.dart';

class ImageSelectionWidget {
  final double width;
  final double height;
  final int imageQuality;
  final Function(PickedFile) onImageSelection;

  ImageSelectionWidget({
    @required this.width,
    @required this.height,
    @required this.imageQuality,
    @required this.onImageSelection,
  });

  void show(BuildContext context) {
    BotigaBottomModal(
      isDismissible: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Add image', style: AppTheme.textStyle.color100.size(22).w700),
          SizedBox(height: 24),
          ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _onImageButtonPressed(context, ImageSource.camera);
              },
              contentPadding: EdgeInsets.only(left: 0.0),
              leading: Icon(
                Icons.camera_alt,
                color: AppTheme.color100,
              ),
              title: Text('Take photo',
                  style: AppTheme.textStyle.color100.size(17).w500)),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              _onImageButtonPressed(context, ImageSource.gallery);
            },
            contentPadding: EdgeInsets.only(left: 0.0),
            leading: Icon(
              Icons.image,
              color: AppTheme.color100,
            ),
            title: Text('Choose from gallery',
                style: AppTheme.textStyle.color100.size(17).w500),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    ).show(context);
  }

  void _onImageButtonPressed(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: source,
        maxWidth: width,
        maxHeight: height,
        imageQuality: imageQuality,
      );
      onImageSelection(pickedFile);
    } catch (e) {
      if (e.code != null &&
          (e.code == 'photo_access_denied' ||
              e.code == 'camera_access_denied')) {
        _showSettingsDialog(context, source);
      } else {
        Toast(message: 'Unexpected error').show(context);
      }
    }
  }

  void _showSettingsDialog(BuildContext context, ImageSource source) async {
    final feature = source == ImageSource.camera ? 'camera' : 'gallery';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Access Denied',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'To access $feature, enable it in your app settings',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Cancel',
              style: AppTheme.textStyle.w600.color50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Settings',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}
