import 'package:myapp/modelos/planeta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ControlePlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.bd');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(caminho, version: 1, onCreate: _criarBD);
  }

  Future<void> _criarBD(Database db, int version) async {
    const sql = '''
 CREATE TABLE planetas(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  distancia REAL NOT NULL,
  tamanho REAL NOT NULL,
  apelido TEXT
 )
 ''';
    await db.execute(sql);
  }

  // ignore: non_constant_identifier_names
  Future<List<Planeta>> LerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((map) => Planeta.fromMap(map)).toList();
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('planetas', planeta.toMap());
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }
}