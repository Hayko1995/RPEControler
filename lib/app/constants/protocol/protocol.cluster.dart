import 'package:rpe_c/core/logger/logger.dart';

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
  final nodeNumber = '00';

  String sendEnableAllClusters(networkNumber, {clusterId = '00'}) {
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

  String sendDisableAllCluster(networkNumber, {clusterId = '00'}) {
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

  String sendDeleteAllCluster(networkNumber, {clusterId = '00'}) {
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

  String sendSyncClusters(networkNumber, {clusterId = '00'}) {
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

  String sendEnableCluster(networkNumber, clusterId) {
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

  String sendDisableCluster(networkNumber, clusterId) {
    String messageLength = "06";
    String subcommand = "20";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendDeleteCluster(
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
    networkNumber,
    clusterId,
  ) {
    String messageLength = "06";
    String subcommand = "01";
    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        clusterId;
    return command;
  }

  String sendClusterOff(
    networkNumber,
    clusterId,
  ) {
    String messageLength = "06";
    String subcommand = "02";
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
      networkNumber,
      clusterId,
      clusterType,
      status,
      multiClusterId,
      clusterNodes) {
    String subcommand = "00";
    // String messageLength = "16";
    String singleNet = '01';

    //TODO  cluster id FIX
    //TODO node Number error  Error

    int length = (clusterNodes.length / 2).round();
    // logger.
    String numberOfNodes =
        ((clusterNodes.length / 6).round()).toRadixString(16);
    if (numberOfNodes.length < 2) {
      numberOfNodes = "0$numberOfNodes";
    }
    int len = 11 + length;
    String messageLength = len.toRadixString(16).toUpperCase();
    if (messageLength.length < 2) {
      messageLength = "0$messageLength";
    }

    String command = cluster +
        subcommand +
        messageLength + //TODO need to fix
        nodeNumber +
        networkNumber +
        singleNet +
        clusterId +
        clusterType +
        status +
        multiClusterId +
        numberOfNodes +
        clusterNodes;
    return command;
  }

  String sendSetMultinetCluster(
      //TODO need to understand set Cluster
      networkNumber,
      clusterId,
      clusterType,
      status,
      multiClusterId,
      numberOfNodes,
      clusterNodes) {
    String subcommand = "01";
    String messageLength = "16";
    String singleNet = '02';

    String command = cluster +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        singleNet +
        clusterType +
        clusterId +
        clusterType +
        status +
        multiClusterId +
        numberOfNodes +
        clusterNodes;
    return command;
  }

  String sendSetThresholdCluster(
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
