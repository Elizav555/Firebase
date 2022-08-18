import 'package:firebase/model/buy_item.dart';
import 'package:firebase/state/app_notifier.dart';
import 'package:firebase/widgets/buy_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateNotifier>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BuyItemWidget(
                  item: state.shoppingList.values.elementAt(index));
            },
            itemCount: state.shoppingList.length,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AppStateNotifier>().addItem(BuyItem(
              name: "NewItem${state.shoppingList.length}",
              id: "newId${state.shoppingList.length}"));
        },
        tooltip: 'Add new BuyItem',
        child: const Icon(Icons.add),
      ),
    );
  }
}
