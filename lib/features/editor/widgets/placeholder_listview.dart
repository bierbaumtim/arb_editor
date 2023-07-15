import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/option.dart';
import '../models/placeholder/placeholder_datetime_format.dart';
import '../models/placeholder/placeholder_number_format.dart';
import '../models/placeholder/placeholder_type.dart';
import '../models/translation_item.dart';
import '../provider.dart';
import '../../common/text_popup_menu_button.dart';

class PlaceholderListView extends StatelessWidget {
  const PlaceholderListView({
    super.key,
    required this.selectedItem,
  });

  final TranslationItem selectedItem;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 8, right: 4),
        itemBuilder: (context, index) => PlacerholderTile(
          index: index,
          selectedItem: selectedItem,
        ),
        itemCount: selectedItem.placeholders.length,
      ),
    );
  }
}

class PlacerholderTile extends ConsumerWidget {
  const PlacerholderTile({
    super.key,
    required this.index,
    required this.selectedItem,
  });

  final int index;
  final TranslationItem selectedItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editingControllerContainer =
        ref.watch(selectedTranslationItemPlaceholderEditingControllerProvider);

    return FocusTraversalOrder(
      order: NumericFocusOrder(index + 1),
      child: Card(
        elevation: 12,
        shadowColor: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: ExpansionTile(
          maintainState: true,
          initiallyExpanded: index == 0,
          controlAffinity: ListTileControlAffinity.leading,
          collapsedShape: const Border.fromBorderSide(BorderSide.none),
          shape: const Border.fromBorderSide(BorderSide.none),
          backgroundColor: Colors.transparent,
          title: Text(selectedItem.placeholders[index].name),
          trailing: IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () =>
                ref.read(editorControllerProvider.notifier).removePlaceholder(
                      ref.read(selectedTranslationItemIndexProvider),
                      index,
                    ),
          ),
          children: [
            _NameTile(
              controller: editingControllerContainer[index].nameController,
              onSubmitted: (value) => ref
                  .read(editorControllerProvider.notifier)
                  .setPlaceholderName(
                    ref.read(selectedTranslationItemIndexProvider),
                    index,
                    value,
                  ),
            ),
            const SizedBox(height: 4),
            ListTile(
              title: const Text('Type'),
              trailing: _TypeSelectionButton(
                selectedItem: selectedItem,
                index: index,
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              title: const Text('Format'),
              trailing: switch (selectedItem.placeholders[index].type) {
                DoublePlaceholder() => _NumberFormatSelectionButton(
                    selectedItem: selectedItem,
                    index: index,
                  ),
                IntPlaceholder() => _NumberFormatSelectionButton(
                    selectedItem: selectedItem,
                    index: index,
                  ),
                NumberPlaceholder() => _NumberFormatSelectionButton(
                    selectedItem: selectedItem,
                    index: index,
                  ),
                DateTimePlaceholder() => _DatetimeFormatSelectionButton(
                    selectedItem: selectedItem,
                    index: index,
                  ),
                _ => null,
              },
            ),
            if (selectedItem.placeholders[index].dateTimeFormat
                case CustomPdtf()) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: TextField(
                  controller: editingControllerContainer[index]
                      .customDateTimeFormatController,
                  onSubmitted: (value) => ref
                      .read(editorControllerProvider.notifier)
                      .setPlaceholderCustomDateTimeFormat(
                        ref.read(selectedTranslationItemIndexProvider),
                        index,
                        value,
                      ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 4),
            ListTile(
              title: const Text('Decimal Digits'),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  controller:
                      editingControllerContainer[index].decimalDigitsController,
                  textAlign: TextAlign.end,
                  onSubmitted: (value) => ref
                      .read(editorControllerProvider.notifier)
                      .setPlaceholderDecimalDigits(
                        ref.read(selectedTranslationItemIndexProvider),
                        index,
                        value,
                      ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              title: const Text('Symbol'),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  controller:
                      editingControllerContainer[index].symbolController,
                  textAlign: TextAlign.end,
                  onSubmitted: (value) => ref
                      .read(editorControllerProvider.notifier)
                      .setPlaceholderName(
                        ref.read(selectedTranslationItemIndexProvider),
                        index,
                        value,
                      ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const ListTile(
              title: Text('Custom Pattern'),
              enabled: false,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _DatetimeFormatSelectionButton extends ConsumerWidget {
  const _DatetimeFormatSelectionButton({
    // ignore: unused_element
    super.key,
    required this.selectedItem,
    required this.index,
  });

  final TranslationItem selectedItem;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextPopupMenuButton<Option<PlaceholderDateTimeFormat>>(
      text: selectedItem.placeholders[index].dateTimeFormat?.name ?? 'None',
      initialValue: Option.fromNullable(
        selectedItem.placeholders[index].dateTimeFormat,
      ),
      onSelected: (value) => ref
          .read(editorControllerProvider.notifier)
          .setPlaceholderDateTimeFormat(
            ref.read(selectedTranslationItemIndexProvider),
            index,
            value.mapOr(null, (v) => v),
          ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: None(),
          child: Text('None'),
        ),
        const PopupMenuItem(
          value: Some(DayPdtf()),
          child: Text('day'),
        ),
        const PopupMenuItem(
          value: Some(AbbrWeekdayPdtf()),
          child: Text('abbrWeekday'),
        ),
        const PopupMenuItem(
          value: Some(WeekdayPdtf()),
          child: Text('weekday'),
        ),
        const PopupMenuItem(
          value: Some(AbbrStandaloneMonthPdtf()),
          child: Text('abbrStandaloneMonth'),
        ),
        const PopupMenuItem(
          value: Some(StandaloneMonthPdtf()),
          child: Text('standaloneMonth'),
        ),
        const PopupMenuItem(
          value: Some(NumMonthPdtf()),
          child: Text('numMonth'),
        ),
        const PopupMenuItem(
          value: Some(NumMonthDayPdtf()),
          child: Text('numMonthDay'),
        ),
        const PopupMenuItem(
          value: Some(NumMonthWeekdayDayPdtf()),
          child: Text('numMonthWeekdayDay'),
        ),
        const PopupMenuItem(
          value: Some(AbbrMonthPdtf()),
          child: Text('abbrMonth'),
        ),
        const PopupMenuItem(
          value: Some(AbbrMonthDayPdtf()),
          child: Text('abbrMonthDay'),
        ),
        const PopupMenuItem(
          value: Some(AbbrMonthWeekdayDayPdtf()),
          child: Text('abbrMonthWeekdayDay'),
        ),
        const PopupMenuItem(
          value: Some(MonthPdtf()),
          child: Text('month'),
        ),
        const PopupMenuItem(
          value: Some(MonthDayPdtf()),
          child: Text('monthDay'),
        ),
        const PopupMenuItem(
          value: Some(MonthWeekdayDayPdtf()),
          child: Text('monthWeekdayDay'),
        ),
        const PopupMenuItem(
          value: Some(AbbrQuarterPdtf()),
          child: Text('abbrQuarter'),
        ),
        const PopupMenuItem(
          value: Some(QuarterPdtf()),
          child: Text('quarter'),
        ),
        const PopupMenuItem(
          value: Some(YearPdtf()),
          child: Text('year'),
        ),
        const PopupMenuItem(
          value: Some(YearNumMonthPdtf()),
          child: Text('yearNumMonth'),
        ),
        const PopupMenuItem(
          value: Some(YearNumMonthDayPdtf()),
          child: Text('yearNumMonthDay'),
        ),
        const PopupMenuItem(
          value: Some(YearNumMonthWeekdayDayPdtf()),
          child: Text('yearNumMonthWeekdayDay'),
        ),
        const PopupMenuItem(
          value: Some(YearAbbrMonthPdtf()),
          child: Text('yearAbbrMonth'),
        ),
        const PopupMenuItem(
          value: Some(YearAbbrMonthDayPdtf()),
          child: Text('yearAbbrMonthDay'),
        ),
        const PopupMenuItem(
          value: Some(YearAbbrMonthWeekdayDayPdtf()),
          child: Text('yearAbbrMonthWeekdayDay'),
        ),
        const PopupMenuItem(
          value: Some(YearMonthPdtf()),
          child: Text('yearMonth'),
        ),
        const PopupMenuItem(
          value: Some(YearMonthDayPdtf()),
          child: Text('yearMonthDay'),
        ),
        const PopupMenuItem(
          value: Some(YearMonthWeekdayDayPdtf()),
          child: Text('yearMonthWeekdayDay'),
        ),
        const PopupMenuItem(
          value: Some(YearAbbrQuarterPdtf()),
          child: Text('yearAbbrQuarter'),
        ),
        const PopupMenuItem(
          value: Some(YearQuarterPdtf()),
          child: Text('yearQuarter'),
        ),
        const PopupMenuItem(
          value: Some(Hour24Pdtf()),
          child: Text('hour24'),
        ),
        const PopupMenuItem(
          value: Some(Hour24MinutePdtf()),
          child: Text('hour24Minute'),
        ),
        const PopupMenuItem(
          value: Some(Hour24MinuteSecondPdtf()),
          child: Text('hour24MinuteSecond'),
        ),
        const PopupMenuItem(
          value: Some(HourPdtf()),
          child: Text('hour'),
        ),
        const PopupMenuItem(
          value: Some(HourMinutePdtf()),
          child: Text('hourMinute'),
        ),
        const PopupMenuItem(
          value: Some(HourMinuteSecondPdtf()),
          child: Text('hourMinuteSecond'),
        ),
        const PopupMenuItem(
          value: Some(HourMinuteGenericTzPdtf()),
          child: Text('hourMinuteGenericTz'),
        ),
        const PopupMenuItem(
          value: Some(HourMinuteTzPdtf()),
          child: Text('hourMinuteTz'),
        ),
        const PopupMenuItem(
          value: Some(HourGenericTzPdtf()),
          child: Text('hourGenericTz'),
        ),
        const PopupMenuItem(
          value: Some(HourTzPdtf()),
          child: Text('hourTz'),
        ),
        const PopupMenuItem(
          value: Some(MinutePdtf()),
          child: Text('minute'),
        ),
        const PopupMenuItem(
          value: Some(MinuteSecondPdtf()),
          child: Text('minuteSecond'),
        ),
        const PopupMenuItem(
          value: Some(SecondPdtf()),
          child: Text('second'),
        ),
        const PopupMenuItem(
          value: Some(CustomPdtf('')),
          child: Text('custom'),
        ),
      ],
    );
  }
}

class _NumberFormatSelectionButton extends ConsumerWidget {
  const _NumberFormatSelectionButton({
    // ignore: unused_element
    super.key,
    required this.selectedItem,
    required this.index,
  });

  final TranslationItem selectedItem;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextPopupMenuButton<Option<PlaceholderNumberFormat>>(
      onSelected: (value) => ref
          .read(editorControllerProvider.notifier)
          .setPlaceholderNumberFormat(
            ref.read(selectedTranslationItemIndexProvider),
            index,
            value.mapOr(null, (v) => v),
          ),
      text: selectedItem.placeholders[index].numberFormat?.name ?? 'None',
      initialValue: Option.fromNullable(
        selectedItem.placeholders[index].numberFormat,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: None(),
          child: Text('None'),
        ),
        ...PlaceholderNumberFormat.values.map(
          (f) => PopupMenuItem(
            value: Some(f),
            child: Text(f.name),
          ),
        ),
      ],
    );
  }
}

class _TypeSelectionButton extends ConsumerWidget {
  const _TypeSelectionButton({
    // ignore: unused_element
    super.key,
    required this.selectedItem,
    required this.index,
  });

  final TranslationItem selectedItem;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextPopupMenuButton<PlaceholderType>(
      text: switch (selectedItem.placeholders[index].type) {
        DateTimePlaceholder() => 'DateTime',
        DoublePlaceholder() => 'double',
        IntPlaceholder() => 'int',
        NumberPlaceholder() => 'number',
        StringPlaceholder() => 'String',
        UnknownPlaceholder(:final value) => value,
      },
      initialValue: selectedItem.placeholders[index].type,
      onSelected: (value) =>
          ref.read(editorControllerProvider.notifier).setPlaceholderType(
                ref.read(selectedTranslationItemIndexProvider),
                index,
                value,
              ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: DoublePlaceholder(),
          child: Text('double'),
        ),
        const PopupMenuItem(
          value: IntPlaceholder(),
          child: Text('int'),
        ),
        const PopupMenuItem(
          value: NumberPlaceholder(),
          child: Text('number'),
        ),
        const PopupMenuItem(
          value: DateTimePlaceholder(),
          child: Text('DateTime'),
        ),
        const PopupMenuItem(
          value: StringPlaceholder(),
          child: Text('String'),
        ),
      ],
    );
  }
}

class _NameTile extends StatelessWidget {
  const _NameTile({
    // ignore: unused_element
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            'Name',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: constraints.maxWidth * 0.8 < 250
                      ? constraints.maxWidth * 0.8
                      : 250,
                  child: TextField(
                    controller: controller,
                    onSubmitted: onSubmitted,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
