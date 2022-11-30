import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:logger/logger.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

class FormBuilderScreen extends StatelessWidget {
  FormBuilderScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final _logger = Logger();
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormBuilderTextField(
                      keyboardType: TextInputType.emailAddress,
                      name: 'name',
                      initialValue: 'f@f.com',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Este valor es requerido.'),
                        FormBuilderValidators.email(errorText: 'debe ser email')
                      ]),
                      decoration:
                          const InputDecoration(label: Text('Full Name')),
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
                      decoration:
                          const InputDecoration(label: Text('Last Name')),
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
                            _formKey.currentState!.fields['date']
                                ?.didChange(null);
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
                        _logger
                            .i('inicio: ${value!.start} - fin: ${value.end}');
                      },
                      min: 0.0,
                      max: 100.0,
                      initialValue: const RangeValues(4, 7),
                      divisions: 20,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration:
                          const InputDecoration(labelText: 'Price Range'),
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
                      initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderRadioGroup<String>(
                      decoration: const InputDecoration(
                        labelText: 'My chosen language',
                      ),
                      initialValue: null,
                      name: 'best_language',
                      onChanged: (value) {
                        _logger.i(value);
                      },
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      options:
                          ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
                              .map((lang) => FormBuilderFieldOption(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(growable: false),
                      controlAffinity: ControlAffinity.leading,
                    ),
                    FormBuilderSegmentedControl(
                      decoration: const InputDecoration(
                        labelText: 'Movie Rating (Archer)',
                      ),
                      name: 'movie_rating',
                      // initialValue: 1,
                      // textStyle: TextStyle(fontWeight: FontWeight.bold),
                      options: List.generate(10, (i) => i + 1)
                          .map((number) => FormBuilderFieldOption(
                                value: number,
                                child: Text(
                                  number.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _logger.i(value);
                      },
                    ),
                    FormBuilderSwitch(
                      title: const Text('I Accept the terms and conditions'),
                      name: 'accept_terms_switch',
                      initialValue: true,
                      onChanged: (value) {
                        _logger.i(value);
                      },
                    ),
                    FormBuilderCheckboxGroup<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'The language of my people'),
                      name: 'languages',
                      // initialValue: const ['Dart'],
                      options: const [
                        FormBuilderFieldOption(value: 'Dart'),
                        FormBuilderFieldOption(value: 'Kotlin'),
                        FormBuilderFieldOption(value: 'Java'),
                        FormBuilderFieldOption(value: 'Swift'),
                        FormBuilderFieldOption(value: 'Objective-C'),
                      ],
                      onChanged: (value) {
                        _logger.i(value);
                      },
                      separator: const VerticalDivider(
                        width: 10,
                        thickness: 5,
                        color: Colors.red,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(1),
                        FormBuilderValidators.maxLength(3),
                      ]),
                    ),
                    FormBuilderFilterChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'The language of my people'),
                      name: 'languages_filter',
                      selectedColor: Colors.red,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Dart',
                          avatar: CircleAvatar(child: Text('D')),
                        ),
                        FormBuilderChipOption(
                          value: 'Kotlin',
                          avatar: CircleAvatar(child: Text('K')),
                        ),
                        FormBuilderChipOption(
                          value: 'Java',
                          avatar: CircleAvatar(child: Text('J')),
                        ),
                        FormBuilderChipOption(
                          value: 'Swift',
                          avatar: CircleAvatar(child: Text('S')),
                        ),
                        FormBuilderChipOption(
                          value: 'Objective-C',
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                      ],
                      onChanged: (value) {
                        _logger.i(value);
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(1),
                        FormBuilderValidators.maxLength(3),
                      ]),
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText:
                              'Ok, if I had to choose one language, it would be:'),
                      name: 'languages_choice',
                      initialValue: 'Dart',
                      options: const [
                        FormBuilderChipOption(
                          value: 'Dart',
                          avatar: CircleAvatar(child: Text('D')),
                        ),
                        FormBuilderChipOption(
                          value: 'Kotlin',
                          avatar: CircleAvatar(child: Text('K')),
                        ),
                        FormBuilderChipOption(
                          value: 'Java',
                          avatar: CircleAvatar(child: Text('J')),
                        ),
                        FormBuilderChipOption(
                          value: 'Swift',
                          avatar: CircleAvatar(child: Text('S')),
                        ),
                        FormBuilderChipOption(
                          value: 'Objective-C',
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                      ],
                      onChanged: (value) {
                        _logger.i(value);
                      },
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
                    ),
                    ElevatedButton(
                      child: const Text('Open map'),
                      onPressed: () {
                        showPlacePicker2(context);
                      },
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void showPlacePicker2(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => PlacePicker(
          apiKey: Platform.isAndroid
              ? ''
              : 'YOUR IOS API KEY',
          onPlacePicked: (result) {
            _logger.i(
                'Lat ${result.geometry!.location.lat} - Lat ${result.geometry!.location.lng} - Addrees ${result.formattedAddress} - JSON ${result.geometry!.location.toJson()}');
            Navigator.of(context).pop();
          },
          initialPosition: const LatLng(6.1487815, -75.6214691),
          useCurrentLocation: true,
          resizeToAvoidBottomInset:
              false, // remove this line, if map offsets are wrong
              hintText: 'Test de hint text',
              searchingText: 'Seraching text ....',
              selectText: 'select text..',
        ),
      ),
    );
  }

  void showPlacePicker(context) async {
    /*
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyArO7Wkd2r_mMHjzJQufXph2a-xsR4cErs",
              displayLocation: const LatLng(6.1487815, -75.6214691),
              localizationItem: LocalizationItem(
                  tapToSelectLocation: 'toca para seleccionar'),
            )));

    // Handle the result in your way
    _logger.i('country - ${result.country!.name} ${result.country!.shortName}');
    _logger.i('city - ${result.city!.name} ${result.city!.shortName}');
    _logger.i('name - ${result.name}');
    _logger.i('latLng - ${result.latLng}');
    _logger.i(
        'result - ${result.formattedAddress} - ${result.locality} - ${result.placeId} - ${result.postalCode} - ${result.subLocalityLevel1!.name} - ${result.subLocalityLevel2!.name}');
  */
  }
}
