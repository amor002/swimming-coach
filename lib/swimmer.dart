import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swimming_coach/swimmer_card.dart';
import 'main.dart';


class Swimmer {

  String name;
  int totalDistance;
  int intensity;
  int maxIntensity;

  int firstQuarter;
  int secondQuarter;
  int thirdQuarter;
  int fourthQuarter;

  int totalTime;

  Swimmer({
    this.name,
    this.totalDistance,
    this.intensity,
    double maxIntensity,
    this.firstQuarter,
    this.secondQuarter,
    this.thirdQuarter,
    this.fourthQuarter,
  }): assert(firstQuarter+secondQuarter+thirdQuarter+fourthQuarter == 100) {

    this.totalTime = (((maxIntensity*(200-intensity))/100) * 60 * 1000).round();
    this.firstQuarter = (((50-firstQuarter)/100)*totalTime).round();
    
    this.secondQuarter = (((50-secondQuarter)/100)*totalTime).round();
    this.thirdQuarter = (((50-thirdQuarter)/100)*totalTime).round();
    this.fourthQuarter = (((50-fourthQuarter)/100)*totalTime).round();

  }


}



class SwimmerForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SwimmerForm();
}

class _SwimmerForm extends State<SwimmerForm> {

  GlobalKey<FormState> form = new GlobalKey();
  TextEditingController hours, minutes, seconds, millis,
  intensity,
   totalDistance, name, firstQuarter, secondQuarter, thirdQuarter, fourthQuarter;

  void initState() {
    super.initState();
    hours = new TextEditingController(text: '0');
    minutes = new TextEditingController(text: '0');
    seconds = new TextEditingController(text: '0');
    millis = new TextEditingController(text: '0');
    intensity = new TextEditingController();

    totalDistance = new TextEditingController();
    name = new TextEditingController();
    firstQuarter = new TextEditingController(text: '25');
    secondQuarter = new TextEditingController(text: '25');

    thirdQuarter = new TextEditingController(text: '25');
    fourthQuarter = new TextEditingController(text: '25');
    
  }

  void dispose() {
    super.dispose();

    hours.dispose();
    minutes.dispose();
    seconds.dispose();
    millis.dispose();

    totalDistance.dispose();
    name.dispose();
    intensity.dispose();

    firstQuarter.dispose();
    secondQuarter.dispose();
    thirdQuarter.dispose();
    fourthQuarter.dispose();
  }

  Widget numberField({TextEditingController controller,validator, String label, String suffixText}) {
    return TextFormField(
                                    controller: controller,
                                    validator: validator,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                                   WhitelistingTextInputFormatter.digitsOnly
                                                              ],
                                    decoration: InputDecoration(
                                      labelText: label,
                                      suffixText: suffixText
                                    ),
                                  );
  }

  bool isValidInputs() =>
      double.parse(firstQuarter.text)+double.parse(secondQuarter.text)
          +double.parse(thirdQuarter.text)
          +double.parse(fourthQuarter.text) == 100;

  String validator(String text) => text.trim().length == 0 ? "this field cannot be empty" : null;

  double getTime() {
    return (double.parse(hours.text)*60+
        double.parse(minutes.text)+
        double.parse(seconds.text)/60+
        (double.parse(millis.text)/100)/60);
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Swimmer",
         style: TextStyle(
           fontWeight: FontWeight.bold
         )
         ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

          if(form.currentState.validate()) {
            if(isValidInputs()) {
              swimmers.add(SwimmerCard(new Swimmer(
                  name: name.text,
                  maxIntensity: getTime(),
                  intensity: int.parse(intensity.text),
                  firstQuarter: int.parse(firstQuarter.text),
                  secondQuarter: int.parse(secondQuarter.text),
                  thirdQuarter: int.parse(thirdQuarter.text),
                  fourthQuarter: int.parse(fourthQuarter.text),//
                  totalDistance: int.parse(totalDistance.text)
              )));
              Navigator.pop(context);
            }else {
              showDialog(context: context,
              builder: (context) => AlertDialog(
                title: Text("invalid input"),
                content: Text("the sum of speed changes should be 100%"),
                actions: <Widget>[
                  FlatButton(onPressed: () => Navigator.pop(context),
                      child: Text("ok", style: TextStyle(color: Colors.blue),))
                ],
              ));
            }
          }
        },
        child: Icon(Icons.check),
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: name,
                      validator: validator,
                      decoration: InputDecoration(
                        labelText: "Swimmer's name",  
                      ),
                  ),
                    TextFormField(
                      controller: totalDistance,
                      validator: validator,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                                         WhitelistingTextInputFormatter.digitsOnly
                                                    ],
                      decoration: InputDecoration(
                        labelText: "Swimming Distance",
                        suffixText: "meters"
                      ),

                  ),

                    TextFormField(
                      controller: intensity,
                      validator: validator,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          labelText: "intensity",
                          suffixText: "%"
                      ),

                    ),
                  SizedBox(height: 5,),
                CardField(
                  label: "Swimmer's best record",
                  field1: numberField(
                    controller: hours,
                    label: "hours",
                    validator: validator
                  ),
                  field2: numberField(
                    controller: minutes,
                    label: "minutes",
                    validator: validator
                  ),
                  field3: numberField(
                    controller: seconds,
                    label: "seconds",
                    validator: validator
                  ),
                  field4: numberField(
                    controller: millis,
                    label: "millis",
                    validator: validator
                  ),
                ) ,
                    SizedBox(height: 7),
                    CardField(
                      label: "Speed Changes",
                      field1: numberField(
                        controller: firstQuarter,
                        suffixText: "%",
                        validator: (text) {
                          if(validator(text) != null) {
                            return validator(text);
                          }
                          if(double.parse(text) >= 50) {
                            return "the maximum value of each quarter is 49%";
                          }
                          return null;
                        },
                        label: "start"
                      ),
                      field2: numberField(
                          controller: secondQuarter,
                          suffixText: "%",
                          validator: (text) {
                            if(validator(text) != null) {
                              return validator(text);
                            }
                            if(double.parse(text) >= 50) {
                              return "the maximum value of each quarter is 49%";
                            }
                            return null;
                          },
                          label: "after start"
                      ),
                      field3: numberField(
                          controller: thirdQuarter,
                          suffixText: "%",
                          validator: (text) {
                            if(validator(text) != null) {
                              return validator(text);
                            }
                            if(double.parse(text) >= 50) {
                              return "the maximum value of each quarter is 49%";
                            }
                            return null;
                          },
                          label: "before finish"
                      ),
                      field4: numberField(
                          controller: fourthQuarter,
                          suffixText: "%",
                          validator: (text) {
                            if(validator(text) != null) {
                              return validator(text);
                            }
                            if(double.parse(text) >= 50) {
                              return "the maximum value of each quarter is 49%";
                            }
                            return null;
                          },
                          label: "finish"
                      ),
                    )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}


class CardField extends StatelessWidget {

  String label;
  Widget field1;
  Widget field2;
  Widget field3;
  Widget field4;

  CardField({this.label, this.field1, this.field2, this.field3, this.field4});
  
  @override
  Widget build(BuildContext context) {
    
    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(label, style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700
                          )),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: field1,
                                ),
                                SizedBox(width: 50),
                                Flexible(
                                  child: field2,
                                ),
                            ],
                  ),
                  Row(
                    children: <Widget>[

                                Flexible(
                                  child: field3,
                                ),
                                SizedBox(width: 50),
                                Flexible(
                                  child: field4,
                                )
                    ],
                  )
                          ],
                        ),
                      ),
                    );
  }

}