import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/pressable_text.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/splash_hero.dart';
import 'package:vrooom/core/configs/network/network_config.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../domain/entities/role.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../widgets/divider_with_text.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/configs/routes/app_routes.dart';
import '../widgets/social_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http; // Do wysłania tokenu na backend
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginUseCase _loginUseCase = sl();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;


  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  // Nowa metoda do inicjalizacji
  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: '514717995283-fmh6vq95s5hjgfn6dctfp0p6fd3pp737.apps.googleusercontent.com',
      );
    } catch (error) {
      print('Błąd inicjalizacji Google Sign-In: $error');
    }
  }


// 2. Metoda do obsługi logowania
  Future<void> handleSignIn() async {
    try {
      // 3. Wywołaj 'authenticate', podając 'scopes' jako 'scopeHint'
      // (zakładając, że 'initialize' zostało już wywołane wcześniej)
      final GoogleSignInAccount? account = await _googleSignIn.authenticate(
        scopeHint: [
          'email',
          'profile',
        ],
      );

      if (account == null) {
        // Użytkownik anulował logowanie
        print('Logowanie anulowane');
        return;
      }

      // 4. Pobierz tokeny uwierzytelniające
      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;

      if (idToken == null) {
        print('Nie udało się pobrać idToken');
        return;
      }

      // DODAJ TĘ LINIĘ:
      print('--- OTO MÓJ TOKEN ID ---');
      print(idToken);
      print('-------------------------');
      // 5. Wyślij 'idToken' na swój backend Spring
      print('--- Wysyłanie tokenu na backend ---');
      await sendTokenToBackend(idToken);

    } catch (error) {
      print('Błąd logowania Google: $error');
    }
  }

// 6. Metoda wysyłająca token do Twojego API
  Future<void> sendTokenToBackend(String token) async {
    try {
      final response = await http.post(
        Uri.parse("${NetworkConfig.ip}/api/auth/google"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        // Sukces! Backend zweryfikował token i zalogował użytkownika
        // Tutaj możesz zapisać własny token JWT otrzymany od Springa
        print('Backend pomyślnie zweryfikował token.');
        print('Odpowiedź serwera: ${response.body}');
      } else {
        // Błąd
        print('Backend zwrócił błąd: ${response.statusCode}');
        print('Treść błędu: ${response.body}');
      }
    } catch (e) {
      print('Błąd podczas wysyłania tokenu: $e');
    }
  }


  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final result = await _loginUseCase(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (user) {
        if (user.role == Role.admin) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.carManagement,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: "Stationary Car Rentals", showBackButton: false),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Note: Hero Widget
                const Center(child: SplashHero()),
                const SizedBox(height: AppSpacing.lg),

                // Note: Login section
                CustomTextField(
                  label: "Email",
                  hintText: 'hello@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                    label: "Password",
                    hintText: 'Your password',
                    isPassword: true,
                    controller: _passwordController),
                Align(
                  alignment: Alignment.centerRight,
                  child: PressableText(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    text: 'Forgot password?',
                    style: const TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  text: _isLoading == false ? "Login" : "Logging in...",
                  onPressed: () => _handleLogin(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Note: Social Login section
                _buildSocialLoginSection(),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        const DividerWithText(text: "Or Continue With"),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SocialButton(text: "Facebook"),
            const SizedBox(width: AppSpacing.md),
            SocialButton(text: "Google",onTap: handleSignIn),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.text.neutral400),
            ),
            PressableText(
              text: 'Sign Up',
              style: const TextStyle(color: AppColors.primary),
              onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
            ),
          ],
        ),
      ],
    );
  }
}
