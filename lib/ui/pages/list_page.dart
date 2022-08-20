import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/shopping_list_bloc.dart';
import '../../state/shopping_list_events.dart';
import '../../state/shopping_list_state.dart';
import '../../utils/sort_filter_types.dart';
import '../widgets/buy_item_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.title, required this.bloc})
      : super(key: key);
  final ShoppingListBloc bloc;
  final String title;

  @override
  State<StatefulWidget> createState() => ListState();
}

class ListState extends State<ListPage> {
  final TextEditingController _inputController = TextEditingController();
  bool _isAddActive = false;

  @override
  void initState() {
    widget.bloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.bloc,
      child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
          builder: (context, state) {
        var icon = Icons.filter_none;
        if (state.filterType == FilterType.purchased) {
          icon = Icons.check_box;
        } else if (state.filterType == FilterType.nonPurchased) {
          icon = Icons.check_box_outline_blank;
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                PopupMenuButton(
                    icon: const Icon(Icons.sort),
                    itemBuilder: (context) {
                      return SortType.values
                          .map(
                            (element) => PopupMenuItem<SortType>(
                              value: element,
                              child: Text("$element"),
                            ),
                          )
                          .toList();
                    },
                    onSelected: (SortType value) {
                      context
                          .read<ShoppingListBloc>()
                          .add(FilterSortItemsEvent(state.filterType, value));
                    }),
                GestureDetector(
                    onTap: () {
                      var newFilterType = FilterType.none;
                      if (state.filterType == FilterType.none) {
                        newFilterType = FilterType.purchased;
                      } else if (state.filterType == FilterType.purchased) {
                        newFilterType = FilterType.nonPurchased;
                      }
                      context.read<ShoppingListBloc>().add(
                          FilterSortItemsEvent(newFilterType, state.sortType));
                    },
                    child: Icon(icon)),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
            body: state is ListHasDataState
                ? Column(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          state.backgroundImageURL))),
                              child: ListView(
                                children: state.data
                                    .map((item) => BuyItemWidget(
                                        item: item,
                                        onChecked:
                                            (String id, bool isChecked) =>
                                                context
                                                    .read<ShoppingListBloc>()
                                                    .add(UpdateItemEvent(
                                                        id,
                                                        isChecked,
                                                        state.filterType,
                                                        state.sortType))))
                                    .toList(),
                              ))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _inputController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter new item name',
                                ),
                                onChanged: (_) {
                                  setState(() {
                                    _isAddActive =
                                        _inputController.text.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isAddActive
                                  ? () {
                                      context.read<ShoppingListBloc>().add(
                                          AddItemEvent(
                                              _inputController.value.text,
                                              state.filterType,
                                              state.sortType));
                                      _inputController.text = '';
                                      setState(() {
                                        _isAddActive =
                                            _inputController.text.isNotEmpty;
                                      });
                                    }
                                  : null,
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()));
      }),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
