import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validation/extensions/ext_string.dart';
import 'package:form_validation/screens/success_screen.dart';
import 'package:form_validation/widgets/custom_form_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de prueba'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            const Text('data'),
            TextFormField(),
            CustomFormField(
              hintText: 'Name',
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-Z]+|\s"),
                )
              ],
              validator: (val) {
                if (val!.isValidName) return 'Enter valid name';
              },
            ),
            CustomFormField(
              hintText: 'Email',
              validator: (val) {
                if (val!.isValidEmail) return 'Enter valid email';
              },
            ),
            CustomFormField(
              hintText: 'Phone',
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"[0-9]"),
                )
              ],
              validator: (val) {
                if (val!.isValidPhone) return 'Enter valid phone';
              },
            ),
            CustomFormField(
              hintText: 'Password',
              validator: (val) {
                if (val!.isValidPassword) return 'Enter valid password';
              },
            ),
            ElevatedButton(
              child: const Text('Button label'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SuccessScreen(),
                    ),
                  );
                }
              },
            )
          ]),
        ),
      )),
    );
  }
}