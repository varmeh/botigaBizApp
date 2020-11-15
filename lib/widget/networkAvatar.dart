import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/index.dart';

/*
 * Displays cached network image 
 * In case, imageUrl is null or image does not exist at url
 * it shows placeholder image
*/

class ProductNetworkAvatar extends StatefulWidget {
  final String imageUrl;
  final String imagePlaceholder;
  final double radius;
  final Function func;

  ProductNetworkAvatar(
      {@required this.imageUrl,
      this.imagePlaceholder = 'assets/images/avatar.png',
      this.radius = 4.0,
      @required this.func});

  @override
  _ProductNetworkAvatarState createState() => _ProductNetworkAvatarState();
}

class _ProductNetworkAvatarState extends State<ProductNetworkAvatar> {
  @override
  Widget build(BuildContext context) {
    return widget.imageUrl == null ? _placeholderImage() : _networkImage();
  }

  Widget _networkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.widget.radius),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        width: 120.0,
        height: 90.0,
        placeholder: (_, __) => _placeholderImage(),
        imageUrl: this.widget.imageUrl,
        errorWidget: (context, url, error) {
          Future.delayed(Duration.zero, () async {
            if (this.widget.func != null) {
              this.widget.func();
            }
          });
          return _placeholderImage();
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 120.0,
      height: 90.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill, image: AssetImage(this.widget.imagePlaceholder)),
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
        errorWidget: (context, url, error) {
          return _placeholderImage();
        },
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
        errorWidget: (context, url, error) {
          return _placeholderImage();
        },
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
