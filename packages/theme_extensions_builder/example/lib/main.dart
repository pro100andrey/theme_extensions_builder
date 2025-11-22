import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'app.dart';

void main() {
  timeDilation = 2.0;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}
