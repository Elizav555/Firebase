import 'package:firebase/domain/auth/auth_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/nav_const.dart';
import '../state/auth/auth_bloc.dart';
import '../state/auth/auth_events.dart';
import '../state/auth/auth_state.dart';

class AuthPage extends StatelessWidget {
  const AuthPage(
      {Key? key,
      required this.title,
      required this.bloc,
      required this.authManager})
      : super(key: key);
  final String title;
  final AuthBloc bloc;
  final AuthManager authManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: BlocProvider(
          create: (_) => bloc,
          child: BlocBuilder<AuthBloc, AuthState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SuccessState) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.shoppingList, (_) => false);
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LoadedState) {
                  return Center(
                      child: ElevatedButton(
                          onPressed: () =>
                              context.read<AuthBloc>().add(SignInEvent()),
                          child: const Text('Login')));
                } else {
                  return const Center(child: Text('Error'));
                }
              }),
        ));
  }
}
