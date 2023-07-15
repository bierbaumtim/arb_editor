import 'package:freezed_annotation/freezed_annotation.dart';

part 'placeholder.freezed.dart';

class Placeholder {
  final String name;
  final PlaceholderType type;
  final PlaceholderNumberFormat? numberFormat;
  final PlaceholderDateTimeFormat? dateTimeFormat;
  final int? decimalDigits;
  final String? symbol;
  final String? customPattern;

  const Placeholder({
    required this.name,
    required this.type,
    this.numberFormat,
    this.dateTimeFormat,
    this.decimalDigits,
    this.symbol,
    this.customPattern,
  });

  factory Placeholder.fromMap(String name, Map<String, dynamic> json) {
    final optionalParameters =
        json['optionalParameters'] as Map<String, dynamic>? ??
            <String, dynamic>{};

    final type = PlaceholderType.fromJson(json['type'] as String? ?? '');
    final isDateTimeType = type is DateTimePlaceholder;
    final isNumberType = switch (type) {
      IntPlaceholder() || DoublePlaceholder() || NumberPlaceholder() => true,
      _ => false,
    };

    return Placeholder(
      name: name,
      type: type,
      numberFormat: isNumberType
          ? _placeholderFormatFromJson(json['format'] as String?)
          : null,
      dateTimeFormat: isDateTimeType
          ? PlaceholderDateTimeFormat.fromJson(json['type'] as String? ?? '')
          : null,
      decimalDigits: optionalParameters['decimalDigits'] as int?,
      customPattern: optionalParameters['customPattern'] as String?,
      symbol: optionalParameters['symbol'] as String?,
    );
  }

  static PlaceholderNumberFormat? _placeholderFormatFromJson(String? value) {
    switch (value) {
      case 'compact':
        return PlaceholderNumberFormat.compact;
      case 'compactCurrency':
        return PlaceholderNumberFormat.compactCurrency;
      case 'compactSimpleCurrency':
        return PlaceholderNumberFormat.compactSimpleCurrency;
      case 'compactLong':
        return PlaceholderNumberFormat.compactLong;
      case 'currency':
        return PlaceholderNumberFormat.currency;
      case 'decimalPattern':
        return PlaceholderNumberFormat.decimalPattern;
      case 'decimalPercentPattern':
        return PlaceholderNumberFormat.decimalPercentPattern;
      case 'percentPattern':
        return PlaceholderNumberFormat.percentPattern;
      case 'scientificPattern':
        return PlaceholderNumberFormat.scientificPattern;
      case 'simpleCurrency':
        return PlaceholderNumberFormat.simpleCurrency;
      default:
        return null;
    }
  }
}

sealed class PlaceholderType {
  const PlaceholderType();

  static PlaceholderType fromJson(String json) {
    return switch (json) {
      'int' => const IntPlaceholder(),
      'double' => const DoublePlaceholder(),
      'num' => const NumberPlaceholder(),
      'DateTime' => const DateTimePlaceholder(),
      'String' => const StringPlaceholder(),
      _ => UnknownPlaceholder(json),
    };
  }
}

class IntPlaceholder extends PlaceholderType {
  const IntPlaceholder();
}

class DoublePlaceholder extends PlaceholderType {
  const DoublePlaceholder();
}

class NumberPlaceholder extends PlaceholderType {
  const NumberPlaceholder();
}

class DateTimePlaceholder extends PlaceholderType {
  const DateTimePlaceholder();
}

class StringPlaceholder extends PlaceholderType {
  const StringPlaceholder();
}

class UnknownPlaceholder extends PlaceholderType {
  final String value;

  const UnknownPlaceholder(this.value);
}

enum PlaceholderNumberFormat {
  compact,
  compactCurrency,
  compactSimpleCurrency,
  compactLong,
  currency,
  decimalPattern,
  decimalPercentPattern,
  percentPattern,
  scientificPattern,
  simpleCurrency;
}

@freezed
class PlaceholderDateTimeFormat with _$PlaceholderDateTimeFormat {
  const PlaceholderDateTimeFormat._();

  const factory PlaceholderDateTimeFormat.day() = _Day;
  const factory PlaceholderDateTimeFormat.abbrWeekday() = _AbbrWeekday;
  const factory PlaceholderDateTimeFormat.weekday() = _Weekday;
  const factory PlaceholderDateTimeFormat.abbrStandaloneMonth() =
      _AbbrStandaloneMonth;
  const factory PlaceholderDateTimeFormat.standaloneMonth() = _StandaloneMonth;
  const factory PlaceholderDateTimeFormat.numMonth() = _NumMonth;
  const factory PlaceholderDateTimeFormat.numMonthDay() = _NumMonthDay;
  const factory PlaceholderDateTimeFormat.numMonthWeekdayDay() =
      _NumMonthWeekdayDay;
  const factory PlaceholderDateTimeFormat.abbrMonth() = _AbbrMonth;
  const factory PlaceholderDateTimeFormat.abbrMonthDay() = _AbbrMonthDay;
  const factory PlaceholderDateTimeFormat.abbrMonthWeekdayDay() =
      _AbbrMonthWeekdayDay;
  const factory PlaceholderDateTimeFormat.month() = _Month;
  const factory PlaceholderDateTimeFormat.monthDay() = _MonthDay;
  const factory PlaceholderDateTimeFormat.monthWeekdayDay() = _MonthWeekdayDay;
  const factory PlaceholderDateTimeFormat.abbrQuarter() = _AbbrQuarter;
  const factory PlaceholderDateTimeFormat.quarter() = _Quarter;
  const factory PlaceholderDateTimeFormat.year() = _Year;
  const factory PlaceholderDateTimeFormat.yearNumMonth() = _YearNumMonth;
  const factory PlaceholderDateTimeFormat.yearNumMonthDay() = _YearNumMonthDay;
  const factory PlaceholderDateTimeFormat.yearNumMonthWeekdayDay() =
      _YearNumMonthWeekdayDay;
  const factory PlaceholderDateTimeFormat.yearAbbrMonth() = _YearAbbrMonth;
  const factory PlaceholderDateTimeFormat.yearAbbrMonthDay() =
      _YearAbbrMonthDay;
  const factory PlaceholderDateTimeFormat.yearAbbrMonthWeekdayDay() =
      _YearAbbrMonthWeekdayDay;
  const factory PlaceholderDateTimeFormat.yearMonth() = _YearMonth;
  const factory PlaceholderDateTimeFormat.yearMonthDay() = _YearMonthDay;
  const factory PlaceholderDateTimeFormat.yearMonthWeekdayDay() =
      _YearMonthWeekdayDay;
  const factory PlaceholderDateTimeFormat.yearAbbrQuarter() = _YearAbbrQuarter;
  const factory PlaceholderDateTimeFormat.yearQuarter() = _YearQuarter;
  const factory PlaceholderDateTimeFormat.hour24() = _Hour24;
  const factory PlaceholderDateTimeFormat.hour24Minute() = _Hour24Minute;
  const factory PlaceholderDateTimeFormat.hour24MinuteSecond() =
      _Hour24MinuteSecond;
  const factory PlaceholderDateTimeFormat.hour() = _Hour;
  const factory PlaceholderDateTimeFormat.hourMinute() = _HourMinute;
  const factory PlaceholderDateTimeFormat.hourMinuteSecond() =
      _HourMinuteSecond;
  const factory PlaceholderDateTimeFormat.hourMinuteGenericTz() =
      _HourMinuteGenericTz;
  const factory PlaceholderDateTimeFormat.hourMinuteTz() = _HourMinuteTz;
  const factory PlaceholderDateTimeFormat.hourGenericTz() = _HourGenericTz;
  const factory PlaceholderDateTimeFormat.hourTz() = _HourTz;
  const factory PlaceholderDateTimeFormat.minute() = _Minute;
  const factory PlaceholderDateTimeFormat.minuteSecond() = _MinuteSecond;
  const factory PlaceholderDateTimeFormat.second() = _Second;
  const factory PlaceholderDateTimeFormat.custom(String pattern) = _Custom;

  String toJsonValue() => when(
        day: () => 'd',
        abbrWeekday: () => 'E',
        weekday: () => 'EEEE',
        abbrStandaloneMonth: () => 'LLL',
        standaloneMonth: () => 'LLLL',
        numMonth: () => 'M',
        numMonthDay: () => 'Md',
        numMonthWeekdayDay: () => 'MEd',
        abbrMonth: () => 'MMM',
        abbrMonthDay: () => 'MMMd',
        abbrMonthWeekdayDay: () => 'MMMEd',
        month: () => 'MMMM',
        monthDay: () => 'MMMMd',
        monthWeekdayDay: () => 'MMMMEEEEd',
        abbrQuarter: () => 'QQQ',
        quarter: () => 'QQQQ',
        year: () => 'y',
        yearNumMonth: () => 'yM',
        yearNumMonthDay: () => 'yMd',
        yearNumMonthWeekdayDay: () => 'yMEd',
        yearAbbrMonth: () => 'yMMM',
        yearAbbrMonthDay: () => 'yMMMd',
        yearAbbrMonthWeekdayDay: () => 'yMMMEd',
        yearMonth: () => 'yMMMM',
        yearMonthDay: () => 'yMMMMd',
        yearMonthWeekdayDay: () => 'yMMMMEEEEd',
        yearAbbrQuarter: () => 'yQQQ',
        yearQuarter: () => 'yQQQQ',
        hour24: () => 'H',
        hour24Minute: () => 'Hm',
        hour24MinuteSecond: () => 'Hms',
        hour: () => 'j',
        hourMinute: () => 'jm',
        hourMinuteSecond: () => 'jms',
        hourMinuteGenericTz: () => 'jmv',
        hourMinuteTz: () => 'jmz',
        hourGenericTz: () => 'jv',
        hourTz: () => 'jz',
        minute: () => 'm',
        minuteSecond: () => 'ms',
        second: () => 's',
        custom: (pattern) => pattern,
      );

  String get name => when(
        day: () => 'day',
        abbrWeekday: () => 'abbrWeekday',
        weekday: () => 'weekday',
        abbrStandaloneMonth: () => 'abbrStandaloneMonth',
        standaloneMonth: () => 'standaloneMonth',
        numMonth: () => 'numMonth',
        numMonthDay: () => 'numMonthDay',
        numMonthWeekdayDay: () => 'numMonthWeekdayDay',
        abbrMonth: () => 'abbrMonth',
        abbrMonthDay: () => 'abbrMonthDay',
        abbrMonthWeekdayDay: () => 'abbrMonthWeekdayDay',
        month: () => 'month',
        monthDay: () => 'monthDay',
        monthWeekdayDay: () => 'monthWeekdayDay',
        abbrQuarter: () => 'abbrQuarter',
        quarter: () => 'quarter',
        year: () => 'year',
        yearNumMonth: () => 'yearNumMonth',
        yearNumMonthDay: () => 'yearNumMonthDay',
        yearNumMonthWeekdayDay: () => 'yearNumMonthWeekdayDay',
        yearAbbrMonth: () => 'yearAbbrMonth',
        yearAbbrMonthDay: () => 'yearAbbrMonthDay',
        yearAbbrMonthWeekdayDay: () => 'yearAbbrMonthWeekdayDay',
        yearMonth: () => 'yearMonth',
        yearMonthDay: () => 'yearMonthDay',
        yearMonthWeekdayDay: () => 'yearMonthWeekdayDay',
        yearAbbrQuarter: () => 'yearAbbrQuarter',
        yearQuarter: () => 'yearQuarter',
        hour24: () => 'hour24',
        hour24Minute: () => 'hour24Minute',
        hour24MinuteSecond: () => 'hour24MinuteSecond',
        hour: () => 'hour',
        hourMinute: () => 'hourMinute',
        hourMinuteSecond: () => 'hourMinuteSecond',
        hourMinuteGenericTz: () => 'hourMinuteGenericTz',
        hourMinuteTz: () => 'hourMinuteTz',
        hourGenericTz: () => 'hourGenericTz',
        hourTz: () => 'hourTz',
        minute: () => 'minute',
        minuteSecond: () => 'minuteSecond',
        second: () => 'second',
        custom: (_) => 'custom',
      );

  static PlaceholderDateTimeFormat? fromJson(String json) {
    switch (json) {
      case 'd':
        return const PlaceholderDateTimeFormat.day();
      case 'E':
        return const PlaceholderDateTimeFormat.abbrWeekday();
      case 'EEEE':
        return const PlaceholderDateTimeFormat.weekday();
      case 'LLL':
        return const PlaceholderDateTimeFormat.abbrStandaloneMonth();
      case 'LLLL':
        return const PlaceholderDateTimeFormat.standaloneMonth();
      case 'M':
        return const PlaceholderDateTimeFormat.numMonth();
      case 'Md':
        return const PlaceholderDateTimeFormat.numMonthDay();
      case 'MEd':
        return const PlaceholderDateTimeFormat.numMonthWeekdayDay();
      case 'MMM':
        return const PlaceholderDateTimeFormat.abbrMonth();
      case 'MMMd':
        return const PlaceholderDateTimeFormat.abbrMonthDay();
      case 'MMMEd':
        return const PlaceholderDateTimeFormat.abbrMonthWeekdayDay();
      case 'MMMM':
        return const PlaceholderDateTimeFormat.month();
      case 'MMMMd':
        return const PlaceholderDateTimeFormat.monthDay();
      case 'MMMMEEEEd':
        return const PlaceholderDateTimeFormat.monthWeekdayDay();
      case 'QQQ':
        return const PlaceholderDateTimeFormat.abbrQuarter();
      case 'QQQQ':
        return const PlaceholderDateTimeFormat.quarter();
      case 'y':
        return const PlaceholderDateTimeFormat.year();
      case 'yM':
        return const PlaceholderDateTimeFormat.yearNumMonth();
      case 'yMd':
        return const PlaceholderDateTimeFormat.yearNumMonthDay();
      case 'yMEd':
        return const PlaceholderDateTimeFormat.yearNumMonthWeekdayDay();
      case 'yMMM':
        return const PlaceholderDateTimeFormat.yearAbbrMonth();
      case 'yMMMd':
        return const PlaceholderDateTimeFormat.yearAbbrMonthDay();
      case 'yMMMEd':
        return const PlaceholderDateTimeFormat.yearAbbrMonthWeekdayDay();
      case 'yMMMM':
        return const PlaceholderDateTimeFormat.yearMonth();
      case 'yMMMMd':
        return const PlaceholderDateTimeFormat.yearMonthDay();
      case 'yMMMMEEEEd':
        return const PlaceholderDateTimeFormat.yearMonthWeekdayDay();
      case 'yQQQ':
        return const PlaceholderDateTimeFormat.yearAbbrQuarter();
      case 'yQQQQ':
        return const PlaceholderDateTimeFormat.yearQuarter();
      case 'H':
        return const PlaceholderDateTimeFormat.hour24();
      case 'Hm':
        return const PlaceholderDateTimeFormat.hour24Minute();
      case 'Hms':
        return const PlaceholderDateTimeFormat.hour24MinuteSecond();
      case 'j':
        return const PlaceholderDateTimeFormat.hour();
      case 'jm':
        return const PlaceholderDateTimeFormat.hourMinute();
      case 'jms':
        return const PlaceholderDateTimeFormat.hourMinuteSecond();
      case 'jmv':
        return const PlaceholderDateTimeFormat.hourMinuteGenericTz();
      case 'jmz':
        return const PlaceholderDateTimeFormat.hourMinuteTz();
      case 'jv':
        return const PlaceholderDateTimeFormat.hourGenericTz();
      case 'jz':
        return const PlaceholderDateTimeFormat.hourTz();
      case 'm':
        return const PlaceholderDateTimeFormat.minute();
      case 'ms':
        return const PlaceholderDateTimeFormat.minuteSecond();
      case 's':
        return const PlaceholderDateTimeFormat.second();
      case '':
        return null;
      default:
        return PlaceholderDateTimeFormat.custom(json);
    }
  }
}
