class AppConstants {
  static const int requestTimeout = 4;
  static const String light = "lightSensors";
  static const String deviceTable = "rpeDevice";
  static const String networkTable = "rpeNet";
  static const String clusterTable = "clusters";
  static const String dbName = "RPEControls.db";
  static const int airQuality = 1;
  static const int uiUpdateInterval = 3000;
  static const String advName = 'Prov'; //TODO change

  static const bool debug = true;

  static const Map<String, dynamic> images = {
    "12": "assets/images/icons/ESP32.jpg",
    "0B": "assets/images/icons/air-quality-sensor.png",
    "15": "assets/images/icons/Temperature.jpg",
    "40": "assets/images/icons/Relay.jpg",
    "1A": "assets/images/icons/buzzer.jpg",
    "00": "assets/images/icons/air-quality-sensor.png",
  };

  static List<String> buttonActivators = ['02', '03', '1A', '40'];
  static List<String> dimmerActivators = ['01'];
  static List<String> buttonSensor = ['06'];
  static List<String> dimmerSensor = ['06'];

  static const Map<String, dynamic> deviceTypes = {
    'devType': {
      1: {
        //In_Wall_Outlet
        'dSub': {
          0: {
            'nSen': 8,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 41, 6: 42, 7: 43},
          },
          1: {
            'nSen': 9,
            'senT': {
              0: 37,
              1: 4,
              2: 38,
              3: 39,
              4: 40,
              5: 41,
              6: 42,
              7: 43,
              8: 5
            },
          },
        }
      },
      2: {
        //In_Wall_Switch
        'dSub': {
          0: {
            'nSen': 5,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40},
          },
          1: {
            'nSen': 6,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44},
          },
          2: {
            'nSen': 7,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44, 6: 1},
          },
          3: {
            'nSen': 8,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44, 6: 1, 7: 5},
          }
        }
      },
      3: {
        //Power Strip
        'dSub': {
          0: {
            'nSen': 5,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40},
          },
          1: {
            'nSen': 6,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44},
          },
          2: {
            'nSen': 7,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44, 6: 1},
          },
          3: {
            'nSen': 8,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44, 6: 1, 7: 5},
          }
        }
      },
      4: {
        //Sprinkler
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11},
          },
        }
      },
      5: {
        //HVAC
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 28}, // vibration
          },
        }
      },
      6: {
        //Contact switch
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 31},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 31, 3: 5},
          },
          2: {
            'nSen': 5,
            'senT': {0: 37, 1: 4, 2: 31, 3: 5, 4: 32},
          },
        }
      },
      7: {
        // Parking_Sen
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 28}, // vibration
          },
        }
      },
      8: {
        //Shutoff_Valve
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 28}, // vibration
          },
          2: {
            // re check
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
        }
      },
      9: {
        //Moisture
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 17},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 17, 3: 11},
          },
        }
      },
      10: {
        //People_Counter
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 28}, // vibration
          },
        }
      },
      11: {
        //Air quality/Gas_Sensor
        'dSub': {
          0: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 53, 3: 54},
          },
          1: {
            'nSen': 5,
            'senT': {0: 37, 1: 4, 2: 53, 3: 54, 4: 5}, // vibration
          },
        }
      },
      12: {
        //LevelDetect
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 28}, // vibration
          },
        }
      },
      13: {
        //Liquid_Pre'senT'
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      14: {
        //Range_Sen
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      15: {
        //Dust_Sen
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      16: {
        //Sound Detector
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      17: {
        //Duct Cntrol
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 5}, // humidity
          },
        }
      },
      18: {
        //Generic Coord
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 5}, // humidity
          },
        }
      },
      19: {
        //Display
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      20: {
        //Flow_Sen
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11},
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      21: {
        //Temp Sensor also temp probe
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 5}, // humidity
          },
        }
      },
      22: {
        //Repeater
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 5}, // humidity
          },
        }
      },
      23: {
        //Motion_Detect
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 44},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 44, 3: 1}, // humidity
          },
          2: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 50}, // human presence, humidity
          },
        }
      },
      24: {
        //Light_Sen
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 1},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 46, 3: 5}, // humidity
          },
        }
      },
      25: {
        //Light_Controller
        'dSub': {
          0: {
            'nSen': 5,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40},
          },
          1: {
            'nSen': 6,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44},
          },
          2: {
            'nSen': 7,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44, 6: 1},
          },
          3: {
            'nSen': 8,
            'senT': {0: 37, 1: 4, 2: 38, 3: 39, 4: 40, 5: 44, 6: 1, 7: 5},
          }
        }
      },
      26: {
        //Buzzer
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 4,
            'senT': {0: 0, 1: 37, 2: 4, 3: 5}, // humidity
          },
        }
      },
      27: {
        //Gesture
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 47}, // Gesture
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 47, 3: 1}, // Proximity and light
          },
        }
      },
      28: {
        //Smoke
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 48}, // Smoke
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 48, 3: 5}, // Smoke & humidity
          },
        }
      },
      29: {
        //Cellular Comm
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
          1: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 49}, // GPS
          },
        }
      },
      30: {
        //Pressure Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 26}, //Pressure
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 26, 3: 5}, // Pressure + Humidity
          },
        }
      },
      31: {
        //Human Presence Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 50}, //Human Presence
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 50, 3: 5}, // Human Presence + Humidity
          },
        }
      },
      32: {
        //UV Light Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 3}, //UV light
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 3, 3: 5}, // UV Light + Humidity
          },
        }
      },
      33: {
        //Ultrasonic Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 6}, //Ultrasonic
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 6, 3: 5}, // Ultrasonic + Humidity
          },
        }
      },
      34: {
        //Load Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 52}, //Load
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 52, 3: 5}, // Load + Humidity
          },
        }
      },
      35: {
        //Color Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 2}, //Color
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 2, 3: 5}, // Color + Humidity
          },
        }
      },
      36: {
        //Force Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 16}, //Force
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 16, 3: 5}, //Force + Humidity
          },
        }
      },
      37: {
        //Lightning Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 51}, //Lightning
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 51, 3: 5}, // Lightining + Humidity
          },
        }
      },
      38: {
        //RFID reader
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 18}, //RFID
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 18, 3: 5}, //RFID + Humidity
          },
        }
      },
      39: {
        //Vibration Sensor
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 28}, //Vibration
          },
          1: {
            'nSen': 4,
            'senT': {0: 37, 1: 4, 2: 28, 3: 5}, //Vibration + Humidity
          },
        }
      },
      40: {
        //Single Relay
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
        }
      },
      41: {
        //Two Relay
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
        }
      },
      42: {
        //Four Relay
        'dSub': {
          0: {
            'nSen': 2,
            'senT': {0: 37, 1: 4},
          },
        }
      },
      43: {
        //Single Valve
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11}, //Flow
          },
        }
      },
      44: {
        //Two Valve
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11}, //Flow
          },
        }
      },
      45: {
        //Four Valve
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11}, //Flow
          },
        }
      },
      46: {
        //Two Sprinkler
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11}, //Flow
          },
        }
      },
      47: {
        //Four Sprinkler
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4, 2: 11}, //Flow
          },
        }
      },
      48: {
        //Window Blind control
        'dSub': {
          0: {
            'nSen': 3,
            'senT': {0: 37, 1: 4},
          },
        }
      },
    }
  };

  List<String> domainList = [
    'Sprinkler', //0
    'Outlets', //1
    'Lighting', //2
    'Access', //3
    'Water Shutoff', //4
    'Switches', //5
    'HVAC', //6
    'Temperature', //7
    'Power Strip', //8
    'Air Fans', //9
    'Counter', //10
    'Solar', //11
    'Rubbish', //12
    'Parking', //13
    'Valves', //14
    'Lamp Posts', //15
    'Washer', //16
    'Pool', //17
    'Faucets', //18
    'Water Heater', //19
    'Bathrooms', //20
  ];

  List<String> devNameArray = [
    "Generi_Device",
    "In_Wall_Outlet",
    "In_Wall_Switch",
    "Power_Strip",
    "Sprinkler_Valve",
    "HVAC_Sw_Cnt",
    "Contact_Sw",
    "Parking_Sen",
    "Shutoff_Valve",
    "Moisture_Sen",
    "People_Counter",
    "Air_Quality",
    "LevelDetect",
    "Liquid_Pre'senT'",
    "Range_Detect",
    "Dust_Detect",
    "Noise_Detect",
    "Duct_Cnt",
    "Coordinator",
    "Display",
    "Flow_Detect",
    "Temp_Sen",
    "Repeater",
    "Motion_Detector",
    "Light_Sen",
    "Light_Controller",
    "Buzzer",
    "Gesture Sensor",
    "Smoke Sensor",
    "Cellular Comm",
    "Pressure Sensor",
    "Human Presence",
    "UV Light Sensor",
    "Ultrasonic Sensor",
    "Load Sensor",
    "Color Sensor",
    "Force Sensor",
    "Lightning Sensor",
    "RFID Reader",
    "Vibration Sensor",
    "One Relay Cnt",
    "Two Relay Cnt",
    "Four Relay Cnt",
    "One Valve Cnt",
    "Two Valve Cnt",
    "Four Valve Cnt",
    "Two Sprinkler Cnt",
    "Four Sprinkler Cnt",
    "Window Blind Cnt",
  ];

  static const Map<String, dynamic> Sensortype_id = {
    'State': 0, // Actuation state
    'light': 1,
    'color': 2,
    'ultraviolet': 3,
    'Temperature': 4,
    'Humidity': 5,
    'Ultrasound': 6,
    'Infrared': 7,
    'Steam_Flow': 8,
    'Energy': 9,
    'Liquid_Flow': 10,
    'Water_Flow': 11,
    'Gas_Flow': 12,
    'Air_Flow': 13,
    'Magneto': 14,
    'Float_Level': 15,
    'Force': 16,
    'Moisture': 17,
    'RFID': 18,
    'NFC': 19,
    'WiFi': 20,
    'Audio': 21,
    'Image': 22,
    'Gas': 23,
    'Dust': 24,
    'Smoke': 25,
    'Pressure': 26,
    'Gyro': 27,
    'Vibration': 28,
    'Tilt': 29,
    'Accel': 30,
    'Contact': 31,
    'Glass_Break': 32,
    'People_Count': 33,
    'Car_Counter': 34,
    'Parking_Sen': 35,
    'Water_pressure': 36,
    'Battery_pwr_sen': 37,
    'EM1_Volt': 38,
    'EM1_Amp': 39,
    'EM1_Pwr': 40,
    'EM2_Volt': 41,
    'EM2_Amp': 42,
    'EM2_Pwr': 43,
    'Motion': 44,
    'Sound': 45,
    'Leakage': 46,
    'Gesture': 47,
    'GPS': 49,
    'Human_Presence': 50,
    'Lightning': 51,
    'Load': 52,
    'eCO2': 53,
    'TVOC': 54,
  };

  List<String> SensortypeArray = [
    "state",
    "Light",
    "Color",
    "Ultraviolet",
    "Temperature",
    "Humidity",
    "Ultrasound",
    "Infrared",
    "Steam_Flow",
    "Energy",
    "Liquid Flow",
    "Water Flow",
    "Gas Flow",
    "Air Flow",
    "Magneto",
    "Float_Level",
    "Force",
    "Moisture",
    "RFID",
    "NFC",
    "WiFi",
    "Audio",
    "Image",
    "Gas",
    "Dust",
    "Smoke",
    "Pressure",
    "Gyro",
    "Vibration",
    "Tilt",
    "Accelerameter",
    "Contact",
    "Glass Break",
    "People_Count",
    "Car_Counter",
    "Parking Sensor",
    "Water Presure",
    "Battery Power",
    "EM1 Voltage",
    "EM1 Current",
    "EM1 Power",
    "EM2 Voltage",
    "EM2 Current",
    "EM2 Power",
    "Motion",
    "Sound",
    "Leakage",
    "Proximity",
    "Smoke",
    "GPS",
    "Human_Presence",
    "Lightning",
    "Load",
    "CO2",
    "TVOC"
  ];

  static const Map<String, dynamic> sensorRangeType = {
    'lVal': 0,
    'lMin': 0,
    'lMax': 100,
    'hVal': 100,
    'hMin': 0,
    'hMax': 100,
    'dlta': 1,
  };
}
