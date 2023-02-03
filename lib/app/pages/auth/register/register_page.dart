import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger/app/core/ui/helpers/loader.dart';
import 'package:vakinha_burger/app/core/ui/helpers/messages.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/pages/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/base_state/base_state.dart';
import 'register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController>
    with Loader, Messages {
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<RegisterController, RegisterState>(
        listener: (context, state) {
          state.status.matchAny(
            any: () => hideLoader(),
            register: () => showLoader(),
            error: () {
              hideLoader();
              showError('Erro ao registrar usuário');
            },
            success: () {
              hideLoader();
              showSuccess('Cadastro realizado com sucesso');
              Navigator.pop(context);
            },
          );
        },
        child: Scaffold(
          appBar: DeliveryAppbar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cadastro', style: context.textStyles.textTitle),
                    Text(
                      'Preencha os campos abaixo para criar o seu cadastro',
                      style:
                          context.textStyles.textMedium.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: nameEC,
                      decoration: const InputDecoration(labelText: 'Nome*'),
                      validator: Validatorless.required('Nome obrigatório'),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: emailEC,
                      decoration: const InputDecoration(labelText: 'E-mail*'),
                      validator: Validatorless.multiple([
                        Validatorless.required('E-mail obrigatório'),
                        Validatorless.email('E-mail inválido'),
                      ]),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: passwordEC,
                      decoration: const InputDecoration(labelText: 'Senha*'),
                      obscureText: true,
                      validator: Validatorless.multiple([
                        Validatorless.required('Senha obrigatória'),
                        Validatorless.min(6, 'Senha inválido'),
                      ]),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirma senha*'),
                      obscureText: true,
                      validator: Validatorless.multiple([
                        Validatorless.required(
                            'Confirmação de senha obrigatória'),
                        Validatorless.compare(
                            passwordEC, 'As senhas não coincidem')
                      ]),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: DeliveryButton(
                        width: double.infinity,
                        label: 'CADASTRAR',
                        onPressed: () {
                          final valid =
                              _formKey.currentState?.validate() ?? false;
                          if (valid) {
                            controller.register(
                                nameEC.text, emailEC.text, passwordEC.text);
                          }
                        },
                      ),
                    )
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
