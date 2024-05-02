import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:rpe_c/app/constants/app.constants.dart';

Future sendMail() async {
  String username = AppConstants.adminMail;
  String password = AppConstants.adminPass;

  // final smtpServer = gmail(username, password);

  final smtpServer = SmtpServer('mail.rpecontrols.com',
      port: 465,
      ignoreBadCertificate: true,
      ssl: true,
      username: username,
      password: password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Your name')
    ..recipients.add('harry.balian@rpecontrols.com')
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Huston we have a problem</h1>\n<p>Huston we have a problem</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
