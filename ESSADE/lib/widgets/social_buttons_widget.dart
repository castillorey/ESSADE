import 'package:flutter/material.dart';

class SocialButtonWidget extends StatelessWidget {
  final String fbLogoPath, gooLogoPath;
  final VoidCallback onFbPressed, onGooPressed;
  SocialButtonWidget({
    @required this.fbLogoPath,
    @required this.gooLogoPath,
    @required this.onFbPressed,
    @required this.onGooPressed
  });

  @override
  Widget build(BuildContext context) {

    Widget _buildSocialBtn(Function onTap, AssetImage logo) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
            image: DecorationImage(
              image: logo,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
                () => onFbPressed,
            AssetImage(
              fbLogoPath,
            ),
          ),
          _buildSocialBtn(
                () => onGooPressed,
            AssetImage(
              gooLogoPath,
            ),
          ),
        ],
      ),
    );
  }
}
