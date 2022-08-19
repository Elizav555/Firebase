import 'dart:math';

import 'package:firebase/model/buy_item.dart';
import 'package:firebase/state/app_notifier.dart';
import 'package:firebase/widgets/buy_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  @override
  void initState() {
    context.read<AppStateNotifier>().getBackgroundImageURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateNotifier>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
              // child: ListView.builder(
              //   itemBuilder: (BuildContext context, int index) {
            //     Function(bool?, BuyItem) onChecked =
            //         (bool? isChecked, BuyItem item) {
            //       if (isChecked != null) {
            //         context
            //             .read<AppStateNotifier>()
            //             .checkItem(item.id, isChecked);
              //         _dbInteractor
              //             .updateBuyItem(item.id, {"isPurchased": isChecked});
              //       }
              //     };
              //     return BuyItemWidget(
              //         item: state.shoppingList.elementAt(index),
              //         onChecked: onChecked);
              //   },
              //   itemCount: state.shoppingList.length,
              // ),
              child: Container(
            decoration: BoxDecoration(
                image: state.backgroundImageURL != null
                    ? DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(state.backgroundImageURL!))
                    : null),
            child: StreamBuilder<List<BuyItem>>(
                stream: state.getListStream(),
                builder: (context, snapshot) {
                  return ListView(
                    children: snapshot.hasData
                        ? snapshot.data!
                            .map((item) => BuyItemWidget(
                                item: item,
                                onChecked: (String id, bool isChecked) =>
                                    state.updateItem(id, isChecked)))
                            .toList()
                        : <Widget>[],
                  );
                }),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          state.addItem(Random().nextInt(100));
        },
        tooltip: 'Add new BuyItem',
        child: const Icon(Icons.add),
      ),
    );
  }
}
