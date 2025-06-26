import 'package:flutter/material.dart';
import 'package:food_cycle/provider/login_vm.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:food_cycle/screens/auth_screen/forget_password_screen/forget_password_screen.dart';
import 'package:food_cycle/screens/auth_screen/login_screen/widget/decoration_widget.dart';
import 'package:food_cycle/screens/auth_screen/register_screen/register_screen.dart';
import 'package:food_cycle/utils/color_resources.dart';
import 'package:food_cycle/utils/extension.dart';
import 'package:food_cycle/utils/images.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool obsecure = true;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loginViewModel.isLoading,
        progressIndicator: const Center(child: LoadingBar()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: SingleChildScrollView(
            child: Form(
              key: loginViewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.logo,
                    height: height * 0.2,
                    width: width * 0.7,
                  ),
                  30.sH,
                  TextFormField(
                    controller: loginViewModel.emailController,
                    focusNode: loginViewModel.emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoration("Enter Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(passwordFocus),
                  ),
                  20.sH,
                  TextFormField(
                    controller: loginViewModel.passwordController,
                    focusNode: passwordFocus,
                    obscureText: obsecure,
                    decoration: inputDecoration("Enter Password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                            obsecure ? Icons.visibility_off : Icons.visibility,
                            color: ColorResources.primaryColor),
                        onPressed: () => setState(() => obsecure = !obsecure),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Enter min. 6 characters';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => loginViewModel.loginFun(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordScreen()));
                          },
                          child: const Text(
                            'Forget Password',
                            style:
                                TextStyle(color: ColorResources.primaryColor),
                          ))
                    ],
                  ),
                  CustomButton(
                    text: 'Login',
                    color: ColorResources.primaryColor,
                    onTap: () async => await loginViewModel.loginFun(context),
                  ),
                  30.sH,
                  const Divider(thickness: 1.5),
                  10.sH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member?",
                          style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        ),
                        child: const Text(
                          "Create an account",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorResources.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
