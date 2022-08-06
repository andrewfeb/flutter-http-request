import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  static const String urlApi = 'https://reqres.in/api/users';

  const User(
      {this.id = 0,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.avatar});

  factory User.fromJson(Map<String, dynamic> object) {
    return User(
        id: object['id'],
        email: object['email'],
        firstName: object['first_name'],
        lastName: object['last_name'],
        avatar: object['avatar']);
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body)['data'];

      return jsonObject.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$urlApi/$id'));
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body)['data'];

      return User.fromJson(jsonObject);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> createUser(User user) async {
    final response = await http.post(
      Uri.parse(urlApi),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName
      }),
    );

    return (response.statusCode == 201) ? true : false;
  }

  Future<bool> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$urlApi/${user.id}'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': user.id,
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName
      }),
    );

    return (response.statusCode == 200) ? true : false;
  }

  static Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$urlApi/$id'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
      },
    );

    return (response.statusCode == 204) ? true : false;
  }
}
