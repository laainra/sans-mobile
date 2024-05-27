class User {
  final String name;
  final String username;
  final String password;

  User({
    required this.name,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String,
        username: json['username'] as String,
        password: json['password'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'password': password,
      };
}