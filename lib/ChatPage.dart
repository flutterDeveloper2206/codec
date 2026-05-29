import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cotec/vaibretion_helper.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  List<String> messageList = [];

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  String highVoltage = '';
  String lowVoltage = '';
  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      if (_connection.isConnected == true) {
        _sendMessage('0i');
        // _sendMessage('1i');
        // messages.clear();
        // _sendMessage('f');
      }
      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  VoltMeterData voltMeterData = VoltMeterData();

  dataCalculate(double value) {
    if (value <= 300) {
      voltMeterData = VoltMeterData(
          color: Colors.green,
          endValue: 301,
          interval: 100,
          maximum: 301,
          value: value,
          voltage: 'V');
    }

    if (value > 300 && value < 3001) {
      if (value > 301 && value < 400) {
        // LocalAudioPlayer.play('assets/sound/waring_sound.wav');
        LocalAudioPlayer.play('assets/sound/waring_sound.wav');
      }
      if (value > 301 && value < 800) {
        VibrationHelper.orderSuccessVibrate();
        VibrationHelper.orderSuccessVibrate();
      }
      var newValue = value / 1000;
      voltMeterData = VoltMeterData(
          color: Colors.red,
          endValue: 3.1,
          interval: 1,
          maximum: 3.1,
          value: newValue,
          voltage: 'KV');
    }
    if (value >= 3001 && value < 30000) {
      if (value > 3001 && value < 3100) {
        // LocalAudioPlayer.play('assets/sound/waring_sound.wav');
        LocalAudioPlayer.play('assets/sound/waring_sound.wav');
      }
      if (value > 3001 && value < 3800) {
        VibrationHelper.orderSuccessVibrate();
        VibrationHelper.orderSuccessVibrate();
      }
      var newValue = value / 1000;
      voltMeterData = VoltMeterData(
          color: Colors.red,
          endValue: 30.1,
          interval: 10,
          maximum: 30.1,
          value: newValue,
          voltage: 'KV');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final List<Row> list = messages.map((_message) {
    //   return Row(
    //     children: <Widget>[
    //       Container(
    //         child: Text(
    //             (text) {
    //               return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
    //             }(_message.text.trim()),
    //             style: TextStyle(color: Colors.white)),
    //         padding: EdgeInsets.all(12.0),
    //         margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
    //         width: 222.0,
    //         decoration: BoxDecoration(
    //             color:
    //                 _message.whom == clientID ? Colors.blueAccent : Colors.grey,
    //             borderRadius: BorderRadius.circular(7.0)),
    //       ),
    //     ],
    //     mainAxisAlignment: _message.whom == clientID
    //         ? MainAxisAlignment.end
    //         : MainAxisAlignment.start,
    //   );
    // }).toList();

    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ' + serverName + '...')
              : isConnected
                  ? Text('Live chat with ' + serverName)
                  : Text('Chat log with ' + serverName))),
      body: SafeArea(
          child: Column(
        children: [
          SfRadialGauge(
              // enableLoadingAnimation: true,
              animationDuration: 4500,
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  interval: voltMeterData.interval,
                  axisLineStyle:
                      AxisLineStyle(color: Colors.transparent, thickness: 20),
                  maximum: voltMeterData.maximum,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: voltMeterData.endValue,
                      color: voltMeterData.color,
                      endWidth: 25,
                      startWidth: 25,
                    ),
                    // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                    // GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
                  ],
                  tickOffset: 10,
                  minorTickStyle: MinorTickStyle(
                      length: 8, thickness: 3, color: Colors.black),
                  majorTickStyle: MajorTickStyle(
                      length: 12, thickness: 5, color: Colors.black),
                  axisLabelStyle:
                      GaugeTextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      needleStartWidth: 0,
                      value: voltMeterData.value,
                      needleColor: Color(0xffF95A37),
                      knobStyle: KnobStyle(color: Color(0xffE6E6E6)),
                      // value: double.parse(randomValues.toString()),
                      animationDuration: 3000,
                      animationType: AnimationType.elasticOut,
                      enableAnimation: true,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          '${voltMeterData.value.toStringAsFixed(1)}\n${voltMeterData.voltage}',
                          key: ValueKey(voltMeterData.value.toString()),

                          textAlign: TextAlign.center,
                          // This key causes the AnimatedSwitcher to interpret this as a "new"
                          // child each time the count changes, so that it will begin its animation
                          // when the count changes.
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        angle: 90,
                        positionFactor: 0.5)
                  ],
                )
              ]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Low Voltage:- $lowVoltage'),
              Text('high Voltage:- $highVoltage'),
            ],
          )
        ],
      )
          // Column(
          //   children: <Widget>[
          //     // Flexible(
          //     //   child: ListView(
          //     //       padding: const EdgeInsets.all(12.0),
          //     //       controller: listScrollController,
          //     //       children: list),
          //     // ),
          //     // Row(
          //     //   children: <Widget>[
          //     //     Flexible(
          //     //       child: Container(
          //     //         margin: const EdgeInsets.only(left: 16.0),
          //     //         child: TextField(
          //     //           style: const TextStyle(fontSize: 15.0),
          //     //           controller: textEditingController,
          //     //           decoration: InputDecoration.collapsed(
          //     //             hintText: isConnecting
          //     //                 ? 'Wait until connected...'
          //     //                 : isConnected
          //     //                     ? 'Type your message...'
          //     //                     : 'Chat got disconnected',
          //     //             hintStyle: const TextStyle(color: Colors.grey),
          //     //           ),
          //     //           enabled: isConnected,
          //     //         ),
          //     //       ),
          //     //     ),
          //     //     Container(
          //     //       margin: const EdgeInsets.all(8.0),
          //     //       child: IconButton(
          //     //           icon: const Icon(Icons.send),
          //     //           onPressed: isConnected
          //     //               ? () => _sendMessage(textEditingController.text)
          //     //               : null),
          //     //     ),
          //     //   ],
          //     // )
          //   ],
          // ),
          ),
    );
  }

  List<String> checkList = [];

  void _onDataReceiveds(Uint8List data) {
    print('data ++77777   ${data}');
    // Allocate buffer for parsed data
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 333),
        curve: Curves.easeOut);
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
      print('22222222 ${messages.length.toString()}');

      // }
      // if (dataString.contains('X')) {
      //
      //   if (dataString == 'X0i') {
      //     _sendMessage('1i');
      //   }
      //   if (dataString.contains('F')) {
      //     var listF = dataString.split(';');
      //     print('voltage == ${listF.last}');
      //     messageF = int.parse(listF.last);
      //     int c12 = excelFunction(messageF);
      //     _sendMessage('$c12' + 'u');
      //   } else {
      //     _sendMessage('f');
      //     var listF = dataString.split(';');
      //     print('voltage == ${listF.last}');
      //     messageF = int.parse(listF.last);
      //     int c12 = excelFunction(messageF);
      //     _sendMessage('$c12' + 'u');
      //   }
      // }
      autoMessage();
      var list = dataString.split(';');
      print('voltage == ${list.last}');
      print(
          '_messageBuffer + dataString.substring(0, index) ==${dataString.substring(0, index)}');
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    // listScrollController.animateTo(
    //     listScrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 333),
    //     curve: Curves.easeOut);
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    String dataString = String.fromCharCodes(buffer);
    // print('data ++77777   ${data}');
    // print('dataString ++77777   ${dataString}');
    int index = buffer.indexOf(13);

    setState(() {
      messages.add(
        _Message(
          1,
          backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        ),
      );

      String livem = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString.substring(0, index);
      print('***********((()))   ${dataString}');

      print('***********((()))   ${livem}');
      int messageF = 0;
      if (livem.contains('X0i') || livem.contains('R0i')) {
        _sendMessage('1i');
      }
      if (livem.startsWith('F')) {
        messageList.clear();
        messageList.add(livem);
        var listF = messageList.first.split(';');
        print('voltage ==+++ ${listF.last}');
        messageF = int.parse(listF.last);
        print('voltage ==+++1212121 ${messageF}');

        int c12 = excelFunction(messageF);
        print('voltage ==+++---- ${c12}');

        _sendMessage('$c12' + 'u');
        print('livem ++77777   ${messageList.toString()}');
      } else {
        if (livem.startsWith('V')) {
          print('livem ++77777==============   ${livem}');
          var listF = livem.split(';');
          print('voltage FIRST *** ${listF.first.replaceAll('V', '')}');
          print('voltage ==+++ ${listF.last}');
          lowVoltage = listF.first.replaceAll('V', '');
          if (listF.last.isNotEmpty && listF.last != "V") {
            highVoltage = listF.last;
            messageF = int.parse(listF.last);
            print('voltage ==+++1212121 ${messageF}');
            dataCalculate(double.parse(listF.last));
          }
        }
      }
    });
  }

  autoMessage() {
    int messageF = 0;

    // if (dataString.contains('X')) {
    // checkList.add(dataString);

    messages.forEach((element) {
      if (element.text.contains('X0i') || element.text.contains('R0i')) {
        _sendMessage('1i');
      }
      // if (element.whom == clientID) {
      print('22222222+++++++++++++ ${element.text.toString()}');
      print(
          '${element.text}   22222222+++++++++++++ ${element.text.startsWith('F')}');
      if (element.text.startsWith('F')) {
        var listF = element.text.split(';');
        print('voltage ==+++ ${listF.last}');
        messageF = int.parse(listF.last);
        print('voltage ==+++1212121 ${messageF}');

        int c12 = excelFunction(messageF);
        print('voltage ==+++---- ${c12}');

        _sendMessage('$c12' + 'u');
      }
      // }
    });
  }

  int excelFunction(int c12) {
    int mod5 = c12 % 5;
    int mod17 = c12 % 17;
    int result = ((c12 + mod5 + mod17) * 16 + c12) ~/ 128;
    return result.toInt();
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

class VoltMeterData {
  double interval;
  double value;
  double endValue;
  double maximum;
  String voltage;
  Color color;
  VoltMeterData(
      {this.interval = 100,
      this.endValue = 301,
      this.value = 0,
      this.voltage = 'V',
      this.maximum = 301,
      this.color = Colors.green});
}
