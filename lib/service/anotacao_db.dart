import '../model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoDB{
  static final AnotacaoDB _anotacaoDB = AnotacaoDB._internal();
  static final tableName = "anotacoes";
  Database _db;

  factory  AnotacaoDB(){
    return _anotacaoDB;
  }

  AnotacaoDB._internal(){
  }

  get db async{
    if(_db != null){
      return _db;
    }
    else{
       _db = await iniciateDB();
       return _db;
    }
  }
  //Método para Criar DB
  //Precisa ser criado passando parametros dB e versão
  _onCreate(Database db, int version) async{
    String sql = "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "data DATETIME)";
    await db.execute(sql);
  }

  iniciateDB() async{
    print("Iniciar Baaco de dados");
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados,"dados.db");
    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: _onCreate,
    );
    return bd;
  }

  Future<int>saveAnotacao(Anotacao anotacao) async{
    var  dataBank = await db;
    int resultado  = await dataBank.insert(tableName,anotacao.toMap() );
    return resultado;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao)async{

    var  dataBank = await db;
    return await dataBank.update(
      tableName,
      anotacao.toMap(),
      where: "id = ?",
      whereArgs: [anotacao.id]
    );
  }

  Future<int> deletarAnotacao(int id) async{
    var  dataBank = await db;
    return await dataBank.delete(
        tableName,
        where: "id = ?",
        whereArgs: [id],
    );
  }

   recuperarAnotacoes()async{
    var  dataBank = await db;
    String sql = "SELECT * FROM   $tableName ORDER BY data DESC";
    List anotacoes = await dataBank.rawQuery(sql);
    return anotacoes;
  }


}


