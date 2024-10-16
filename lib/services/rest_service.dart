import 'package:get/get.dart';

class RestServiceController extends GetxController {
  String get base => 'http://192.168.126.77:3000';

  //

  // auth rest service
  String get auth => '$base/auth/check';
  String get login => '$base/auth/login/';
  String get register => '$base/auth/register/';

  // user rest service
  String get userData => '$base/user/data';

  // character rest service
  String get character => '$base/character/';
  String get createCharacter => '$base/character/create';
  String get getCharacter => '$base/character/get'; // parameter characterId
  String get deleteCharacter =>
      '$base/character/delete'; // parameter characterId
  String get updateCharacter =>
      '$base/character/update'; // parameter characterId

  // work rest service
  String get work => '$base/work/all'; // parameter characterId
  String get getWork => '$base/work/get'; // parameter workId
  String get createWork => '$base/work/create'; // parameter characterId
  String get deleteWork => '$base/work/delete'; // parameter workId
  String get updateWork => '$base/work/update'; // parameter workId

  // Tasks rest service
  String get tasks => '$base/tasks'; // parameter workId
  String get getTask => '$base/tasks/get'; // parameter taskId
  String get createTask => '$base/tasks/create'; // parameter workId
  String get deleteTask => '$base/tasks/delete'; // parameter taskId
  String get updateTask => '$base/tasks/update'; // parameter taskId


  // Special rest service
  String get charSpecials => '$base/special'; // parameter charId
  String get getSpecial => '$base/special/get'; // parameter specialId
  String get createSpecial => '$base/special/create'; // parameter charId
  String get deleteSpecial => '$base/special/delete'; // parameter specialId
  String get updateSpecial => '$base/special/update'; // parameter specialId
}
