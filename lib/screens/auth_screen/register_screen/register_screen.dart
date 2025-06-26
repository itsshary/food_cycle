import 'package:flutter/material.dart';
import 'package:food_cycle/provider/register_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:food_cycle/notification/notification_service/notification_service_screen_logic.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:food_cycle/screens/auth_screen/register_screen/widgets/inpude_decoration_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final NotificationServiceScreenLogic notificationRequest =
      NotificationServiceScreenLogic();

  @override
  void initState() {
    super.initState();
    notificationRequest.requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final registerVM = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: registerVM.isLoading,
        progressIndicator: const Center(child: LoadingBar()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: registerVM.formKey,
            child: ListView(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Set Up Your Account",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                /// First Name
                TextFormField(
                  controller: registerVM.firstNameController,
                  decoration: buildInputDecoration("Enter First Name"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your first name"
                      : null,
                ),
                const SizedBox(height: 10),

                /// Last Name
                TextFormField(
                  controller: registerVM.lastNameController,
                  decoration: buildInputDecoration("Enter Last Name"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your last name"
                      : null,
                ),
                const SizedBox(height: 10),

                /// Email
                TextFormField(
                  controller: registerVM.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildInputDecoration("Enter Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email address";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                /// Password
                TextFormField(
                  controller: registerVM.passwordController,
                  obscureText: true,
                  decoration: buildInputDecoration("Enter Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                /// Phone Number
                IntlPhoneField(
                  controller: registerVM.phoneController,
                  decoration: InputDecoration(
                    fillColor: Colors.green.shade100,
                    filled: true,
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  onChanged: (phone) {},
                ),

                const SizedBox(height: 10),

                /// Role Dropdown
                DropdownButtonFormField<String>(
                  value: registerVM.selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'Needy', child: Text('Needy')),
                    DropdownMenuItem(value: 'Donater', child: Text('Donater')),
                  ],
                  decoration: buildInputDecoration("Select Role"),
                  onChanged: (value) {
                    registerVM.selectedRole = value;
                  },
                  validator: (value) =>
                      value == null ? "Please select a role" : null,
                ),
                const SizedBox(height: 20),

                /// Register Button
                CustomButton(
                  text: "Register",
                  color: Colors.green,
                  onTap: () => registerVM.registerUser(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
