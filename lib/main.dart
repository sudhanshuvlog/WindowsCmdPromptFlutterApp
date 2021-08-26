import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

main() async {
  // ignore: close_sinks

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Socket with ardino'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  // ignore: override_on_non_overriding_member
  var serverResponse;
  var x = "null";
  var i = 0;
  var output = "Waiting...";
  // ignore: non_constant_identifier_names
  var command_name;

  get borderRadius => null;
// ignore: non_constant_identifier_names
  send_command_recive_output(datA) async {
    // ignore: close_sinks
    final socket = await Socket.connect("192.168.99.1", 2222);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    socket.write(datA); //to send data
    print("data written");
    socket.listen(
      //to recive output
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        print('Server: $serverResponse');
        setState(() {
          output =
              serverResponse; //this is the  main line which helps in updating the Text widget...
          print(output);
        });
      },
      onError: (error) {
        print(error);
        socket.close();
      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        socket.close();
      },
      // handle errors
    );
  }

  void initstate() async {
    super.initState();
    //g();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          hintColor: Colors.orange,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            centerTitle: true,
            title: Text(
              'Command Line',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 10),
              ),
            ),
          ),
          body: Center(
            // ignore: deprecated_member_us
            child: Container(
              color: Colors.black,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        TextField(
                          
                            cursorColor: Colors.blue,
                            style: TextStyle(color: Colors.lightGreen,fontSize: 25),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 25.0),
                                hintText: "Enter your  command",
                                border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.deepPurpleAccent),
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            onSubmitted: (String value) async {
                              setState(() {
                                command_name = value;
                              });
                              //command_name = value;

                              print(command_name);
                              send_command_recive_output(command_name);
                              // return name;
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            output,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        // ignore: deprecated_member_use
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                await send_command_recive_output(command_name);
                              },
                              child: Text(
                                "    Send    ",
                                style: TextStyle(fontSize: 25.0),
                              ),
                              
                              style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                                 
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.deepPurpleAccent))))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

class TestStyle {
}
