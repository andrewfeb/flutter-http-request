import 'package:flutter/material.dart';
import 'package:http_request/user.dart';
import 'add.dart';

class DetailUser extends StatefulWidget {
  final int idUser;
  const DetailUser({required this.idUser, Key? key}) : super(key: key);

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  late Future<User> futureUser;

  @override
  void initState() {
    futureUser = User.getUserById(widget.idUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.topCenter,
        child: FutureBuilder<User>(
          future: futureUser,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(snapshot.data!.avatar),
                  ),
                ),
                Text('First name: ${snapshot.data!.firstName}'),
                Text('Last name: ${snapshot.data!.lastName}'),
                Text('Email: ${snapshot.data!.email}'),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AddUser(user: snapshot.data);
                          }));
                        },
                        child: const Text('Edit'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Warning'),
                                  content: const Text(
                                      'Are you sure to delete this user?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('NO'),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        User.deleteUser(snapshot.data!.id)
                                            .then((isSuccess) {
                                          String message = (isSuccess)
                                              ? 'Delete data success'
                                              : 'Delete data failed';
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(message),
                                          ));
                                        });
                                      },
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      child: const Text('YES'),
                                    ),
                                  ],
                                );
                              });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}
