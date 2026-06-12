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
  String get bottomNavInbox => 'Requests';

  @override
  String get bottomNavYou => 'You';

  @override
  String get themeDarkMode => 'Dark mode';

  @override
  String get themeLightMode => 'Light mode';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorUserExists => 'User already exists';

  @override
  String get errorInternal => 'Internal server error';

  @override
  String get errorInvalidEmail => 'Invalid email format';

  @override
  String get errorPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get errorRequiredField => 'This field is required';

  @override
  String get registerSuccess => 'Registration completed. Please log in.';

  @override
  String get profileFeatureMarketplaceTitle => 'Marketplace Access';

  @override
  String get profileFeatureMarketplaceDesc =>
      'Explore hundreds of active business transfer opportunities.';

  @override
  String get profileFeatureChatTitle => 'Direct Contact';

  @override
  String get profileFeatureChatDesc =>
      'Talk securely with owners through our integrated chat.';

  @override
  String get profileFeaturePublishTitle => 'List Your Business';

  @override
  String get profileFeaturePublishDesc =>
      'Sell or transfer your company with total confidentiality.';

  @override
  String get restrictedAlertTitle => 'Want to see all the details?';

  @override
  String get restrictedAlertDesc =>
      'Log in or sign up on Relevo to view prices, full descriptions, and contact the owners.';

  @override
  String get homeAboutTitle => 'What is Relevo?';

  @override
  String get homeAboutDesc =>
      'Relevo is the leading platform to transfer and acquire established businesses in a confidential, direct, and transparent manner. We connect founders with the next generation of leaders.';

  @override
  String get homeAboutButton => 'Who are we?';

  @override
  String get profileSectionAbout => 'About Me';

  @override
  String get profileSectionProfessional => 'Professional Profile';

  @override
  String get profileLocationLabel => 'Location';

  @override
  String get profileBioLabel => 'Biography';

  @override
  String get profileBackgroundLabel => 'Experience & Capabilities';

  @override
  String get profileNoLocation => 'No location specified';

  @override
  String get profileNoBio => 'No biography written yet';

  @override
  String get profileNoBackground => 'No experience detailed yet';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileSaveButton => 'Save changes';

  @override
  String get profileSaveSuccess => 'Profile updated successfully';

  @override
  String get profileSaving => 'Saving...';

  @override
  String get profileLocationHint => 'e.g., Barcelona, Catalonia';

  @override
  String get profileBioHint => 'Tell us a bit about yourself...';

  @override
  String get profileBackgroundHint =>
      'Detail your professional experience and skills...';

  @override
  String get sellTitle => 'My Selling Space';

  @override
  String get sellPublishButton => 'Publish Offer';

  @override
  String get sellMyOffersSection => 'Your Published Opportunities';

  @override
  String get sellEmptyStateTitle => 'No businesses published yet';

  @override
  String get sellEmptyStateDesc =>
      'We help you find the ideal buyer. Start listing your business with total confidentiality.';

  @override
  String get offerCreateTitle => 'Publish Business';

  @override
  String get offerSectorLabel => 'Business Sector';

  @override
  String get offerSectorHint => 'e.g., Hospitality, Automotive, Tech...';

  @override
  String get offerRegionLabel => 'Location / Region';

  @override
  String get offerRegionHint => 'e.g., Gironès, Barcelona, Andorra...';

  @override
  String get offerRevenueLabel => 'Annual Revenue Range';

  @override
  String get offerEmployeesLabel => 'Number of Employees';

  @override
  String get offerYearLabel => 'Creation Year (Optional)';

  @override
  String get offerYearHint => 'e.g., 2012';

  @override
  String get offerDescLabel => 'Brief Business Description';

  @override
  String get offerDescHint =>
      'Summarize your business in a couple of catchy sentences...';

  @override
  String get offerExtendedLabel => 'Detailed Description (Optional)';

  @override
  String get offerExtendedHint =>
      'Detail more aspects like customer base, assets, reason for transfer...';

  @override
  String get offerPublishButton => 'Publish Opportunity';

  @override
  String get offerPublishSuccess => 'Opportunity published successfully!';

  @override
  String get offerPublishError => 'Error publishing opportunity. Try again.';

  @override
  String get offerErrorInvalidYear => 'Enter a valid year';

  @override
  String get offerErrorDescTooShort =>
      'Description must be at least 10 characters long';

  @override
  String get offerDetailsTitle => 'Offer Details';

  @override
  String get offerDetailsLocation => 'Location';

  @override
  String get offerDetailsRevenue => 'Annual Revenue';

  @override
  String get offerDetailsEmployees => 'Employees';

  @override
  String get offerDetailsYear => 'Creation Year';

  @override
  String get offerDetailsDescription => 'Business Description';

  @override
  String get offerDetailsExtended => 'Additional Information';

  @override
  String get offerDetailsApplyButton => 'Request Information';

  @override
  String get offerDetailsPublished => 'Published';

  @override
  String get inboxTitle => 'Requests Inbox';

  @override
  String get inboxTabReceived => 'Received';

  @override
  String get inboxTabSent => 'Sent';

  @override
  String get inboxEmptyReceived =>
      'You haven\'t received any access requests yet';

  @override
  String get inboxEmptySent => 'You haven\'t sent any access requests yet';

  @override
  String get inboxStatusPending => 'Pending';

  @override
  String get inboxStatusAccepted => 'Accepted';

  @override
  String get inboxStatusRejected => 'Rejected';

  @override
  String get inboxActionAccept => 'Accept';

  @override
  String get inboxActionReject => 'Reject';

  @override
  String get inboxMessageLabel => 'Message';

  @override
  String get offerApplyFormTitle => 'Access Request';

  @override
  String get offerApplyBackgroundLabel => 'Professional Background';

  @override
  String get offerApplyBackgroundHint =>
      'Explain your background or experience in the sector...';

  @override
  String get offerApplyRegionsLabel => 'Preferred Regions for Transfer';

  @override
  String get offerApplyRegionsHint =>
      'e.g., Gironès, Osona, Andorra (comma-separated)...';

  @override
  String get offerApplyBioLabel => 'Biography';

  @override
  String get offerApplyBioHint =>
      'Write a brief description of who you are and your values...';

  @override
  String get offerApplyCvLabel => 'Curriculum Vitae (PDF)';

  @override
  String get offerApplyCvSelect => 'Attach your CV in PDF format';

  @override
  String offerApplyCvSelected(Object filename) {
    return 'CV attached: $filename';
  }

  @override
  String get offerApplySubmitButton => 'Send Request to Owner';

  @override
  String get offerApplyRequiredError => 'This field is required';

  @override
  String offerApplyMinLengthError(Object min) {
    return 'Must be at least $min characters long';
  }

  @override
  String get offerApplyCvError => 'Please attach your PDF resume';

  @override
  String get offerApplyCapitalLabel => 'Available capital (€)';

  @override
  String get offerApplyCapitalHint => 'e.g., 50000';

  @override
  String get offerApplyCapitalError => 'Enter a valid amount (>= 0)';

  @override
  String get offerApplyFinancingLabel => 'Do you need financing?';

  @override
  String get offerApplyNdaLabel =>
      'I accept the non-disclosure agreement (NDA) and commit to keep the details of the offer confidential.';

  @override
  String get offerApplyNdaError =>
      'You must accept the non-disclosure agreement to continue.';

  @override
  String get offerApplySuccessTitle => 'Request sent!';

  @override
  String get offerApplySuccessMessage =>
      'Your request has been successfully sent to the owner of the offer.';

  @override
  String get offerApplySuccessOk => 'Got it';

  @override
  String offerApplyErrorPrefix(Object error) {
    return 'Error sending request: $error';
  }

  @override
  String get inboxErrorLoading => 'Error loading requests';

  @override
  String get inboxRetry => 'Retry';

  @override
  String get inboxStatusUpdatedSuccessfully => 'successfully.';

  @override
  String get inboxOwnerLabel => 'Owner';

  @override
  String get inboxNotAvailable => 'N/A';

  @override
  String get solicitudApplicantData => 'Applicant details';

  @override
  String get solicitudNoBio => 'No biography specified.';

  @override
  String get solicitudNoBackground => 'No professional background specified.';

  @override
  String get solicitudPreferencesFinance => 'Preferences & Financials';

  @override
  String get solicitudAllRegions => 'All regions';

  @override
  String get solicitudNotSpecified => 'Not specified';

  @override
  String get solicitudYes => 'Yes';

  @override
  String get solicitudNo => 'No';

  @override
  String get solicitudDocSecurity => 'Documentation & Security';

  @override
  String get solicitudNdaTitle => 'Non-Disclosure Agreement (NDA)';

  @override
  String get solicitudAccepted => 'Accepted';

  @override
  String get solicitudCvTitle => 'Curriculum Vitae';

  @override
  String get solicitudCvPdfSubtitle => 'Attached PDF file';

  @override
  String get solicitudCvView => 'View';

  @override
  String get solicitudCvPreviewComingSoon => 'CV preview coming soon!';

  @override
  String get profileMentoring => 'Mentoring Program';

  @override
  String get mentoringTitle => 'Mentoring';

  @override
  String get mentoringProgressLabel => 'Your progress';

  @override
  String mentoringDurationMinutes(Object duration) {
    return '$duration min';
  }

  @override
  String get mentoringModuleCompleted => 'Completed';

  @override
  String get mentoringModulePending => 'Pending';

  @override
  String get mentoringCompletedAlert =>
      'Congratulations! You have completed this mentoring module.';

  @override
  String get mentoringMarkAsCompleted => 'Mark as Completed';

  @override
  String get mentoringItemTip => 'Tip';

  @override
  String get mentoringItemQuestion => 'Question';

  @override
  String get mentoringItemTask => 'Task';

  @override
  String get mentoringDetailTitle => 'Module Details';

  @override
  String get mentoringLoading => 'Loading mentoring...';

  @override
  String mentoringError(Object error) {
    return 'Error loading mentoring: $error';
  }

  @override
  String get profileAlerts => 'Search Alerts';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get alertsTitle => 'Manage Alerts';

  @override
  String get alertsEmpty => 'You have no configured alerts.';

  @override
  String get alertsCreateButton => 'Activate Alert';

  @override
  String get alertsDeleteSuccess => 'Alert deleted successfully';

  @override
  String get alertsCreateSuccess => 'Alert created successfully';

  @override
  String get alertsSelectRevenue => 'Select the revenue range of interest:';

  @override
  String get notificationsTitle => 'Notification Inbox';

  @override
  String get notificationsEmpty => 'You have no notifications.';

  @override
  String notificationsNewOffer(Object sector) {
    return 'A new offer in the $sector sector has been published that matches your preferences.';
  }

  @override
  String get revenueRangeUNDER_100K => 'Under 100K €';

  @override
  String get revenueRangeBETWEEN_100K_500K => 'Between 100K € and 500K €';

  @override
  String get revenueRangeBETWEEN_500K_1M => 'Between 500K € and 1M €';

  @override
  String get revenueRangeBETWEEN_1M_5M => 'Between 1M € and 5M €';

  @override
  String get revenueRangeOVER_5M => 'Over 5M €';

  @override
  String get mentoringTabBuy => 'I want to buy';

  @override
  String get mentoringTabSell => 'I want to sell';

  @override
  String get mentoringNoModules => 'No modules in this route';

  @override
  String mentoringErrorLoadingContent(Object error) {
    return 'Error loading content: $error';
  }

  @override
  String get mentoring_seller_m1_title => 'Preparing the company for sale';

  @override
  String get mentoring_seller_m1_description =>
      'Learn to identify the best time to sell, understand common reasons for selling, and avoid frequent mistakes before publishing the listing.';

  @override
  String get mentoring_seller_m1_i1_title => 'Prepare the sale';

  @override
  String get mentoring_seller_m2_title => 'Organizing the documentation';

  @override
  String get mentoring_seller_m2_description =>
      'Prepare the financial, legal, and operational documentation necessary to build trust with potential buyers.';

  @override
  String get mentoring_seller_m2_i1_title => 'Key documentation';

  @override
  String get mentoring_seller_m3_title => 'Valuing the company';

  @override
  String get mentoring_seller_m3_description =>
      'Understand which factors determine the value of a company, such as profitability, assets, and growth potential.';

  @override
  String get mentoring_seller_m3_i1_title => 'Business valuation';

  @override
  String get mentoring_seller_m4_title => 'Creating an attractive listing';

  @override
  String get mentoring_seller_m4_description =>
      'Learn to present the business professionally, highlighting strengths and protecting confidential information.';

  @override
  String get mentoring_seller_m4_i1_title => 'Professional presentation';

  @override
  String get mentoring_seller_m5_title => 'Managing contacts and negotiations';

  @override
  String get mentoring_seller_m5_description =>
      'Screen potential buyers, share information progressively, and manage negotiations professionally.';

  @override
  String get mentoring_seller_m5_i1_title => 'The negotiation process';

  @override
  String get mentoring_seller_m6_title => 'Closing the sale';

  @override
  String get mentoring_seller_m6_description =>
      'Complete the final phases of the process, including Due Diligence, signing contracts, and preparing the transition.';

  @override
  String get mentoring_seller_m6_i1_title => 'Closing the sale';

  @override
  String get mentoring_buyer_m1_title => 'Defining buying objectives';

  @override
  String get mentoring_buyer_m1_description =>
      'Determine the available budget, sectors of interest, and characteristics that the ideal company should have.';

  @override
  String get mentoring_buyer_m1_i1_title => 'Define criteria';

  @override
  String get mentoring_buyer_m2_title => 'Searching for opportunities';

  @override
  String get mentoring_buyer_m2_description =>
      'Learn where to find companies for sale and how to perform an initial screening of potential opportunities.';

  @override
  String get mentoring_buyer_m2_i1_title => 'Searching for opportunities';

  @override
  String get mentoring_buyer_m3_title => 'Analyzing the financial situation';

  @override
  String get mentoring_buyer_m3_description =>
      'Interpret the financial information of the company, including revenue, profits, debt, and liquidity.';

  @override
  String get mentoring_buyer_m3_i1_title => 'Financial analysis';

  @override
  String get mentoring_buyer_m4_title => 'Assessing if the price is right';

  @override
  String get mentoring_buyer_m4_description =>
      'Analyze whether the valuation proposed by the seller is consistent with the reality and potential of the business.';

  @override
  String get mentoring_buyer_m4_i1_title => 'Evaluating the valuation';

  @override
  String get mentoring_buyer_m5_title => 'Negotiating the purchase';

  @override
  String get mentoring_buyer_m5_description =>
      'Prepare to negotiate the price and conditions of the transaction, identifying risks and opportunities.';

  @override
  String get mentoring_buyer_m5_i1_title => 'Negotiation strategies';

  @override
  String get mentoring_buyer_m6_title => 'Formalizing the acquisition';

  @override
  String get mentoring_buyer_m6_description =>
      'Review legal documentation, complete Due Diligence, and formalize the purchase using the corresponding contracts.';

  @override
  String get mentoring_buyer_m6_i1_title => 'Contracts and closing';

  @override
  String get mentoring_buyer_m7_title => 'Managing the company after purchase';

  @override
  String get mentoring_buyer_m7_description =>
      'Plan the transition, maintain the trust of the team and clients, and lay the foundation for future business growth.';

  @override
  String get mentoring_buyer_m7_i1_title => 'Transfer of powers';
}
