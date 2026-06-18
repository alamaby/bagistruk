import 'package:logger/logger.dart';

/// Singleton logger for app-wide logging. Use [log] for one-off messages
/// and [error]/[warn] for error/warning diagnostics.
///
/// Why a singleton: `package:logger.Logger` is cheap but allocating one
/// per call site scatters filter/output configuration. Centralizing it
/// keeps the call sites short and lets us swap output adapters (e.g.
/// Sentry/Crashlytics) in one place later.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void log(String message) => _logger.i(message);
  static void warn(String message, [Object? error, StackTrace? stack]) =>
      _logger.w(message, error: error, stackTrace: stack);
  static void error(String message, [Object? err, StackTrace? stack]) =>
      _logger.e(message, error: err, stackTrace: stack);
}
