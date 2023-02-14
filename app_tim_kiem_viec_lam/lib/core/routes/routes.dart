import '../../screens/authentication/login/login.dart';
import '../../screens/authentication/register/register.dart';
import '../../screens/home/home.dart';
import '../../screens/profile/profile.dart';
import '../../screens/splash/splash.dart';

class AppRoutes {
  static const String LoginRoute = "/login";
  static const String SignupRoutes = "/signup";
  static const String HomeRoutes = "/home";
  static const String ProfileRoutes = "/profile";
  static const String ChamThiDuaRoutes = "/thidua";
  static const String SplashRoutes = "/splash";
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
    // ProfileRoutes: (context) => ProfileScreen(),
    // ListBookmarkRoutes: (context) => ListBookmarkScreen()

/*    SignupRoutes: (context) => SignupView(),
    HomeRoutes: (context) => HomeView(),*/
  };
}
