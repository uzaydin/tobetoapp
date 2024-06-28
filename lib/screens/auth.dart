import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/widgets/bottom_navigation.dart';
import 'package:tobetoapp/screens/user/reset_password.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/password_suffix_icon.dart';
import 'package:tobetoapp/widgets/validation_video_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;
  bool _isLoginPage = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: const DrawerManager(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _authBlocListener,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.verticalPaddingMedium,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildAuthForm(context),
                const CommonFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _authBlocListener(BuildContext context, AuthState state) {
    if (state is AuthLoading) {
      _showLoadingDialog(context);
    } else {
      Navigator.of(context).pop();
    }
    if (state is AuthFailure) {
      _showErrorSnackbar(context, state.message);
    } else if (state is AuthSuccess) {
      _navigateToMainPage(context);
    } else if (state is Unauthenticated) {
      _navigateToAuthPage(context);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 25),
            Text("Giriş yapılıyor..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToMainPage(BuildContext context) {
    context.read<AuthProviderDrawer>().login();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavigation(),
      ),
    );
  }

  void _navigateToAuthPage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Auth(),
    ));
  }

  Widget _buildAuthForm(BuildContext context) {
    return OutlineGradientButton(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      strokeWidth: 3,
      radius: Radius.circular(AppConstants.br30),
      gradient: const LinearGradient(
        colors: [
          AppColors.tobetoMoru,
          Color.fromARGB(209, 255, 255, 255),
          Color.fromARGB(178, 255, 255, 255),
          AppColors.tobetoMoru,
        ],
        stops: [0.0, 0.5, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        children: [
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          _buildLogo(),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          _buildWelcomeText(context),
          SizedBox(height: AppConstants.sizedBoxHeightLarge),
          _buildToggleSwitch(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          if (!_isLoginPage) _buildSignUpFields(),
          _buildEmailField(),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          _buildPasswordField(),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          if (!_isLoginPage) _buildConfirmPasswordField(),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          _buildSubmitButton(context),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          if (_isLoginPage) _buildAdditionalOptions(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: AppConstants.screenWidth * 0.6,
      height: AppConstants.screenHeight * 0.1,
      child: Image.asset(
        'assets/logo/tobetologo.PNG',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Text(
      "Hoşgeldiniz",
      style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(fontWeight: FontWeight.w400),
    );
  }

  Widget _buildToggleSwitch() {
    return ToggleSwitch(
      minWidth: AppConstants.screenWidth * 0.35,
      minHeight: AppConstants.screenHeight * 0.06,
      cornerRadius: AppConstants.br30,
      activeBgColors: const [
        [Color.fromARGB(255, 120, 98, 180)],
        [Color.fromARGB(255, 120, 98, 180)],
      ],
      activeBgColor: const [Colors.white],
      inactiveBgColor: Colors.grey[200],
      inactiveFgColor: const Color.fromARGB(255, 120, 98, 180),
      initialLabelIndex: _isLoginPage ? 0 : 1,
      totalSwitches: 2,
      labels: const ["Giriş Yap", "Kayıt Ol"],
      onToggle: (index) {
        setState(() {
          _isLoginPage = index == 0;
        });
      },
    );
  }

  Widget _buildSignUpFields() {
    return Column(
      children: [
        _buildNameField(),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
        _buildLastNameField(),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: "Ad",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.br20),
        ),
        prefixIcon: const Icon(Icons.assignment_ind_rounded),
      ),
      autocorrect: false,
      validator: (value) => validation(value, "Lütfen adınızı giriniz."),
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: "Soyad",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.br20),
        ),
        prefixIcon: const Icon(Icons.assignment_ind_rounded),
      ),
      autocorrect: false,
      validator: (value) => validation(value, "Lütfen soyadınızı giriniz."),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "E-Posta",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.br20),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      validator: (value) =>
          validation(value, "Lütfen bir e-posta adresi giriniz."),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Şifre",
        suffixIcon: PasswordSuffixIcon(
          isPasswordVisible: _isPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.br20),
        ),
        prefixIcon: const Icon(Icons.lock_outline_rounded),
      ),
      autocorrect: false,
      obscureText: !_isPasswordVisible,
      validator: (value) => validation(value, "Lütfen bir şifre giriniz"),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      children: [
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: "Şifre Tekrar",
            suffixIcon: PasswordSuffixIcon(
              isPasswordVisible: _isRepeatPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.br20),
            ),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
          ),
          autocorrect: false,
          obscureText: !_isRepeatPasswordVisible,
          validator: (value) =>
              validatePasswordConfirmation(value, _passwordController.text),
        ),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tobetoMoru,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.br20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingXLarge,
            vertical: AppConstants.verticalPaddingSmall,
          ),
        ),
        child: Text(
          _isLoginPage ? "Giriş Yap" : "Kayıt Ol",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAdditionalOptions(BuildContext context) {
    return Column(
      children: [
        _buildDividerWithText(),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
        _buildGoogleSignInButton(context),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
        _buildForgotPasswordButton(context),
      ],
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 2,
          width: 50,
          color: Colors.black,
        ),
        SizedBox(width: AppConstants.sizedBoxWidthSmall),
        const Text("Ya da"),
        SizedBox(width: AppConstants.sizedBoxWidthSmall),
        Container(
          height: 2,
          width: 50,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(AuthGoogleSignIn());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.google),
          SizedBox(width: AppConstants.sizedBoxWidthSmall),
          const Text("Google ile Giriş Yap"),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResetPassword(),
          ),
        );
      },
      child: const Text("Şifremi Unuttum"),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isLoginPage) {
        _login();
      } else {
        _signUp();
      }
    }
  }

  void _login() {
    context.read<AuthBloc>().add(
          AuthLogin(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  void _signUp() {
    context.read<AuthBloc>().add(
          AuthSignUp(
            name: _nameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  String? validatePasswordConfirmation(
      String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Lütfen şifreyi tekrar giriniz.";
    } else if (confirmPassword != password) {
      return "Şifreler eşleşmiyor.";
    }
    return null;
  }
}
