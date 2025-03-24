import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _otp;
  String? _message;

  String? get otp => _otp;
  String? get message => _message;

  Future<bool> requestOTP(String phoneNumber) async {
    final url = Uri.parse(
        'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/send-otp');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "data": {
            "type": "registration_otp_codes",
            "attributes": {
              "phone": phoneNumber,
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          _otp = responseData['data'].toString();
          _message = responseData['message'];
          debugPrint('✅ OTP Sent: $_otp');
          notifyListeners();
          return true;
        } else {
          _message = 'Failed to send OTP';
          debugPrint('❌ Error: $_message');
          notifyListeners();
          return false;
        }
      } else {
        debugPrint('❌ Failed with status: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
      return false;
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    final url = Uri.parse(
        'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/verify-otp');

    final client = http.Client();

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'PostmanRuntime/7.29.2',
        },
        body: jsonEncode({
          "data": {
            "type": "registration_otp_codes",
            "attributes": {
              "phone": phoneNumber,
              "otp": int.tryParse(otp),
              "device_meta": {
                "type": "mobile",
                "name": "FlutterApp",
                "os": "Android",
                "browser": "Flutter WebView",
                "user_agent": "FlutterApp",
                "screen_resolution": "1080x1920",
                "language": "en-US"
              }
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          debugPrint('✅ OTP Verified: ${responseData['message']}');
          return true;
        } else {
          debugPrint('❌ Verification Failed: ${responseData['message']}');
          return false;
        }
      } else {
        debugPrint('❌ Failed with status: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
      return false;
    } finally {
      client.close();
    }
  }


}
