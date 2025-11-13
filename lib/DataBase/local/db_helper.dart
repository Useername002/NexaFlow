import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';//for input output

class DbHelper {
  //Database variable
  static final String USERTABLE = "users";
  static final String USERID = "USERID";
  static final String USEREMAIL = "email";
  static final String PASSWORD = "password";
  static final String USERNAME = "name";
  static final String PHONE = "phone";
  //Shared Preference variable
  static const isLogedinKey="isLoggedin";
  static const UsernameKey="userName";
  //singleton object
  static final DbHelper instance= DbHelper._();
  DbHelper._();

  Database? Mydb;
  Future<Database> getDB() async {
    if (Mydb != null) {
      return Mydb!;
    } else {
      Mydb = await opendb();
      return Mydb!;
    }
  }

  Future<Database> opendb() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    String dbpath = join(appdir.path, "Users.db");
    return await openDatabase(
      dbpath,
      onCreate: (db, version) {
        //Create table using db.execute which dosen't return anything
        db.execute(
          "create table $USERTABLE($USERID integer primary key autoincrement,$USEREMAIL text unique,$PASSWORD text,$USERNAME text,$PHONE text)",
        );
      },
      version: 1,
    );
  }

  Future<bool> adduser({
    required String uEmail,
    required String uName,
    required String uPhone,
    required String uPassword,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(USERTABLE, {
      USERNAME: uName,
      USEREMAIL: uEmail,
      PHONE: uPhone,
      PASSWORD: uPassword,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String,dynamic>>> getuser()async{
    var db=await getDB();
    List<Map<String,dynamic>> userData=await db.query(USERTABLE);
    return userData;
  }

  Future<Map<String,dynamic>?> getUserByemail(String email)async{
    var db=await getDB();
    //db.query returns a value
    final result=await db.query(USERTABLE,where: '$USEREMAIL =?',whereArgs: [email],);
    if(result.isNotEmpty){
      return result.first;
    }
    else
      {
        return null;
      }
  }

  Future<bool>validateuser(String email,String password)async{
    var db=await getDB();
    final result=await db.query(USERTABLE,where: '$USEREMAIL=? AND $PASSWORD=?',whereArgs: [email,password],);
    return result.isNotEmpty;
  }

  Future<bool>userexists(String email)async{
    var db=await getDB();
    final result=await db.query(USERTABLE,where: '$USEREMAIL=?',whereArgs: [email,]);
    return result.isNotEmpty;
  }

Future<void> setLogin(String userName)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setBool(isLogedinKey, true);
    await prefs.setString(UsernameKey, userName);
}

Future<void> logout() async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.clear();
}

Future<bool> isLoggedin()async{
    final prefs=await SharedPreferences.getInstance();
    return await prefs.getBool(isLogedinKey)??false;
}

static Future<String?> getuserName()async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString(UsernameKey);
}

}

// class DBHelper {
//   //singleton
//   DBHelper._();
//
//   static final DBHelper getInstance = DBHelper._();
//
//   static final String TABLE_NOTE = "note";
//   static final String COLUMN_NOTE_SNO = "s_no";
//   static final String COLUMN_NOTE_TITLE = "title";
//   static final String COLUMN_NOTE_DESC = "desc";
//
//
//   Database? MyDB;
//
//   Future<Database> getDB() async {
//     // MyDB??=await openDB();
//     //return MyDB;
//     if (MyDB != null) {
//       return MyDB!;
//     }
//     else {
//       MyDB = await openDB();
//       return MyDB!;
//     }
//   }
//
//   Future<Database> openDB() async {
//     Directory appDir = await getApplicationDocumentsDirectory();
//     String dbPath = join(appDir.path, "noteDB.db");
//     return await openDatabase(
//       dbPath,
//       onCreate: (db, version) {
//         //creating tables
//         db.execute(
//           "create table $TABLE_NOTE($COLUMN_NOTE_SNO integer primary key autoincrement,$COLUMN_NOTE_TITLE text ,$COLUMN_NOTE_DESC text)",
//         );
//       },
//       version: 1,
//     );
//   }
//
//   Future<bool> addNote({required String mTitle, required String mDesc}) async {
//     var db = await getDB();
//     int rowsEffected = await db.insert(TABLE_NOTE, {
//       COLUMN_NOTE_TITLE: mTitle,
//       COLUMN_NOTE_DESC: mDesc,
//     });
//     return rowsEffected > 0;
//   }
//
//   Future<List<Map<String, dynamic>>> getAllNotes() async {
//     var db = await getDB();
//     List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);
//     return mData;
//   }
// }
