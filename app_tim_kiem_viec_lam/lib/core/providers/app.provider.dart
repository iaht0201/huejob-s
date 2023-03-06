import 'package:app_tim_kiem_viec_lam/core/providers/jobCategoryProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'authenciation_provider.dart';
import 'job_provider.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthenciationNotifier()),
    ChangeNotifierProvider(create: (_) => JobProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => JobCategory())
  ];
}
