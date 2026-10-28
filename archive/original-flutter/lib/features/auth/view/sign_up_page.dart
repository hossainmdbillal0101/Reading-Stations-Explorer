import 'package:explorer/features/auth/data/user_model.dart';
import 'package:explorer/features/auth/logic/auth_provider.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/misc/buttons.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/misc/routes.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:explorer/utils/context_less.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  UserDataModel? _userDataModel;

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: deviceSize.height * 0.9,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/CVGCM.png",
                      height: 120.h,
                      width: 120.h,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Neumorphic(
                      style: KEltDecoration.innerShadow,
                      child: FormBuilderTextField(
                        style: const TextStyle(
                          color: KEltColor.txt,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        name: 'name',
                        decoration:
                            KEltInputDecoration.inputDecoration.copyWith(
                          hintText: 'Input Your Name',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            context,
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Neumorphic(
                      style: KEltDecoration.innerShadow,
                      child: FormBuilderTextField(
                        style: const TextStyle(
                          color: KEltColor.txt,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        name: 'metric',
                        decoration:
                            KEltInputDecoration.inputDecoration.copyWith(
                          hintText: 'Enter Your Metric Number',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            context,
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Neumorphic(
                      style: KEltDecoration.innerShadow,
                      child: FormBuilderTextField(
                        style: const TextStyle(
                          color: KEltColor.txt,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        name: 'email',
                        decoration:
                            KEltInputDecoration.inputDecoration.copyWith(
                          hintText: 'Input Your Email',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            context,
                          ),
                          FormBuilderValidators.email(
                            context,
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Neumorphic(
                      style: KEltDecoration.innerShadow,
                      child: FormBuilderTextField(
                        keyboardType: TextInputType.text,
                        name: 'password',
                        style: const TextStyle(
                          color: KEltColor.txt,
                        ),
                        obscureText: true,
                        obscuringCharacter: '#',
                        decoration:
                            KEltInputDecoration.inputDecoration.copyWith(
                          hintText: 'Input Your Password',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            context,
                          ),
                          FormBuilderValidators.minLength(
                            context,
                            6,
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account? ",
                          style: TextStyle(color: KEltColor.txt),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.nav.pushReplacementNamed(
                              Routes.landing,
                            );
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: KEltColor.txt,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return ref.watch(registrationProvider).map(
                              initial: (_) => CustomButton(
                                onTap: () async {
                                  if (_formkey.currentState!
                                      .saveAndValidate()) {
                                    final Map<
                                            String,
                                            FormBuilderFieldState<
                                                FormBuilderField,
                                                dynamic>> formdata =
                                        _formkey.currentState!.fields;
                                    _userDataModel = UserDataModel(
                                      name: formdata['name']!.value as String,
                                      email: formdata['email']!.value as String,
                                      uid: '',
                                      metric:
                                          formdata['metric']!.value as String,
                                      favourites: [],
                                    );

                                    ref
                                        .watch(
                                          registrationProvider.notifier,
                                        )
                                        .register(
                                          email: formdata['email']!.value
                                              as String,
                                          password: formdata['password']!.value
                                              as String,
                                        );
                                  }
                                },
                                title: "Sign Up",
                              ),
                              loading: (_) => const Loader(),
                              loaded: (_) {
                                if (_.data.user != null) {
                                  FBC.usersCollection
                                      .doc(_.data.user!.uid)
                                      .set(
                                        _userDataModel!
                                            .copyWith(
                                              uid: _.data.user!.uid,
                                            )
                                            .toMap(),
                                      )
                                      .then((value) {
                                    ref.refresh(
                                      currentUserProvider,
                                    );
                                  });
                                  context.nav.pushNamedAndRemoveUntil(
                                    Routes.landing,
                                    (route) => false,
                                  );
                                }
                                return const SizedBox();
                              },
                              error: (_) {
                                Future.delayed(
                                  const Duration(
                                    seconds: 3,
                                  ),
                                ).then((value) {
                                  ref.refresh(
                                    registrationProvider,
                                  );
                                });
                                return ErrorHandleWidget(
                                  error: _.error,
                                );
                              },
                            );
                      },
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
