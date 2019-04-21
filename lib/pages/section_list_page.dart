import 'package:flutter/material.dart';
import 'package:gch_cityservice/screens/home_screen.dart';

class SectionListPage extends StatefulWidget {
  @override
  State<SectionListPage> createState() => SectionListPageState();
}

class SectionListPageState extends State<SectionListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: taskBloc.stream,
      initialData: Set(),
      builder: (ctx, snapshot) {
        var list = tasksSet.toList();
        return ListView.builder(
          itemBuilder: (ctx, index) => myListTile(ctx, index),
          itemCount: list.length,
        );
      },
    );
  }

  Widget myListTile(BuildContext ctx, index){
    MyTask tsk = tasksSet.toList().elementAt(index);
    return Card(
      elevation: 10,
      child:
          Column(
            children: <Widget>[
              Container(height: 8,),
              Row(
                children: <Widget>[
                  Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,//const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))
                      ),
                      child: Center(
                        child: Text(tsk.title, style: TextStyle(color: Colors.white),),
                      )
                  ),
                  Expanded(
                    child: Text(" "),
                  ),
                  Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,//const Color.fromRGBO(0x7e, 0x00, 0xff, 1),//0x7e00ff),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))
                      ),
                      child: Center(
                        child: Text( dateText(   tsk.sendTime ?? DateTime.utc(2019).millisecondsSinceEpoch    ), style: TextStyle(color: Colors.white),),
                      )
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(width: 10,),
                  Expanded(
                    //width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        Text(intToCategory(tsk.cathegory?.index), style: TextStyle(color: Theme.of(context).primaryColor/*const Color.fromRGBO(0x00, 0x71, 0x7a, 1)*/),),
                        Divider(),
                        Text(tsk.snippet??"Ясно хуита", maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color.fromRGBO(0x8e, 0x8e, 0x8e, 1)),),
                        Divider(),
                        Text("${tsk.distanceToUser} метр(ов) от вас", style: TextStyle(color: Theme.of(context).primaryColor),),
                        Divider(),
                      ],
                    ),
                  ),
                  Container(width: 10,),
                  Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.network("http://sim-kr.ru/UserImages/37cd40ac.jpg"),
//                          Placeholder(
//                            color: Theme.of(context).accentColor,
//                          ),
                        )
                      )
                    ],
                  ),
                  Container(width: 10,)
                ],
              ),
              //Text("Wabba labba dub dub", style: TextStyle(fontSize: 20),)
            ],
          )

      )
    ;
  }

  String dateText(int secs){
    print(secs.toString());
    var b = DateTime.fromMillisecondsSinceEpoch(secs);
    int day = b.day;
    //int day = DateTime.fromMillisecondsSinceEpoch(secs)?.day;
    int month = DateTime.fromMillisecondsSinceEpoch(secs)?.month;
    String monthString = month.toString();
    if(month < 10){
      monthString = '0'+monthString;
    }
    monthString = day.toString()+"."+monthString;
    return monthString;
  }
}

String intToCategory(int index){
  String category;
  switch(index){
    case 0: category = "Нет"; break;
    case 1: category = "Дороги"; break;
    case 2: category = "Вандализм"; break;
    case 3: category = "Транспорт"; break;
    case 4: category = "Мусор"; break;
    case 5: category = "Освещение"; break;
    default: category = "Undefined";
  }
  return category;
}

AppBar myListAppBar() {
  return AppBar(
    title: Text("MyList"),
  );
}


///http://sim-kr.ru/UserImages/37cd40ac.jpg