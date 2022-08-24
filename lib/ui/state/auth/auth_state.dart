abstract class AuthState {}

class LoadingState extends AuthState {}

class LoadedState extends AuthState {}

class SuccessState extends AuthState {}

class ErrorState extends AuthState {}
