import 'package:flutter/material.dart';
import 'package:http_request/user.dart';
import 'add.dart';
import 'detail.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<User>> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = User.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: FutureBuilder<List<User>>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(snapshot.data![index].avatar),
                  ),
                  title: Text(
                      '${snapshot.data![index].firstName} ${snapshot.data![index].lastName}'),
                  subtitle: Text(snapshot.data![index].email),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailUser(idUser: snapshot.data![index].id);
                    }));
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddUser();
          }));
        },
        tooltip: 'Add user',
        child: const Icon(Icons.add),
      ),
    );
  }
}
