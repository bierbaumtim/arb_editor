sealed class PlaceholderDateTimeFormat {
  const PlaceholderDateTimeFormat();

  static PlaceholderDateTimeFormat? fromJson(String json) => switch (json) {
        'd' => const DayPdtf(),
        'E' => const AbbrWeekdayPdtf(),
        'EEEE' => const WeekdayPdtf(),
        'LLL' => const AbbrStandaloneMonthPdtf(),
        'LLLL' => const StandaloneMonthPdtf(),
        'M' => const NumMonthPdtf(),
        'Md' => const NumMonthDayPdtf(),
        'MEd' => const NumMonthWeekdayDayPdtf(),
        'MMM' => const AbbrMonthPdtf(),
        'MMMd' => const AbbrMonthDayPdtf(),
        'MMMEd' => const AbbrMonthWeekdayDayPdtf(),
        'MMMM' => const MonthPdtf(),
        'MMMMd' => const MonthDayPdtf(),
        'MMMMEEEEd' => const MonthWeekdayDayPdtf(),
        'QQQ' => const AbbrQuarterPdtf(),
        'QQQQ' => const QuarterPdtf(),
        'y' => const YearPdtf(),
        'yM' => const YearNumMonthPdtf(),
        'yMd' => const YearNumMonthDayPdtf(),
        'yMEd' => const YearNumMonthWeekdayDayPdtf(),
        'yMMM' => const YearAbbrMonthPdtf(),
        'yMMMd' => const YearAbbrMonthDayPdtf(),
        'yMMMEd' => const YearAbbrMonthWeekdayDayPdtf(),
        'yMMMM' => const YearMonthPdtf(),
        'yMMMMd' => const YearMonthDayPdtf(),
        'yMMMMEEEEd' => const YearMonthWeekdayDayPdtf(),
        'yQQQ' => const YearAbbrQuarterPdtf(),
        'yQQQQ' => const YearQuarterPdtf(),
        'H' => const Hour24Pdtf(),
        'Hm' => const Hour24MinutePdtf(),
        'Hms' => const Hour24MinuteSecondPdtf(),
        'j' => const HourPdtf(),
        'jm' => const HourMinutePdtf(),
        'jms' => const HourMinuteSecondPdtf(),
        'jmv' => const HourMinuteGenericTzPdtf(),
        'jmz' => const HourMinuteTzPdtf(),
        'jv' => const HourGenericTzPdtf(),
        'jz' => const HourTzPdtf(),
        'm' => const MinutePdtf(),
        'ms' => const MinuteSecondPdtf(),
        's' => const SecondPdtf(),
        '' => null,
        _ => CustomPdtf(json),
      };

  String toJsonValue() => switch (this) {
        DayPdtf() => 'd',
        AbbrWeekdayPdtf() => 'E',
        WeekdayPdtf() => 'EEEE',
        AbbrStandaloneMonthPdtf() => 'LLL',
        StandaloneMonthPdtf() => 'LLLL',
        NumMonthPdtf() => 'M',
        NumMonthDayPdtf() => 'Md',
        NumMonthWeekdayDayPdtf() => 'MEd',
        AbbrMonthPdtf() => 'MMM',
        AbbrMonthDayPdtf() => 'MMMd',
        AbbrMonthWeekdayDayPdtf() => 'MMMEd',
        MonthPdtf() => 'MMMM',
        MonthDayPdtf() => 'MMMMd',
        MonthWeekdayDayPdtf() => 'MMMMEEEEd',
        AbbrQuarterPdtf() => 'QQQ',
        QuarterPdtf() => 'QQQQ',
        YearPdtf() => 'y',
        YearNumMonthPdtf() => 'yM',
        YearNumMonthDayPdtf() => 'yMd',
        YearNumMonthWeekdayDayPdtf() => 'yMEd',
        YearAbbrMonthPdtf() => 'yMMM',
        YearAbbrMonthDayPdtf() => 'yMMMd',
        YearAbbrMonthWeekdayDayPdtf() => 'yMMMEd',
        YearMonthPdtf() => 'yMMMM',
        YearMonthDayPdtf() => 'yMMMMd',
        YearMonthWeekdayDayPdtf() => 'yMMMMEEEEd',
        YearAbbrQuarterPdtf() => 'yQQQ',
        YearQuarterPdtf() => 'yQQQQ',
        Hour24Pdtf() => 'H',
        Hour24MinutePdtf() => 'Hm',
        Hour24MinuteSecondPdtf() => 'Hms',
        HourPdtf() => 'j',
        HourMinutePdtf() => 'jm',
        HourMinuteSecondPdtf() => 'jms',
        HourMinuteGenericTzPdtf() => 'jmv',
        HourMinuteTzPdtf() => 'jmz',
        HourGenericTzPdtf() => 'jv',
        HourTzPdtf() => 'jz',
        MinutePdtf() => 'm',
        MinuteSecondPdtf() => 'ms',
        SecondPdtf() => 's',
        CustomPdtf(:final pattern) => pattern,
      };

  String get name => switch (this) {
        DayPdtf() => 'day',
        AbbrWeekdayPdtf() => 'abbrWeekday',
        WeekdayPdtf() => 'weekday',
        AbbrStandaloneMonthPdtf() => 'abbrStandaloneMonth',
        StandaloneMonthPdtf() => 'standaloneMonth',
        NumMonthPdtf() => 'numMonth',
        NumMonthDayPdtf() => 'numMonthDay',
        NumMonthWeekdayDayPdtf() => 'numMonthWeekdayDay',
        AbbrMonthPdtf() => 'abbrMonth',
        AbbrMonthDayPdtf() => 'abbrMonthDay',
        AbbrMonthWeekdayDayPdtf() => 'abbrMonthWeekdayDay',
        MonthPdtf() => 'month',
        MonthDayPdtf() => 'monthDay',
        MonthWeekdayDayPdtf() => 'monthWeekdayDay',
        AbbrQuarterPdtf() => 'abbrQuarter',
        QuarterPdtf() => 'quarter',
        YearPdtf() => 'year',
        YearNumMonthPdtf() => 'yearNumMonth',
        YearNumMonthDayPdtf() => 'yearNumMonthDay',
        YearNumMonthWeekdayDayPdtf() => 'yearNumMonthWeekdayDay',
        YearAbbrMonthPdtf() => 'yearAbbrMonth',
        YearAbbrMonthDayPdtf() => 'yearAbbrMonthDay',
        YearAbbrMonthWeekdayDayPdtf() => 'yearAbbrMonthWeekdayDay',
        YearMonthPdtf() => 'yearMonth',
        YearMonthDayPdtf() => 'yearMonthDay',
        YearMonthWeekdayDayPdtf() => 'yearMonthWeekdayDay',
        YearAbbrQuarterPdtf() => 'yearAbbrQuarter',
        YearQuarterPdtf() => 'yearQuarter',
        Hour24Pdtf() => 'hour24',
        Hour24MinutePdtf() => 'hour24Minute',
        Hour24MinuteSecondPdtf() => 'hour24MinuteSecond',
        HourPdtf() => 'hour',
        HourMinutePdtf() => 'hourMinute',
        HourMinuteSecondPdtf() => 'hourMinuteSecond',
        HourMinuteGenericTzPdtf() => 'hourMinuteGenericTz',
        HourMinuteTzPdtf() => 'hourMinuteTz',
        HourGenericTzPdtf() => 'hourGenericTz',
        HourTzPdtf() => 'hourTz',
        MinutePdtf() => 'minute',
        MinuteSecondPdtf() => 'minuteSecond',
        SecondPdtf() => 'second',
        CustomPdtf() => 'custom',
      };
}

class DayPdtf extends PlaceholderDateTimeFormat {
  const DayPdtf();
}

class AbbrWeekdayPdtf extends PlaceholderDateTimeFormat {
  const AbbrWeekdayPdtf();
}

class WeekdayPdtf extends PlaceholderDateTimeFormat {
  const WeekdayPdtf();
}

class AbbrStandaloneMonthPdtf extends PlaceholderDateTimeFormat {
  const AbbrStandaloneMonthPdtf();
}

class StandaloneMonthPdtf extends PlaceholderDateTimeFormat {
  const StandaloneMonthPdtf();
}

class NumMonthPdtf extends PlaceholderDateTimeFormat {
  const NumMonthPdtf();
}

class NumMonthDayPdtf extends PlaceholderDateTimeFormat {
  const NumMonthDayPdtf();
}

class NumMonthWeekdayDayPdtf extends PlaceholderDateTimeFormat {
  const NumMonthWeekdayDayPdtf();
}

class AbbrMonthPdtf extends PlaceholderDateTimeFormat {
  const AbbrMonthPdtf();
}

class AbbrMonthDayPdtf extends PlaceholderDateTimeFormat {
  const AbbrMonthDayPdtf();
}

class AbbrMonthWeekdayDayPdtf extends PlaceholderDateTimeFormat {
  const AbbrMonthWeekdayDayPdtf();
}

class MonthPdtf extends PlaceholderDateTimeFormat {
  const MonthPdtf();
}

class MonthDayPdtf extends PlaceholderDateTimeFormat {
  const MonthDayPdtf();
}

class MonthWeekdayDayPdtf extends PlaceholderDateTimeFormat {
  const MonthWeekdayDayPdtf();
}

class AbbrQuarterPdtf extends PlaceholderDateTimeFormat {
  const AbbrQuarterPdtf();
}

class QuarterPdtf extends PlaceholderDateTimeFormat {
  const QuarterPdtf();
}

class YearPdtf extends PlaceholderDateTimeFormat {
  const YearPdtf();
}

class YearNumMonthPdtf extends PlaceholderDateTimeFormat {
  const YearNumMonthPdtf();
}

class YearNumMonthDayPdtf extends PlaceholderDateTimeFormat {
  const YearNumMonthDayPdtf();
}

class YearNumMonthWeekdayDayPdtf extends PlaceholderDateTimeFormat {
  const YearNumMonthWeekdayDayPdtf();
}

class YearAbbrMonthPdtf extends PlaceholderDateTimeFormat {
  const YearAbbrMonthPdtf();
}

class YearAbbrMonthDayPdtf extends PlaceholderDateTimeFormat {
  const YearAbbrMonthDayPdtf();
}

class YearAbbrMonthWeekdayDayPdtf extends PlaceholderDateTimeFormat {
  const YearAbbrMonthWeekdayDayPdtf();
}

class YearMonthPdtf extends PlaceholderDateTimeFormat {
  const YearMonthPdtf();
}

class YearMonthDayPdtf extends PlaceholderDateTimeFormat {
  const YearMonthDayPdtf();
}

class YearMonthWeekdayDayPdtf extends PlaceholderDateTimeFormat {
  const YearMonthWeekdayDayPdtf();
}

class YearAbbrQuarterPdtf extends PlaceholderDateTimeFormat {
  const YearAbbrQuarterPdtf();
}

class YearQuarterPdtf extends PlaceholderDateTimeFormat {
  const YearQuarterPdtf();
}

class Hour24Pdtf extends PlaceholderDateTimeFormat {
  const Hour24Pdtf();
}

class Hour24MinutePdtf extends PlaceholderDateTimeFormat {
  const Hour24MinutePdtf();
}

class Hour24MinuteSecondPdtf extends PlaceholderDateTimeFormat {
  const Hour24MinuteSecondPdtf();
}

class HourPdtf extends PlaceholderDateTimeFormat {
  const HourPdtf();
}

class HourMinutePdtf extends PlaceholderDateTimeFormat {
  const HourMinutePdtf();
}

class HourMinuteSecondPdtf extends PlaceholderDateTimeFormat {
  const HourMinuteSecondPdtf();
}

class HourMinuteGenericTzPdtf extends PlaceholderDateTimeFormat {
  const HourMinuteGenericTzPdtf();
}

class HourMinuteTzPdtf extends PlaceholderDateTimeFormat {
  const HourMinuteTzPdtf();
}

class HourGenericTzPdtf extends PlaceholderDateTimeFormat {
  const HourGenericTzPdtf();
}

class HourTzPdtf extends PlaceholderDateTimeFormat {
  const HourTzPdtf();
}

class MinutePdtf extends PlaceholderDateTimeFormat {
  const MinutePdtf();
}

class MinuteSecondPdtf extends PlaceholderDateTimeFormat {
  const MinuteSecondPdtf();
}

class SecondPdtf extends PlaceholderDateTimeFormat {
  const SecondPdtf();
}

class CustomPdtf extends PlaceholderDateTimeFormat {
  final String pattern;

  const CustomPdtf(this.pattern);
}
