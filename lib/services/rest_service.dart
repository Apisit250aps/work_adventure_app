import 'package:get/get.dart';

class RestServiceController extends GetxController {
  String get base => 'http://10.250.58.229:3000';

  //

  // auth rest service
  String get auth => '$base/auth/';
  String get login => '$base/auth/login/';
  String get register => '$base/auth/register/';


  // character rest service 
  
}