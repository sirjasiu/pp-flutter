import 'package:pp/app/configuration/configuration.dart';
import 'package:pp/app/logs/logs.dart';
import 'package:pp/app/stats/stats.dart';
import 'package:pp/app/welcome/welcome.dart';
import 'package:vrouter/vrouter.dart';

List<VRouteElement> buildRoutes() => [
      VWidget(
        path: '/',
        widget: const WelcomePage(),
        stackedRoutes: [
          VWidget(path: 'stats', widget: const StatsPage()),
          VWidget(path: 'logs', widget: const LogsPage()),
          VWidget(path: 'config', widget: const ConfigurationPage()),
        ],
      )
    ];
