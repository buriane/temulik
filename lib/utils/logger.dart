// ignore_for_file: deprecated_member_use

import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    // Menggunakan format waktu yang tersedia
    printTime: true,
  ),
);