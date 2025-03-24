
import '../../../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<void> sendOtp(String phone) async {
    final request = {
      "data": {
        "type": "registration_otp_codes",
        "attributes": {"phone": phone}
      }
    };
    await apiClient.post('/auth/registration-otp-codes/actions/phone/send-otp', data: request);
  }

  Future<void> verifyOtp(String phone, String otp) async {
    final request = {
      "data": {
        "type": "registration_otp_codes",
        "attributes": {
          "phone": phone,
          "otp": otp,
          "device_meta": {
            "type": "mobile",
            "name": "FlutterApp",
            "os": "Android",
            "browser": "Chrome"
          }
        }
      }
    };
    await apiClient.post('/auth/registration-otp-codes/actions/phone/verify-otp', data: request);
  }
}
