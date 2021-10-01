
import 'package:hooks_riverpod/hooks_riverpod.dart';

final configurationService =
Provider((ref) => ConfigurationService());

class ConfigurationService {
  String get interpreterPath => "http://10.2.1.173:1080/interpreter";
}