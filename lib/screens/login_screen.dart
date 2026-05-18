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

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loginUser,
                child: const Text("Login"),
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
              child: const Text("Create New Account"),
            )

          ],
        ),
      ),
    );
  }
}