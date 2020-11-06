import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:agendatarefas/models/aviso.dart';

class AvisoPages {
  static final AvisoPages _instance = AvisoPages.internal();

  factory AvisoPages() => _instance;

  AvisoPages.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "aviso_lista.db");
    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE aviso("
          "id INTEGER PRIMARY KEY, "
          "titlo TEXT, "
          "descrip TEXT)");
    });
  }

  Future<int> getCount() async {
    Database database = await db;
    return Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM aviso"));
  }

  Future close() async {
    Database database = await db;
    database.close();
  }


// inserção de dados
  Future<Aviso> save(Aviso aviso) async {
    Database database = await db;
    aviso.id = await database.insert('aviso', aviso.toMap());
    return aviso;
  }

// ler tarefa por indice
  Future<Aviso> getById(int id) async {
    Database database = await db;
    List<Map> maps = await database.query('aviso',
        columns: ['id', 'titlo', 'descrip'],
        where: 'id=?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Aviso.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Ler todas as tarefas
  Future<List<Aviso>> getAll() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM aviso");
    List<Aviso> stuffList = listMap.map((x) => Aviso.fromMap(x)).toList();
    return stuffList;
  }

  // atualizar tarefa
  Future<int> update(Aviso aviso) async {
    Database database = await db;
    return await database
        .update('aviso', aviso.toMap(), where: 'id=?', whereArgs: [aviso.id]);
  }

  // excluir por id
  Future<int> delete(int id) async {
    Database database = await db;
    return await database.delete('aviso', where: 'id=?', whereArgs: [id]);
  }

  // excluir tudo
  Future<int> deleteAll() async {
    Database database = await db;
    return await database.rawDelete("DELETE * FROM aviso");
  }
}
