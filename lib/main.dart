import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'indexed.dart';
import 'rolling_nav_bar.dart';
  
import 'dart:ui';
import 'package:polygon_clipper/polygon_clipper.dart';


//teste


void main() => runApp(MyApp());

double scaledHeight(BuildContext context, double baseSize) {
  return baseSize * (MediaQuery.of(context).size.height / 800);
}

double scaledWidth(BuildContext context, double baseSize) {
  return baseSize * (MediaQuery.of(context).size.width / 375);
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color logoColor;
  int activeIndex;

  var iconData = <IconData>[
    Icons.home,
    Icons.people,
    Icons.account_circle,
    Icons.chat,
    Icons.settings,
  ];

  var badges = <int>[null, null, null, null, null];

  var iconText = <Widget>[
    Text('Home', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Friends', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Account', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Chat', style: TextStyle(color: Colors.grey, fontSize: 12)),
    Text('Settings', style: TextStyle(color: Colors.grey, fontSize: 12)),
  ];

  var indicatorColors = <Color>[
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  List<Widget> get badgeWidgets => indexed(badges)
      .map((Indexed indexed) => indexed.value != null
          ? Text(indexed.value.toString(),
              style: TextStyle(
                color: indexed.index == activeIndex
                    ? indicatorColors[indexed.index]
                    : Colors.white,
              ))
          : null)
      .toList();

  @override
  void initState() {
    logoColor = Colors.red[600];
    activeIndex = 0;
    super.initState();
  }

  void incrementIndex() {
    setState(() {
      activeIndex = activeIndex < (iconData.length - 1) ? activeIndex + 1 : 0;
      print(activeIndex);
    });
  }

  // ignore: unused_element
  _onAnimate(AnimationUpdate update) {
    setState(() {
      logoColor = update.color;
    });
  }

  _onTap(int index) {
    activeIndex = index;
  }

  void _incrementBadge() {
    badges[activeIndex] =
        badges[activeIndex] == null ? 1 : badges[activeIndex] + 1;
    setState(() {});
  }

  List<Widget> get builderChildren => const <Widget>[
        Text('1', style: TextStyle(color: Colors.grey)),
        Text('2', style: TextStyle(color: Colors.grey)),
        Text('3', style: TextStyle(color: Colors.grey)),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[100],
      ),
      home: Builder(
        builder: (BuildContext context) {
          double largeIconHeight = MediaQuery.of(context).size.width;
          double navBarHeight = scaledHeight(context, 85);
          double topOffset = (MediaQuery.of(context).size.height -
                  largeIconHeight -
                  MediaQuery.of(context).viewInsets.top -
                  (navBarHeight * 2)) /
              2;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: logoColor,
              child: Icon(Icons.add),
              onPressed: _incrementBadge,
            ),
            appBar: AppBar(
              title: Text('Rolling Nav Bar'),
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: topOffset,
                  height: largeIconHeight,
                  width: largeIconHeight,
                  child: GestureDetector(
                    onTap: incrementIndex,
                    child: ClipPolygon(
                      sides: 6,
                      borderRadius: 15,
                      child: Container(
                        height: largeIconHeight,
                        width: largeIconHeight,
                        color: logoColor,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 100, 30, 0),
                            child: Transform(
                              transform: Matrix4.skew(0.1, -0.50),
                              child: Text(
                                'Rolling\nNav Bar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: scaledWidth(context, 63),
                                  fontFeatures: <FontFeature>[
                                    FontFeature.enable('smcp')
                                  ],
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(125, 0, 0, 255),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              // bottom: 0,
              height: navBarHeight,
              width: MediaQuery.of(context).size.width,
              // Option 1: Recommended
              child: RollingNavBar.iconData(
                activeBadgeColors: <Color>[
                  Colors.white,
                ],
                activeIndex: activeIndex,
                animationCurve: Curves.linear,
                animationType: AnimationType.roll,
                baseAnimationSpeed: 200,
                badges: badgeWidgets,
                iconData: iconData,
                iconColors: <Color>[Colors.grey[800]],
                iconText: iconText,
                indicatorColors: indicatorColors,
                iconSize: 25,
                indicatorRadius: scaledHeight(context, 30),
                onAnimate: _onAnimate,
                onTap: _onTap,
              ),

              // Option 2: Possibly more complicated, but there if you need it
              // child: RollingNavBar.builder(
              //   builder: (
              //     BuildContext context,
              //     int index,
              //     AnimationInfo info,
              //     AnimationUpdate update,
              //   ) {
              //     return builderChildren[index];
              //   },
              //   badges: badgeWidgets.sublist(0, builderChildren.length),
              //   indicatorColors:
              //       indicatorColors.sublist(0, builderChildren.length),
              //   numChildren: builderChildren.length,
              //   onTap: _onTap,
              // ),
            ),
          );
        },
      ),
    );
  }
}



//teste







class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

TextEditingController editingController = TextEditingController();

bool _isButtonClicked = false;
var _buttonIcon = Icons.cloud_download;
var _buttonText = 'Procurar';
var _buttonColor = Colors.grey;
String buscador = 'case';
final controladordabusca = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _isButtonClicked ? _getData() : null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          return 
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [Text('Clique para buscar',textAlign: TextAlign.center, textScaleFactor: 1.5,)]);
          case ConnectionState.waiting:
            return Column (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget> [CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))]);
          default:
            if (snapshot.hasError)
              return new Text('Erro: ${snapshot.error}');
            else
              return    
              createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: 
          TextField(
        controller: controladordabusca,
        onChanged: (newvalue) => buscador = newvalue,
        decoration: InputDecoration(
        labelText: "Procurar",
        hintText: "Procurar",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),


      ),
      body: futureBuilder,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: _buttonColor,
            onPressed: () {
              ///Calling method to fetch data from the server
              _getData();
    
              ///You need to reset UI by calling setState.
              setState(() {
                _isButtonClicked == false
                    ? _isButtonClicked = true
                    : _isButtonClicked = false;
    
                if (!_isButtonClicked) {
                  _buttonIcon = Icons.cloud_download;
                  _buttonColor = Colors.green;
                  _buttonText = "Procurar";
                } else {
                  _buttonIcon = Icons.replay;
                  _buttonColor = Colors.deepOrange;
                  _buttonText = "Resetar";
                }
              });
            },
            icon: Icon(
              _buttonIcon,
              color: Colors.white,
            ),
            label: Text(
              _buttonText,
              style: TextStyle(color: Colors.white),
            ),
    ));
  }

Future<Map<String,dynamic>> _getData() async {

var interno = Map<String,dynamic>();
    
String busca = buscador;



var document;



Response response = 

await Client().get(Uri.parse('https://steamcommunity.com/market/search?appid=730&q=$busca/'));

document = parse(response.body);

for (int id = 0; id < 10; id++){

var nome = document.getElementById('result_$id/_name').querySelectorAll('span.market_listing_item_name');

var preco = document.getElementById('result_$id/_name').querySelectorAll('span.market_table_value > span.normal_price');

var quant = document.getElementById('result_$id/_name').querySelectorAll('span.market_table_value > span.market_listing_num_listings_qty');

for (var a in nome) {
  interno['nome$id'] = a.innerHtml;
  }

for (var b in preco) {
  interno['preco$id'] = b.innerHtml;
  }

for (var c in quant) {
  interno['quant$id'] = c.innerHtml;
  }
}


     await new Future.delayed(new Duration(seconds: 2));

    return interno;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    Map<String,dynamic> interno = snapshot.data;
    
    return new ListView.builder(
      
        itemCount: 10,
        itemBuilder: 
        (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: Text(interno['nome$index']),
                subtitle: Text(interno['quant$index']),
                trailing: Text(interno['preco$index']),
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
    );
  }
}