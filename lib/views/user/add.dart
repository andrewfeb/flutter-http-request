import 'package:flutter/material.dart';
import 'package:http_request/user.dart';

class AddUser extends StatefulWidget {
  final User? user;
  const AddUser({this.user, Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.user != null) {
      _controllerFirstName.text = widget.user!.firstName;
      _controllerLastName.text = widget.user!.lastName;
      _controllerEmail.text = widget.user!.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.user == null) ? 'Add User' : 'Change User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _controllerFirstName,
                decoration: const InputDecoration(
                    labelText: 'First name', hintText: 'Enter first name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerLastName,
                decoration: const InputDecoration(
                    labelText: 'Last name', hintText: 'Enter last name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', hintText: 'Enter email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.user == null) {
                        User user = User(
                            firstName: _controllerFirstName.text,
                            lastName: _controllerLastName.text,
                            email: _controllerEmail.text,
                            avatar: '');
                        user.createUser(user).then((isSuccess) {
                          String message = (isSuccess)
                              ? 'Add data successfully'
                              : 'Add data failed';
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        });
                      } else {
                        User user = User(
                            id: widget.user!.id,
                            firstName: _controllerFirstName.text,
                            lastName: _controllerLastName.text,
                            email: _controllerEmail.text,
                            avatar: '');
                        user.updateUser(user).then((isSuccess) {
                          String message = (isSuccess)
                              ? 'Update data successfully'
                              : 'Update data failed';
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        });
                      }
                    }
                  },
                  child: Text((widget.user == null) ? 'Save' : 'Update')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerEmail.dispose();
  }
}
