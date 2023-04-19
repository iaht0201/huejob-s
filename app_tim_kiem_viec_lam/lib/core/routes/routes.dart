import 'package:app_tim_kiem_viec_lam/screens/profile/profile_edit.dart';

import '../../screens/authentication/login/login.dart';
import '../../screens/authentication/register/register.dart';
import '../../screens/home/home.dart';
import '../../screens/profile/profile_setting.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/splash/splash.dart';

class AppRoutes {
  
  static const String LoginRoute = "/login";
  static const String SignupRoutes = "/signup";
  static const String HomeRoutes = "/home";
  static const String ProfileRoutes = "/profile";
  static const String ChamThiDuaRoutes = "/thidua";
  static const String SplashRoutes = "/splash";
  static const String EditProfileRoutes = "/edit";
  static final routes = {
    LoginRoute: (context) => LoginView(),
    HomeRoutes: (context) => HomePage(),
    ProfileRoutes: (context) => ProfileScreen(),
    // DetailMovieRoutes: (context) => DetailMovieView(),
    // TrailerRoutes: (context) => WebViewVideo(),
    // SearchRoutes: (context) => SearchScreen(),
    SignupRoutes: (context) => SignupView(),
    //   ChamThiDuaRoutes: (context) => const ChamThiDua(),
    SplashRoutes: (context) => SplashScreen(),
    EditProfileRoutes: (context) => EditProfile(),
    // ProfileRoutes: (context) => ProfileScreen(
    // ),
    // ListBookmarkRoutes: (context) => ListBookmarkScreen()

/*    SignupRoutes: (context) => SignupView(),
    HomeRoutes: (context) => HomeView(),*/
  };
}
