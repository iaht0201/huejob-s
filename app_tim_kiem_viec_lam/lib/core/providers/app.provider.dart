import 'package:app_tim_kiem_viec_lam/core/models/chat_message.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/chat_messager_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/comment.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_category_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'authenciation_provider.dart';
import 'post_provider.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthenciationNotifier()),
    ChangeNotifierProvider(create: (_) => PostProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
    ChangeNotifierProvider(create: (_) => JobsProvider()),
    ChangeNotifierProvider(create: (_) => CommentProvider())
  ];
}
