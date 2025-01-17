import 'package:rpe_c/core/logger/logger.dart';

class MeshAssociation {
  final association = "93";
  final setAssociation = "01";
  final enableAssociation = "10";
  final enableAllAssociation = '50';
  final disableAssociation = "20";
  final disableAllAssociation = "A0";
  final deleteAssociation = "40";
  final deleteAllAssociation = "C0";
  final syncAssociation = '08';

  String sendEnableAssociation(nodeNumber, networkNumber, associationId) {
    String subCommand = "10";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendEnableAllAssociations(nodeNumber, networkNumber,
      {associationId = '00'}) {
    String subCommand = "50";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendDisableAssociation(nodeNumber, networkNumber, associationId) {
    String subCommand = "20";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendDisableAllAssociations(networkNumber, {associationId = '00'}) {
    String subCommand = "A0";
    String messageLength = "06";
    String nodeNumber = "00";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendDeleteAssociation(networkNumber, association) {
    String subCommand = "40";
    String messageLength = "06";
    String nodeNumber = '00';
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        association;
    return command;
  }

  String sendDeleteAllAssociations(networkNumber, {associationId = '00'}) {
    String subCommand = "C0";
    String messageLength = "06";
    String nodeNumber = "00";
    String command = associationId +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendSyncAssociations(nodeNumber, networkNumber,
      {associationId = '00'}) {
    //todo need to define
    String subCommand = "08";
    String messageLength = "06";
    String command = associationId +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendSetAssociation(
      nodeNumber,
      networkNumber,
      associationId,
      associationType,
      numberInitiators,
      numberListeners,
      status,
      actuatorList,
      sensorList,
      initiatorNodes,
      listenerNodes,
      {reserved1 = '00',
      reserved2 = '00'}) {
    String subCommand = "01";
    String messageLength = "06";
    var results = {};
    results['association'] = association;
    results['subCommand'] = subCommand;
    results['messageLength'] = messageLength;
    results['nodeNumber'] = nodeNumber;
    results['networkNumber'] = networkNumber;
    results['reserved1'] = reserved1;
    results['associationId'] = associationId;
    results['associationType'] = associationType;
    results['numberInitiators'] = numberInitiators;
    results['numberListeners'] = numberListeners;
    results['status'] = status;
    results['reserved2'] = reserved2;
    results['actuatorList'] = actuatorList;
    results['sensorList'] = sensorList;
    results['initiatorNodes'] = initiatorNodes;
    results['listenerNodes'] = listenerNodes;

    logger.i(results);
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        reserved1 +
        associationId +
        associationType +
        numberInitiators +
        numberListeners +
        status +
        reserved2 +
        actuatorList +
        sensorList +
        initiatorNodes +
        listenerNodes;
    return command;
  }
}

class MeshMultiAssociation {
  final association = "95";
  final setAssociation = "01";
  final enableAssociation = "10";
  final enableAllAssociation = '50';
  final disableAssociation = "20";
  final disableAllAssociation = "A0";
  final deleteAssociation = "40";
  final deleteAllAssociation = "C0";
  final syncAssociation = '08';

  String sendEnableAssociation(nodeNumber, networkNumber, associationId) {
    String subCommand = "10";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendEnableAllAssociations(nodeNumber, networkNumber,
      {associationId = '00'}) {
    String subCommand = "50";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendDisableAssociation(nodeNumber, networkNumber, associationId) {
    String subCommand = "20";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendDisableAllAssociations(nodeNumber, networkNumber,
      {associationId = '00'}) {
    String subCommand = "A0";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendDeleteAssociation(nodeNumber, networkNumber, association) {
    String subCommand = "40";
    String messageLength = "06";
    String command = association +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        association;
    return command;
  }

  String sendDeleteAllAssociations(nodeNumber, networkNumber,
      {associationId = '00'}) {
    String subCommand = "C0";
    String messageLength = "06";
    String command = associationId +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendSyncAssociations(nodeNumber, networkNumber,
      {associationId = '00'}) {
    //todo need to define
    String subCommand = "08";
    String messageLength = "06";
    String command = associationId +
        subCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        associationId;
    return command;
  }

  String sendSetAssociation(nodeNumber, networkNumber) {
    //todo need talk
    String subCommand = "01";
    String messageLength = "06";
    String command =
        "00" + subCommand + messageLength + nodeNumber + networkNumber + "00";
    return command;
  }
}
