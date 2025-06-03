import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  // Singleton yapısı için statik nesne ve veritabanı değişkeni
  static final UserDatabase _instance = UserDatabase._internal();
  static Database? _db;

  // Özel kurucu
  UserDatabase._internal();

  // Singleton fabrika kurucu
  factory UserDatabase() => _instance;

  // Veritabanına erişim; yoksa oluşturur
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // Veritabanını açma ve güncelleme işlemleri
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 2, // Versiyon 2; yeni sütun eklemek için artırıldı
      onCreate: (db, version) async {
        // Yeni veritabanı oluşturulduğunda tabloyu oluştur
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            email TEXT UNIQUE,                    
            password TEXT,                        
            name TEXT,                            
            surname TEXT,                         
            birthDate TEXT,                      
            birthPlace TEXT,                      
            currentCity TEXT,                  
            uid TEXT
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Versiyon yükseltme sırasında çalışır, bir kez çalışacak
        if (oldVersion < 2) {
          // Eğer eski versiyonda uid sütunu yoksa ekle
          await db.execute('ALTER TABLE users ADD COLUMN uid TEXT;');
        }
      },
    );
  }

  // Yeni kullanıcı ekleme fonksiyonu
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user);
  }

  // Kullanıcı doğrulama (email ve şifre ile)
  Future<Map<String, dynamic>?> validateUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // Email ile kullanıcı bilgisi getirme
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty ? res.first : null;
  }

  // Son eklenen kullanıcıyı getirme
  Future<Map<String, dynamic>?> getLastUser() async {
    final db = await database;
    final res = await db.query('users', orderBy: 'id DESC', limit: 1);
    return res.isNotEmpty ? res.first : null;
  }

  // Tüm kullanıcıları listeleme
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Tüm kullanıcıları silme (veritabanını sıfırlama)
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }
}
