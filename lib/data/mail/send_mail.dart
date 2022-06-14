import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<int> sendMail({
  required String fromEmail,
  required String fromName,
  required String name,
  required String email,
  required String subject,
  required String message,
}) async {
  const serviceId = 'service_n8p850f';
  const templateId = 'template_a9uh6ub';
  const userId = '8LIoWshFlhPCfuNtZ';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  try {
    final response = await http.post(
      url,
      headers: {
        'origin': 'https://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'from_name': fromName,
            'from_email': fromEmail,
            'user_name': name,
            'user_email': email,
            'to_email': email,
            'user_subject': subject,
            'user_message': message,
          },
        },
      ),
    );
    return response.statusCode;
  } on HttpException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
    rethrow;
  }

  return 404;
}
