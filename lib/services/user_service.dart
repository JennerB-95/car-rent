import '../core.dart';

class UserService {
  User getProfile() {
    return User(
      firstname: "Faisal",
      lastname: "Ramdan",
      email: "faisalramdan.id@gmail.com",
      gender: "male",
      phone: "(62) 8569-11-00XX-XX",
      photoURL:
          "https://firebasestorage.googleapis.com/v0/b/finsell-production.appspot.com/o/images%2Favatar-profile%2F2021-09-15%2002%3A46%3A48.774555%20-%20faisal-ramdan?alt=media&token=c65ed624-1fd7-47d4-9489-b9861c33fd31",
      dob: DateTime.parse("2017-03-17"),
      company: "Coding Your Life",
      address: UserAddress(
        street: "Permata Street No. 17",
        city: "Bogor",
        province: "West Java",
        country: "Indonesia",
        postalCode: "170712",
      ),
      balance: "17,7jt",
      membership: "Gold",
      progress: 77,
    );
  }
}
