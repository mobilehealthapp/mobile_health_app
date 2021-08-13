import 'dart:convert';
import 'dart:math';

String getSecureCode(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  String code = base64UrlEncode(values);
  print(code);
  return code;
}
