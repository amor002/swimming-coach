import 'package:flutter/material.dart';
import 'package:swimming_coach/progress_bar.dart';
import 'package:swimming_coach/swimmer.dart';
import 'main.dart';

class SwimmerCard extends StatefulWidget {

  _SwimmerCard state;
  SwimmerCard(Swimmer swimmer): state = new _SwimmerCard(swimmer);

  void start() => state.start();

  void reset() => state.reset();

  @override
  _SwimmerCard createState() => state;

}

class _SwimmerCard extends State<SwimmerCard> with TickerProviderStateMixin {

  Swimmer swimmer;
  _SwimmerCard(this.swimmer);
  AnimationController controller;
  Animation animation;
  bool deleted = false;

  AnimationController colorController;
  Animation<Color> colorAnimation;
  List<int> timeTable = new List();
  int currentQuarter = 0;

  void start() {
    controller.forward();
    colorController.forward();
  }

  void reset() {
    controller.reset();
    colorController.reset();
    setState(() {
      currentQuarter = 0;
    });
  }

  double get  coveredDistance => (currentQuarter*swimmer.totalDistance/4) + animation.value;
  double get timePassed {

    var velocity = (swimmer.totalDistance/4)/timeTable[currentQuarter]; // m / millis
    var passedTime = animation.value / velocity;
    switch(currentQuarter) {
      case 1:
        passedTime += swimmer.firstQuarter;
        break;
      case 2:
        passedTime += swimmer.firstQuarter + swimmer.secondQuarter;
        break;
      case 3:
        passedTime += swimmer.firstQuarter + swimmer.secondQuarter + swimmer.thirdQuarter;
        break;
      default:
        break;
    }

    return passedTime; // time in milli seconds
  }

  String formatTime(double time) {
    int millis = time.round();
    int seconds = 0;
    int minutes = 0;
    int hours = 0;

    while(millis >= 1000) {
      seconds++;
      millis -= 1000;
    }

    while(seconds >= 60) {
      minutes++;
      seconds -= 60;
    }

    while(minutes >= 60) {
      hours++;
      minutes -= 60;
    }

    return "$hours:$minutes:$seconds.${((){
      String num = millis.toString();
      if(num.length == 3) {
        num = num.substring(0, 2);
      }
      return num;
    })()}";

  }
  @override
  void initState() {
    super.initState();

    colorController = new AnimationController(vsync: this, duration: Duration(milliseconds: swimmer.totalTime));
    colorAnimation = ColorTween(begin: Colors.deepPurple, end: Colors.green).animate(colorController);

    timeTable.add(swimmer.firstQuarter);
    timeTable.add(swimmer.secondQuarter);
    timeTable.add(swimmer.thirdQuarter);
    timeTable.add(swimmer.fourthQuarter);

    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: timeTable[currentQuarter]));
    animation = new Tween(begin: 0.0, end: swimmer.totalDistance/4.0).animate(controller);

    controller.addListener(() {

      if(animation.value == swimmer.totalDistance/4) {
        if(currentQuarter != 3) {
          setState(() {
            controller.duration = Duration(milliseconds: timeTable[++currentQuarter]);
          });
          controller.forward(from: 0.0);
        }
      }
    });
  }

  void dispose() {
    super.dispose();
    controller.dispose();
    colorController.dispose();
  }



  @override
  Widget build(BuildContext context) {

    if(deleted) {
      return Container();
    }

    return Card(
      child: Padding(
          padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(swimmer.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 19
                  ),),
                IconButton(icon: Icon(Icons.close), onPressed: () {
                  showDialog(context: context,
                  builder: (context) =>
                  AlertDialog(
                    title: Text("delete swimmer"),
                    content: Text("are you sure you want to remove `${swimmer.name}`"),
                    actions: <Widget>[
                      FlatButton(onPressed: () => Navigator.pop(context), child: Text("cancel", style: TextStyle(color: Colors.blue),)),
                      FlatButton(onPressed: () {
                        swimmers.removeWhere((card) => card.state.swimmer == swimmer);
                        setState(() {
                          deleted = true;
                        });
                        Navigator.pop(context);
                      },
                          child: Text("delete", style: TextStyle(color: Colors.red),)),
                    ],
                  )
                  );
                })
              ],
            ),
            SizedBox(height: 4),
            AnimatedBuilder(
              animation: animation,
              builder:(context, widget) =>
                  AnimatedBuilder(
                    animation: colorAnimation,
                    builder: (context, widget) => ProgressBar(
                progressColor: colorAnimation.value,
                progress: 100*((coveredDistance)/swimmer.totalDistance),
                background: Colors.grey,
              ),
                  ),
            ),
            SizedBox(height: 4),
            AnimatedBuilder(
                animation: animation,
                builder:(context, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("covered distance: ${coveredDistance.toStringAsFixed(2)} m"),
                          SizedBox(height: 4),
                          Text("time passed: ${formatTime(timePassed)}"),
                          SizedBox(height: 4),
                          Text("speed: ${((swimmer.totalDistance/4)/(timeTable[currentQuarter]/1000)).toStringAsFixed(2)} m/s"),
                          SizedBox(height: 4),
                          Text("remaining: ${(swimmer.totalDistance-coveredDistance).toStringAsFixed(2)} m")
                        ]),
                    Builder(
                        builder: (context) {
                          if(coveredDistance == swimmer.totalDistance) {
                            return Column(
                              children: <Widget>[
                                Text("start: ${formatTime(timeTable[0].roundToDouble())}"),
                                SizedBox(height: 4),
                                Text("after start: ${formatTime(timeTable[1].roundToDouble())}"),
                                SizedBox(height: 4),
                                Text("before finish: ${formatTime(timeTable[2].roundToDouble())}"),
                                SizedBox(height: 4),
                                Text("finish: ${formatTime(timeTable[3].roundToDouble())}"),
                              ],
                            );
                          }
                          return Container();
                        }

                    )
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }

}