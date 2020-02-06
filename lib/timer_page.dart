import 'package:flutter/material.dart';
import 'dart:async';
import 'lap.dart';
import 'stint.dart';
import 'yellow_flags.dart';
import 'safety_car.dart';

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));

void openPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Next page'),
        ),
        body: const Center(
          child: Text(
            'This is the next page',
            style: TextStyle(fontSize: 14),
          ),
        ),
      );
    },
  ));
}




class Dependencies {

  final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(fontSize: 60.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 60;
  IconData safetyCarIcon = Icons.directions_car;
  int lapNumber = 1;
  int pitwallEta = 0;
  Color sessionStateColor = Colors.green;
  YellowFlags yellowFlagObject = new YellowFlags();
  SafetyCar safetyCarObject = new SafetyCar();
  bool safetyCar = false;
  String sessionStateText = "Running";

  Stint stint = new Stint();
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final Dependencies dependencies = new Dependencies();
  
  void lapButtonPressed() {
    setState(() {

      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsedMilliseconds}");
        
        addLap(dependencies.stopwatch.elapsedMilliseconds);
        dependencies.lapNumber ++;
        dependencies.stopwatch.reset();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }
  

  void addLap(laptime)
  {
    Lap thisLap = new Lap();
    thisLap.lapNumber = dependencies.lapNumber;
    thisLap.laptimeMilliseconds = laptime;
    thisLap.yellowFlags = dependencies.yellowFlagObject;
    thisLap.safetyCar = dependencies.safetyCar;

    int milliseconds = dependencies.stopwatch.elapsedMilliseconds;
    
    dependencies.stint.addLap(thisLap);
  }

  void toggleYellow(context)
  {
    setState(() {
      dependencies.yellowFlagObject.toggleState();
      dependencies.sessionStateColor = dependencies.yellowFlagObject.sessionStateColor;
      dependencies.sessionStateText =  dependencies.yellowFlagObject.sessionState;
    });
  }

  void toggleSafetyCar(context)
  {
    setState(() {
        dependencies.safetyCarObject.toggleState();
        dependencies.sessionStateColor = dependencies.safetyCarObject.sessionStateColor;
        dependencies.sessionStateText =  dependencies.safetyCarObject.sessionState;
    });
  }

  getCurrentLapOptionsRow()
  {
    return <Widget> 
    [
      IconButton(
          icon:  Icon(dependencies.yellowFlagObject.flagIcon),
          iconSize: 60,
          color: Colors.yellow,
          tooltip: 'Yellow Flag',
          onPressed: () {
            toggleYellow(context);
          },
        ),
        IconButton(
          icon:  Icon(dependencies.safetyCarObject.icon),
          iconSize: 60,
          color: dependencies.safetyCarObject.iconColor,
          tooltip: 'Safety Car',
          onPressed: () {
            toggleSafetyCar(context);
          },
        ),
    ];
  }

  formatLaptime(laptimeMilliseconds)
  {
    int laptimeThousands = (laptimeMilliseconds ).truncate();
    int laptimeSeconds = (laptimeThousands / 1000).truncate();
    int laptimeMinutes = (laptimeSeconds / 60).truncate();
    int laptimeHours = (laptimeMinutes / 60).truncate();

    String laptime = 
    (laptimeMinutes % 60).toString().padLeft(2, '0') + ":" +
    (laptimeSeconds % 100).toString().padLeft(2, '0') + "." +
    (laptimeThousands % 100).toString().padLeft(3, '0');

    return laptime;
  }
  
  getHistoricalLapRowWidget(Lap thisLap)
  {
    Row thisRow = new Row
    (
      children: <Widget>[
          Text(thisLap.lapNumber.toString(),style: TextStyle(fontSize: 60)),
          Text(formatLaptime(thisLap.laptimeMilliseconds),style: dependencies.textStyle)
      ],
    );

    return thisRow;
  }

  getLapHistory()
  {
    var lapWidgets = <Widget>[];

    var lapHistory = dependencies.stint.getLast(3);
    if(lapHistory==null)
      return lapWidgets;
     for (int i = lapHistory.length-1; i >= 0; i--)
    {
      Lap thisLap = lapHistory.elementAt(i);
        lapWidgets.add(getHistoricalLapRowWidget(thisLap));
    }

    return lapWidgets;
    
  }

  getFooter()
  {
    var footerWidgets = <Widget>[];
    Row thisRow = new Row
    (
      children: <Widget>[
          Text(" Pit ETA: ",style: TextStyle(fontSize: 60)),
          Text(dependencies.pitwallEta.toString(),style: TextStyle(fontSize: 60))
      ],
    );

    footerWidgets.add(thisRow);

    return footerWidgets;
  }

  getCurrentLapNumber()
  {
    return new Text(dependencies.lapNumber.toString(),style: TextStyle(fontSize: 60));
  }

  getCurrentLaptimeRow()
  {
    return <Widget>
    [
      getCurrentLapNumber(),
      getCurrentLaptime(),
      getCurrentLapButtons()
        ];
  }

  getCurrentLaptime() 
  {
    return new Expanded(child: new TimerText(dependencies: dependencies));
  }

  getCurrentLapButtons()
  {
    return new Expanded(
      flex: 0,
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildFloatingButton(dependencies.stopwatch.isRunning ? "lap" : "start", lapButtonPressed),
          ],
        ),
      ),
    );
  }



  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle = const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
      child: new Text(text, style: roundTextStyle),
      backgroundColor: Colors.green,
      onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      title: Text(dependencies.sessionStateText),
      centerTitle: true,
      backgroundColor: dependencies.sessionStateColor,
      leading: 
        IconButton(
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Previous page',
          onPressed: () {
            openPage(context);
          },
        ),
      ),
    body:  Center(
      child:  Container(
        margin: EdgeInsets.fromLTRB(0, 40, 0, 30),
        height: 600,
        child: new Column(
          children: <Widget>[
            new Row(
              children:  getCurrentLaptimeRow()
            ),
            new Row(
              children: getCurrentLapOptionsRow()
            ),
            new Column(
              children: getLapHistory()
            ),
            new Column(
              children: getFooter()
            )
          ],
        ),
      ),
    ),
  );
  }
} // Class TimerPage


class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() => new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate), callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          new RepaintBoundary(
            child: new SizedBox(
              height: 72.0,
              child: new MinutesAndSeconds(dependencies: dependencies),
            ),
          ),
          new RepaintBoundary(
            child: new SizedBox(
              height: 72.0,
              child: new Hundreds(dependencies: dependencies),
            ),
          ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() => new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }

  
}