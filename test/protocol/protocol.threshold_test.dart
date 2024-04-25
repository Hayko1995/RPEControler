import 'package:rpe_c/app/constants/protocol/protocol.threshold.dart';
import 'package:test/test.dart';

void main() {
  MeshThreshold meshThreshold = MeshThreshold();

  test('sendEnableAllThresholds', () {
    String command = meshThreshold.sendEnableAllThresholds("01", "01");
    expect(command, "905006010100");
  });

  test('sendDisableThreshold', () {
    String command = meshThreshold.sendDisableThreshold("01", "01");
    expect(command, "902006010100");
  });
  test('sendDisableAllThresholds', () {
    String command = meshThreshold.sendDisableAllThresholds("01", "01");
    expect(command, "90A006010100");
  });

  test('sendDeleteAllThresholds', () {
    String command = meshThreshold.sendDeleteAllThresholds("01", "01");
    expect(command, "90C006010100");
  });
  test('sendSyncThresholds', () {
    String command = meshThreshold.sendSyncThresholds("01", "01");
    expect(command, "900806010100");
  });

  test('sendEnableThreshold', () {
    String command = meshThreshold.sendEnableThreshold("01", "01");
    expect(command, "901006010100");
  });
  test('sendDeleteThreshold', () {
    String command =
        meshThreshold.sendDeleteThreshold("01", "01", '03');
    expect(command, "904006010103");
  });

  test('sendSetThreshold', () {
    //TODO need to test

    String command = meshThreshold.sendSetThreshold("01", "01", "01", "01",
        "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01");
    expect(command, "90013101010001010101010101010101010100");
  });
  test('sendSetAssocThreshold', () {
    //TODO need to test

    String command = meshThreshold.sendSetAssocThreshold("01", "01", "01", "01",
        "01", "01", "01", "01", "01", "01", "01", "01", "00");
    expect(command, "90023101010001010101010101010101010100");
  });
}
