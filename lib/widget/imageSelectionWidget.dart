import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../theme/index.dart';
import 'botigaBottomModal.dart';
import 'toast.dart';
import 'dart:io';

class ImageSelectionWidget {
  final double width;
  final double height;
  final Function(File) onImageSelection;

  ImageSelectionWidget({
    @required this.width,
    @required this.height,
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
            title: Transform(
              transform: Matrix4.translationValues(-16, 0.0, 0.0),
              child: Text('Take photo',
                  style: AppTheme.textStyle.color100.size(17).w500),
            ),
          ),
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
            title: Transform(
              transform: Matrix4.translationValues(-16, 0.0, 0.0),
              child: Text('Choose from gallery',
                  style: AppTheme.textStyle.color100.size(17).w500),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ).show(context);
  }

  void _onImageButtonPressed(BuildContext context, ImageSource source) async {
    try {
      PickedFile pickedFile = await ImagePicker().getImage(
        source: source,
      );
      if (pickedFile != null) {
        _cropImage(pickedFile);
      }
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

  _cropImage(pickedFile) async {
    CropAspectRatio aspectRatio;
    CropAspectRatioPreset aspectRatioPreset;
    if (width == 150 && height == 150) {
      aspectRatio = CropAspectRatio(ratioX: 1, ratioY: 1);
      aspectRatioPreset = CropAspectRatioPreset.square;
    } else {
      aspectRatio = CropAspectRatio(ratioX: 4, ratioY: 3);
      aspectRatioPreset = CropAspectRatioPreset.ratio4x3;
    }
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: aspectRatio,
      maxHeight: height.toInt(),
      maxWidth: width.toInt(),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: AppTheme.primaryColor,
        toolbarWidgetColor: AppTheme.backgroundColor,
        activeControlsWidgetColor: AppTheme.primaryColor,
        initAspectRatio: aspectRatioPreset,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(title: ''),
    );
    if (croppedImage != null) {
      onImageSelection(croppedImage);
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
          TextButton(
            child: Text(
              'Cancel',
              style: AppTheme.textStyle.w600.color50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
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
