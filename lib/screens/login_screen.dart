import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Controladores de Rive 
StateMachineController? controller;
SMIBool? isChecking; // Activa el oso chismoso
SMIBool? isHandsUp; // Se tapa los ojos
SMITrigger? trigSuccess; // Se emocionó
SMITrigger? trigFail; // Se puso SAD
SMINumber? numLook; // Movimiento de cabeza/ojos

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;

  // Controladores de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller != null) {
                      artboard.addController(controller!);

                      // Enlazar inputs con la app
                      isChecking = controller!.findSMI<SMIBool>('isChecking');
                      isHandsUp = controller!.findSMI<SMIBool>('isHandsUp');
                      trigSuccess = controller!.findSMI<SMITrigger>('trigSuccess');
                      trigFail = controller!.findSMI<SMITrigger>('trigFail');
                      numLook = controller!.findSMI<SMINumber>('numLook'); 
                    
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                onChanged: (value) {
                  // Cuando se escribe en email
                  isHandsUp?.change(false);
                  isChecking?.change(true);

                  //  mover los ojos dependiendo del largo del texto
                  if (numLook != null) {
                    numLook!.value = value.length.toDouble();
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                onChanged: (value) {
                  // Cuando se escribe en password
                  isHandsUp?.change(true);
                },
                obscureText: _isHidden,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  "¿Gaxiola el mejor profe?",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //  BOTÓN DE LOGIN
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Iniciar Sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  //  Login con animaciones
  void _login() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email == "test@gmail.com" && pass == "1234") {
      trigSuccess?.fire(); //  animación de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login exitoso 🎉")),
      );
    } else {
      trigFail?.fire(); //  animación de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email o contraseña incorrectos ❌")),
      );
    }
  }
}
