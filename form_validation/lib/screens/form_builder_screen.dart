import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:logger/logger.dart';

class FormBuilderScreen extends StatelessWidget {
  FormBuilderScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final logger = Logger();
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilderTextField(
                  keyboardType: TextInputType.emailAddress,
                  name: 'name',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'Este valor es requerido.'),
                        FormBuilderValidators.email(errorText: 'debe ser email')
                  ]),
                  decoration: const InputDecoration(label: Text('Full Name')),
                  onChanged: (value) {
                    logger.i(value);
                    /*
                    logger.v("Verbose log");
                    logger.d("Debug log");
                    logger.i("Info log");
                    logger.w("Warning log");
                    logger.e("Error log");
                    logger.wtf("What a terrible failure log");
                    */
                  },
                ),
                FormBuilderTextField(
                  name: 'name2',
                  enabled: false,
                  initialValue: 'initial value',
                  valueTransformer: (value) {
                    return value!.toUpperCase();
                  },
                  decoration: const InputDecoration(label: Text('Last Name')),
                ),
                FormBuilderDropdown<String>(
                  name: 'gender',
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    icon: const Icon(Icons.person),
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['gender']?.reset();
                      },
                    ),
                    hintText: 'Select Gender',
                  ),
                  items: genderOptions
                      .map((gender) => DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      logger.i(_formKey.currentState!.value);
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text('Patch Value'),
                  onPressed: () {
                    _formKey.currentState!
                        .patchValue({'name2': 'Patch Value.'});
                  },
                )
              ],
            )),
      ),
    );
  }
}
