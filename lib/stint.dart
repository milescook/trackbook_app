import 'lap.dart';

class Stint {
    List<Lap> laps = <Lap>[];

    addLap(lap)
    {
      laps.add(lap);
    }

    getLap(lapNumber)
    {
      return laps[lapNumber];
    }

    Iterable<Lap> getLast(lapCount)
    {
      Iterable<Lap> lastLaps = new List<Lap>();
      if (laps.length == 0) return lastLaps;
      if(laps.length<lapCount)
      {
        lastLaps = laps.getRange(0,laps.length);
      }
      else
      {
        lastLaps= laps.getRange(laps.length - lapCount,laps.length);
      }

      return lastLaps;
    }
  }