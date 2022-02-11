import 'package:dbsearch/Bloc/user_event.dart';
import 'package:dbsearch/Bloc/user_state.dart';
import 'package:dbsearch/db/usernamedb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UsernameDB db;
  UserBloc({required UserState initialState, required this.db})
      : super(initialState) {
    on<Create>((event, emit) async {
      await db.create(event.model);
      emit(Sucess());
    });
    on<Search>((event, emit) async {
      if (event.keyword == "") {
        emit(InitialState());
        return;
      }
      emit(Loading());
      final users = await db.searchUser(event.keyword);
      if (users.isEmpty) {
        emit(Empty());
      }
      emit(Loaded(users: users));
    },
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 300))
            .flatMap((mapper)));
    on<Delete>((event, emit) async {
      final oldstate = (state as Loaded).users;
      oldstate.removeWhere((element) => element.id == event.id);
      await db.deleteUser(event.id);
      emit(Loaded(users: oldstate));
    });
    on<Read>((event, emit) async {
      if (event.name == null) {
        final users = await db.getalluser();
        emit(Loaded(users: users));
      }
    });
  }
}
