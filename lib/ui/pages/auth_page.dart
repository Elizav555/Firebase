import 'package:firebase/state/auth/auth_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_state.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key, required this.title, required this.bloc})
      : super(key: key);
  final String title;
  final AuthBloc bloc;

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
                } else {
                  return Center(
                      child: ElevatedButton(
                          onPressed: () => context
                              .read<AuthBloc>()
                              .add(SignInEvent(context)),
                          child: const Text('Login')));
                }
              }),
        ));
  }
}
