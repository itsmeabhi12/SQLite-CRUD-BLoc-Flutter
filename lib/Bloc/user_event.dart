import 'package:dbsearch/db/usermodel.dart';

abstract class UserEvent {}

class Create extends UserEvent {
  final UserModel model;
  Create({required this.model});
}

class Read extends UserEvent {
  final String? name;
  Read({this.name});
}

class Update extends UserEvent {
  final UserModel userModel;
  Update({required this.userModel});
}

class Delete extends UserEvent {
  final int id;
  Delete({required this.id});
}

class Search extends UserEvent {
  final String keyword;
  Search({required this.keyword});
}
