import 'package:ai_test/screens/login_screen.dart';
import 'package:ai_test/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Image.asset(
              'assets/1.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.5),
                  Colors.transparent
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              ),
            ),
            Positioned(
              bottom: 260,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(
                      'Creat',
                      style: TextStyle(
                        color: Colors.purple[700]!.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                    ),
                    Text(
                      'anything you',
                      style: TextStyle(
                        color: Colors.purple[700]!.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                    ),
                    Text(
                      'want with AI',
                      style: TextStyle(
                        color: Colors.purple[700]!.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:  Text(
                          'Creat an account',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purple[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.purple[200]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
