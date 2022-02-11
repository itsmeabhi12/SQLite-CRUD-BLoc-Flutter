import 'package:dbsearch/Bloc/user_bloc.dart';
import 'package:dbsearch/Bloc/user_event.dart';
import 'package:dbsearch/Bloc/user_state.dart';
import 'package:dbsearch/db/usermodel.dart';
import 'package:dbsearch/db/usernamedb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<UserBloc>(
          create: (_) =>
              UserBloc(initialState: InitialState(), db: UsernameDB.instance),
          child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Local DB"),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<UserBloc>(context).add(Read());
              },
              icon: const Icon(Icons.list))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onChanged: (val) {
                BlocProvider.of<UserBloc>(context).add(Search(keyword: val));
              },
            ),
            Expanded(child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is InitialState) {
                  return const Center(
                    child: Text('Type to Search in db'),
                  );
                }
                if (state is Empty) {
                  return const Center(
                    child: Text('Not Found'),
                  );
                }
                if (state is Sucess) {
                  return const Center(
                    child: Text('User Added'),
                  );
                }
                final List<Widget> listuser = (state as Loaded)
                    .users
                    .map((e) => Card(
                            child: ListTile(
                          title: Text(e.name!),
                          trailing: IconButton(
                              onPressed: () {
                                BlocProvider.of<UserBloc>(context)
                                    .add(Delete(id: e.id!));
                              },
                              icon: const Icon(Icons.delete)),
                        )))
                    .toList();
                return ListView(
                  children: listuser,
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (contxt) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<UserBloc>(context).add(Create(
                          model: UserModel.fromJson(
                              {"name": _textEditingController.text})));
                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add Data"))
              ],
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
