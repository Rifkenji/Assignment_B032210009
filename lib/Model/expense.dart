import '../Controller/sqlite_db.dart';
import '../Controller/request_controller.dart';

class Expense {
  static const String SQLiteTable = "expense";
  int? id;
  String desc;
  double amount;
  String dateTime;

  Expense(this.amount, this.desc, this.dateTime);

  Expense.fromJson(Map<String, dynamic> json)
      : desc = json['desc'] as String,
        amount = double.parse(json['amount'] as dynamic),
        dateTime = json['dateTime'] as String,
        id = json['id'] as int?;

  // toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() =>
      {'desc': desc, 'amount': amount, 'dateTime': dateTime, 'id': id};

  //for add save
  Future<bool> save() async {
    // Save to local SQLite
    int? newId = await SQLiteDB().insert(SQLiteTable, toJson());

    // Update the id if it's not set
    if (id == null) {
      id = newId;
    }

    //api
    RequestController req = RequestController(path: "/api/expenses.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      return true;
    } else {
      // Handle the error if the remote save fails
      print("Error saving expense remotely: ${req.status()}, ${req.result()}");
      return false;
    }
  }

  //for edit
  Future<bool> update() async {
    RequestController req = RequestController(path: "/api/expenses.php");

    // Update in remote database
    await req.put(toJson()); // Pass the JSON data for update

    if (req.status() != 200) {
      // Handle the error if the remote update fails
      print(
          "Error updating expense remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    // The rest of your local update logic goes here

    return true; // Return true if update is successful
  }

  Future<bool> delete(Map<String, dynamic> requestBody) async {
    RequestController req = RequestController(path: "/api/expenses.php");

    // Include the request body
    req.setBody(toJson());

    // Delete from remote database
    await req.delete(requestBody);
    if (req.status() != 200) {
      print(
          "Error deleting expense remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    // Delete from local SQLite database
    int rowsAffected = await SQLiteDB().delete(
        SQLiteTable, 'dateTime', dateTime);

    if (rowsAffected > 0) {
      print("Successfully deleted locally. Rows affected: $rowsAffected");
      return true;
    } else {
      print("Error deleting expense locally. Rows affected: $rowsAffected");
      return false;
    }
  }

  static Future<List<Expense>> loadAll() async {
    // Logic to load expenses from a data source (e.g., a database)
    // For example, you might use a database query or an API call here
    // Return a List<Expense> with the loaded expenses

    // Placeholder code:
    List<Expense> expenses = [
      Expense(10.0, 'Groceries', '2023-01-01 12:00:00'),
      Expense(20.0, 'Dinner', '2023-01-02 18:30:00'),
      // Add more expenses as needed
    ];

    return expenses;
  }
}
