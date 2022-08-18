import 'package:firebase/database/db_interactor.dart';
import 'package:firebase/model/buy_item.dart';
import 'package:firebase/state/app_notifier.dart';
import 'package:firebase/widgets/buy_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final _dbInteractor = ShoppingDBInteractor();

  Future<BuyItem> addItem(int index) async {
    return await _dbInteractor.addBuyItem("NewItem$index");
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateNotifier>().state;
    _dbInteractor.getList().then(
        (value) => context.read<AppStateNotifier>().setState(newList: value));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Function(bool?, BuyItem) onChecked =
                    (bool? isChecked, BuyItem item) {
                  if (isChecked != null) {
                    context
                        .read<AppStateNotifier>()
                        .checkItem(item.id, isChecked);
                    _dbInteractor
                        .updateBuyItem(item.id, {"isPurchased": isChecked});
                  }
                };
                return BuyItemWidget(
                    item: state.shoppingList.elementAt(index),
                    onChecked: onChecked);
              },
              itemCount: state.shoppingList.length,
            ),
            // child: StreamBuilder<List<BuyItem>>(
            //     stream: _dbInteractor.getListStream(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         context
            //             .read<AppStateNotifier>()
            //             .setState(newList: snapshot.data!);
            //       }
            //       return ListView(
            //         children: snapshot.hasData
            //             ? snapshot.data!
            //                 .map((item) => BuyItemWidget(item: item))
            //                 .toList()
            //             : <Widget>[],
            //       );
            //     })
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem(state.shoppingList.length)
              .then((value) => context.read<AppStateNotifier>().addItem(value));
        },
        tooltip: 'Add new BuyItem',
        child: const Icon(Icons.add),
      ),
    );
  }
}
