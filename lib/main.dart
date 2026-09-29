import 'package:taksh_e_commerce/app.dart' as app;

/// Production entry point
void main() async {
  await app.runApp(app.AppConfig.production());
}
