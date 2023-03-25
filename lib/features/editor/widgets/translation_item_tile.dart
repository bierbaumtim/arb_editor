import 'package:flutter/material.dart';

import '../models/translation_item.dart';

class TransactionItemTile extends StatelessWidget {
  const TransactionItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final TranslationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(item.key),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
