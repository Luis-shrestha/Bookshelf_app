class IdGenerator {
  // Singleton pattern
  IdGenerator._privateConstructor();
  static final IdGenerator _instance = IdGenerator._privateConstructor();
  factory IdGenerator() => _instance;

  // Auto-incrementing ID
  int _currentId = 0;
  int getNextId() => _currentId++;
}
