import 'package:get/get.dart';
import '../core.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: Routes.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: Routes.AVAILABLE_CARS,
      page: () => AvailableCarsView(),
      binding: AvailableCarsBinding(),
    ),
    GetPage(
      name: Routes.BOOK_CAR,
      page: () => BookCarView(),
      binding: BookCarBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATION,
      page: () => NotificationView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      title: 'Privacy Policy',
      page: () => const PrivacyPolicyView(),
    ),
    GetPage(
      name: Routes.TERMS_CONDITIONS,
      title: 'Terms & Conditions',
      page: () => const TermsConditionsView(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      title: 'Edit Profile',
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: Routes.USER_AGREEMENT,
      title: 'User Agreement',
      page: () => const UserAgreementView(),
    ),
  ];
}
