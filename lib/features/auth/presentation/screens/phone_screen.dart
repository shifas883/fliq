import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your phone\nnumber",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+919090909090',
                border: OutlineInputBorder(),
              ),
            ),
            Text(
              "Fliq will send you an OTP",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            Spacer(),
            GestureDetector(
              onTap:
                  _isLoading
                      ? null
                      : () async {
                        setState(() => _isLoading = true);

                        bool success = await authProvider.requestOTP(
                          "+91${_phoneController.text}",
                        );

                        setState(() => _isLoading = false);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ OTP Sent: ${authProvider.otp}\nMessage: ${authProvider.message}',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OTPVerificationScreen(
                                    phoneNumber: "+91${_phoneController.text}",
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '❌ Failed: ${authProvider.message ?? 'Unknown Error'}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Request OTP',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
