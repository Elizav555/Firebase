import 'package:firebase/database/shopping_db.dart';
import 'package:firebase/widgets/buy_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/app_bloc.dart';
import '../state/app_events.dart';
import '../state/app_state.dart';
import '../storage/storage.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ShoppingDB>(
            create: (_) => ShoppingDBImpl()..getAllItemsStream()),
        RepositoryProvider<ShoppingStorage>(
            create: (_) => ShoppingStorageImpl()),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(
            RepositoryProvider.of(context), RepositoryProvider.of(context)),
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
            if (state is AppHasDataState) {
              return Column(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(state.backgroundImageURL))),
                          child: ListView(
                            children: state.data
                                .map((item) => BuyItemWidget(
                                    item: item,
                                    onChecked: (String id, bool isChecked) =>
                                        context.read<AppBloc>().add(
                                            UpdateItemEvent(id, isChecked))))
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
                                  context.read<AppBloc>().add(AddItemEvent(
                                      _inputController.value.text));
                                  _inputController.text = '';
                                },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }
}
