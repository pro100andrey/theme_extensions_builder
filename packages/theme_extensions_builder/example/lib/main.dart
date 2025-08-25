import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'app.dart';

void main() {
  timeDilation = 10.0;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}
