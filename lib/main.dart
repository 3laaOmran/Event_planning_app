import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/theme_provider.dart';
import 'package:evently_app/ui/auth/login/login_screen.dart';
import 'package:evently_app/ui/auth/register/register_screen.dart';
import 'package:evently_app/ui/home/home_screen/home_screen.dart';
import 'package:evently_app/ui/home/tabs/home_tab/add_event.dart';
import 'package:evently_app/ui/home/tabs/home_tab/edit_event.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_details.dart';
import 'package:evently_app/ui/onboarding/intro_screen.dart';
import 'package:evently_app/utils/app_theme.dart';
import 'package:evently_app/utils/helpers/cash_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/language_provider.dart';
import 'ui/auth/forget_password/forget_password_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CashHelper.init();
  bool? onboarding = CashHelper.getData(key: 'onboarding');
  String initialRoute;
  if (onboarding != null) {
    if (CashHelper.getData(key: 'uId') != null) {
      initialRoute = HomeScreen.routeName;
    } else {
      initialRoute = LoginScreen.routeName;
    }
  } else {
    initialRoute = IntroScreen.routeName;
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LanguageProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => EventListProvider()),
        // ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: EventlyApp(
        initialRoute: initialRoute,
      )));
}

class EventlyApp extends StatelessWidget {
  final String initialRoute;

  const EventlyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        AddEvent.routeName: (context) => const AddEvent(),
        EventDetails.routeName: (context) => const EventDetails(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ForgetPasswordScreen.routeName: (context) =>
            const ForgetPasswordScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        IntroScreen.routeName: (context) => const IntroScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        HomeScreen.routeName : (context) => const HomeScreen(),
        EditEvent.routeName: (context) => const EditEvent(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
    );
  }
}
