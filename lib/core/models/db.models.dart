import 'dart:convert';
import 'dart:ffi';

class RpeDevice {
  final String nodeNumber;
  final String nodeType;
  final String nodeSubType;
  late String location;
  final String stackType;
  final String numChild;
  final String status;
  final String parentNodeNum;
  final String macAddress;
  late String name;
  final String networkTableMAC;
  final String image;

  //todo new Fileds
  late String dName;
  final int dNetNum;
  final int dNum;
  final int dType;
  final int dSubType;
  final int dStackType;
  final int dLocation;
  final int dParNum; // Parent Node Num
  final int dNumChild;
  final int dAssociation;
  final String dMacAddr;
  final int dStatus;
  final int dDim;
  final int nAct;
  final String actStatus; // actuation status
  final int numOfSen; // num of sensors
  final int numOfAssocSen;
  final String sensorVal;
  final String
      clTbl; // table which holds if a given device is part of a cluster (0-9)
  final String aITbl; // assoc Initiator table
  final String aLTbl;
  final String timI; //timerInd: 0,
  final String thI; //threshInd: 0,
  final String thP1;
  final String thP2;
  final String thTY; // threshold type
  final String thSN; // threshold sensor
  final String thAT; // Action Type
  final String thSA;
  final String thST; // Start Time
  final String thET; // End Time
  final String thWK; // Weekday
  final String thEM;
  final String thSM;
  final String ST; // start time
  final String ET; // end time
  final String TT; // timer type
  final String WK; // Weekday
  final String AT; // action type
  final String SA; // status
  final String EM;
  final String SM;
  final String senD;

  RpeDevice(
      {required this.nodeNumber,
      required this.nodeType,
      required this.nodeSubType,
      required this.location,
      required this.stackType,
      required this.numChild,
      required this.status,
      required this.parentNodeNum,
      required this.macAddress,
      required this.name,
      required this.networkTableMAC,
      this.image = '',

      //todo new Filed
      this.dName = '',
      this.dNetNum = 0,
      this.dNum = 0,
      this.dType = 0,
      this.dSubType = 0,
      this.dStackType = 0,
      this.dLocation = 0,
      this.dParNum = 0, // Parent Node Num
      this.dNumChild = 0,
      this.dAssociation = 0,
      this.dMacAddr = "",
      this.dStatus = 0,
      this.dDim = 0,
      this.nAct = 0,
      this.actStatus = "", // actuation status
      this.numOfSen = 0, // num of sensors
      this.numOfAssocSen = 0,
      this.sensorVal = "",
      this.clTbl = "",
      this.aITbl = "", // assoc Initiator table
      this.aLTbl = "",
      this.timI = "", //timerInd: 0= "",
      this.thI = "", //threshInd: 0= "",
      this.thP1 = "",
      this.thP2 = "",
      this.thTY = "", // threshold type
      this.thSN = "", // threshold sensor
      this.thAT = "", // Action Type
      this.thSA = "",
      this.thST = "", // Start Time
      this.thET = "", // End Time
      this.thWK = "", // Weekday
      this.thEM = "",
      this.thSM = "",
      this.ST = "", // start time
      this.ET = "", // end time
      this.TT = "", // timer type
      this.WK = "", // Weekday
      this.AT = "", // action type
      this.SA = "", // status
      this.EM = "",
      this.SM = "",
      this.senD = ""});

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'nodeNumber': nodeNumber,
      'nodeType': nodeType,
      'nodeSubType': nodeSubType,
      'location': location,
      'stackType': stackType,
      'numChild': numChild,
      'status': status,
      'parentNodeNum': parentNodeNum,
      'macAddress': macAddress,
      'name': name,
      'networkTableMAC': networkTableMAC,
      'image': image,

      //todo New Fields
      'dName': dName,
      'dNetNum': dNetNum,
      'dNum': dNum,
      'dType': dType,
      'dSubType': dSubType,
      'dStackType': dStackType,
      'dLocation': dLocation,
      'dParNum': dParNum,
      'dNumChild': dNumChild,
      'dAssociation': dAssociation,
      'dMacAddr': dMacAddr,
      'dStatus': dStatus,
      'dDim': dDim,
      'nAct': nAct,
      'actStatus': actStatus, // actuation status
      'numOfSen': numOfSen, // num of sensors
      'numOfAssocSen': numOfAssocSen,
      'sensorVal': sensorVal,
      'clTbl': clTbl,
      'aITbl': aITbl, // assoc Initiator table
      'aLTbl': aLTbl,
      'timI': timI, //timerInd: 0,
      'thI': thI, //threshInd: 0,
      'thP1': thP1,
      'thP2': thP2,
      'thTY': thTY, // threshold type
      'thSN': thSN, // threshold sensor
      'thAT': thAT, // Action Type
      'thSA': thSA,
      'thST': thST, // Start Time
      'thET': thET, // End Time
      'thWK': thWK, // Weekday
      'thEM': thEM,
      'thSM': thSM,
      'ST': ST, // start time
      'ET': ET, // end time
      'TT': TT, // timer type
      'WK': WK, // Weekday
      'AT': AT, // action type
      'SA': SA, // status
      'EM': EM,
      'SM': SM,
      'senD': senD
    };
  }

  factory RpeDevice.fromMap(Map<String, dynamic> map) {
    return RpeDevice(
        nodeNumber: map['nodeNumber'] ?? "",
        nodeType: map['nodeType'] ?? "",
        nodeSubType: map['nodeSubType'] ?? "",
        location: map['location'] ?? "",
        stackType: map['stackType'] ?? "",
        numChild: map['numChild'] ?? "",
        status: map['status'] ?? "",
        parentNodeNum: map['parentNodeNum'] ?? "",
        macAddress: map['macAddress'] ?? "",
        name: map['name'] ?? "",
        networkTableMAC: map['networkTableMAC'] ?? 0,
        image: map['image'] ?? "",
        dName: map['dName'] ?? "",
        dNetNum: map['dNetNum'] ?? 0,
        dNum: map['dNum'] ?? 0,
        dType: map['dType'] ?? 0,
        dSubType: map['dSubType'] ?? 0,
        dStackType: map['dStackType'] ?? 0,
        dLocation: map['dLocation'] ?? 0,
        dParNum: map['dParNum'] ?? 0,
        dNumChild: map['dNumChild'] ?? 0,
        dAssociation: map['dAssociation'] ?? 0,
        dMacAddr: map['dMacAddr'] ?? "",
        dStatus: map['dStatus'] ?? 0,
        dDim: map['dDim'] ?? 0,
        nAct: map['nAct'] ?? 0,
        actStatus: map['actStatus'] ?? "",
        numOfSen: map['numOfSen'] ?? 0,
        numOfAssocSen: map['numOfAssocSen'] ?? 0,
        sensorVal: map['sensorVal'] ?? "",
        clTbl: map['clTbl'] ?? "",
        aITbl: map['aITbl'] ?? "",
        aLTbl: map['aLTbl'] ?? "",
        timI: map['timI'] ?? "",
        thI: map['thI'] ?? "",
        thP1: map['thP1'] ?? "",
        thP2: map['thP2'] ?? "",
        thTY: map['thTY'] ?? "",
        thSN: map['thSN'] ?? "",
        thAT: map['thAT'] ?? "",
        thSA: map['thSA'] ?? "",
        thST: map['thST'] ?? "",
        thET: map['thET'] ?? "",
        thWK: map['thWK'] ?? "",
        thEM: map['thEM'] ?? "",
        thSM: map['thSM'] ?? "",
        ST: map['ST'] ?? "",
        ET: map['ET'] ?? "",
        TT: map['TT'] ?? "",
        WK: map['WK'] ?? "",
        AT: map['AT'] ?? "",
        SA: map['SA'] ?? "",
        EM: map['EM'] ?? "",
        SM: map['SM'] ?? "",
        senD: map['senD'] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory RpeDevice.fromJson(String source) =>
      RpeDevice.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => '''Device(nodeNumber: $nodeNumber, groups: $nodeType,  
         nodeSubType: $nodeSubType,  location: $location,
         stackType $stackType, numChild $numChild,
         status $status, parentNodeNum $parentNodeNum, macAddress $macAddress,
         name $name, networkTableMAC $networkTableMAC, image $image )''';
}

class RpeNetwork {
  final String name;
  final int num;
  final int domain;
  final int preDef;
  final String macAddr;
  final String ipAddr;
  final String url;
  final String key;
  final int numOfNodes;
  final int nRT; // num of RTs in networks
  final int nRTCh; // num of children per RT (max 10 RT)
  final int nEDs; // num of EDs in network
  final int netT; // network type
  final int netId; // network Id
  final int netPId; //TODO what is this
  final int netPT; //TODO what is this
  final int nTim; // total of timers defined in a network
  final int nThr; // total of thresholds defined in a network
  final int nCl; // number of clusters
  final int nMCl;
  final int nAso; // number of associations
  final int nMAso; // number of multi network associations
  final int date;

  RpeNetwork(
      {this.name = "",
      this.num = 0,
      this.domain = 0,
      this.preDef = 0,
      this.macAddr = "",
      this.ipAddr = "",
      this.url = "",
      this.key = '',
      this.numOfNodes = 0,
      this.nRT = 0,
      this.nRTCh = 0,
      this.nEDs = 0,
      this.netT = 0,
      this.netId = 0,
      this.netPId = 0,
      this.netPT = 0,
      this.nTim = 0,
      this.nThr = 0,
      this.nCl = 0,
      this.nMCl = 0,
      this.nAso = 0,
      this.nMAso = 0,
      this.date = 0});

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'num': num,
      'domain': domain,
      'preDef': preDef,
      'macAddr': macAddr,
      'ipAddr': ipAddr,
      'url': url,
      'key': key,
      'numOfNodes': numOfNodes,
      'nRT': nRT,
      'nRTCh': nRTCh,
      'nEDs': nEDs,
      'netT': netT,
      'netId': netId,
      'netPId': netPId,
      'netPT': netPT,
      'nTim': nTim,
      'nThr': nThr,
      'nCl': nCl,
      'nMCl': nMCl,
      'nAso': nAso,
      'nMAso': nMAso,
      'date': date,
    };
  }

  factory RpeNetwork.fromMap(Map<String, dynamic> map) {
    return RpeNetwork(
      name: map['name'] ?? "",
      num: map['num'] ?? "",
      domain: map['domain'] ?? "",
      preDef: map['preDef'] ?? "",
      macAddr: map['macAddr'] ?? "",
      ipAddr: map['ipAddr'] ?? "",
      url: map['url'] ?? "",
      key: map['key'] ?? "",
      numOfNodes: map['numOfNodes'] ?? "",
      nRT: map['nRT'],
      nRTCh: map['nRTCh'],
      nEDs: map['nEDs'],
      netT: map['netT'],
      netId: map['netId'],
      netPId: map['netPId'],
      netPT: map['netPT'],
      nTim: map['nTim'],
      nThr: map['nThr'],
      nCl: map['nCl'],
      nMCl: map['nMCl'],
      nAso: map['nAso'],
      nMAso: map['nMAso'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RpeNetwork.fromJson(String source) =>
      RpeNetwork.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  //TODO add fields
  @override
  String toString() => '''RPEDevice(name: $name, ip: $num, type: $domain''';
}

class Cluster {
  late String clusterName;
  late String devices;
  late String description;

  Cluster(
      {required this.clusterName, required this.devices, this.description = ''});

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'clusterName': clusterName,
      'devices': devices,
      'description': description,
    };
  }

  factory Cluster.fromMap(Map<String, dynamic> map) {
    return Cluster(
      clusterName: map['clusterName'] ?? "",
      devices: map['devices'] ?? "",
      description: map['description'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Cluster.fromJson(String source) =>
      Cluster.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => '''Cluster(clusterName: $clusterName, devices: $devices,  
         description: $description )''';
}
