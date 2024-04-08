class MeshTimer {
  final timer = "92";
  final setTimer = "01";
  final enableTimer = "10";
  final enableAllTimer = "50";
  final disableTimer = "20";
  final disableAllTimer = "A0";
  final deleteTimer = "40";
  final deleteAllTimers = "C0";
  final syncTimers = "08";

  String sendEnableAllTimers(nodeNumber, networkNumber, {timerId = '00'}) {
    String messageLength = "06";
    String enableAllTimer = '50';
    String command = timer +
        enableAllTimer +
        messageLength +
        nodeNumber +
        networkNumber +
        timerId;

    return command;
  }

  String sendDisableTimer(nodeNumber, networkNumber, {timerId = '00'}) {
    String messageLength = "06";
    String enableAllTimer = '20';
    String command = timer +
        enableAllTimer +
        messageLength +
        nodeNumber +
        networkNumber +
        timerId;
    return command;
  }

  String sendDeleteAllTimers(nodeNumber, networkNumber, {timerId = '00'}) {
    String messageLength = "06";
    String deleteAllTimers = "C0";
    String command = timer +
        deleteAllTimers +
        messageLength +
        nodeNumber +
        networkNumber +
        timerId;
    return command;
  }

  String sendSyncTimers(nodeNumber, networkNumber, {timerId = '00'}) {
    String messageLength = "06";
    String syncTimers = "08";
    String command = timer +
        syncTimers +
        messageLength +
        nodeNumber +
        networkNumber +
        timerId;
    return command;
  }

  String sendEnableTimer(nodeNumber, networkNumber, {timerId = '00'}) {
    String messageLength = "06";
    String enableTimer = "10";
    String command = timer +
        enableTimer +
        messageLength +
        nodeNumber +
        networkNumber +
        timerId;
    return command;
  }

  String sendDeleteTimer(
    nodeNumber,
    networkNumber,
    timerId,
  ) {
    String messageLength = "06";
    String deleteTimer = "40";
    String command = timer +
        deleteTimer +
        messageLength +
        nodeNumber +
        networkNumber +
        timerId;
    return command;
  }

  //TODO need to understand set Timer
  String sendSetTimer(
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
      {reserved = "FF"}) {
    String messageLength = "16";
    String setTimer = '01';

    String command = timer +
        setTimer +
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
}
