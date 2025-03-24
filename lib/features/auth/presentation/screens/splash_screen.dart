import 'package:flutter/material.dart';
import 'package:lilac/features/auth/presentation/screens/phone_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/image.png'), // Local image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text
                const Text(
                  "Connect. Meet. Love. With Fliq Dating",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneScreen()));
                  },
                  icon: const Icon(Icons.phone,color: Colors.white,),
                  label: const Text('Sign in with Phone'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
