import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger/app/core/ui/helpers/loader.dart';
import 'package:vakinha_burger/app/core/ui/helpers/messages.dart';
import 'package:vakinha_burger/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/pages/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/base_state/base_state.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController>
    with Loader, Messages {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool passwordVisibility = false;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<LoginController, LoginState>(
        listener: (context, state) {
          state.status.matchAny(
            any: () => hideLoader(),
            login: () => showLoader(),
            loginError: () {
              hideLoader();
              showError('Login ou senha inválidos');
            },
            error: () {
              hideLoader();
              showError('Erro ao realizar login');
            },
            success: () {
              hideLoader();
              Navigator.pop(context, true);
            },
          );
        },
        child: Scaffold(
          appBar: DeliveryAppbar(),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login', style: context.textStyles.textTitle),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: emailEC,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                          ),
                          validator: Validatorless.multiple([
                            Validatorless.required('E-mail obrigatório'),
                            Validatorless.email('E-mail inválido'),
                          ]),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          obscureText: !passwordVisibility,
                          controller: passwordEC,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                passwordVisibility = !passwordVisibility;
                              },
                              child: Icon(
                                // ignore: unrelated_type_equality_checks
                                passwordVisibility == true
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: context.colors.primary,
                                size: 18,
                              ),
                            ),
                          ),
                          validator: Validatorless.multiple([
                            Validatorless.required('Senha obrigatória'),
                            Validatorless.min(6, 'Senha inválida'),
                          ]),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: DeliveryButton(
                            width: double.infinity,
                            label: 'ENTRAR',
                            onPressed: () {
                              final valid =
                                  _formKey.currentState?.validate() ?? false;
                              if (valid) {
                                controller.login(emailEC.text, passwordEC.text);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não possui uma conta?',
                          style: context.textStyles.textBold),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/auth/register');
                          },
                          child: Text(
                            'Cadastre-se',
                            style: context.textStyles.textBold
                                .copyWith(decoration: TextDecoration.underline)
                                .copyWith(color: Colors.blue),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
