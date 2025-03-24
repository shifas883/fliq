import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'chat_list.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter your your OTP",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
              ),),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                final otp = otpController.text.trim();
                final success = await authProvider.verifyOTP(
                  widget.phoneNumber,
                  otp,
                );

                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatListScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid OTP')),
                  );
                }
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(child: Text('Verify',style: TextStyle(
                      color: Colors.white
                  ),))),
            ),
          ],
        ),
      ),
    );
  }
}
