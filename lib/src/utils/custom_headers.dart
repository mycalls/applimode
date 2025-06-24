// core
import 'package:applimode_app/env/env.dart';

final Map<String, String> rTwoSecureHeader = {
  "X-Custom-Auth-Key": Env.workerKey,
};
