import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/*
 * Displays cached network image 
 * In case, imageUrl is null or image does not exist at url
 * it shows placeholder image
*/

class ProductNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final String imagePlaceholder;
  final double radius;

  ProductNetworkAvatar({
    @required this.imageUrl,
    this.imagePlaceholder = 'assets/images/avatar.png',
    this.radius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == null ? _placeholderImage() : _networkImage();
  }

  Widget _networkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.radius),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        width: 48.0,
        height: 48.0,
        placeholder: (_, __) => _placeholderImage(),
        imageUrl: this.imageUrl,
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 48.0,
      height: 48.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill, image: AssetImage(this.imagePlaceholder)),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}

class ProfileNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final String imagePlaceholder;
  final double radius;

  ProfileNetworkAvatar({
    @required this.imageUrl,
    this.imagePlaceholder = 'assets/images/avatar.png',
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == null ? _placeholderImage() : _networkImage();
  }

  Widget _networkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.radius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: 96,
        height: 96,
        placeholder: (_, __) => _placeholderImage(),
        imageUrl: this.imageUrl,
      ),
    );
  }

  Widget _placeholderImage() {
    return CircleAvatar(
      backgroundColor: AppTheme.color05,
      backgroundImage: AssetImage(this.imagePlaceholder),
      radius: this.radius,
    );
  }
}

class EditProductNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final String imagePlaceholder;
  final double radius;

  EditProductNetworkAvatar({
    @required this.imageUrl,
    this.imagePlaceholder = 'assets/images/avatar.png',
    this.radius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == null ? _placeholderImage() : _networkImage();
  }

  Widget _networkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.radius),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        width: double.infinity,
        height: 176.0,
        placeholder: (_, __) => _placeholderImage(),
        imageUrl: this.imageUrl,
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: double.infinity,
      height: 176.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill, image: AssetImage(this.imagePlaceholder)),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    );
  }
}
