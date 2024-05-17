class MeshThreshold {
  final threshold = '90';

  final setThreshold = '01';
  final deleteThreshold = '40';
  final enableThreshold = '10';
  final disableThreshold = '20';
  final enableAllThreshold = '50';
  final disableAllThreshold = 'A0';
  final deleteAllThreshold = 'C0';
  final syncThreshold = '08';
  final setAssocThreshold = '02';

  String sendDeleteThreshold(nodeNumber, networkNumber, thresholdId) {
    String subCommand = "40";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendEnableThreshold(nodeNumber, networkNumber, {thresholdId = '00'}) {
    String subCommand = "10";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendDisableThreshold(nodeNumber, networkNumber, {thresholdId = '00'}) {
    String subCommand = "20";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendEnableAllThresholds(nodeNumber, networkNumber,
      {thresholdId = '00'}) {
    String subCommand = "50";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendDisableAllThresholds(nodeNumber, networkNumber,
      {thresholdId = '00'}) {
    String subCommand = "A0";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendDeleteAllThresholds(nodeNumber, networkNumber,
      {thresholdId = '00'}) {
    String subCommand = "C0";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendSyncThresholds(nodeNumber, networkNumber, {thresholdId = '00'}) {
    //todo need to define
    String subCommand = "08";
    String messageLength = "06";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdId;
    return command;
  }

  String sendSetAssocThreshold(
      nodeNumber,
      networkNumber,
      thresholdId,
      param1,
      param2,
      thresholdType,
      activationType,
      senActivationNum,
      sensorType,
      clusterId,
      accTimerIndex,
      status,
      weekday,
      {reserved = '00'}) {
    //todo need to understand
    String subCommand = "02";
    String messageLength = "31";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        reserved +
        thresholdId +
        param1 +
        param2 +
        thresholdType +
        activationType +
        senActivationNum +
        sensorType +
        clusterId +
        accTimerIndex +
        status +
        param1 +
        param2 +
        weekday;
    return command;
  }

  String sendSetThreshold(
      nodeNumber,
      networkNumber,
      thresholdId,
      param1,
      param2,
      thresholdType,
      activationType,
      senActivationNum,
      sensorType,
      clusterId,
      accTimerIndex,
      status,
      tparam1,
      tparam2,
      weekday,
      {reserved = '00'}) {
    //todo need to understand
    String subCommand = "01";
    String messageLength = "1F";
    String command = threshold +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        reserved +
        thresholdId +
        param1 +
        param2 +
        thresholdType +
        activationType +
        senActivationNum +
        sensorType +
        clusterId +
        accTimerIndex +
        status +
        tparam1 +
        tparam2 +
        weekday;
    return command;
  }
}
