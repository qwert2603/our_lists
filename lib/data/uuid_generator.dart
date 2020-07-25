import 'package:uuid/uuid.dart';

abstract class UuidGenerator {
  String generateRandomUuid();
}

class UuidGeneratorImpl implements UuidGenerator {
  @override
  String generateRandomUuid() => Uuid().v4();
}
