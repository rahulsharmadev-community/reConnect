part of '../registration_screen.dart';

class _RegisterationForm extends StatefulWidget {
  final Function(String name, String? email, String? phoneNo) onRegister;
  const _RegisterationForm({super.key, required this.onRegister});

  @override
  State<_RegisterationForm> createState() => _RegisterationFormState();
}

class _RegisterationFormState extends State<_RegisterationForm> {
  late final TextEditingController _nameCr;
  late final TextEditingController _infoCr;
  late final TapGestureRecognizer _recognizer;

  late final FocusNode _infoNode;
  late final FocusNode _nameNode;

  final _formKey = GlobalKey<FormState>();

  final primeryColor = const Color(0xff53A1EB);
  final roundedBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  Widget space([double height = 16]) => SizedBox(height: height);
  bool isvalidPh = false, isvalidEmail = false, isvalidName = false;

  final emailReg = RegExp(
      r'^(([^<>()[\]\\.,;:!#$_\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\")){3,25}$');
  final numberReg = RegExp(r'^[0-9]{5,10}$');
  final nameReg = RegExp(r'^[a-zA-Z| ]+$');

  _onAgreementTap() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Terms and Conditions are applied'),
    ));
  }

  bool get _isRegisterable {
    if (_nameCr.text.isEmpty || _infoCr.text.isEmpty) return false;
    if (isvalidName && (isvalidEmail || isvalidPh)) return true;
    return false;
  }

  void Function()? get _onRegisterTap {
    if (_isRegisterable) {
      return () {
        widget.onRegister(_nameCr.text, isvalidEmail ? _infoCr.text : null,
            isvalidPh ? _infoCr.text : null);
      };
    }
    return null;
  }

  @override
  void initState() {
    _nameCr = TextEditingController();
    _infoCr = TextEditingController();
    _infoNode = FocusNode();
    _nameNode = FocusNode();
    _recognizer = TapGestureRecognizer()..onTap = _onAgreementTap;
    super.initState();
  }

  @override
  void dispose() {
    _nameCr.dispose();
    _infoCr.dispose();
    _recognizer.dispose();
    _infoNode.dispose();
    _nameNode.dispose();
    super.dispose();
  }

  String get lable {
    if (isvalidPh && !isvalidEmail) return 'Phone number';
    if (isvalidEmail && !isvalidPh) return 'Email';
    return 'Email or Phone no.';
  }

  List<Widget> imageWidgets() {
    final width = MediaQuery.of(context).size.width;
    return [
      Image.asset(
        'assets/images/name.png',
        width: width / 2.1,
        color: primeryColor,
      ),
      Image.asset('assets/images/rope.png'),
      space(),
      SizedBox(
        width: width / 1.5,
        child: const Text(
          "Look like you don't have an account. Let's create a new account",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xff1c1c1c)),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Theme(
        data: ThemeData.light(),
        child: Card(
            elevation: 8,
            color: Colors.white,
            margin: const EdgeInsets.all(24),
            shape: roundedBorder,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...imageWidgets(),
                    space(8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        children: [
                          customTextField(
                            label: 'Name',
                            maxLength: 15,
                            controller: _nameCr,
                            focusNode: _nameNode,
                            onEditingComplete: () {
                              if (_isRegisterable) {
                                _nameNode.unfocus();
                              } else {
                                _infoNode.nextFocus();
                              }
                            },
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                isvalidName = nameReg.hasMatch(value);
                                return !isvalidName
                                    ? 'Enter a Valid Name'
                                    : null;
                              }
                              return null;
                            },
                          ),
                          space(!isvalidName ? 16 : 4),
                          customTextField(
                            label: lable,
                            controller: _infoCr,
                            focusNode: _infoNode,
                            onEditingComplete: () {
                              if (_isRegisterable) {
                                _infoNode.unfocus();
                              } else {
                                _nameNode.nextFocus();
                              }
                            },
                            maxLength: isvalidPh ? 10 : null,
                            prefixText: isvalidPh ? '+91' : null,
                            suffixText: isvalidEmail ? '@gmail.com' : null,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                isvalidPh = isvalidEmail = true;
                                isvalidPh = numberReg.hasMatch(value);
                                isvalidEmail = emailReg.hasMatch(value) &&
                                    isvalidPh != true;
                                if (!isvalidEmail &&
                                    _infoCr.text.length > 2 &&
                                    !isvalidPh) {
                                  return "Couldn't find your Google Account";
                                }
                                if (isvalidPh && _infoCr.text.length != 10) {
                                  return "Invalid phone number";
                                }
                                return null;
                              }
                              return null;
                            },
                          ),
                          space(),
                          registerButton(),
                          space(),
                          AggrementText(
                            recognizer: _recognizer,
                            color: primeryColor,
                          ),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }

  FilledButton registerButton() {
    return FilledButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primeryColor,
          fixedSize: const Size(double.maxFinite, 48),
          shape: roundedBorder),
      onPressed: _onRegisterTap,
      child: const Text(
        'Register',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget customTextField(
      {required String label,
      required FocusNode focusNode,
      required TextEditingController controller,
      required String? Function(String?) validator,
      VoidCallback? onEditingComplete,
      String? prefixText,
      String? suffixText,
      int? maxLength}) {
    var unfocused = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8));

    final focused = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8));
    final error = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(8));
    return TextFormField(
      focusNode: focusNode,
      enableInteractiveSelection: false,
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: 16, color: primeryColor),
      cursorColor: Colors.blue,
      maxLength: maxLength,
      onEditingComplete: onEditingComplete,
      onChanged: (value) {
        _formKey.currentState?.validate();
        setState(() {});
      },
      decoration: InputDecoration(
          isDense: true,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
          floatingLabelStyle: const TextStyle(fontSize: 16, color: Colors.blue),
          prefixText: prefixText,
          suffixText: suffixText,
          labelText: label,
          focusColor: Colors.blue,
          enabledBorder: unfocused,
          disabledBorder: unfocused,
          focusedBorder: focused,
          focusedErrorBorder: error,
          errorBorder: error),
    );
  }
}
