import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/screens/drawing_painter.dart';
import 'package:myapp/screens/homepage.dart';
import 'package:myapp/services/recognizer.dart';
import 'package:myapp/models/prediction.dart';
import 'package:myapp/utils/constants.dart';
import 'dart:math';


class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = List<Offset>();
  final _recognizer = Recognizer();
  List<Prediction> _prediction;
  bool initialize = false;

//confidence
String confi = "0";
//label
String label = "none";

String letterQuiz = "";
int score = 0;

List baybayinLetters= ["A","B","BE/BI","BO/BU","KA"];

  @override
  void initState() {
    super.initState();
    _initModel();

 //int randomIndex = Random().nextInt(baybayinLetters.length);
//String letterQuiz = "";  
int randomIndex = Random().nextInt(baybayinLetters.length);
setState(() {
letterQuiz = baybayinLetters[randomIndex];  
});

}

  @override
  
  Widget build(BuildContext context) {
//  print(letterQuiz);
double screenW = MediaQuery.of(context).size.width;
double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Baybayin Recognizer'),
        actions: [FlatButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage(),));
 //             Navigator.pop(context, MaterialPageRoute(builder:(context)=>HomePage(),));
            }, child:Icon(Icons.close,color: Colors.white,))],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(10.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Baybayin Handwritten Quiz',style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Draw the letter in baybayin',)],),),
                  //  _mnistPreviewImage(),
                Container(padding:EdgeInsets.all(10),width:screenW*0.3,decoration:BoxDecoration(border:Border.all(color: Colors.blue,width: 2)),
                  child: Text(letterQuiz,textAlign: TextAlign.center,style: TextStyle(fontSize: screenW*0.06,fontWeight: FontWeight.bold),),)
                ],
                ),
              ),
              SizedBox(height: screenH*0.01,),
              Container(width: screenH*0.5,
                child: 
                Center(child: _drawCanvasWidget())),
//              SizedBox(
  //              height: 10,
   //           ),
            //  Text(_prediction[0].label.toString().toUpperCase() ?? 'none'),
            //  Text(_prediction[0].confidence.toString().toUpperCase()?? 'none'),
              SizedBox(height: screenH*0.01),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  Container(width: MediaQuery.of(context).size.width*0.3,child: RaisedButton(onPressed:(){_recognize();},child: Text("Submit",style: TextStyle(color:Colors.white),),color: Colors.green,elevation: 5,)),
                  Container(width: MediaQuery.of(context).size.width*0.3,
                    child: RaisedButton(onPressed:(){
                        _points.clear();
                      _prediction.clear();
                        },
                        child: Text("Clear",style: TextStyle(color:Colors.white)),color: Colors.red,elevation: 5,),
                        ),
                  Container(width: MediaQuery.of(context).size.width*0.3,
                    child: RaisedButton(onPressed:(){_quiz();
                        _points.clear();
                      _prediction.clear();
                        },
                        child: Text("Next",style: TextStyle(color:Colors.white)),color: Colors.blue,elevation: 5,),
                        ),
                  
                  ],),
                 
            SizedBox(height: screenH*0.005,), 
             Expanded(
               child: Container(height: screenH*0.3 ,
                 child: Padding(padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Container(padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,decoration:BoxDecoration(color:Colors.blue,borderRadius:BorderRadiusDirectional.vertical(top:Radius.elliptical(50, 50))),
                      child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    
                          Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Letter : ",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                              Container(color: Colors.white,width: MediaQuery.of(context).size.width*0.2,
                              child: Text(label,textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                               
                            ],
                          )),
                          Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Confidence : ",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                              Container(color: Colors.white, width: MediaQuery.of(context).size.width*0.15,
                              child: Text(confi, textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),  
                            ],
                          )),  ],),

                      Container(padding:EdgeInsets.all(2),decoration:BoxDecoration(border:Border.all(color: Colors.white,width: 2)),
                        child: Column(
                          children: [Text("Score:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
                            Text(score.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.08)),
                          ],
                        )),
                        ],
                      )),
                  ),
               ),
             ),
                       
              ]
                      ,
          ),
        ),
      ),
 
  /*  floatingActionButton: FloatingActionButton(backgroundColor: Colors.red,
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _points.clear();
            _prediction.clear();
          });
        },
      ),
  */
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.canvasSize + Constants.borderSize * 2,
      height: Constants.canvasSize + Constants.borderSize * 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: Constants.borderSize,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          if (_localPosition.dx >= 0 &&
              _localPosition.dx <= Constants.canvasSize &&
              _localPosition.dy >= 0 &&
              _localPosition.dy <= Constants.canvasSize) {
            setState(() {
              _points.add(_localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
     //moved this to add button 
     //     _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Widget _mnistPreviewImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.black,
      child: FutureBuilder(
        future: _previewImage(),
        builder: (BuildContext _, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data,
              fit: BoxFit.fill,
            );
          } else {
            return Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    print(pred.toString());
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    print((_prediction[0].label).toString().toUpperCase());
    confi = _prediction[0].confidence.toStringAsFixed(2).toUpperCase() ?? '0' ;
    label = _prediction[0].label.toString().toUpperCase() ?? '0';
    if (letterQuiz == label){
        score += 1;   
        };
    print(score);
  });
  }
String _quiz()
{
 // List baybayinLetters= ["a","b","be_bi","bo_bu","ka"];
 //int randomIndex = Random().nextInt(baybayinLetters.length);
//String letterQuiz = "";  
 int randomIndex = Random().nextInt(baybayinLetters.length);
setState(() {
 letterQuiz = baybayinLetters[randomIndex];  
  _points.clear();
//  _prediction.clear();
confi = "";
label = "";
});
}
}


