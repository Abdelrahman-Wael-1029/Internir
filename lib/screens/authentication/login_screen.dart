import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internir/screens/layout/home_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/jobs_provider.dart';
import 'create_account.dart';
import 'package:internir/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged in successfully!")),
      );

      var jobProvider = context.read<JobsProvider>();
      await jobProvider.fetchJobs();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeLayout()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to log in: ${e.toString()}")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome ",
                    style: TextStyle(
                      fontFamily: 'Greta Arabic',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Hunters",
                    style: TextStyle(
                      fontFamily: 'Greta Arabic',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Log in with your account",
              style: TextStyle(
                fontFamily: 'Greta Arabic',
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.indigo,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Greta Arabic',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, CreateAccountScreen.routeName);
                },
                child: const Text(
                  "Create new account",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
