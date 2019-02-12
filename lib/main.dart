// Replace the code in main.dart with the following.

import 'package:flutter/material.dart';

void main() {
  runApp( new FriendlyChatApp());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.green,
  accentColor: Colors.white,
);

class FriendlyChatApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "WhatsApp",
      theme: kDefaultTheme, 
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChatScreenState();
  }
}
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  @override
void dispose() {                                                   //new
  for (ChatMessage message in _messages)                           //new
    message.animationController.dispose();                         //new
  super.dispose();                                                 //new
}  
  bool _isComposing = false;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = new TextEditingController();
  Widget _buildTextComposer(){
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child:new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
        controller: _textEditingController,
        onSubmitted: _handleSubmitted,
        decoration: new InputDecoration.collapsed(
          hintText: "Send Message",
        ),
        onChanged: (String text){
          setState(() {
            _isComposing = text.length > 0;
          });
        },
      ) ,
          ),
          ClipOval(
            child: new Container(
            color: _isComposing ? Colors.green : Colors.grey[100],
              child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textEditingController.text)    //modified
                  : null, 
            ),
          ),)
        ],
      )
    ),
    );
  }

void _handleSubmitted(String text){
  ChatMessage message = new ChatMessage(
    text: text,
    animationController: new AnimationController(                  //new
      duration: new Duration(milliseconds: 700),                   //new
      vsync: this,                                                 //new
    ),                                                             //new
  );    
  setState(() {                                                    //new
    _isComposing = false;                                          //new
  });    
  setState(() {
    _messages.insert(0,message);
  });
  _textEditingController.clear();
  message.animationController.forward();
}

  @override
  Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(title: new Text("WhatsApp")),
    body: new Column(                                        //modified
      children: <Widget>[                                         //new
        new Flexible(                                             //new
          child: new ListView.builder(                            //new 
            padding: new EdgeInsets.all(8.0),                     //new
            reverse: true,                                        //new
            itemBuilder: (_, int index) => _messages[index],      //new
            itemCount: _messages.length,                          //new
          ),                                                      //new
        ),                                                        //new
        new Divider(height: 1.0),                                 //new
        new Container(                                            //new
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor),                  //new
          child: _buildTextComposer(),                       //modified
        ),                                                        //new
      ],                                                          //new
    ),                                                            //new
  );
}
}
class ChatMessage extends StatelessWidget{
  ChatMessage({this.text,this.animationController});
  final AnimationController animationController;                 
  final String text;
  final String _name = "Meyssa";
  @override
  Widget build(BuildContext context){
       return new SizeTransition(                                    //new
    sizeFactor: new CurvedAnimation(                              //new
        parent: animationController, curve: Curves.easeOut),      //new
    axisAlignment: 0.0,                                           //new
    child: new Container(                                    //modified
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Expanded(                                               //new
  child: new Column(                                   //modified
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Text(_name, style: Theme.of(context).textTheme.subhead),
      new Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: new Text(text),
      ),
    ],
  ),
),              
          ],
        ),
      ) 
    );
  }
}