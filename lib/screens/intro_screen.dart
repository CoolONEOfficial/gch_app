import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback callback;

  const IntroScreen({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        PageViewModel(
            pageColor: const Color(0xFF03A9F4),
            body: Text(
              'ФОРМИРУЙ И УЧАВСТВУЙ В СОВМЕСТНЫХ ОБРАЩЕНИЯХ КО ВЛАСТИ',
            ),
            title: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('ВМЕСТЕ НАС СЛЫШНО', textAlign: TextAlign.center, style: Theme.of(context).textTheme.title.merge(TextStyle(color: Colors.white, fontSize: 50)),),
            ),
            textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
            mainImage: Image.asset(
              'assets/images/intro/intro_1.png',
              height: 285.0,
              width: 285.0,
              alignment: Alignment.center,
            )),
        PageViewModel(
          pageColor: const Color(0xFF8BC34A),
          //iconImageAssetPath: 'assets/waiter.png',
          body: Text(
            'ПОЛУЧАЙ УВЕДОМЛЕНИЯ ПОСЛЕ ВЫПОЛНЕНИЯ ЗАПРОСА',
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('ГОВОРИ С ВЛАСТЬЮ', style: Theme.of(context).textTheme.title.merge(TextStyle(color: Colors.white, fontSize: 50)),),
          ),
          mainImage: Image.asset(
            'assets/images/intro/intro_2.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        ),
        PageViewModel(
          pageColor: const Color(0xFF607D8B),
          iconImageAssetPath: 'assets/taxi-driver.png',
          body: Text(
            'НАЧНИ УЧАВСТВОВАТЬ В РАЗВИТИИ ГОРОДА',
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('ДЕЙСТВУЙ', style: Theme.of(context).textTheme.title.merge(TextStyle(color: Colors.white, fontSize: 50)),),
          ),
          mainImage: Image.asset(
            'assets/images/intro/intro_3.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        ),
      ],
      skipText: Container(),
      doneText: Text("Готово"),
      onTapDoneButton: () {
        callback();
      },
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    );
  }

}