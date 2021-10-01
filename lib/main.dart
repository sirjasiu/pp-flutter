import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/app/home/home.dart';
import 'package:pp/core/services/shared_preferences_service.dart';
import 'package:pp/routing/routing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:vrouter/vrouter.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final sharedPreferences = await SharedPreferences.getInstance();
  // Must add this line.
  await WindowManager.instance.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  WindowManager.instance.waitUntilReadyToShow().then((_) async{
    // Set to frameless window
    await WindowManager.instance.setAsFrameless();
    const size = Size(800, 500);
    await WindowManager.instance.setSize(size);
    await WindowManager.instance.center();
    await initTray();
    WindowManager.instance.setMinimumSize(size);
    WindowManager.instance.setClosable(false);
    //WindowManager.instance.show();
  });
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: const MyApp(),
  ));
}

Future<void> initTray() async {
  await TrayManager.instance.setIcon(
    Platform.isWindows
        ? 'assets/icon/vision.ico'
        : 'assets/icon/vision.png',
  );
  List<MenuItem> items = [
    MenuItem(title: 'Hide'),
    MenuItem(title: 'Show'),
    MenuItem.separator,
    MenuItem(title: 'Exit'),
  ];
  await TrayManager.instance.setContextMenu(items);
  TrayManager.instance.addListener(MyAppTrayListener());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return VRouter(
      buildTransition: (animation1, _, child) => FadeTransition(opacity: animation1, child: child),
      theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: const Color(0xfff5f5f5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
          )),
      title: "Partner proxy",
      debugShowCheckedModeBanner: false,
      builder: (_, child) => HomePage(child: child),
      routes: buildRoutes(),
    );
  }

}

class MyAppTrayListener with TrayListener {
  @override
  void onTrayIconMouseDown() {
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.title == 'Hide') {
      WindowManager.instance.hide();
    }
    if (menuItem.title == 'Show') {
      WindowManager.instance.show();
    }
    if (menuItem.title == 'Exit') {
      WindowManager.instance.terminate();
    }
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
