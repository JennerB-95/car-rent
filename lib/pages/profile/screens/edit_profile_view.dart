import 'package:country_pickers/country_pickers.dart';
import '../../../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:queen_validators/queen_validators.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: 100,
          ),
          SafeArea(
            child: GetBuilder<ProfileController>(
              builder: (_) {
                return Column(
                  children: [
                    const AppBarWidget(
                        title: "Edit Profile", isBorderRadius: false),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            buildHeader(),
                            buildEditProfileForm(),
                          ],
                        ),
                      ),
                    ),
                    buildSignUpAction(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 17.0),
            child: AvatarWidget(
              photoURL: controller.userProfile.photoURL,
              isHideProgressBar: true,
              width: 120,
              heroTag: "profile",
            ),
          ),
          TextButton(
            onPressed: () => OpenDialog.info(
                lottieFilename: LottieFileName.COMING_SOON,
                lottiePadding: EdgeInsets.only(top: 50)),
            style: TextButton.styleFrom(
              primary: Colors.blue,
              //padding: EdgeInsets.all(10),
            ),
            child: const Text(
              "Change Photo Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold
                  // decoration: TextDecoration.underline,
                  ),
            ),
          ),
          const SizedBox(height: 23),
        ],
      ),
    );
  }

  Widget buildEditProfileForm() {
    return Form(
      key: controller.keyEditProfileForm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormFieldX(
                    controller: controller.firstnameCtrl,
                    label: "Firstname",
                    hintText: "Enter your firstname",
                    validator: qValidator([
                      IsRequired("Firstname is required."),
                    ]),
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: TextFormFieldX(
                    controller: controller.lastnameCtrl,
                    label: "Lastname",
                    hintText: "Enter your lastname",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextFormFieldX(
              controller: controller.usernameCtrl,
              label: "Username",
              hintText: "Enter your username",
              errorText: controller.isUsernameAvailable
                  ? null
                  : "Username already exits.",
              validator: qValidator([
                IsRequired("Username is rrequired."),
                MinLength(3, "Username at least with 3 characters."),
              ]),
            ),
            const SizedBox(height: 15),
            TextFormFieldX(
              controller: controller.phoneCtrl,
              label: "Phone Number",
              hintText: "Enter your phone number",
              keyboardType: TextInputType.phone,
              initPhoneCode: CountryPickerUtils.getCountryByPhoneCode(
                  ConverterHelper.getPhoneCode(controller.userProfile.phone) ??
                      '62'),
              validator: (value) {
                if (value.isEmpty) {
                  return "Phone number is required.";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DateFormField(
                    initialDate: controller.userProfile.dob,
                    controller: controller.dobCtrl,
                    labelText: "Date of Birth",
                    hintText: "Enter your date of birth",
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: DropdownFormField(
                    value: controller.userProfile.gender == null
                        ? null
                        : Globals.getGenderItems().firstWhere((item) =>
                            item.value ==
                            controller.userProfile.gender?.toLowerCase()),
                    controller: controller.genderCtrl,
                    labelText: "Gender",
                    hintText: "Enter your gender",
                    items: Globals.getGenderItems(),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Gender is required.";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextFormFieldX(
              controller: controller.streetCtrl,
              label: "Street",
              hintText: "Enter your street",
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextFormFieldX(
                    controller: controller.cityCtrl,
                    label: "City",
                    hintText: "Enter your city",
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: TextFormFieldX(
                    controller: controller.provinceCtrl,
                    label: "Province",
                    hintText: "Enter your province",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: CountryFormField(
                    label: "Country",
                    controller: controller.countryCtrl,
                    initCountry: CountryPickerUtils.getCountryByName(
                        controller.countryCtrl.text),
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: TextFormFieldX(
                    controller: controller.postalCodeCtrl,
                    label: "Postal Code",
                    hintText: "Enter your postal code",
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget buildSignUpAction() {
    return FittedButton(
      onPressed: controller.updateProfile,
      label: ("Save Profile"),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}
