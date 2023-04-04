class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String contactNumber;
  String adress;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.contactNumber,
      this.adress});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as String,
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      contactNumber: json["contact_number"],
      adress: json["adress"],
    );
  }
}
