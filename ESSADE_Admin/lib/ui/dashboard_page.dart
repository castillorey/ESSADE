import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      //color: essadeAdminBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildFirstRow(),
          Expanded(
            child: ListView(
              children: [
                ResponsiveBuilder(
                  builder: (context, sizingInformation){
                    var screenType = sizingInformation.deviceScreenType;
                    if(screenType == DeviceScreenType.mobile || screenType == DeviceScreenType.tablet)
                      return _buildWelcomeRowTabletAndBelow();
                    else
                      return _buildWelcomeRowDesktop();
                  },
                ),
                SizedBox(height: 20.0),
                _buildStatisticsRow(),
                SizedBox(height: 20.0),
                _buildDataValues()
              ],
            ),
          )
        ],
      ),
    );
  }
  
  _buildFirstRow(){
    var now = new DateFormat('EEE, MMM d, ''yy').format(new DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tablero', style: essadeH4(essadeBlack)),
        Text('${now}', style: essadeParagraph(color: essadeGray))
      ],
    );
  }

  _buildWelcomeRowTabletAndBelow(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(height: 230),
        Positioned.fill(
          top: 50.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            decoration: BoxDecoration(
                color: essadePrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '¡Hola Kevin, Bienvenido!',
                    style: essadeH4(essadePrimaryColor),
                    textAlign: TextAlign.center
                  )
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 60.0,
            child: Image.asset('/images/welcome.png', width: 160)
        )
      ],
    );
  }

  _buildWelcomeRowDesktop(){
    return Stack(
      children: [
        Container(height: 230),
        Positioned.fill(
          top: 50.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 80.0),
            decoration: BoxDecoration(
                color: essadePrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('¡Hola Kevin, Bienvenido!', style: essadeH3(essadePrimaryColor)),
              ],
            ),
          ),
        ),
        Positioned(
            right: 80.0,
            bottom: 20.0,
            child: Image.asset('/images/welcome.png', width: 200)
        )
      ],
    );
  }

  _buildStatisticsRow(){
    return Row(
      children: [
        Expanded(child: Placeholder(fallbackHeight: 220)),
        SizedBox(width: 10.0),
        Expanded(child: Placeholder(fallbackHeight: 220))
      ],
    );
  }

  _buildDataValues(){
    return Row(
      children: [
        Expanded(child: Placeholder(fallbackHeight: 100)),
        SizedBox(width: 10.0),
        Expanded(child: Placeholder(fallbackHeight: 100)),
        SizedBox(width: 10.0),
        Expanded(child: Placeholder(fallbackHeight: 100))
      ],
    );
  }
}
