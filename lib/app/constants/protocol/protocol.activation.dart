class MeshDeviceActivation {
  final activation = "94";

  final on = "01";
  final off = "02";
  final allOn = "05";
  final allOff = "0A";
  final up = "10";
  final down = "20";
  final allUp = "50";
  final allDown = "A0";
  final enableActuation = "04";
  final disableActuation = "08";
  final enableAllActuation = "14";
  final disableAllActuation = "18";
  final setDimmer = "03";
  final setAllDimmer = "06";

  String sendOn(nodeNumber, networkNumber) {
    String onCommand = "01";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendOff(nodeNumber, networkNumber) {
    String onCommand = "02";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendAllOn(nodeNumber, networkNumber) {
    String onCommand = "05";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendAllOff(nodeNumber, networkNumber) {
    String onCommand = "0A";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendAllUp(nodeNumber, networkNumber) {
    String onCommand = "50";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendAllDown(nodeNumber, networkNumber) {
    String onCommand = "A0";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendEnableActuation(nodeNumber, networkNumber) {
    String onCommand = "04";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendDisableActuation(nodeNumber, networkNumber) {
    String onCommand = "08";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendEnableAllActuation(nodeNumber, networkNumber) {
    String onCommand = "14";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendDisableAllActuation(nodeNumber, networkNumber) {
    String onCommand = "18";
    String messageLength = "05";
    String command =
        activation + onCommand + messageLength + nodeNumber + networkNumber;
    return command;
  }

  String sendDimmer(nodeNumber, networkNumber, dimmerLevel) {
    String onCommand = "03";
    String messageLength = "06";
    String command = activation +
        onCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        dimmerLevel;
    return command;
  }

  String sendAllDimmer(nodeNumber, networkNumber, dimmerLevel) {
    String onCommand = "06";
    String messageLength = "06";
    String command = activation +
        onCommand +
        messageLength +
        nodeNumber +
        networkNumber +
        dimmerLevel;
    return command;
  }
}
