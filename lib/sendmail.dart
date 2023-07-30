import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'home.dart';

class SendMail extends StatefulWidget {
  final String mailtosend;
  const SendMail({Key? key, required this.mailtosend}) : super(key: key);

  @override
  State<SendMail> createState() => _SendMailState();
}

String generateRandomString(int lengthOfString) {
  final random = Random();
  const allChars =
      'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL1234567890';
  final randomString = List.generate(
          lengthOfString, (index) => allChars[random.nextInt(allChars.length)])
      .join();
  return randomString;
}

class _SendMailState extends State<SendMail> {
  String code = '123456';
  final _code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _code,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Code',
                labelText: 'Code',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (code == _code.text) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomTabBar()));
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Your code is not correct'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok')),
                            ],
                          ));
                }
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Success'),
                          content: Text('You code has sent successfully.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ok')),
                          ],
                        ));

                // final smtpServer = SmtpServer('smtp.gmail.com',
                //     username: 'asfaqali495@gmail.com', password: '30679897');
                //
                // final message = Message()
                //   ..from = Address('asfaqali495@gmail.com')
                //   ..recipients.add('asfaqhmd@example.com')
                //   ..subject = 'Hello from Flutter'
                //   ..text = 'This is the body of the email';
                //
                // try {
                //   final sendReport = await send(message, smtpServer);
                //   print('Message sent: ${sendReport.messageSendingEnd}');
                //   showDialog(
                //       context: context,
                //       builder: (_) => AlertDialog(
                //             title: Text('Success'),
                //             content:
                //                 Text('Your code has been successfully sent'),
                //             actions: [
                //               TextButton(
                //                   onPressed: () {
                //                     Navigator.pop(context);
                //                   },
                //                   child: Text('Ok')),
                //             ],
                //           ));
                // } catch (e) {
                //   showDialog(
                //       context: context,
                //       builder: (_) => AlertDialog(
                //             title: Text('Error'),
                //             content:
                //                 Text('Error occurred while sending email: $e'),
                //             actions: [
                //               TextButton(
                //                   onPressed: () {
                //                     Navigator.pop(context);
                //                   },
                //                   child: Text('Ok')),
                //             ],
                //           ));
                //   print('Error occurred while sending email: $e');
                // }
              },
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
