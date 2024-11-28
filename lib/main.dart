import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nested/nested.dart';
import 'app_config.dart';
import 'bloc/message_bloc/message_bloc.dart';
import 'core/base_bloc/base_bloc.dart';
import 'theme.dart';
import 'views/auth/init_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// flavor & env setup
  await FlutterConfig.loadEnvVariables();
  AppConfig.initiate();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  await ScreenUtil.ensureScreenSize();

  Bloc.observer = AppBlocObserver();

  runApp(MultiBlocProvider(providers: <SingleChildWidget>[
    BlocProvider<MessageBloc>(create: (BuildContext context) => MessageBloc()),
  ], child: const App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 835),
        builder: (_, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme: themeData,
            home: const InitPage(),
            debugShowCheckedModeBanner:
                AppConfig.shared.flavor == Flavor.staging,
          );
        });
  }
}
