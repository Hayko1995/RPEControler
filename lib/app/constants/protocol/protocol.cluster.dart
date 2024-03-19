class MeshCluster {
  final cluster = "91";
  final setCluster = "00";
  final setThreshold = "90";
  final enableCluster = "10";
  final enableAllCluster = "50";
  final disableCluster = "20";
  final disableAllCluster = "A0";
  final deleteCluster = "40";
  final deleteAllCluster = "C0";
  final syncClusters = "08";

  String sendEnableAllClusters(nodeNumber, networkNumber, {clusterId = '00'}) {
    String messageLength = "06";
    String subcommand = '50';
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;

    return command;
  }

  String sendDisableAllCluster(nodeNumber, networkNumber, {clusterId = '00'}) {
    String messageLength = "06";
    String subcommand = 'A0';
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendDeleteAllCluster(nodeNumber, networkNumber, {clusterId = '00'}) {
    String messageLength = "06";
    String deleteAllTimers = "C0";
    String command = cluster +
        deleteAllTimers +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendSyncClusters(nodeNumber, networkNumber, {clusterId = '00'}) {
    String messageLength = "06";
    String subcommand = "08";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendEnableCluster(nodeNumber, networkNumber, clusterId) {
    String messageLength = "06";
    String enableTimer = "10";
    String command = cluster +
        enableTimer +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendDisableCluster(nodeNumber, networkNumber, clusterId) {
    String messageLength = "20";
    String subcommand = "10";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendDeleteCluster(
    nodeNumber,
    networkNumber,
    clusterId,
  ) {
    String messageLength = "06";
    String subcommand = "40";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendClusterOn(
    nodeNumber,
    networkNumber,
    clusterId,
  ) {
    String messageLength = "06";
    String subcommand = "0A";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendClusterOff(
    nodeNumber,
    networkNumber,
    clusterId,
  ) {
    String messageLength = "06";
    String subcommand = "0C";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendSetSingleNetCluster(
      //TODO need to understand set Cluster
      nodeNumber,
      networkNumber,
      timerId,
      param1,
      param2,
      timerType,
      actionType,
      sensorActionNumber,
      weekDay,
      clusterId,
      assocThreshold,
      status,
      {reserved = "00"}) {
    String subcommand = "01";
    String messageLength = "16";
    String singleNet = '01';

    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        reserved +
        timerId +
        param1 +
        param2 +
        timerType +
        actionType +
        sensorActionNumber +
        weekDay +
        clusterId +
        assocThreshold +
        status;
    return command;
  }

  String sendSetMultinetCluster(
      //TODO need to understand set Cluster
      nodeNumber,
      networkNumber,
      timerId,
      param1,
      param2,
      timerType,
      actionType,
      sensorActionNumber,
      weekDay,
      clusterId,
      assocThreshold,
      status,
      {reserved = "00"}) {
    String subcommand = "01";
    String messageLength = "16";
    String singleNet = '01';

    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        reserved +
        timerId +
        param1 +
        param2 +
        timerType +
        actionType +
        sensorActionNumber +
        weekDay +
        clusterId +
        assocThreshold +
        status;
    return command;
  }

  String sendSetThresholdCluster(
      nodeNumber,
      networkNumber,
      thresholdSubCommand,
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
      param3,
      param4,
      weekday) {
    //todo need to understand
    String subCommand = "01";
    String messageLength = "31";
    String command = cluster +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        thresholdSubCommand +
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
        param3 +
        param4 +
        weekday;
    return command;
  }

  String sendTimerCommandCuster(
    nodeNumber,
    networkNumber,
    timerSubCommand,
    timerId,
    param1,
    param2,
    timerType,
    activationType,
    senActivationNum,
    weekday,
    clusterId,
    accThreshold,
    status,
  ) {
    //todo need to understand
    String subCommand = "92";
    String messageLength = "22";
    String command = cluster +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        timerSubCommand +
        timerId +
        param1 +
        param2 +
        timerType +
        activationType +
        senActivationNum +
        weekday +
        clusterId +
        accThreshold +
        status;
    return command;
  }
}
