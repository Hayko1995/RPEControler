class MeshReset {
  final reset = "F0";
  final resetAllNodes = "BB";
  final resetUserMode = "00";
  final resetFactoryMode = "01";
  final resetUniversalMode = "02";

  String sendResetAllNode(nodeNumber, networkNumber, timeDelay,
      {delayValue = '00'}) {
    String messageLength = "07";
    String subcommand = 'BB';
    String command = reset +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        timeDelay +
        delayValue;

    return command;
  }

  String sendResetUserMode(nodeNumber, networkNumber, timeDelay,
      {delayValue = '00'}) {
    String messageLength = "07";
    String subcommand = '00';
    String command = reset +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        timeDelay +
        delayValue;

    return command;
  }

  String sendResetFactoryMode(nodeNumber, networkNumber, timeDelay,
      {delayValue = '00'}) {
    String messageLength = "07";
    String subcommand = '01';
    String command = reset +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        timeDelay +
        delayValue;

    return command;
  }

  String sendResetUniversalMode(nodeNumber, networkNumber, timeDelay,
      {delayValue = '00'}) {
    String messageLength = "07";
    String subcommand = '02';
    String command = reset +
        subcommand +
        messageLength +
        nodeNumber +
        networkNumber +
        timeDelay +
        delayValue;

    return command;
  }

  String sendResetWifi(nodeNumber, networkNumber, timeDelay,
      {delayValue = '00'}) {
    //todo Need to disuse
    String command = "";
    return command;
  }

  String sendEraseFlash(nodeNumber, networkNumber, timeDelay,
      {delayValue = '00'}) {
    //todo Need to disuse
    String command = "";
    return command;
  }
}
