import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:illustrashirt/models/product_basketModel.dart';


class BagDatabase{

  static final BagDatabase instance = BagDatabase._init();

  static Database _database;

  BagDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('bag.db');
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
    final doubleType = ' REAL ';
    final integerType = ' INTEGER ';

   // await db.execute('CREATE TABLE bag (_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, size REAL, color TEXT, type TEXT, sex TEXT, category TEXT, count INTEGER, city TEXT, imagUrl TEXT)');

    await db.execute('''
CREATE TABLE $tableBag ( 
  ${BagFields.id} $idType, 
  ${BagFields.name} $textType,
  ${BagFields.price} $doubleType,
  ${BagFields.size} $textType,
  ${BagFields.color} $textType,
  ${BagFields.type} $textType,
  ${BagFields.sex} $textType, 
  ${BagFields.category} $textType,
  ${BagFields.count} $integerType,
  ${BagFields.city} $textType,
  ${BagFields.imagePathFromGallerie} $textType,
  ${BagFields.imageUrl} $textType 
  )
''');
  }


  Future<BasketModel> create(BasketModel bag) async {
    final db = await instance.database;

    final id = await db.insert(tableBag, bag.toJson());
    return bag.copy(id: id);
  }

  Future<int> getCount () async {
    List<BasketModel> db = await readAll() ;

   return db.length;

  }

  Future<double> getAllPrice () async {
    double a;
    List<BasketModel> db = await readAll() ;

    db.forEach((element) {a+=element.count*element.price;});
    return a;

  }


  Future<BasketModel> readBag(int id) async{
    final db = await instance.database ;

    final maps = await db.query(
      tableBag,
      columns: BagFields.values,

    );

    if(maps.isNotEmpty){
      return BasketModel.fromJson(maps.first);
    }
    return null;

  }
  Future<List<BasketModel>> readAll() async{
    final db = await instance.database ;

    final result = await db.query(
      tableBag,
    );

    return result.map((e) => BasketModel.fromJson(e)).toList();

  }

  Future<int> update(BasketModel prod)async{

    final db = await instance.database;

    return db.update(tableBag, prod.toJson(),
    where: '${BagFields.id} = ${prod.id}',
    );

  }

  Future<int> delete(int id)async{

    final db = await instance.database;

    return db.delete(tableBag,
      where: '${BagFields.id} = $id',
    );

  }


  Future close() async {
    final db = await instance.database;

    db.close();
  }


}