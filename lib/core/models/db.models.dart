import 'dart:convert';
import 'dart:ffi';

class Device {
  final String nodeNumber;
  final String nodeType;
  final String nodeSubType;
  final String location;
  final String stackType;
  final String numChild;
  final String status;
  final String parentNodeNum;
  final String macAddress;
  late  String name;
  final String networkTableMAC;
  final String image;

  Device(
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
      this.image = ''});

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
      'image': image
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
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
        image: map['image'] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => '''Device(nodeNumber: $nodeNumber, groups: $nodeType,  
         nodeSubType: $nodeSubType,  location: $location,
         stackType $stackType, numChild $numChild,
         status $status, parentNodeNum $parentNodeNum, macAddress $macAddress,
         name $name, networkTableMAC $networkTableMAC, image $image )''';
}

class RpeUpload {
  final String dName;
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

  RpeUpload(
      {required this.dName,
      required this.dNetNum,
      required this.dNum,
      required this.dType,
      required this.dSubType,
      required this.dStackType,
      required this.dLocation,
      required this.dParNum, // Parent Node Num
      required this.dNumChild,
      required this.dAssociation,
      required this.dMacAddr,
      required this.dStatus,
      required this.dDim,
      required this.nAct,
      required this.actStatus, // actuation status
      required this.numOfSen, // num of sensors
      required this.numOfAssocSen,
      required this.sensorVal,
      required this.clTbl,
      required this.aITbl, // assoc Initiator table
      required this.aLTbl,
      required this.timI, //timerInd: 0,
      required this.thI, //threshInd: 0,
      required this.thP1,
      required this.thP2,
      required this.thTY, // threshold type
      required this.thSN, // threshold sensor
      required this.thAT, // Action Type
      required this.thSA,
      required this.thST, // Start Time
      required this.thET, // End Time
      required this.thWK, // Weekday
      required this.thEM,
      required this.thSM,
      required this.ST, // start time
      required this.ET, // end time
      required this.TT, // timer type
      required this.WK, // Weekday
      required this.AT, // action type
      required this.SA, // status
      required this.EM,
      required this.SM,
      required this.senD});

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
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

  factory RpeUpload.fromMap(Map<String, dynamic> map) {
    return RpeUpload(
        dName: map['dName'] ?? "",
        dNetNum: map['dNetNum'] ?? "",
        dNum: map['dNum'] ?? "",
        dType: map['dType'] ?? "",
        dSubType: map['dSubType'] ?? "",
        dStackType: map['dStackType'] ?? "",
        dLocation: map['dLocation'] ?? "",
        dParNum: map['dParNum'] ?? "",
        dNumChild: map['dNumChild'] ?? "",
        dAssociation: map['dAssociation'] ?? "",
        dMacAddr: map['dMacAddr'] ?? "",
        dStatus: map['dStatus'] ?? "",
        dDim: map['dDim'] ?? "",
        nAct: map['nAct'] ?? "",
        actStatus: map['actStatus'] ?? "",
        numOfSen: map['numOfSen'] ?? "",
        numOfAssocSen: map['numOfAssocSen'] ?? "",
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

  factory RpeUpload.fromJson(String source) =>
      RpeUpload.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  // TODO add fileds
  @override
  String toString() => '''Update(nodeNumber:)''';
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
