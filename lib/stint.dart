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

    getLast(lapCount)
    {
      if (laps.length == 0) return <Lap>[];
      if(laps.length<lapCount)
        return laps.getRange(0,laps.length);

      return laps.getRange(laps.length - lapCount,lapCount);
    }
  }