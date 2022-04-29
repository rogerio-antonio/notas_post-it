import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "expensetracker-347420",
  "private_key_id": "88c32be7fbe7297fc79e20944f0616dc84efab5a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC5yU2dBPC9sVkR\nxoe+oReLxcuaMZ+7pRjqCCy6G/4f0+k8KeO2wXM/STjSap6mmCGoWz72FMHI3QQo\nNXIP76W645BQCx64bLSedLiTiUOH1fSh4VMsKSYHMwJyyyl0w9Mr15grizBwF9vf\nwV2YRD3e5BJAiSwbeurQoWQT2WFTuaXY0gM3RP2uxk1A+k734xldV4K++ErqGpO4\n2KjYDfRmfaOqS5NV2+LTbQtuqda1KOUHCkq04ZjnCrtF6kJWL/aaBzm8NiHQ/kOk\nyVirYBbh21HgK/TuEm9U7ZpiAL7Gq14jD4TOEz660b2r3BGAn3LnhBOxZArZjaTb\nanqIU0fFAgMBAAECggEAEfeX2/GYXqACHyf2BMeLgWb1k8nsyrbiu+9ic/U1FFro\nGXtrnEcFID+ykRbilPXte1ynsCC9xPEq78CLcWMZwgMz96m7pNZOeWyMVShXMZHN\ngMJLyt+H3/Zc7EEdlz9A8uJ8wulJG+4Sw4btyEYBPccMxNT/QQEYKGkTRqAlO3V0\nj2ojDWdt/f3pBHzz7vEAGnuClg6gThG/UUVYZxG/JjTuDyiWM+I02w3WguaGs9AJ\nHLKsiij0IttnvFqq+0BE1tsL/mGUTE11UWRiEhfsa2HW2TiQHXSllVs4Ri/g06Av\najnwK4Hl8PDZJ8bqRg2uk6R+V7rHdZd6gse6YYA/QQKBgQDi6Oj7A5p5E5uChbJy\nSE956bpNYS4EkCo8aH6+c2UKrKTPpuYXuAQpsB9Jz+fFfzKgCd4yBG8O2InmwaQ7\nssjd5bdkSsNDGYzMJ7g/rWdrf5eokfgSQqExDfatAdqwI4l+Yvspsk7l1vimMQD8\nePIsL1w0TKd62pNHiQVdvdBiOQKBgQDRmry+i/Eld7Uht+OYBmFVecTpC1fKkHcH\nyF4Md3njgfE2uduxj3JkWJeb8hVzbcDBCpc+tEPBE8XLZeILPwUvMn+0GmHg0lqK\nMhzVMjzo99z6NPEGNpmXtBHDEciNAFCGOgGt2is0qmE03AjNlD2HSruf4651UqF/\n4ufFk7ch7QKBgQCa+ET+AkUCwgBoURVBdd9JvPYvGNrL5QXjgd5mBfuRIb3hz/O/\naT72lcGYsLRzLt8NbA/jiyGqOvtbrQ6UcxM6cUQh6+mVryJ43/u3CZ/jTB3w09hf\n6D+ceBPrrqODvpGNzt4IaS33TS0+m6M3ywZiZOoNEfkkL5l8trkCf7uNCQKBgAow\njZBt2TFLGoEjIWtYlA7Ftq7loET2tPKp6PiOLlzDCmjwrB97q8H5FJW+NRDBeydn\nTmb7+HdAcNMshsqpK6VZvR+SUMPPNhuVyBUNNizVL+bx/+2fZeQcGujyyl8gbsm3\ntDExc/xBdCxPrhXgaQVUur5RIUAO3k8LRt0yCysZAoGBALA8/R78Oi3zp9iGW3ew\naeLklVrPxsJd4lXGCPRVYqMgA7v8fkXeHwKHT7FTIr8DDru5OR6pe/0PpN6ujmh5\n98rvJ2p3azeM8qIUUQQjnsBQP8BZhQgQIcHyqZZ5MCuVrFGTZSAs2DVQxBrRYY2I\nk+raRAybRl6h8CafTutzH2CE\n-----END PRIVATE KEY-----\n",
  "client_email": "expensetracker@expensetracker-347420.iam.gserviceaccount.com",
  "client_id": "106976637006703948565",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expensetracker%40expensetracker-347420.iam.gserviceaccount.com"
}

''';

// set up & connect to the spreadsheet
  static final _spreadsheetId = '1lHlCsP_IQIBqEZtY6nj-Dh9ajxruh4DbkD6d2XQEmCI';
  static final _gsheets = GSheets(_credentials);
  static late final Worksheet? _worksheet;

// some variables to keep track of..
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];
  static bool loading = true;

// initialise the spreadsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet2');
    countRows();
  }

// count the number of note
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }

// now we know how many notes to load, now let's load them!
    loadNotes();
  }

// load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
    loading = false;
  }

// insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }
}
