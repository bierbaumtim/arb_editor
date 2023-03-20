import 'package:flutter/material.dart';

typedef TextPopupMenuItemSelected<T> = void Function(T value);

typedef TextPopupMenuItemBuilder<T> = List<PopupMenuEntry<T>> Function(
    BuildContext context);

class TextPopupMenuButton<T> extends StatelessWidget {
  const TextPopupMenuButton({
    super.key,
    required this.itemBuilder,
    required this.text,
    this.onSelected,
    this.initialValue,
    this.elevation,
    this.menuPosition = PopupMenuPosition.under,
  });

  final TextPopupMenuItemBuilder<T> itemBuilder;

  final TextPopupMenuItemSelected<T>? onSelected;

  final T? initialValue;

  final double? elevation;

  final PopupMenuPosition menuPosition;

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSelected == null
          ? null
          : () async {
              final button = context.findRenderObject()! as RenderBox;
              final overlay = Navigator.of(context)
                  .overlay!
                  .context
                  .findRenderObject()! as RenderBox;

              final items = itemBuilder(context);

              double correction = 0;

              if (initialValue != null) {
                for (final item in items) {
                  if (item is PopupMenuItem &&
                      (item as PopupMenuItem).value == initialValue) break;

                  correction += item.height;
                }
              }

              final offset = menuPosition == PopupMenuPosition.under
                  ? Offset(0.0, button.size.height + correction)
                  : Offset(0, correction);

              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(offset, ancestor: overlay),
                  button.localToGlobal(
                    button.size.bottomRight(Offset.zero) + offset,
                    ancestor: overlay,
                  ),
                ),
                Offset.zero & overlay.size,
              );

              final value = await showMenu<T>(
                context: context,
                items: items,
                position: position,
                initialValue: initialValue,
                elevation: elevation,
                constraints: const BoxConstraints(
                  minWidth: 112,
                  maxWidth: 280,
                  maxHeight: 320,
                ),
              );

              if (value != null) {
                onSelected?.call(value);
              }
            },
      child: Text(text),
    );
  }
}
