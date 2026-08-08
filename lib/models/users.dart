class User {
  final int id;
  final String email;
  final String username;
  final String password;
  final String firstname;
  final String lastname;

User({
  required this.id,
  required this.email,
  required this.username,
  required this.password,
  required this.firstname,
  required this.lastname,

});

factory User.fromJson(Map<String, dynamic>json) {
  return User(
    id: json['id'],
    email: json['email'],
    username: json['username'],
    password: json['password'],
    firstname: json['name']['firstname'],
    lastname: json['name']['lastname'],

  );
}
}
