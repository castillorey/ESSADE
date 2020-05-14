import 'package:essade/ui/chat_detail_page.dart';
import 'package:essade/ui/faq_detail_page.dart';
import 'package:essade/ui/tel_directory_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatelessWidget {
  final Widget child;
  final Function onBackPressed;
  final IconData backButtonIcon;

  const DetailPage({Key key, this.child, this.onBackPressed, this.backButtonIcon = Icons.close}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(backButtonIcon, color: essadeBlack),
            onPressed: () => onBackPressed(),
          ),
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: _buildBody(child),
        )
      ),
    );
  }



  Widget _buildBody(Widget page){
    return page;
  }
}
