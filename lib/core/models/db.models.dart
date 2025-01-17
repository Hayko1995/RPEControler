import 'dart:convert';

class RpeDevice {
  late String nodeNumber;
  late String nodeType;
  late String nodeSubType;
  late String location;
  late String stackType;
  late String numChild;
  late String status;
  late String parentNodeNum;
  late String macAddress;
  late String name;
  late String networkTableMAC;
  late String image;
  late String dName;
  late String dNetNum;
  late int isActivation;
  late int deviceType; // device can be 4 type,
  //1 control button
  //2 control dimmer
  //3 indicator button
  // indicator dimmer
  late String netId;
  late String timers;
  late String thresholds;
  late String clusters;
  late String associations;
  late int timI; //timer: 0,
  late int thI; //threshInd: 0,

  final int dNum;
  final int dType;
  final int dSubType;
  final int dStackType;
  final int dLocation;
  final int dParNum; // Parent Node Num
  final int dNumChild;
  final int dAssociation;
  final int dStatus;
  final int dDim;
  final int nAct;
  final String actStatus; // actuation status
  final int numOfSen; // num of sensors
  final int numOfAssocSen;
  late String sensorVal;
  late int notify;
  late String mail;
  late String phoneNumber;
  final String
      clTbl; // table which holds if a given device is part of a cluster (0-9)
  final String aITbl; // assoc Initiator table
  final String aLTbl;


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
      {this.nodeNumber = '',
      this.nodeType = '',
      this.deviceType = 5,
      this.isActivation = 0,
      this.nodeSubType = '',
      this.netId = '',
      this.location = '',
      this.stackType = '',
      this.numChild = '',
      this.status = '',
      this.parentNodeNum = '',
      this.macAddress = '',
      this.name = '',
      this.networkTableMAC = '',
      this.image = '',
      this.dName = '',
      this.dNetNum = '',
      this.dNum = 0,
      this.dType = 0,
      this.dSubType = 0,
      this.dStackType = 0,
      this.dLocation = 0,
      this.dParNum = 0, // Parent Node Num
      this.dNumChild = 0,
      this.dAssociation = 0,
      this.dStatus = 0,
      this.dDim = 0,
      this.nAct = 0,
      this.actStatus = "", // actuation status
      this.numOfSen = 0, // num of sensors
      this.numOfAssocSen = 0,
      this.sensorVal = "0,0,0,0,0,0,0,0,0,0,0",
      this.timers = "{\"timers\":[]}",
      this.thresholds = "{\"thresholds\":[]}",
      this.clusters = "{\"clusters\":[]}",
      this.associations = "{\"associations\":[]}",
      this.mail = '',
      this.phoneNumber = '',
      this.notify = 0,
      this.clTbl = "",
      this.aITbl = "", // assoc Initiator table
      this.aLTbl = "",
      this.timI = 0, //timerInd: 0= "",
      this.thI = 0, //threshInd: 0= "",
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
      'netId': netId,
      'deviceType': deviceType,
      'location': location,
      'isActivation': isActivation,
      'stackType': stackType,
      'numChild': numChild,
      'status': status,
      'parentNodeNum': parentNodeNum,
      'macAddress': macAddress,
      'name': name,
      'networkTableMAC': networkTableMAC,
      'image': image,
      'timers': timers,
      'thresholds': thresholds,
      'clusters': clusters,
      'associations': associations,
      'notify': notify,
      'mail': mail,
      'phoneNumber': phoneNumber,

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
        netId: map['netId'] ?? '',
        deviceType: map['deviceType'] ?? 0,
        nodeSubType: map['nodeSubType'] ?? "",
        isActivation: map['isActivation'] ?? 0,
        location: map['location'] ?? "",
        stackType: map['stackType'] ?? "",
        numChild: map['numChild'] ?? "",
        status: map['status'] ?? "",
        parentNodeNum: map['parentNodeNum'] ?? "",
        macAddress: map['macAddress'] ?? "",
        name: map['name'] ?? "",
        networkTableMAC: map['networkTableMAC'] ?? 0,
        image: map['image'] ?? "",
        timers: map['timers'] ?? "",
        thresholds: map['thresholds'] ?? "",
        clusters: map['clusters'] ?? '',
        associations: map['associations'] ?? '',
        dName: map['dName'] ?? "",
        dNetNum: map['dNetNum'] ?? "",
        dNum: map['dNum'] ?? 0,
        dType: map['dType'] ?? 0,
        dSubType: map['dSubType'] ?? 0,
        dStackType: map['dStackType'] ?? 0,
        dLocation: map['dLocation'] ?? 0,
        dParNum: map['dParNum'] ?? 0,
        dNumChild: map['dNumChild'] ?? 0,
        dAssociation: map['dAssociation'] ?? 0,
        dStatus: map['dStatus'] ?? 0,
        dDim: map['dDim'] ?? 0,
        nAct: map['nAct'] ?? 0,
        actStatus: map['actStatus'] ?? "",
        numOfSen: map['numOfSen'] ?? 0,
        numOfAssocSen: map['numOfAssocSen'] ?? 0,
        sensorVal: map['sensorVal'] ?? "",
        notify: map['notify'] ?? 0,
        mail: map['mail'] ?? '',
        phoneNumber: map['phoneNumber'] ?? "",
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

  @override
  String toString() => '''Device(nodeNumber: $nodeNumber, netId: $netId,
  isActivation: $isActivation, deviceType: $deviceType,  nodeType: $nodeType,  nodeSubType: $nodeSubType,
    location: $location, notify $notify, phoneNumber $phoneNumber, mail $mail,  stackType $stackType, numChild $numChild,
         status $status, parentNodeNum $parentNodeNum, macAddress $macAddress,
         name $name, networkTableMAC $networkTableMAC, image $image )
         'timers' $timers, 'thresholds $thresholds, 'clusters $clusters, associations $associations
         ''';
}

class RpeNetwork {
  late String name;
  final int num;
  late int domain;
  late String preSetDomain;
  final int preDef;
  final String macAddr;
  late String ipAddr;
  final String url;
  final String key;
  late int numOfNodes;
  late String timers; // total of timers defined in a network
  late String thresholds; // total of thresholds defined in a network
  late String clusters; // number of clusters
  late String associations;
  late int numberRTDevices; // num of RTs in networks
  late int numberRTChildren; // num of children per RT (max 10 RT)
  final int nEDs; // num of EDs in network
  final int netT; // network type
  late String netId; // network Id
  final int netPId; //TODO what is this
  final int netPT; //TODO what is this

  late int nTim;
  final int nMCl;
  final int nAso; // number of associations
  final int nMAso; // number of multi network associations
  final int date;

  RpeNetwork(
      {this.name = "",
      this.num = 0,
      this.domain = 0,
      this.preSetDomain = '',
      this.preDef = 0,
      this.macAddr = "",
      this.ipAddr = "",
      this.url = "",
      this.key = '',
      this.timers = "{\"timers\":[]}",
      this.thresholds = "{\"thresholds\":[]}",
      this.clusters = "{\"clusters\":[]}",
      this.associations = "{\"associations\":[]}",
      this.nTim = 0,
      this.numOfNodes = 0,
      this.numberRTDevices = 0,
      this.numberRTChildren = 0,
      this.nEDs = 0,
      this.netT = 0,
      this.netId = '',
      this.netPId = 0,
      this.netPT = 0,
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
      "preSetDomain": preSetDomain,
      'preDef': preDef,
      'macAddr': macAddr,
      'ipAddr': ipAddr,
      'url': url,
      'key': key,
      'numOfNodes': numOfNodes,
      'numberRTDevices': numberRTDevices,
      'numberRTChildren': numberRTChildren,
      'nEDs': nEDs,
      'netT': netT,
      'netId': netId,
      'netPId': netPId,
      'netPT': netPT,
      'timers': timers,
      'thresholds': thresholds,
      'clusters': clusters,
      'associations': associations,
      'nTim': nTim,
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
      preSetDomain: map['preSetDomain'] ?? "",
      preDef: map['preDef'] ?? "",
      macAddr: map['macAddr'] ?? "",
      ipAddr: map['ipAddr'] ?? "",
      url: map['url'] ?? "",
      key: map['key'] ?? "",
      numOfNodes: map['numOfNodes'] ?? "",
      numberRTDevices: map['numberRTDevices'] ?? 0,
      numberRTChildren: map['numberRTChildren'] ?? 0,
      nEDs: map['nEDs'],
      netT: map['netT'],
      netId: map['netId'] ?? '',
      netPId: map['netPId'],
      netPT: map['netPT'],
      timers: map['timers'] ?? "",
      thresholds: map['thresholds'] ?? '',
      clusters: map['clusters'] ?? '',
      associations: map['associations'] ?? '',
      nTim: map['nTim'],
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

  //TODO add fields
  @override
  String toString() =>
      '''RPENetwork(name: $name, ip: $num, type: $domain', netID: $netId, 'preSetDomain' $preSetDomain 
      'timers' $timers, 'thresholds $thresholds, 'clusters $clusters, associations $associations
      ''';
}

class Cluster {
  late int clusterId;
  late String clusterName;
  late String type;
  late String devices;
  late String netNumber;
  late int status;
  late String description;

  Cluster({
    required this.clusterId,
    required this.clusterName,
    required this.devices,
    required this.type,
    required this.netNumber,
    this.description = '',
    required this.status,
  });

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'clusterId': clusterId,
      'clusterName': clusterName,
      'devices': devices,
      'type': type,
      'netNumber': netNumber,
      'description': description,
      'status': status,
    };
  }

  factory Cluster.fromMap(Map<String, dynamic> map) {
    return Cluster(
      clusterId: map['clusterId'] ?? 0,
      clusterName: map['clusterName'] ?? "",
      type: map['type'] ?? "",
      devices: map['devices'] ?? "",
      netNumber: map['netNumber'] ?? "",
      description: map['description'] ?? "",
      status: map['status'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Cluster.fromJson(String source) =>
      Cluster.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about

  @override
  String toString() =>
      '''Cluster(clusterName: ClusterId $clusterId,  $clusterName, devices: $devices,  
         netNumber: $netNumber, description: $description )''';
}

class Association {
  late int associationId;
  late String associationName;
  late String type;
  late String fromDevices;
  late String toDevices;
  late String netNumber;
  late int status;

  Association({
    required this.associationId,
    required this.associationName,
    required this.fromDevices,
    required this.toDevices,
    required this.type,
    required this.netNumber,
    required this.status,
  });

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'associationId': associationId,
      'associationName': associationName,
      'fromDevices': fromDevices,
      'toDevices': toDevices,
      'type': type,
      'netNumber': netNumber,
      'status': status,
    };
  }

  factory Association.fromMap(Map<String, dynamic> map) {
    return Association(
      associationId: map['associationId'] ?? 0,
      associationName: map['associationName'] ?? "",
      type: map['type'] ?? "",
      fromDevices: map['fromDevices'] ?? "",
      toDevices: map['toDevices'] ?? "",
      netNumber: map['netNumber'] ?? "",
      status: map['status'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Association.fromJson(String source) =>
      Association.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about

  @override
  String toString() =>
      '''Associations(clusterName: AssociationsId $associationId, associationName $associationName, fromDevices: $fromDevices,
      toDevices: $toDevices, netNumber: $netNumber)''';
}
