



import 'package:soapy/flavours.dart';
import 'package:soapy/main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.demo;
  await runner.main();
}
