import 'package:rpe_c/app/constants/protocol/protocol.cluster.dart';
import 'package:test/test.dart';

void main() {
  MeshCluster meshTimer = MeshCluster();

  test('sendEnableAllClusters', () {
    String command = meshTimer.sendEnableAllClusters("01", "01");
    expect(command, "915006010100");
  });

  test('sendDisableCluster', () {
    String command = meshTimer.sendDisableCluster("01", "01", "00");
    expect(command, "911020010100");
  });

  test('sendDeleteAllCluster', () {
    String command = meshTimer.sendDeleteAllCluster("01", "01");
    expect(command, "91C006010100");
  });
  test('sendSyncClusters', () {
    String command = meshTimer.sendSyncClusters("01", "01");
    expect(command, "910806010100");
  });

  test('sendEnableCluster', () {
    String command = meshTimer.sendEnableCluster("01", "01", "00");
    expect(command, "911006010100");
  });

  test('sendClusterOff', () {
    String command = meshTimer.sendClusterOff("01", "01", "00");
    expect(command, "910C06010100");
  });

  test('sendClusterOn', () {
    String command = meshTimer.sendClusterOn("01", "01", "00");
    expect(command, "910A06010100");
  });

  test('sendDeleteCluster', () {
    String command = meshTimer.sendDeleteCluster("01", "01", "01");
    expect(command, "914006010101");
  });

  test('sendDisableAllCluster', () {
    String command = meshTimer.sendDisableAllCluster("01", "01");
    expect(command, "91A006010100");
  });

  test('sendSetThresholdCluster', () {
    String command = meshTimer.sendSetThresholdCluster("01", "01", "01", "01",
        "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01");
    expect(command, "91013101010101010101010101010101010101");
  });

  test('sendSetTimer', () {
    //TODO need to test

    String command = meshTimer.sendSetSingleNetCluster(
        "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01");
    expect(command, "91011601010001010101010101010101");
  });

  test('sendTimerCommandCuster', () {
    //TODO need to test

    String command = meshTimer.sendTimerCommandCuster("01", "01", "01", "01",
        "01", "01", "01", "01", "01", "01", "01", "01" "01", "01");
    expect(command, "9192220101010101010101010101010101");
  });

  test('sendSetTimer', () {
    //TODO need to test

    String command = meshTimer.sendSetMultinetCluster(
        "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01");
    expect(command, "91011601010001010101010101010101");
  });
}
