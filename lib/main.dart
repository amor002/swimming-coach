import 'package:flutter/material.dart';
import 'swimmer.dart';
import 'swimmer_card.dart';

List<SwimmerCard> swimmers = new List();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swimming Coach',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  bool started = false;
  GlobalKey<ScaffoldState> scaffold = new GlobalKey();
  ScrollController scrollController;
  double elevation = 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if(scrollController.offset > 0) {
        if(elevation == 0) {
          setState(() {
            elevation = 5;
          });
        }
      }else {
        if(elevation != 0) {
          setState(() {
            elevation = 0;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(started && swimmers.length == 0) {
      started = false;
    }
    
    return Scaffold(

      key: scaffold,
      floatingActionButton: FloatingActionButton(
          tooltip: "add swimmer",
            onPressed: () async {
              if(swimmers.length >= 10) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text("you have reached the maximum number of swimmers"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("ok", style: TextStyle(
                          color: Colors.blue
                        )),
                      )
                    ],
                  )
                );

                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => new SwimmerForm()));

            },
          child: Icon(Icons.add),),
      

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
              title: Text(
                "Swimming Coach", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: elevation,
            ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 55,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: ButtonTheme(
                    height: double.infinity,
                      child: FlatButton(onPressed: started ? () async {

                        for(var swimmer in swimmers) {
                          swimmer.reset();
                        }
                        setState(() =>started = !started);

                      } : null,
                          child: Text("reset",
                           style: TextStyle(fontSize: 18,
                            color: started ? Colors.black : Colors.grey))))
              ),
              Expanded(
                  child: ButtonTheme(
                    height: double.infinity,
                    child: FlatButton(onPressed: started ? null : ()  {
                      if(swimmers.length == 0) return;
                      for(var swimmer in swimmers) {
                        swimmer.start();
                      }
                      setState(() {
                        started = !started;
                      });
                    },
                        child: Text("start", style: TextStyle(fontSize: 18, color: started ? Colors.grey : Colors.black),)),
                  )
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.cyan, Colors.blue],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
          ),
        ),

        child: ListView(
          controller: scrollController,
          children: <Widget>[
          Text("get ready to start training and swimming!",
          style: TextStyle(
              color: Colors.white
          ), textAlign: TextAlign.center,),
        ...swimmers
        ],
      )
        ),
    );
  }

}
