import 'package:car_rental/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: 300,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    buildLoginForm(),
                    buildLoginAction(),
                    buildRegisterAction(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 22),
          ImagesWidget(
            heightImages: 200,
            images: [
              "assets/images/welcome/fast_car.png",
              "assets/images/welcome/vehicle_sale.png",
            ],
          ),
          SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TitleWidget(
              title: "Sign Up",
              fontSizeTitle: 27,
              spacer: 8,
              subtitle:
                  "Travel and live the new experience of \nrent the cars from your home",
            ),
          ),
          SizedBox(height: 13),
        ],
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: TextStyle(color: Color(0xFF707070), fontSize: 18),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter your name",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Email",
            style: TextStyle(color: Color(0xFF707070), fontSize: 18),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter your email",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Phone",
            style: TextStyle(color: Color(0xFF707070), fontSize: 18),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "+62 857-1100-017",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Password",
            style: TextStyle(color: Color(0xFF707070), fontSize: 18),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "********",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Confirm Password",
            style: TextStyle(color: Color(0xFF707070), fontSize: 18),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "********",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
            ),
          ),
          SizedBox(height: 23),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "By signing up, I agree to the Car Rental App's User Agreement and Privacy Policy.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildLoginAction() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.HOME),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27),
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisterAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.only(bottom: 17),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 17),
            ),
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Sign in",
                  style: TextStyle(fontSize: 17),
                )),
          ],
        ),
      ),
    );
  }
}
