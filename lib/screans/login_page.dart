import 'package:chat_app_mini_curso/controllers/login_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:chat_app_mini_curso/screans/sing_up_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();
  bool loadingLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Text(
                      'Bem-vindo!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 500,
                        maxWidth: 250,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://img.freepik.com/vetores-premium/duas-pessoas-a-falar-a-discutir-a-trocar-ideias-o-trabalho-em-equipa-e-os-programadores_1014921-826.jpg?semt=ais_hybrid&w=740&q=80',
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'E-mail',
                        labelText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Senha',
                        labelText: 'Senha',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 2,
                      ),
                      onPressed: loadingLogin
                          ? null
                          : () async {
                              if (controller.formKey.currentState!.validate()) {
                                setState(() {
                                  loadingLogin = true;
                                });
                                await controller.login();
                                if (context.mounted) {
                                  setState(() {
                                    loadingLogin = false;
                                  });
                                }
                              }
                            },
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: loadingLogin
                              ? CircularProgressIndicator(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                )
                              : Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Não tem conta? ',
                            //style: hintStyle,
                          ),
                          TextSpan(
                            text: 'Inscrever-se',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            //mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const SingUpPage(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
