import 'package:flutter/material.dart';
import 'package:lilac/features/auth/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/repositories/chat_repository.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/providers/chat_provider.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            repository: ChatRepository(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Fliq App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
