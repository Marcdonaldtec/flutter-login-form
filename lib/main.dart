import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String email;
  final String password;
  final List<String> gender;

  User(this.email, this.password, this.gender);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login Form',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: Container(
            width: 300.0,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List<String> _selectedGender = [];

  List<User> usersList = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              fillColor: Colors.blueGrey[50],
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer une adresse email valide';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              fillColor: Colors.blueGrey[50],
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('Sexe:', style: TextStyle(color: Colors.black)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...['Masculin', 'Féminin', 'Autre'].map((gender) {
                    return Row(
                      children: [
                        Checkbox(
                          value: _selectedGender.contains(gender),
                          onChanged: (value) {
                            _updateGender(gender, value);
                          },
                        ),
                        Text(gender),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                User newUser = User(
                  _emailController.text,
                  _passwordController.text,
                  _selectedGender,
                );

                setState(() {
                  usersList.add(newUser);
                });

                _showListPage();
              }
            },
            child: Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  void _updateGender(String gender, bool? value) {
    setState(() {
      if (value ?? false) {
        _selectedGender.add(gender);
      } else {
        _selectedGender.remove(gender);
      }
    });
  }

  void _showListPage() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _selectedGender = [];
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(usersList: usersList),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  final List<User> usersList;

  ListPage({required this.usersList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User List',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Email: ${usersList[index].email}'),
            subtitle: Text('Sexe: ${usersList[index].gender.join(', ')}'),
          );
        },
      ),
    );
  }
}
