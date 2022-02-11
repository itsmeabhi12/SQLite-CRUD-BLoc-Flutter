import 'package:dbsearch/db/usermodel.dart';

abstract class UserState {}

class Loading extends UserState {}

class Loaded extends UserState {
  final List<UserModel> users;
  Loaded({required this.users});
}

class Failure extends UserState {
  final String message;
  Failure({required this.message});
}

class Empty extends UserState {}

class Sucess extends UserState {}

class InitialState extends UserState {}
