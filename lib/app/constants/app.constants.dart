class AppConstants {
  static const int requestTimeout = 4;
  static const String light = "lightSensors";
  static const String crTable = "crTable";
  static const String dbName = "RPEControls.db";
  static const Map userData = {
    'light': [
      {"name": "room 1", "value": 20, "group": 1, "warning": true},
      {"name": "room 2", "value": 40, "group": 1, "warning": false},
      {"name": "room 1", "value": 20, "group": 1, "warning": true},
    ],
    'electricity': [
      {"name": "room 1 ", "value": 20, "group": 1, "warning": false},
      {"name": "room 3 ", "value": 40, "group": 1, "warning": false},
    ],
    'water': [
      {"name": "room 1 ", "value": 20, "group": 1, "warning": false},
      {"name": "room 3 ", "value": 40, "group": 1, "warning": false},
    ]
  };
}
