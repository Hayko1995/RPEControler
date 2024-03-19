import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:test/test.dart';

void main() {
  test('sendEnableAllTimers', () {
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendEnableAllTimers("01", "01");
    expect(command, "925006010100");
  });

  test('sendDisableTimer', () {
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendDisableTimer("01", "01");
    expect(command, "922006010100");
  });

  test('sendDeleteAllTimers', () {
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendDeleteAllTimers("01", "01");
    expect(command, "92C006010100");
  });
  test('sendSyncTimers', () {
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendSyncTimers("01", "01");
    expect(command, "920806010100");
  });

  test('sendEnableTimer', () {
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendEnableTimer("01", "01");
    expect(command, "921006010100");
  });
  test('sendDeleteTimer', () {
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendDeleteTimer("01", "01", "01");
    expect(command, "924006010101");
  });

  test('sendSetTimer', () {
    //TODO need to test
    MeshTimer meshTimer = MeshTimer();
    String command = meshTimer.sendSetTimer(
        "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", "01");
    expect(command, "92011601010001010101010101010101");
  });
}
