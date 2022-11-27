import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:logger/logger.dart';

class FormBuilderScreen extends StatelessWidget {
  FormBuilderScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final _logger = Logger();
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
                    _logger.i(value);
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
                const SizedBox(height: 15),
                FormBuilderDateTimePicker(
                  name: 'date',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: 'Appointment Time',
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['date']?.didChange(null);
                      },
                    ),
                  ),
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                  locale: const Locale.fromSubtags(languageCode: 'es'),
                ),
                FormBuilderSlider(
                  name: 'slider',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(6),
                  ]),
                  onChanged: (value) {
                    _logger.i(value);
                  },
                  min: 0.0,
                  max: 10.0,
                  initialValue: 7.0,
                  divisions: 20,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Number of things',
                  ),
                ),
                FormBuilderRangeSlider(
                  name: 'range_slider',
                  // validator: FormBuilderValidators.compose([FormBuilderValidators.min(context, 6)]),
                  onChanged: (value) {
                    _logger.i('inicio: ${value!.start} - fin: ${value.end}');
                  },
                  min: 0.0,
                  max: 100.0,
                  initialValue: const RangeValues(4, 7),
                  divisions: 20,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(labelText: 'Price Range'),
                ),
                FormBuilderCheckbox(
                  name: 'accept_terms',
                  initialValue: false,
                  onChanged: (value) {
                    _logger.i(value);
                  },
                  title: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'I have read and agree to the ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(color: Colors.blue),
                          // Flutter doesn't allow a button inside a button
                          // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086
                          /*
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('launch url');
                                },
                              */
                        ),
                      ],
                    ),
                  ),
                  validator: FormBuilderValidators.equal(
                    true,
                    errorText:
                        'You must accept terms and conditions to continue',
                  ),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'age',
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    suffixIcon: true
                        ? Icon(Icons.error, color: Colors.red)
                        : Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {},
                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.max(70),
                  ]),
                  // initialValue: '12',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      _logger.i(_formKey.currentState!.value);
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
