import 'package:firebase/model/buy_item.dart';
import 'package:flutter/material.dart';

class BuyItemWidget extends StatelessWidget {
  const BuyItemWidget({Key? key, required this.item, required this.onChecked})
      : super(key: key);
  final BuyItem item;
  final Function(String, bool) onChecked;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      elevation: 8,
      child: ListTile(
        title: Text(item.name),
        tileColor: item.isPurchased ? Colors.grey[350] : null,
        trailing: Checkbox(
          value: item.isPurchased,
          onChanged: (isChecked) {
            if (isChecked != null) {
              onChecked(item.id, isChecked);
            }
          },
        ),
      ),
    );
  }
}
