import 'package:emeraldbank_mobileapp/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  // Backend
  bool _isSigning = false;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // User Interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
              'lib/assets/pictures/emerald_logo_white.png',
              width: 100,
              height: 100,
              color: Color(0xFF06D6A0),
              colorBlendMode: BlendMode.srcIn,
              ),
              SizedBox(
                height: 4,
              ),
              Text("EmeraldBank", 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF044E42)
                ),
              ),
              SizedBox(
                height: 80
              ),
              Row(
                children: [
                  Text("Username/Email",
                  style: TextStyle(
                    color: Color(0xFF1A1819),
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),),
                  ],
              ),
              FormContainerWidget(
                controller: _emailController,
                // hintText: "Username/Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Password",
                  style: TextStyle(
                    color: Color(0xFF1A1819),
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),),
                  ],
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "",
                isPasswordField: true,
              ),
              SizedBox(
                height: 2,
              ),
              GestureDetector(
                onTap: () {
                  print("This is the forgot password");
                },
                child: Row(
                  children: [
                    Text("Forgot password?",
                    style: TextStyle(
                    color: Color(0xFF044E42),
                    fontSize: 14,
                    fontWeight: FontWeight.w800
                  ),),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _sigIn,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF06D6A0),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: _isSigning ? CircularProgressIndicator(color: Colors.white) : Text(
                      "Login", 
                      style: 
                      TextStyle(
                        color: Colors.white,
                        fontSize: 16, 
                        fontWeight: FontWeight.bold),
                        )
                      ),
                ),
              ),
              SizedBox(height: 24),
              Text("Version 1.4.3",
                    style: TextStyle(
                    color: Color(0xFF1A1819).withAlpha(128),
                    fontSize: 10,
                    fontWeight: FontWeight.w600
              ),),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an Online Banking?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  ),),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text("Sign Up", style: TextStyle(color: Color(0xFF028A6E), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sigIn() async {
    // String username = _usernameController.text;

    setState((){
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState((){ 
      _isSigning = false;
    });

    if (user != null){
      print("User is successfully Signed in");
      Navigator.pushNamed(context, "/main");
    }
    else{
      print("Some error happened");
    }

  }

}