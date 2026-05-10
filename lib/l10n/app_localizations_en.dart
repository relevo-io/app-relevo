// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String welcomeMessage(String name) {
    return 'Welcome to Relevo, $name';
  }

  @override
  String get fillAllFieldsError => 'Please fill in all fields';

  @override
  String get loginTitle => 'Log In';

  @override
  String get loginWelcome => 'Welcome back!';

  @override
  String get loginSubtitle => 'Log in to manage your opportunities.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailHint => 'e.g. john@company.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHintLogin => 'Your secret password';

  @override
  String get loginButton => 'Log In';

  @override
  String get forgotPasswordButton => 'Forgot your password?';

  @override
  String get registerTitle => 'Join Relevo';

  @override
  String get registerWelcome => 'Create your account';

  @override
  String get registerSubtitle => 'Be part of the new generation of leaders.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'e.g. John Doe';

  @override
  String get passwordHintRegister => 'Minimum 6 characters';

  @override
  String get roleQuestion => 'What are you looking for in Relevo?';

  @override
  String get roleInterested => 'I\'m looking for opportunities';

  @override
  String get roleOwner => 'I want to transfer my business';

  @override
  String get registerButton => 'Create Account';

  @override
  String get homeMarketplaceBadge => 'Leading Marketplace';

  @override
  String get homeSlogan => 'Secure the future of your legacy.';

  @override
  String get homeSlogan2 => 'Boost your new business.';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileDefaultUser => 'User';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileHelp => 'Help & Support';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileNotRegisteredQuestion => 'Not registered yet?';

  @override
  String get profileNotRegisteredSubtitle =>
      'Join the platform and secure the future of your legacy.';

  @override
  String get profileLoginButton => 'Log In';

  @override
  String get profileRegisterButton => 'Sign Up';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavProfile => 'Profile';

  @override
  String get languageSelectorES => 'Español (ES)';

  @override
  String get languageSelectorCA => 'Català (CA)';

  @override
  String get languageSelectorEN => 'English (EN)';

  @override
  String get homeIntro =>
      'We connect experienced founders with the next generation of business leaders.';

  @override
  String get homeStatValue1 => '€12M+';

  @override
  String get homeStatLabel1 => 'Transacted Value';

  @override
  String get homeStatValue2 => '+500';

  @override
  String get homeStatLabel2 => 'Active Owners';

  @override
  String get homeOwnersTitle => 'FOR OWNERS';

  @override
  String get homeOwnersSubtitle =>
      'Your retirement deserves a worthy successor.';

  @override
  String get homeOwnersDesc =>
      'You have built something valuable. Don\'t let it go to waste. We help you find the ideal buyer.';

  @override
  String get homeOwnersFeature1 => 'Professional business valuation.';

  @override
  String get homeOwnersFeature2 => 'Screening of potential buyers.';

  @override
  String get homeOwnersFeature3 => 'Maximum confidentiality.';

  @override
  String get homeEntrepreneursTitle => 'FOR ENTREPRENEURS';

  @override
  String get homeEntrepreneursSubtitle => 'Start on a solid foundation.';

  @override
  String get homeEntrepreneursDesc =>
      'Don\'t start from scratch. Acquire an established company with cash flow and clients.';

  @override
  String get homeEntrepreneursFeatureTitle => 'Proven Profitability';

  @override
  String get homeEntrepreneursFeatureDesc =>
      'Access audited financial histories.';

  @override
  String get homeSearchHint => 'Search Relevo';

  @override
  String get homeFilters => 'Filters';

  @override
  String get homeCompanyOffers => 'Company Offers';

  @override
  String get homeNearbyNews => 'News near you';

  @override
  String get homeViewAll => 'View all';

  @override
  String get bottomNavSell => 'Sell';

  @override
  String get bottomNavInbox => 'Inbox';

  @override
  String get bottomNavYou => 'You';

  @override
  String get themeDarkMode => 'Dark mode';

  @override
  String get themeLightMode => 'Light mode';
}
