import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/draw_screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> _tiles= <Widget>[
    _gridTiles(image:"hello.jpeg",title:"hello",pageroute: DrawScreen(),),
    
    _gridTiles(image:"hello.jpeg",title:"hello",pageroute: DrawScreen(),),
    
    _gridTiles(image:"hello.jpeg",title:"hello",pageroute: DrawScreen(),),
    _gridTiles(image:"hello.jpeg",title:"hello",pageroute: DrawScreen(),),
    
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //appBar:AppBar(title:Text("Baybayin Recognizer",style: TextStyle(color:Colors.white),),
    //actions: <Widget>[Container(padding:EdgeInsets.all(1),child: FlatButton(onPressed: (){}, child:Icon(Icons.settings,color: Colors.white,)))],),
    body: Center(
      child: Column(children:[
    //  SizedBox(height:1),
      Container(padding:EdgeInsets.all(10),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.3
      ,decoration: BoxDecoration(color:Colors.lightBlue,borderRadius:BorderRadiusDirectional.vertical(bottom:Radius.elliptical(50, 50))),
      child: Column(
        children: [Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Container(padding:EdgeInsets.all(10),child: Text("Baybayin Recognizer",style: TextStyle(color:Colors.white,fontSize: 20),))),
            FlatButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>DrawScreen(),));
            }, child:Icon(Icons.settings,color: Colors.white,))
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.05,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
        Text("Hello there",style: TextStyle(fontSize: 50),),
        Container(child:Text("hello"),decoration: BoxDecoration(color: Colors.teal,borderRadius:BorderRadiusDirectional.circular(20)),)
        ],),],
      )),
 //     Container(padding:EdgeInsets.all(10),height:MediaQuery.of(context).size.height*0.6,child:
 //     new GridView.count(crossAxisCount: 2,children: _tiles,))
      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
      Container(padding:EdgeInsets.all(10),height:MediaQuery.of(context).size.height*0.6,
        child:
 //       new GridView.count(crossAxisCount: 2,children: _tiles,)
        Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [_categories(title: "LEARN",image: "hello",pageroute: DrawScreen(),),_categories(title: "PRACTICE",image: "hello",pageroute: DrawScreen(),)],),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [_categories(title: "QUIZ",image: "hello",pageroute: DrawScreen(),),_categories(title: "MORE",image: "hello",pageroute: DrawScreen(),)],)    
            ],
          ),
        )
        )
      ])),
    ); 
  }
}


class _categories extends StatelessWidget {
  _categories({Key key ,this.title, this.image,this.pageroute}): super(key : key);
  final String title;
  final String image;
  Widget pageroute;
  @override
  Widget build(BuildContext context) {
    return Container(height: MediaQuery.of(context).size.height*0.25,width: MediaQuery.of(context).size.width*0.4,
   // color: Colors.blue,
      child: Card(color: Colors.white,child: RaisedButton(elevation:5,hoverColor: Colors.grey[100], color: Colors.white,
          onPressed: (){
//            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>pageroute));
            Navigator.push(context, MaterialPageRoute(builder: (context)=>pageroute));
          },
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[ Container(height: 10,decoration: BoxDecoration(image:
          DecorationImage(image: AssetImage('assets/appimages/'+image),fit: BoxFit.cover)))
          ,Container(margin:EdgeInsets.fromLTRB(10, 10, 10, 10),child: Text(title,style: TextStyle(color:Colors.blue),)),],),
          ),
      ),
    );
  }
}



class _gridTiles extends StatelessWidget {
  _gridTiles({Key key,this.image,this.title, this.pageroute}):super(key: key); 
  final String image;
  final String title;
  final Widget pageroute;
  Widget build(BuildContext context) {
     return GridTile(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Container(margin: EdgeInsets.all(10),
        child: RaisedButton(elevation:5,hoverColor: Colors.blue, 
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>pageroute));
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[ Container(height: 10,decoration: BoxDecoration(image:
        DecorationImage(image: AssetImage('assets/appimages/'+image),fit: BoxFit.cover)))
        ,Container(margin:EdgeInsets.fromLTRB(10, 10, 10, 10),child: Text(title,style: TextStyle(color:Colors.blue),)),],),
        ),),
      )
    );
  }
}