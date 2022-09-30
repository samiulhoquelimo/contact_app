import 'package:contact_app/models/contact_model.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String createTableContact = '''create table $tblContact(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColEmail text,
  $tblContactColAddress text,
  $tblContactColImage text,
  $tblContactColWebsite text,
  $tblContactColFavorite integer,
  $tblContactColDob text)''';

  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'contact.db');
    return openDatabase(dbPath, version: 2, onCreate: (db, version) async {
      await db.execute(createTableContact);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (newVersion == 2) {
        db.execute(
            'alter table $tblContact add column $tblContactColWebsite text');
      }
    });
  }

  static Future<int> insert(ContactModel contactModel) async {
    final db = await open();
    return db.insert(tblContact, contactModel.toMap());
  }

  static Future<List<ContactModel>> getAll() async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tblContact);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<ContactModel> getById(int? id) async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db
        .query(tblContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<int> deleteById(int? id) async {
    final db = await open();
    return db
        .delete(tblContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  static Future<int> updateById(int? id, String column, dynamic value) async {
    final db = await open();
    return db.update(tblContact, {column: value},
        where: '$tblContactColId = ?', whereArgs: [id]);
  }
}
