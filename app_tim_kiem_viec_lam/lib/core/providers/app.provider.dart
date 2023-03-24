import 'package:app_tim_kiem_viec_lam/core/models/chatMessage.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/chatMessagerProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobCategoryProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobsProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'authenciation_provider.dart';
import 'postProvider.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthenciationNotifier()),
    ChangeNotifierProvider(create: (_) => PostProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
    ChangeNotifierProvider(create: (_) => JobsProvider())
  ];
}
