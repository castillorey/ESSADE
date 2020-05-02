import 'package:essade/ui/chat_detail_page.dart';
import 'package:essade/ui/faq_detail_page.dart';
import 'package:essade/ui/tel_directory_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatelessWidget {
  final DetailPageType pageType;

  const DetailPage({Key key, this.pageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close, color: essadeBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: _buildBody(context),
        )
      ),
    );
  }



  Widget _buildBody(BuildContext context){
    switch(pageType){
      case DetailPageType.Chat: {

      }
        break;
      case DetailPageType.TelephoneDirectory:{return TelDirectoryDetailPage();}
        break;
      case DetailPageType.FAQ:{return FAQDetailPage();}
        break;
      case DetailPageType.About:{}
        break;
      case DetailPageType.MisionVision:{}
        break;
      case DetailPageType.Values:{}
        break;
      case DetailPageType.Principles:{}
        break;
      case DetailPageType.Policy:{}
        break;
    }
  }
}
