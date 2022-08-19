import 'package:firebase/database/shopping_db.dart';
import 'package:firebase/widgets/buy_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/app_bloc.dart';
import '../state/app_events.dart';
import '../state/app_state.dart';
import '../storage/storage.dart';
import '../utils/sort_filter_types.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ShoppingDB>(create: (_) => ShoppingDBImpl()),
        RepositoryProvider<ShoppingStorage>(
            create: (_) => ShoppingStorageImpl()),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(
            RepositoryProvider.of(context), RepositoryProvider.of(context)),
        child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
          var icon = Icons.filter_none;
          if (state.filterType == FilterType.purchased) {
            icon = Icons.check_box;
          } else if (state.filterType == FilterType.nonPurchased) {
            icon = Icons.check_box_outline_blank;
          }
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
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
                            .read<AppBloc>()
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
                        context.read<AppBloc>().add(FilterSortItemsEvent(
                            newFilterType, state.sortType));
                      },
                      child: Icon(icon)),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
              body: state is AppHasDataState
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
                                                  context.read<AppBloc>().add(
                                                      UpdateItemEvent(
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
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _inputController.value.text.isEmpty
                                    ? null
                                    : () {
                                        context.read<AppBloc>().add(
                                            AddItemEvent(
                                                _inputController.value.text,
                                                state.filterType,
                                                state.sortType));
                                        _inputController.text = '';
                                      },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()));
        }),
      ),
    );
  }
}
