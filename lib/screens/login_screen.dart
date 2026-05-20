// import 'package:flutter/material.dart';
//
// class LoginScreen extends StatefulWidget {
//   LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController =
//   TextEditingController();
//
//   final TextEditingController passwordController =
//   TextEditingController();
//
//   final TextEditingController usernameController =
//   TextEditingController();
//
//   bool isPasswordHidden = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//
//           children: [
//
//             const Icon(
//               Icons.school,
//               size: 80,
//             ),
//
//             const SizedBox(height: 20),
//
//             const Text(
//               'Welcome Back',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             TextField(
//               controller: emailController,
//
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             TextField(
//               controller: usernameController,
//
//               decoration: const InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.account_circle),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             TextField(
//               controller: passwordController,
//               obscureText: isPasswordHidden,
//
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: const OutlineInputBorder(),
//                 prefixIcon: const Icon(Icons.lock),
//
//                 suffixIcon: IconButton(
//                   onPressed: () {
//
//                     setState(() {
//                       isPasswordHidden = !isPasswordHidden;
//                     });
//
//                   },
//
//                   icon: Icon(
//                     isPasswordHidden
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             SizedBox(
//               width: double.infinity,
//
//               child: ElevatedButton(
//                 onPressed: () {
//
//                   print(emailController.text);
//                   print(passwordController.text);
//
//                 },
//                 style:ButtonStyle(
//                   backgroundColor: WidgetStatePropertyAll(Colors.cyan)
//                 ),
//
//                 child: const Text('Login',
//                   style: TextStyle(
//                     fontWeight:FontWeight.bold
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// version 2 - updated 05 18

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;

  Future<void> loginUser() async {

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login Failed"),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(24),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                // Logo
                Container(

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.school,
                    size: 60,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "StudyFlow",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // Email
                TextField(
                  controller: emailController,

                  decoration: InputDecoration(

                    hintText: "Enter your email",

                    prefixIcon: const Icon(Icons.email),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                TextField(

                  controller: passwordController,
                  obscureText: true,

                  decoration: InputDecoration(

                    hintText: "Enter your password",

                    prefixIcon: const Icon(Icons.lock),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(

                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(

                    onPressed: loginUser,

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.blue,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );

                  },

                  child: const Text(
                    "Create New Account",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}