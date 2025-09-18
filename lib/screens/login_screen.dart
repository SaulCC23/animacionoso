import 'dart:async';
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
SMITrigger? trigSuccess; // Se emociona (alegre)
SMITrigger? trigFail; // Se enoja/triste
SMINumber? numLook; // Movimiento de cabeza/ojos

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;

  // Controladores de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // FocusNodes para detectar cuando los campos están activos
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  // Timer para regresar la vista al frente cuando se deja de escribir
  Timer? _lookTimer;

  @override
  void initState() {
    super.initState();
    
    // Listeners para detectar cambios de foco
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        // Cuando el email recibe foco, activar checking y mirar según el texto
        isHandsUp?.change(false);
        isChecking?.change(true);
        if (numLook != null) {
          numLook!.value = _emailController.text.length.toDouble();
        }
      } else {
        // Cuando pierde el foco, cancelar timer y mirar al frente
        _lookTimer?.cancel();
        if (_emailController.text.isEmpty) {
          isChecking?.change(false);
          if (numLook != null) {
            numLook!.value = 0;
          }
        } else {
          // Si hay texto, mantener checking pero mirar al frente
          if (numLook != null) {
            numLook!.value = 0;
          }
        }
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        // Cuando el password recibe foco, taparse los ojos
        isHandsUp?.change(true);
        isChecking?.change(false);
      } else {
        // Cuando pierde el foco, destaparse pero solo si no hay texto
        if (_passwordController.text.isEmpty) {
          isHandsUp?.change(false);
        }
      }
    });
  }

  @override
  void dispose() {
    _lookTimer?.cancel();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
                focusNode: _emailFocusNode,
                onTap: () {
                  // Al hacer tap en el campo, activar animación inmediatamente
                  isHandsUp?.change(false);
                  isChecking?.change(true);
                  if (numLook != null) {
                    numLook!.value = _emailController.text.length.toDouble();
                  }
                },
                onChanged: (value) {
                  // Siempre actualizar la posición de la mirada cuando se escribe
                  isHandsUp?.change(false);
                  isChecking?.change(true);
                  
                  // Mover los ojos dependiendo del largo del texto
                  if (numLook != null) {
                    numLook!.value = value.length.toDouble();
                  }
                  
                  // timer 
                  _lookTimer?.cancel();
                  if (_emailFocusNode.hasFocus) {
                    _lookTimer = Timer(const Duration(seconds: 2), () {
                      // Desactivar el seguimiento 
                    
                      if (isChecking != null && _emailFocusNode.hasFocus) {
                        isChecking!.change(false); 
                        
                      }
                    });
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
                focusNode: _passwordFocusNode,
                onTap: () {
                  // Al hacer tap en el campo de password, taparse los ojos inmediatamente
                  isHandsUp?.change(true);
                  isChecking?.change(false);
                },
                onChanged: (value) {
                  // Mantener las manos arriba mientras se escribe en password
                  if (_passwordFocusNode.hasFocus) {
                    isHandsUp?.change(true);
                    isChecking?.change(false);
                  }
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

              // BOTÓN DE LOGIN
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

  // Login con animaciones
  void _login() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    // Reset de manos y ojos al validar
    isHandsUp?.change(false);
    isChecking?.change(false);

    if (email == "saulcetina@gmail.com" && pass == "1234") {
      trigSuccess?.fire();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login exitoso")),
      );
    } else {
      trigFail?.fire(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales incorrectas")),
      );
    }
  }
}