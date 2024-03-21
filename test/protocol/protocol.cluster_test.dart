import 'package:rpe_c/app/constants/protocol/protocol.cluster.dart';
import 'package:test/test.dart';

void main() {
  MeshCluster meshTimer = MeshCluster();

  test('sendEnableAllClusters', () {
    String command = meshTimer.sendEnableAllClusters("01");
    expect(command, "915006010100");
  });

  test('sendDisableCluster', () {
    String command = meshTimer.sendDisableCluster("01", "01");
    expect(command, "911020010100");
  });

  test('sendDeleteAllCluster', () {
    String command = meshTimer.sendDeleteAllCluster("01");
    expect(command, "91C006010100");
  });
  test('sendSyncClusters', () {
    String command = meshTimer.sendSyncClusters("01");
    expect(command, "910806010100");
  });

  test('sendEnableCluster', () {
    String command = meshTimer.sendEnableCluster("01", "01");
    expect(command, "911006010100");
  });

  test('sendClusterOff', () {
    String command = meshTimer.sendClusterOff("01", "01");
    expect(command, "910C06010100");
  });

  test('sendClusterOn', () {
    String command = meshTimer.sendClusterOn("01", "01", );
    expect(command, "910A06010100");
  });

  test('sendDeleteCluster', () {
    String command = meshTimer.sendDeleteCluster("01", "01" );
    expect(command, "914006010101");
  });

  test('sendDisableAllCluster', () {
    String command = meshTimer.sendDisableAllCluster("01");
    expect(command, "91A006010100");
  });

  test('sendSetThresholdCluster', () {
    String command = meshTimer.sendSetThresholdCluster("01", "01", "01", "01",
        "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01");
    expect(command, "91013101010101010101010101010101010101");
  });

  test('sendSetSingleNetCluster', () {
    String singleNetActivationCommand = "9100";
    String messageLengthFor2device = "0E";
    String nodeNumber = "00";

    String singleNet = "01";
    //TODO need to test
    String networkNumber = "00";
    String clusterId = '00';
    String clusterType = '00';
    String status = '00';
    String multiClusterId = "0000";
    String numberOfNodes = '02';
    String clusterNodes = "0102";

    String command = meshTimer.sendSetSingleNetCluster(networkNumber, clusterId,
        clusterType, status, multiClusterId, clusterNodes);
    expect(command.substring(0, 4), singleNetActivationCommand);
    expect(command.substring(4, 6), messageLengthFor2device);
    expect(command.substring(6, 8), nodeNumber);
    expect(command.substring(8, 10), networkNumber);
    expect(command.substring(10, 12), singleNet);
    expect(command.substring(12, 14), clusterId);
    expect(command.substring(14, 16), clusterType);
    expect(command.substring(16, 18), status);
    expect(command.substring(18, 22), multiClusterId);
    expect(command.substring(22, 24), numberOfNodes);
    expect(command.substring(24, 28), clusterNodes);
  });

  test('sendTimerCommandCuster', () {
    //TODO need to test

    String command = meshTimer.sendTimerCommandCuster("01", "01", "01", "01",
        "01", "01", "01", "01", "01", "01", "01", "01" "01");
    expect(command, "9192220101010101010101010101010101");
  });

  test('sendSetMultinetCluster', () {
    //TODO need to test

    String command = meshTimer.sendSetMultinetCluster(
        "01", "01", "01", "01", "01", "01", "01");
    expect(command, "91011601010201010101010101");
  });
}
