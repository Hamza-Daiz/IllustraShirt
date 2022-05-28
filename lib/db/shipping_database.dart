import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:illustrashirt/models/customer_detail_model.dart';


class ShippingDatabase {

  static final ShippingDatabase instance = ShippingDatabase._init();

  static Database _database;

  ShippingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('shipping.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = ' TEXT ';

    await db.execute('''
CREATE TABLE $tableShipping ( 
  ${BagFields.id} $idType, 
  ${BagFields.name} $textType,
  ${BagFields.city} $textType,
  ${BagFields.adress} $textType,
  ${BagFields.zipCode} $textType,
  ${BagFields.phone} $textType,
  ${BagFields.email} $textType
  )
''');
  }

Future<Billing> create(Billing bag) async {
    final db = await instance.database;

    final id = await db.insert(tableShipping, bag.toJson());
    return bag.copy(id: id);
  }

  Future<Billing> readShipp(int id) async{
    final db = await instance.database ;

    final maps = await db.query(
      tableShipping,
      columns: BagFields.values,

    );

    if(maps.isNotEmpty){
      return Billing.fromJson(maps.first);
    }
    return null;

  }

  Future<List<Billing>> readAll() async{
    final db = await instance.database ;

    final result = await db.query(
      tableShipping,
    );

    return result.map((e) => Billing.fromJson(e)).toList();

  }

  Future<int> update(Billing prod)async{

    final db = await instance.database;

    return db.update(tableShipping, prod.toJson(),
      where: '${BagFields.id} = ${prod.id}',
    );

  }

  Future<int> delete(int id)async{

    final db = await instance.database;

    return db.delete(tableShipping,
      where: '${BagFields.id} = $id',
    );

  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }


}