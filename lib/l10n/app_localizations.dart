import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taksh E-Commerce'**
  String get appTitle;

  /// No description provided for @madeInIndia.
  ///
  /// In en, this message translates to:
  /// **'Made in India'**
  String get madeInIndia;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @checkingAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get checkingAuthentication;

  /// No description provided for @loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Food delivered to your doorstep'**
  String get loginTagline;

  /// No description provided for @enterPhoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive OTP'**
  String get enterPhoneDescription;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit phone number'**
  String get enterPhoneNumberHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @enterOtpDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to {phone}'**
  String enterOtpDescription(String phone);

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'0000'**
  String get otpHint;

  /// No description provided for @verifyOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpButton;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didNotReceiveCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @otpResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccess;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
  String get invalidPhone;

  /// No description provided for @otpRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get otpRequired;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 4-digit OTP'**
  String get invalidOtp;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @themeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme changed to {theme}'**
  String themeChanged(String theme);

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @myAddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myAddress;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @paymentMethodsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods - Coming Soon'**
  String get paymentMethodsComingSoon;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @joinAsDeliveryMan.
  ///
  /// In en, this message translates to:
  /// **'Join as Delivery Man'**
  String get joinAsDeliveryMan;

  /// No description provided for @openVendor.
  ///
  /// In en, this message translates to:
  /// **'Open Vendor'**
  String get openVendor;

  /// No description provided for @languageSettingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language Settings - Coming Soon'**
  String get languageSettingsComingSoon;

  /// No description provided for @createApplication.
  ///
  /// In en, this message translates to:
  /// **'Create Application'**
  String get createApplication;

  /// No description provided for @createWebsite.
  ///
  /// In en, this message translates to:
  /// **'Create Website'**
  String get createWebsite;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refundPolicy;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @standardDelivery.
  ///
  /// In en, this message translates to:
  /// **'Standard Delivery'**
  String get standardDelivery;

  /// No description provided for @standardDeliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Standard Delivery - Shop Your Favorites!'**
  String get standardDeliveryDescription;

  /// No description provided for @quickDelivery.
  ///
  /// In en, this message translates to:
  /// **'Quick Delivery'**
  String get quickDelivery;

  /// No description provided for @quickDeliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick Delivery - Express 30'**
  String get quickDeliveryDescription;

  /// No description provided for @homeService.
  ///
  /// In en, this message translates to:
  /// **'Home Service'**
  String get homeService;

  /// No description provided for @homeServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore home services coming soon'**
  String get homeServiceDescription;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get searchHint;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit app?'**
  String get exitAppTitle;

  /// No description provided for @exitAppContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitAppContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @categoriesTab.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTab;

  /// No description provided for @cartTab.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTab;

  /// No description provided for @ordersTab.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Cart is Empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add items to get started'**
  String get cartEmptySubtitle;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU: {sku}'**
  String sku(String sku);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total: ₹{amount}'**
  String total(String amount);

  /// No description provided for @removeItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Item'**
  String get removeItemTitle;

  /// No description provided for @removeItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {product} from cart?'**
  String removeItemConfirm(String product);

  /// No description provided for @clearCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove all items from cart?'**
  String get clearCartConfirm;

  /// No description provided for @totalItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Items: {count}'**
  String totalItemsLabel(int count);

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// No description provided for @allOrders.
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get allOrders;

  /// No description provided for @readyForDispatch.
  ///
  /// In en, this message translates to:
  /// **'Ready for Dispatch'**
  String get readyForDispatch;

  /// No description provided for @dispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched'**
  String get dispatched;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @dateNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Date: Newest First'**
  String get dateNewestFirst;

  /// No description provided for @dateOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Date: Oldest First'**
  String get dateOldestFirst;

  /// No description provided for @amountHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Amount: High to Low'**
  String get amountHighToLow;

  /// No description provided for @amountLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Amount: Low to High'**
  String get amountLowToHigh;

  /// No description provided for @recentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recently Updated'**
  String get recentlyUpdated;

  /// No description provided for @leastRecentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Least Recently Updated'**
  String get leastRecentlyUpdated;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get filterByDate;

  /// No description provided for @clearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear date filter'**
  String get clearDateFilter;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get noOrdersYet;

  /// No description provided for @yourOrdersAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your orders will appear here'**
  String get yourOrdersAppearHere;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String orderNumber(String number);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(int days);

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemsCount(int count);

  /// No description provided for @estDelivery.
  ///
  /// In en, this message translates to:
  /// **'Est. delivery: {date}'**
  String estDelivery(String date);

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @placedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on {date}'**
  String placedOn(String date);

  /// No description provided for @deliveryType.
  ///
  /// In en, this message translates to:
  /// **'Delivery Type'**
  String get deliveryType;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDelivery;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Order Items ({count})'**
  String orderItems(int count);

  /// No description provided for @qtyPrice.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} × ₹{price}'**
  String qtyPrice(int qty, String price);

  /// No description provided for @returnItem.
  ///
  /// In en, this message translates to:
  /// **'Return Item'**
  String get returnItem;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInformation;

  /// No description provided for @paidVia.
  ///
  /// In en, this message translates to:
  /// **'Paid via {method}'**
  String paidVia(String method);

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @whatsappError.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp. Please make sure WhatsApp is installed.'**
  String get whatsappError;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String lastUpdated(String date);

  /// No description provided for @termsIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get termsIntroTitle;

  /// No description provided for @termsIntroContent.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our E-Commerce platform. These Terms and Conditions govern your use of our mobile application and services. By accessing or using our app, you agree to be bound by these terms. If you disagree with any part of these terms, you may not access our service.'**
  String get termsIntroContent;

  /// No description provided for @termsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Account Registration'**
  String get termsAccountTitle;

  /// No description provided for @termsAccountContent.
  ///
  /// In en, this message translates to:
  /// **'To use certain features of our service, you must register for an account. You agree to:\n\n• Provide accurate and complete information\n• Maintain the security of your password\n• Notify us immediately of any unauthorized use\n• Accept responsibility for all activities under your account'**
  String get termsAccountContent;

  /// No description provided for @termsUserRespTitle.
  ///
  /// In en, this message translates to:
  /// **'3. User Responsibilities'**
  String get termsUserRespTitle;

  /// No description provided for @termsUserRespContent.
  ///
  /// In en, this message translates to:
  /// **'As a user of our platform, you agree to:\n\n• Use the service only for lawful purposes\n• Not violate any applicable laws or regulations\n• Not infringe on intellectual property rights\n• Not transmit harmful or malicious code\n• Not attempt to gain unauthorized access to our systems'**
  String get termsUserRespContent;

  /// No description provided for @termsProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Products and Services'**
  String get termsProductsTitle;

  /// No description provided for @termsProductsContent.
  ///
  /// In en, this message translates to:
  /// **'We strive to provide accurate product descriptions and pricing. However:\n\n• Product images are for illustration purposes\n• We reserve the right to modify prices without notice\n• Product availability may vary\n• We are not liable for pricing or description errors'**
  String get termsProductsContent;

  /// No description provided for @termsOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Orders and Payment'**
  String get termsOrdersTitle;

  /// No description provided for @termsOrdersContent.
  ///
  /// In en, this message translates to:
  /// **'When placing an order, you agree that:\n\n• All information provided is accurate\n• You are authorized to use the payment method\n• You will pay all applicable charges\n• Orders are subject to acceptance and availability\n• We may cancel orders for any reason'**
  String get termsOrdersContent;

  /// No description provided for @termsShippingTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Shipping and Delivery'**
  String get termsShippingTitle;

  /// No description provided for @termsShippingContent.
  ///
  /// In en, this message translates to:
  /// **'For shipping and delivery:\n\n• Delivery times are estimates only\n• We are not responsible for delays beyond our control\n• Risk of loss passes to you upon delivery\n• You must inspect items upon delivery\n• Delivery address must be accurate and complete'**
  String get termsShippingContent;

  /// No description provided for @termsReturnsTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Returns and Refunds'**
  String get termsReturnsTitle;

  /// No description provided for @termsReturnsContent.
  ///
  /// In en, this message translates to:
  /// **'Our return and refund policy includes:\n\n• Items must be returned within the specified period\n• Products must be in original condition\n• Proof of purchase is required\n• Refunds will be processed to the original payment method\n• Some items may not be eligible for return'**
  String get termsReturnsContent;

  /// No description provided for @termsIpTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Intellectual Property'**
  String get termsIpTitle;

  /// No description provided for @termsIpContent.
  ///
  /// In en, this message translates to:
  /// **'All content on our platform, including but not limited to text, graphics, logos, images, and software, is our property or that of our licensors and is protected by copyright, trademark, and other intellectual property laws.'**
  String get termsIpContent;

  /// No description provided for @termsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'9. Privacy and Data Protection'**
  String get termsPrivacyTitle;

  /// No description provided for @termsPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. We collect and use your personal information in accordance with our Privacy Policy. By using our service, you consent to our collection and use of your information as described.'**
  String get termsPrivacyContent;

  /// No description provided for @termsLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'10. Limitation of Liability'**
  String get termsLiabilityTitle;

  /// No description provided for @termsLiabilityContent.
  ///
  /// In en, this message translates to:
  /// **'To the maximum extent permitted by law:\n\n• We are not liable for indirect or consequential damages\n• Our total liability is limited to the amount paid by you\n• We do not guarantee uninterrupted or error-free service\n• We are not responsible for third-party content or services'**
  String get termsLiabilityContent;

  /// No description provided for @termsIndemnifyTitle.
  ///
  /// In en, this message translates to:
  /// **'11. Indemnification'**
  String get termsIndemnifyTitle;

  /// No description provided for @termsIndemnifyContent.
  ///
  /// In en, this message translates to:
  /// **'You agree to indemnify and hold us harmless from any claims, damages, losses, liabilities, and expenses arising from your use of our service or violation of these terms.'**
  String get termsIndemnifyContent;

  /// No description provided for @termsModTitle.
  ///
  /// In en, this message translates to:
  /// **'12. Modifications to Terms'**
  String get termsModTitle;

  /// No description provided for @termsModContent.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms at any time. We will notify you of significant changes. Your continued use of the service after changes constitutes acceptance of the modified terms.'**
  String get termsModContent;

  /// No description provided for @termsTerminationTitle.
  ///
  /// In en, this message translates to:
  /// **'13. Termination'**
  String get termsTerminationTitle;

  /// No description provided for @termsTerminationContent.
  ///
  /// In en, this message translates to:
  /// **'We may terminate or suspend your account and access to our service immediately, without prior notice, for any reason, including breach of these terms.'**
  String get termsTerminationContent;

  /// No description provided for @termsLawTitle.
  ///
  /// In en, this message translates to:
  /// **'14. Governing Law'**
  String get termsLawTitle;

  /// No description provided for @termsLawContent.
  ///
  /// In en, this message translates to:
  /// **'These terms are governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.'**
  String get termsLawContent;

  /// No description provided for @termsContactTitle.
  ///
  /// In en, this message translates to:
  /// **'15. Contact Information'**
  String get termsContactTitle;

  /// No description provided for @termsContactContent.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms and Conditions, please contact us:\n\nEmail: support@taksh-ecommerce.com\nPhone: +91 1800-123-4567\nAddress: Mumbai, Maharashtra, India'**
  String get termsContactContent;

  /// No description provided for @termsAck.
  ///
  /// In en, this message translates to:
  /// **'By using our service, you acknowledge that you have read and understood these Terms & Conditions.'**
  String get termsAck;

  /// No description provided for @refundCommitmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Commitment'**
  String get refundCommitmentTitle;

  /// No description provided for @refundCommitmentContent.
  ///
  /// In en, this message translates to:
  /// **'At Taksh E-Commerce, customer satisfaction is our top priority. We want you to be completely satisfied with your purchase. If you\'re not happy with your order, we\'re here to help with our easy return and refund process.'**
  String get refundCommitmentContent;

  /// No description provided for @refundReadPolicy.
  ///
  /// In en, this message translates to:
  /// **'Please read this policy carefully to understand your rights and responsibilities regarding returns and refunds.'**
  String get refundReadPolicy;

  /// No description provided for @refundEligibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Return Eligibility'**
  String get refundEligibilityTitle;

  /// No description provided for @refundEligibilityContent.
  ///
  /// In en, this message translates to:
  /// **'You can return most items within 7 days of delivery if:'**
  String get refundEligibilityContent;

  /// No description provided for @refundEligibilityItem1.
  ///
  /// In en, this message translates to:
  /// **'The item is unused and in its original condition'**
  String get refundEligibilityItem1;

  /// No description provided for @refundEligibilityItem2.
  ///
  /// In en, this message translates to:
  /// **'All original packaging, tags, and labels are intact'**
  String get refundEligibilityItem2;

  /// No description provided for @refundEligibilityItem3.
  ///
  /// In en, this message translates to:
  /// **'You have proof of purchase (order confirmation or invoice)'**
  String get refundEligibilityItem3;

  /// No description provided for @refundEligibilityItem4.
  ///
  /// In en, this message translates to:
  /// **'The product is not on the non-returnable list'**
  String get refundEligibilityItem4;

  /// No description provided for @refundEligibilityItem5.
  ///
  /// In en, this message translates to:
  /// **'The item has not been damaged or altered'**
  String get refundEligibilityItem5;

  /// No description provided for @refundNonReturnableTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Non-Returnable Items'**
  String get refundNonReturnableTitle;

  /// No description provided for @refundNonReturnableContent.
  ///
  /// In en, this message translates to:
  /// **'The following items cannot be returned:'**
  String get refundNonReturnableContent;

  /// No description provided for @refundNonReturnableItem1.
  ///
  /// In en, this message translates to:
  /// **'Perishable goods (food, flowers, etc.)'**
  String get refundNonReturnableItem1;

  /// No description provided for @refundNonReturnableItem2.
  ///
  /// In en, this message translates to:
  /// **'Intimate or sanitary products'**
  String get refundNonReturnableItem2;

  /// No description provided for @refundNonReturnableItem3.
  ///
  /// In en, this message translates to:
  /// **'Customized or personalized items'**
  String get refundNonReturnableItem3;

  /// No description provided for @refundNonReturnableItem4.
  ///
  /// In en, this message translates to:
  /// **'Digital products and downloads'**
  String get refundNonReturnableItem4;

  /// No description provided for @refundNonReturnableItem5.
  ///
  /// In en, this message translates to:
  /// **'Gift cards and vouchers'**
  String get refundNonReturnableItem5;

  /// No description provided for @refundNonReturnableItem6.
  ///
  /// In en, this message translates to:
  /// **'Products marked as \"non-returnable\" at the time of purchase'**
  String get refundNonReturnableItem6;

  /// No description provided for @refundProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Return Process'**
  String get refundProcessTitle;

  /// No description provided for @refundProcessContent.
  ///
  /// In en, this message translates to:
  /// **'Follow these simple steps to initiate a return:'**
  String get refundProcessContent;

  /// No description provided for @refundStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Initiate Return Request'**
  String get refundStep1Title;

  /// No description provided for @refundStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Go to \"Your Orders\" section in the app and select the item you want to return. Choose the return reason and submit your request.'**
  String get refundStep1Desc;

  /// No description provided for @refundStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Return Approval'**
  String get refundStep2Title;

  /// No description provided for @refundStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Our team will review your request within 24 hours. You\'ll receive a confirmation email with return instructions.'**
  String get refundStep2Desc;

  /// No description provided for @refundStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Pack the Item'**
  String get refundStep3Title;

  /// No description provided for @refundStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Pack the item securely in its original packaging with all accessories, tags, and invoice.'**
  String get refundStep3Desc;

  /// No description provided for @refundStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Pickup or Drop-off'**
  String get refundStep4Title;

  /// No description provided for @refundStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose between free pickup from your address or drop-off at our partner locations.'**
  String get refundStep4Desc;

  /// No description provided for @refundTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Refund Timeline'**
  String get refundTimelineTitle;

  /// No description provided for @refundTimelineContent.
  ///
  /// In en, this message translates to:
  /// **'After we receive your returned item:'**
  String get refundTimelineContent;

  /// No description provided for @refundTimelineItem1Day.
  ///
  /// In en, this message translates to:
  /// **'Day 1-2'**
  String get refundTimelineItem1Day;

  /// No description provided for @refundTimelineItem1Desc.
  ///
  /// In en, this message translates to:
  /// **'Item received at our facility and quality check initiated'**
  String get refundTimelineItem1Desc;

  /// No description provided for @refundTimelineItem2Day.
  ///
  /// In en, this message translates to:
  /// **'Day 3-4'**
  String get refundTimelineItem2Day;

  /// No description provided for @refundTimelineItem2Desc.
  ///
  /// In en, this message translates to:
  /// **'Quality inspection completed and refund approved'**
  String get refundTimelineItem2Desc;

  /// No description provided for @refundTimelineItem3Day.
  ///
  /// In en, this message translates to:
  /// **'Day 5-7'**
  String get refundTimelineItem3Day;

  /// No description provided for @refundTimelineItem3Desc.
  ///
  /// In en, this message translates to:
  /// **'Refund processed to your original payment method'**
  String get refundTimelineItem3Desc;

  /// No description provided for @refundProcessingNote.
  ///
  /// In en, this message translates to:
  /// **'Bank processing may take an additional 3-5 business days depending on your bank.'**
  String get refundProcessingNote;

  /// No description provided for @refundMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Refund Methods'**
  String get refundMethodsTitle;

  /// No description provided for @refundMethodsContent.
  ///
  /// In en, this message translates to:
  /// **'Refunds will be processed through:'**
  String get refundMethodsContent;

  /// No description provided for @refundMethodOriginalTitle.
  ///
  /// In en, this message translates to:
  /// **'Original Payment Method'**
  String get refundMethodOriginalTitle;

  /// No description provided for @refundMethodOriginalDesc.
  ///
  /// In en, this message translates to:
  /// **'Refunded to the same card/UPI/wallet used for purchase'**
  String get refundMethodOriginalDesc;

  /// No description provided for @refundMethodOriginalDays.
  ///
  /// In en, this message translates to:
  /// **'5-7 days'**
  String get refundMethodOriginalDays;

  /// No description provided for @refundMethodCreditTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Credit'**
  String get refundMethodCreditTitle;

  /// No description provided for @refundMethodCreditDesc.
  ///
  /// In en, this message translates to:
  /// **'Instant credit to your Taksh E-Commerce wallet for future purchases'**
  String get refundMethodCreditDesc;

  /// No description provided for @refundMethodCreditDays.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get refundMethodCreditDays;

  /// No description provided for @refundMethodBankTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get refundMethodBankTitle;

  /// No description provided for @refundMethodBankDesc.
  ///
  /// In en, this message translates to:
  /// **'Direct transfer to your bank account (requires account details)'**
  String get refundMethodBankDesc;

  /// No description provided for @refundMethodBankDays.
  ///
  /// In en, this message translates to:
  /// **'7-10 days'**
  String get refundMethodBankDays;

  /// No description provided for @refundDamagedTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Damaged or Defective Products'**
  String get refundDamagedTitle;

  /// No description provided for @refundDamagedContent.
  ///
  /// In en, this message translates to:
  /// **'If you receive a damaged or defective product:\n\n• Report within 48 hours of delivery\n• Provide clear photos of the damage/defect\n• We will arrange immediate pickup\n• Replacement or full refund will be processed\n• No questions asked for genuine cases'**
  String get refundDamagedContent;

  /// No description provided for @refundWrongTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Wrong Product Delivered'**
  String get refundWrongTitle;

  /// No description provided for @refundWrongContent.
  ///
  /// In en, this message translates to:
  /// **'If you receive the wrong product:\n\n• Contact us immediately through the app\n• We will arrange free return pickup\n• Correct product will be shipped immediately\n• If correct product is unavailable, full refund will be issued'**
  String get refundWrongContent;

  /// No description provided for @refundPartialTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Partial Refunds'**
  String get refundPartialTitle;

  /// No description provided for @refundPartialContent.
  ///
  /// In en, this message translates to:
  /// **'In certain situations, partial refunds may be granted:'**
  String get refundPartialContent;

  /// No description provided for @refundPartialItem1.
  ///
  /// In en, this message translates to:
  /// **'Items returned after the return window but within 15 days'**
  String get refundPartialItem1;

  /// No description provided for @refundPartialItem2.
  ///
  /// In en, this message translates to:
  /// **'Products with signs of use or minor damage'**
  String get refundPartialItem2;

  /// No description provided for @refundPartialItem3.
  ///
  /// In en, this message translates to:
  /// **'Items missing accessories or packaging'**
  String get refundPartialItem3;

  /// No description provided for @refundPartialItem4.
  ///
  /// In en, this message translates to:
  /// **'Discounted or sale items (as per terms)'**
  String get refundPartialItem4;

  /// No description provided for @refundExchangeTitle.
  ///
  /// In en, this message translates to:
  /// **'9. Exchange Policy'**
  String get refundExchangeTitle;

  /// No description provided for @refundExchangeContent.
  ///
  /// In en, this message translates to:
  /// **'We offer easy exchanges for:\n\n• Size or color variations\n• Different product models\n• Upgraded versions\n\nThe exchange process is similar to returns, but you can select a replacement product during the return request.'**
  String get refundExchangeContent;

  /// No description provided for @refundCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'10. Cancellation Policy'**
  String get refundCancelTitle;

  /// No description provided for @refundCancelContent.
  ///
  /// In en, this message translates to:
  /// **'You can cancel your order before it is shipped:\n\n• Full refund for pre-shipment cancellations\n• Instant processing to original payment method\n• No cancellation charges\n• Refund within 3-5 business days'**
  String get refundCancelContent;

  /// No description provided for @refundContactTitle.
  ///
  /// In en, this message translates to:
  /// **'11. Contact for Returns'**
  String get refundContactTitle;

  /// No description provided for @refundContactContent.
  ///
  /// In en, this message translates to:
  /// **'Need help with returns or refunds? Reach out to us:\n\nEmail: returns@taksh-ecommerce.com\nLive Chat: Available 24/7 in the app\n\nOur customer support team is here to assist you throughout the return and refund process.'**
  String get refundContactContent;

  /// No description provided for @refundSatisfactionTitle.
  ///
  /// In en, this message translates to:
  /// **'100% Satisfaction Guarantee'**
  String get refundSatisfactionTitle;

  /// No description provided for @refundSatisfactionContent.
  ///
  /// In en, this message translates to:
  /// **'We stand behind our products and are committed to your satisfaction.'**
  String get refundSatisfactionContent;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroContent.
  ///
  /// In en, this message translates to:
  /// **'At Taksh E-Commerce, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.'**
  String get privacyIntroContent;

  /// No description provided for @privacyAgreeContent.
  ///
  /// In en, this message translates to:
  /// **'By using our app, you agree to the collection and use of information in accordance with this policy.'**
  String get privacyAgreeContent;

  /// No description provided for @privacyCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacyCollectTitle;

  /// No description provided for @privacyCollectContent.
  ///
  /// In en, this message translates to:
  /// **'We collect several types of information for various purposes:'**
  String get privacyCollectContent;

  /// No description provided for @privacyPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get privacyPersonalTitle;

  /// No description provided for @privacyPersonalContent.
  ///
  /// In en, this message translates to:
  /// **'• Name, email address, and phone number\n• Shipping and billing addresses\n• Payment information (securely processed)\n• Date of birth (optional)\n• Profile picture (optional)'**
  String get privacyPersonalContent;

  /// No description provided for @privacyUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage Data'**
  String get privacyUsageTitle;

  /// No description provided for @privacyUsageContent.
  ///
  /// In en, this message translates to:
  /// **'• App usage statistics and preferences\n• Device information (model, OS version)\n• IP address and location data\n• Cookies and similar tracking technologies\n• Search queries and browsing history'**
  String get privacyUsageContent;

  /// No description provided for @privacyTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Data'**
  String get privacyTransactionTitle;

  /// No description provided for @privacyTransactionContent.
  ///
  /// In en, this message translates to:
  /// **'• Purchase history and order details\n• Payment transaction information\n• Delivery and shipping information\n• Product reviews and ratings'**
  String get privacyTransactionContent;

  /// No description provided for @privacyUseTitle.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacyUseTitle;

  /// No description provided for @privacyUseContent.
  ///
  /// In en, this message translates to:
  /// **'We use your information for the following purposes:'**
  String get privacyUseContent;

  /// No description provided for @privacyUseItem1.
  ///
  /// In en, this message translates to:
  /// **'Process and fulfill your orders'**
  String get privacyUseItem1;

  /// No description provided for @privacyUseItem2.
  ///
  /// In en, this message translates to:
  /// **'Provide customer support and respond to inquiries'**
  String get privacyUseItem2;

  /// No description provided for @privacyUseItem3.
  ///
  /// In en, this message translates to:
  /// **'Send order confirmations and shipping updates'**
  String get privacyUseItem3;

  /// No description provided for @privacyUseItem4.
  ///
  /// In en, this message translates to:
  /// **'Personalize your shopping experience'**
  String get privacyUseItem4;

  /// No description provided for @privacyUseItem5.
  ///
  /// In en, this message translates to:
  /// **'Improve our products and services'**
  String get privacyUseItem5;

  /// No description provided for @privacyUseItem6.
  ///
  /// In en, this message translates to:
  /// **'Send promotional offers and marketing communications'**
  String get privacyUseItem6;

  /// No description provided for @privacyUseItem7.
  ///
  /// In en, this message translates to:
  /// **'Detect and prevent fraud and security issues'**
  String get privacyUseItem7;

  /// No description provided for @privacyUseItem8.
  ///
  /// In en, this message translates to:
  /// **'Comply with legal obligations'**
  String get privacyUseItem8;

  /// No description provided for @privacyUseItem9.
  ///
  /// In en, this message translates to:
  /// **'Analyze usage trends and optimize app performance'**
  String get privacyUseItem9;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Information Sharing and Disclosure'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingContent.
  ///
  /// In en, this message translates to:
  /// **'We may share your information with:'**
  String get privacySharingContent;

  /// No description provided for @privacyProvidersTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Providers'**
  String get privacyProvidersTitle;

  /// No description provided for @privacyProvidersContent.
  ///
  /// In en, this message translates to:
  /// **'Third-party vendors who assist us in operating our platform, processing payments, shipping orders, and providing customer service.'**
  String get privacyProvidersContent;

  /// No description provided for @privacyPartnersTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Partners'**
  String get privacyPartnersTitle;

  /// No description provided for @privacyPartnersContent.
  ///
  /// In en, this message translates to:
  /// **'Trusted partners who offer complementary services or products that may interest you.'**
  String get privacyPartnersContent;

  /// No description provided for @privacyLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Requirements'**
  String get privacyLegalTitle;

  /// No description provided for @privacyLegalContent.
  ///
  /// In en, this message translates to:
  /// **'When required by law, regulation, legal process, or governmental request.'**
  String get privacyLegalContent;

  /// No description provided for @privacyTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Transfers'**
  String get privacyTransferTitle;

  /// No description provided for @privacyTransferContent.
  ///
  /// In en, this message translates to:
  /// **'In connection with a merger, acquisition, or sale of assets.'**
  String get privacyTransferContent;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityContent.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate technical and organizational measures to protect your personal information:\n\n• Encryption of sensitive data in transit and at rest\n• Secure servers and regular security audits\n• Access controls and authentication mechanisms\n• Regular security training for our staff\n• Compliance with industry security standards'**
  String get privacySecurityContent;

  /// No description provided for @privacySecurityNote.
  ///
  /// In en, this message translates to:
  /// **'While we strive to protect your information, no method of transmission over the internet is 100% secure.'**
  String get privacySecurityNote;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Your Privacy Rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the following rights regarding your personal information:'**
  String get privacyRightsContent;

  /// No description provided for @privacyRightsItem1.
  ///
  /// In en, this message translates to:
  /// **'Access: Request a copy of your personal data'**
  String get privacyRightsItem1;

  /// No description provided for @privacyRightsItem2.
  ///
  /// In en, this message translates to:
  /// **'Correction: Update or correct inaccurate information'**
  String get privacyRightsItem2;

  /// No description provided for @privacyRightsItem3.
  ///
  /// In en, this message translates to:
  /// **'Deletion: Request deletion of your personal data'**
  String get privacyRightsItem3;

  /// No description provided for @privacyRightsItem4.
  ///
  /// In en, this message translates to:
  /// **'Opt-out: Unsubscribe from marketing communications'**
  String get privacyRightsItem4;

  /// No description provided for @privacyRightsItem5.
  ///
  /// In en, this message translates to:
  /// **'Data Portability: Receive your data in a portable format'**
  String get privacyRightsItem5;

  /// No description provided for @privacyRightsItem6.
  ///
  /// In en, this message translates to:
  /// **'Object: Object to certain data processing activities'**
  String get privacyRightsItem6;

  /// No description provided for @privacyRightsItem7.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Consent: Withdraw previously given consent'**
  String get privacyRightsItem7;

  /// No description provided for @privacyCookiesTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Cookies and Tracking Technologies'**
  String get privacyCookiesTitle;

  /// No description provided for @privacyCookiesContent.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar technologies to:\n\n• Remember your preferences and settings\n• Understand how you use our app\n• Provide personalized content and advertisements\n• Analyze app performance and user behavior\n\nYou can control cookies through your device settings, though some features may not function properly if disabled.'**
  String get privacyCookiesContent;

  /// No description provided for @privacyLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Third-Party Links'**
  String get privacyLinksTitle;

  /// No description provided for @privacyLinksContent.
  ///
  /// In en, this message translates to:
  /// **'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies.'**
  String get privacyLinksContent;

  /// No description provided for @privacyChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Children\'s Privacy'**
  String get privacyChildrenTitle;

  /// No description provided for @privacyChildrenContent.
  ///
  /// In en, this message translates to:
  /// **'Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.'**
  String get privacyChildrenContent;

  /// No description provided for @privacyRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'9. Data Retention'**
  String get privacyRetentionTitle;

  /// No description provided for @privacyRetentionContent.
  ///
  /// In en, this message translates to:
  /// **'We retain your personal information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.'**
  String get privacyRetentionContent;

  /// No description provided for @privacyInternationalTitle.
  ///
  /// In en, this message translates to:
  /// **'10. International Data Transfers'**
  String get privacyInternationalTitle;

  /// No description provided for @privacyInternationalContent.
  ///
  /// In en, this message translates to:
  /// **'Your information may be transferred to and maintained on servers located outside your country. We ensure appropriate safeguards are in place for such transfers.'**
  String get privacyInternationalContent;

  /// No description provided for @privacyChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'11. Changes to This Privacy Policy'**
  String get privacyChangesTitle;

  /// No description provided for @privacyChangesContent.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy on this page and updating the \"Last Updated\" date.'**
  String get privacyChangesContent;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'12. Contact Us'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactContent.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy or our data practices, please contact us:\n\nEmail: privacy@taksh-ecommerce.com\nPhone: +91 1800-123-4567\nAddress: Mumbai, Maharashtra, India'**
  String get privacyContactContent;

  /// No description provided for @privacyMattersTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get privacyMattersTitle;

  /// No description provided for @privacyMattersContent.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your privacy and handling your data responsibly.'**
  String get privacyMattersContent;

  /// No description provided for @ourStoryContent.
  ///
  /// In en, this message translates to:
  /// **'Founded in 2020, Taksh E-Commerce emerged with a vision to revolutionize online shopping in India. We started with a simple idea: to make quality products accessible to everyone, everywhere. Today, we serve millions of customers across the country, offering a diverse range of products from electronics to fashion, home essentials to groceries.'**
  String get ourStoryContent;

  /// No description provided for @ourMissionContent.
  ///
  /// In en, this message translates to:
  /// **'Our mission is to empower consumers by providing a seamless, trustworthy, and delightful shopping experience. We strive to connect people with products they love while supporting local businesses and promoting sustainable practices.'**
  String get ourMissionContent;

  /// No description provided for @ourVisionContent.
  ///
  /// In en, this message translates to:
  /// **'To become India\'s most customer-centric e-commerce platform, where people can discover, explore, and purchase anything they want with complete confidence and convenience.'**
  String get ourVisionContent;

  /// No description provided for @trustTransparencyDesc.
  ///
  /// In en, this message translates to:
  /// **'We believe in building lasting relationships through honest communication and reliable service.'**
  String get trustTransparencyDesc;

  /// No description provided for @qualityFirstDesc.
  ///
  /// In en, this message translates to:
  /// **'Every product we offer meets our stringent quality standards to ensure customer satisfaction.'**
  String get qualityFirstDesc;

  /// No description provided for @customerCentricityDesc.
  ///
  /// In en, this message translates to:
  /// **'Our customers are at the heart of everything we do. Their satisfaction is our success.'**
  String get customerCentricityDesc;

  /// No description provided for @sustainabilityDesc.
  ///
  /// In en, this message translates to:
  /// **'We are committed to eco-friendly practices and reducing our environmental footprint.'**
  String get sustainabilityDesc;

  /// No description provided for @innovationDesc.
  ///
  /// In en, this message translates to:
  /// **'We continuously evolve our technology and services to provide the best shopping experience.'**
  String get innovationDesc;

  /// No description provided for @whatWeOfferContent.
  ///
  /// In en, this message translates to:
  /// **'• Wide Range of Products: From electronics to fashion, home & kitchen to beauty products\n\n• Competitive Prices: Best deals and offers on quality products\n\n• Fast Delivery: Quick and reliable shipping across India\n\n• Secure Payments: Multiple payment options with top-notch security\n\n• 24/7 Support: Our customer service team is always here to help\n\n• Easy Returns: Hassle-free returns and refunds'**
  String get whatWeOfferContent;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @addressValue.
  ///
  /// In en, this message translates to:
  /// **'Bhopal, Madhya Pradesh, India'**
  String get addressValue;

  /// No description provided for @updateProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfileTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @mobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobileLabel;

  /// No description provided for @saveDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Details'**
  String get saveDetails;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid name'**
  String get enterValidName;

  /// No description provided for @joinDeliveryManTitle.
  ///
  /// In en, this message translates to:
  /// **'Join as Delivery Man'**
  String get joinDeliveryManTitle;

  /// No description provided for @fillDetailsDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to join as a delivery partner'**
  String get fillDetailsDelivery;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @mobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get mobileRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @pincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincodeLabel;

  /// No description provided for @pincodeInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'Pincode must be 6 digits'**
  String get pincodeInvalidLength;

  /// No description provided for @pincodeInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Pincode must contain only numbers'**
  String get pincodeInvalidFormat;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @requiredFieldsNote.
  ///
  /// In en, this message translates to:
  /// **'* Required fields'**
  String get requiredFieldsNote;

  /// No description provided for @fillDetailsRequest.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to request {type}'**
  String fillDetailsRequest(String type);

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordComplexity.
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase, and number'**
  String get passwordComplexity;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @appDevelopment.
  ///
  /// In en, this message translates to:
  /// **'App Development'**
  String get appDevelopment;

  /// No description provided for @webDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Web Development'**
  String get webDevelopment;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryCharges.
  ///
  /// In en, this message translates to:
  /// **'Delivery Charges'**
  String get deliveryCharges;

  /// No description provided for @platformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee'**
  String get platformFee;

  /// No description provided for @cgst.
  ///
  /// In en, this message translates to:
  /// **'CGST'**
  String get cgst;

  /// No description provided for @sgst.
  ///
  /// In en, this message translates to:
  /// **'SGST'**
  String get sgst;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// No description provided for @otherCharges.
  ///
  /// In en, this message translates to:
  /// **'Other Charges'**
  String get otherCharges;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get free;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @returnOrder.
  ///
  /// In en, this message translates to:
  /// **'Return Order'**
  String get returnOrder;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help'**
  String get needHelp;

  /// No description provided for @orderIssues.
  ///
  /// In en, this message translates to:
  /// **'Do you have any issues with this order?'**
  String get orderIssues;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get chatWithUs;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send us an email'**
  String get sendEmail;

  /// No description provided for @returnFunctionalityComing.
  ///
  /// In en, this message translates to:
  /// **'Return functionality will be available soon. You can contact support for assistance.'**
  String get returnFunctionalityComing;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @similarProducts.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get similarProducts;

  /// No description provided for @selectVariant.
  ///
  /// In en, this message translates to:
  /// **'Select Variant'**
  String get selectVariant;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @failedToLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product'**
  String get failedToLoadProduct;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @typeMinCharsToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type at least {count} characters to start searching'**
  String typeMinCharsToSearch(int count);

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @deliveryOptions.
  ///
  /// In en, this message translates to:
  /// **'Delivery Options'**
  String get deliveryOptions;

  /// No description provided for @priceDetails.
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get priceDetails;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Pay'**
  String get proceedToPay;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @loadingOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading order details...'**
  String get loadingOrderDetails;

  /// No description provided for @addAddressToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please add a delivery address to continue'**
  String get addAddressToContinue;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @orderPlacedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully!'**
  String get orderPlacedSuccessfully;

  /// No description provided for @somethingWentWrongPayment.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with your payment'**
  String get somethingWentWrongPayment;

  /// No description provided for @viewOrder.
  ///
  /// In en, this message translates to:
  /// **'View Order'**
  String get viewOrder;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @selectAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get selectAddress;

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My Addresses'**
  String get myAddresses;

  /// No description provided for @noAddressesSaved.
  ///
  /// In en, this message translates to:
  /// **'No addresses saved'**
  String get noAddressesSaved;

  /// No description provided for @addFirstAddress.
  ///
  /// In en, this message translates to:
  /// **'Add your first address to get started'**
  String get addFirstAddress;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @deleteAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address? This action cannot be undone.'**
  String get deleteAddressConfirm;

  /// No description provided for @setDefault.
  ///
  /// In en, this message translates to:
  /// **'Set Default'**
  String get setDefault;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @selectLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select Location on Map'**
  String get selectLocationOnMap;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location Selected'**
  String get locationSelected;

  /// No description provided for @tapToPickLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick location on map'**
  String get tapToPickLocation;

  /// No description provided for @addressType.
  ///
  /// In en, this message translates to:
  /// **'Address Type'**
  String get addressType;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipientName;

  /// No description provided for @enterRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Enter recipient\'s full name'**
  String get enterRecipientName;

  /// No description provided for @labelOther.
  ///
  /// In en, this message translates to:
  /// **'Label (e.g., Friend\'s House)'**
  String get labelOther;

  /// No description provided for @enterLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter a label for this address'**
  String get enterLabel;

  /// No description provided for @houseFlatNo.
  ///
  /// In en, this message translates to:
  /// **'House/Flat/Block No.'**
  String get houseFlatNo;

  /// No description provided for @enterHouseNo.
  ///
  /// In en, this message translates to:
  /// **'Enter house or flat number'**
  String get enterHouseNo;

  /// No description provided for @landmarkOptional.
  ///
  /// In en, this message translates to:
  /// **'Landmark (Optional)'**
  String get landmarkOptional;

  /// No description provided for @landmarkHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Near City Mall'**
  String get landmarkHint;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterCity;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @enterState.
  ///
  /// In en, this message translates to:
  /// **'Enter state'**
  String get enterState;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @enterPincode.
  ///
  /// In en, this message translates to:
  /// **'Enter Pincode'**
  String get enterPincode;

  /// No description provided for @pincodeLengthError.
  ///
  /// In en, this message translates to:
  /// **'Pincode must be 6 digits'**
  String get pincodeLengthError;

  /// No description provided for @setAsDefaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Set as default address'**
  String get setAsDefaultAddress;

  /// No description provided for @setAsDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This address will be used by default for deliveries'**
  String get setAsDefaultSubtitle;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @pleaseEnterRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter recipient name'**
  String get pleaseEnterRecipientName;

  /// No description provided for @pleaseEnterHouseNo.
  ///
  /// In en, this message translates to:
  /// **'Please enter house/flat number'**
  String get pleaseEnterHouseNo;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @pleaseSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select a location on the map'**
  String get pleaseSelectLocation;

  /// No description provided for @ourStory.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get ourStory;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVision;

  /// No description provided for @ourCoreValues.
  ///
  /// In en, this message translates to:
  /// **'Our Core Values'**
  String get ourCoreValues;

  /// No description provided for @trustTransparency.
  ///
  /// In en, this message translates to:
  /// **'Trust & Transparency'**
  String get trustTransparency;

  /// No description provided for @qualityFirst.
  ///
  /// In en, this message translates to:
  /// **'Quality First'**
  String get qualityFirst;

  /// No description provided for @customerCentricity.
  ///
  /// In en, this message translates to:
  /// **'Customer Centricity'**
  String get customerCentricity;

  /// No description provided for @sustainability.
  ///
  /// In en, this message translates to:
  /// **'Sustainability'**
  String get sustainability;

  /// No description provided for @innovation.
  ///
  /// In en, this message translates to:
  /// **'Innovation'**
  String get innovation;

  /// No description provided for @whatWeOffer.
  ///
  /// In en, this message translates to:
  /// **'What We Offer'**
  String get whatWeOffer;

  /// No description provided for @ourImpact.
  ///
  /// In en, this message translates to:
  /// **'Our Impact'**
  String get ourImpact;

  /// No description provided for @happyCustomers.
  ///
  /// In en, this message translates to:
  /// **'Happy Customers'**
  String get happyCustomers;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// No description provided for @redirectingToCart.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to cart in {seconds} seconds'**
  String redirectingToCart(String seconds);

  /// No description provided for @errorCode.
  ///
  /// In en, this message translates to:
  /// **'Error Code: {code}'**
  String errorCode(String code);

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @orderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumberLabel;

  /// No description provided for @searchForProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get searchForProducts;

  /// No description provided for @searchForProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get searchForProductsHint;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProducts;

  /// No description provided for @quick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get quick;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @failedToLoadAddresses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load addresses'**
  String get failedToLoadAddresses;

  /// No description provided for @couldNotDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the address. Please try again.'**
  String get couldNotDeleteAddress;

  /// No description provided for @couldNotUpdateAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not update the address. Please try again.'**
  String get couldNotUpdateAddress;

  /// No description provided for @couldNotAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not add the address. Please try again.'**
  String get couldNotAddAddress;

  /// No description provided for @couldNotSetDefaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not set the default address. Please try again.'**
  String get couldNotSetDefaultAddress;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocation;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @locationEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Location enabled! Showing nearby stores...'**
  String get locationEnabledMessage;

  /// No description provided for @nearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Nearby Stores'**
  String get nearbyStores;

  /// No description provided for @findNearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby Stores'**
  String get findNearbyStores;

  /// No description provided for @loadingNearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Loading nearby stores...'**
  String get loadingNearbyStores;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @autoDetectLocation.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect your delivery address'**
  String get autoDetectLocation;

  /// No description provided for @yourAppContent.
  ///
  /// In en, this message translates to:
  /// **'Your App Content'**
  String get yourAppContent;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @disableLocation.
  ///
  /// In en, this message translates to:
  /// **'Disable Location'**
  String get disableLocation;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationAccess;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionRequired;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @permissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Permanently Denied'**
  String get permissionPermanentlyDenied;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Services Disabled'**
  String get locationServicesDisabled;

  /// No description provided for @allowLocationAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get allowLocationAccess;

  /// No description provided for @permissionUIComponents.
  ///
  /// In en, this message translates to:
  /// **'Location Permission UI Components'**
  String get permissionUIComponents;

  /// No description provided for @showBottomSheet.
  ///
  /// In en, this message translates to:
  /// **'Show Bottom Sheet'**
  String get showBottomSheet;

  /// No description provided for @showRationaleDialog.
  ///
  /// In en, this message translates to:
  /// **'Show Rationale Dialog'**
  String get showRationaleDialog;

  /// No description provided for @showSettingsDialog.
  ///
  /// In en, this message translates to:
  /// **'Show Settings Dialog'**
  String get showSettingsDialog;

  /// No description provided for @requestPermissionFullFlow.
  ///
  /// In en, this message translates to:
  /// **'Request Permission (Full Flow)'**
  String get requestPermissionFullFlow;

  /// No description provided for @getCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get getCurrentLocation;

  /// No description provided for @locationPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Location permission granted'**
  String get locationPermissionGranted;

  /// No description provided for @grantLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Location Permission'**
  String get grantLocationPermission;

  /// No description provided for @dataAlreadyLoaded.
  ///
  /// In en, this message translates to:
  /// **'Data already loaded - instant display!'**
  String get dataAlreadyLoaded;

  /// No description provided for @searchSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Search saved addresses'**
  String get searchSavedAddresses;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategories;

  /// No description provided for @searchRestaurantsDishes.
  ///
  /// In en, this message translates to:
  /// **'Search for restaurants, dishes...'**
  String get searchRestaurantsDishes;

  /// No description provided for @searchAreaStreetName.
  ///
  /// In en, this message translates to:
  /// **'Search for area, street name...'**
  String get searchAreaStreetName;

  /// No description provided for @joinAsVendorTitle.
  ///
  /// In en, this message translates to:
  /// **'Join as Vendor'**
  String get joinAsVendorTitle;

  /// No description provided for @vendorFillDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in your vendor shop details. Required fields are marked with *'**
  String get vendorFillDetails;

  /// No description provided for @vendorShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Shop Details'**
  String get vendorShopDetails;

  /// No description provided for @vendorShopDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your shop information'**
  String get vendorShopDetailsSubtitle;

  /// No description provided for @vendorOwnerDetails.
  ///
  /// In en, this message translates to:
  /// **'Owner Details'**
  String get vendorOwnerDetails;

  /// No description provided for @vendorOwnerDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter owner information'**
  String get vendorOwnerDetailsSubtitle;

  /// No description provided for @vendorDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get vendorDocuments;

  /// No description provided for @vendorDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload required documents for verification'**
  String get vendorDocumentsSubtitle;

  /// No description provided for @vendorShopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get vendorShopName;

  /// No description provided for @vendorShopNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter shop name'**
  String get vendorShopNameHint;

  /// No description provided for @vendorShopAddress.
  ///
  /// In en, this message translates to:
  /// **'Shop Address'**
  String get vendorShopAddress;

  /// No description provided for @vendorShopAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter complete shop address'**
  String get vendorShopAddressHint;

  /// No description provided for @vendorShopPincode.
  ///
  /// In en, this message translates to:
  /// **'Shop Pincode'**
  String get vendorShopPincode;

  /// No description provided for @vendorShopPincodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit pincode'**
  String get vendorShopPincodeHint;

  /// No description provided for @vendorShopLocation.
  ///
  /// In en, this message translates to:
  /// **'Shop Location *'**
  String get vendorShopLocation;

  /// No description provided for @vendorShopImages.
  ///
  /// In en, this message translates to:
  /// **'Shop Images *'**
  String get vendorShopImages;

  /// No description provided for @vendorShopImagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload up to 5 shop images'**
  String get vendorShopImagesSubtitle;

  /// No description provided for @vendorOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get vendorOwnerName;

  /// No description provided for @vendorOwnerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter owner full name'**
  String get vendorOwnerNameHint;

  /// No description provided for @vendorOwnerAddress.
  ///
  /// In en, this message translates to:
  /// **'Owner Address'**
  String get vendorOwnerAddress;

  /// No description provided for @vendorOwnerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter complete owner address'**
  String get vendorOwnerAddressHint;

  /// No description provided for @vendorOwnerPincode.
  ///
  /// In en, this message translates to:
  /// **'Owner Pincode'**
  String get vendorOwnerPincode;

  /// No description provided for @vendorOwnerPincodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit pincode'**
  String get vendorOwnerPincodeHint;

  /// No description provided for @vendorOwnerLocation.
  ///
  /// In en, this message translates to:
  /// **'Owner Location *'**
  String get vendorOwnerLocation;

  /// No description provided for @vendorMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get vendorMobileNumber;

  /// No description provided for @vendorMobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit mobile number'**
  String get vendorMobileNumberHint;

  /// No description provided for @vendorEmailId.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get vendorEmailId;

  /// No description provided for @vendorEmailIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get vendorEmailIdHint;

  /// No description provided for @vendorOwnerImages.
  ///
  /// In en, this message translates to:
  /// **'Owner Images *'**
  String get vendorOwnerImages;

  /// No description provided for @vendorOwnerImagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload up to 2 owner images'**
  String get vendorOwnerImagesSubtitle;

  /// No description provided for @vendorPickLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick Location from Map'**
  String get vendorPickLocation;

  /// No description provided for @vendorAadharCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Card'**
  String get vendorAadharCard;

  /// No description provided for @vendorPanCard.
  ///
  /// In en, this message translates to:
  /// **'PAN Card'**
  String get vendorPanCard;

  /// No description provided for @vendorBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get vendorBankAccount;

  /// No description provided for @vendorGstNumber.
  ///
  /// In en, this message translates to:
  /// **'GST Number'**
  String get vendorGstNumber;

  /// No description provided for @vendorNonGstCertificate.
  ///
  /// In en, this message translates to:
  /// **'Non GST Certificate'**
  String get vendorNonGstCertificate;

  /// No description provided for @vendorNonGstCertificateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Non GST certificate'**
  String get vendorNonGstCertificateSubtitle;

  /// No description provided for @vendorMsmeCertificate.
  ///
  /// In en, this message translates to:
  /// **'MSME Certificate'**
  String get vendorMsmeCertificate;

  /// No description provided for @vendorMsmeCertificateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload MSME certificate (if applicable)'**
  String get vendorMsmeCertificateSubtitle;

  /// No description provided for @vendorFssaiCertificate.
  ///
  /// In en, this message translates to:
  /// **'FSSAI Certificate *'**
  String get vendorFssaiCertificate;

  /// No description provided for @vendorFssaiCertificateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload FSSAI license for food businesses'**
  String get vendorFssaiCertificateSubtitle;

  /// No description provided for @vendorShopAgreement.
  ///
  /// In en, this message translates to:
  /// **'Shop Agreement'**
  String get vendorShopAgreement;

  /// No description provided for @vendorShopAgreementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload shop agreement (optional)'**
  String get vendorShopAgreementSubtitle;

  /// No description provided for @vendorSubmitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get vendorSubmitApplication;

  /// No description provided for @vendorAadharDetails.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Details'**
  String get vendorAadharDetails;

  /// No description provided for @vendorAadharNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Number *'**
  String get vendorAadharNumber;

  /// No description provided for @vendorAadharNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 12-digit Aadhar number'**
  String get vendorAadharNumberHint;

  /// No description provided for @vendorAadharDocument.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Number Document *'**
  String get vendorAadharDocument;

  /// No description provided for @vendorPanDetails.
  ///
  /// In en, this message translates to:
  /// **'PAN Details'**
  String get vendorPanDetails;

  /// No description provided for @vendorPanCardNumber.
  ///
  /// In en, this message translates to:
  /// **'PAN Card Number *'**
  String get vendorPanCardNumber;

  /// No description provided for @vendorPanCardNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter PAN card number (e.g., ABCDE1234F)'**
  String get vendorPanCardNumberHint;

  /// No description provided for @vendorPanDocument.
  ///
  /// In en, this message translates to:
  /// **'PAN Card Number Document *'**
  String get vendorPanDocument;

  /// No description provided for @vendorBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get vendorBankDetails;

  /// No description provided for @vendorAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number *'**
  String get vendorAccountNumber;

  /// No description provided for @vendorAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter bank account number'**
  String get vendorAccountNumberHint;

  /// No description provided for @vendorIfscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code *'**
  String get vendorIfscCode;

  /// No description provided for @vendorIfscCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter IFSC code'**
  String get vendorIfscCodeHint;

  /// No description provided for @vendorAccountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name *'**
  String get vendorAccountHolderName;

  /// No description provided for @vendorAccountHolderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter account holder name'**
  String get vendorAccountHolderNameHint;

  /// No description provided for @vendorBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name *'**
  String get vendorBankName;

  /// No description provided for @vendorBankNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter bank name (optional)'**
  String get vendorBankNameHint;

  /// No description provided for @vendorBranchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get vendorBranchName;

  /// No description provided for @vendorBranchNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter branch name (optional)'**
  String get vendorBranchNameHint;

  /// No description provided for @vendorUploadBankProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Bank Proof'**
  String get vendorUploadBankProof;

  /// No description provided for @vendorUploadBankProofSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload either Bank Passbook or Cancelled Cheque'**
  String get vendorUploadBankProofSubtitle;

  /// No description provided for @vendorBankDocument.
  ///
  /// In en, this message translates to:
  /// **'Bank Document *'**
  String get vendorBankDocument;

  /// No description provided for @vendorGstDetails.
  ///
  /// In en, this message translates to:
  /// **'GST Details'**
  String get vendorGstDetails;

  /// No description provided for @vendorGstNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'GST Number *'**
  String get vendorGstNumberLabel;

  /// No description provided for @vendorGstNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 15-digit GST number'**
  String get vendorGstNumberHint;

  /// No description provided for @vendorGstDocument.
  ///
  /// In en, this message translates to:
  /// **'GST Number Document *'**
  String get vendorGstDocument;

  /// No description provided for @vendorSaveAndVerify.
  ///
  /// In en, this message translates to:
  /// **'Save & Verify'**
  String get vendorSaveAndVerify;

  /// No description provided for @vendorUploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get vendorUploadDocument;

  /// No description provided for @vendorUploadDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'PDF, JPG, PNG (Max 5MB)'**
  String get vendorUploadDocumentHint;

  /// No description provided for @vendorAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get vendorAddImage;

  /// No description provided for @vendorJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vendor application submitted successfully!'**
  String get vendorJoinSuccess;

  /// No description provided for @vendorShopNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop name is required'**
  String get vendorShopNameRequired;

  /// No description provided for @vendorShopLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop location is required'**
  String get vendorShopLocationRequired;

  /// No description provided for @vendorShopImagesRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one shop image is required'**
  String get vendorShopImagesRequired;

  /// No description provided for @vendorOwnerLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner location is required'**
  String get vendorOwnerLocationRequired;

  /// No description provided for @vendorOwnerImagesRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one owner image is required'**
  String get vendorOwnerImagesRequired;

  /// No description provided for @vendorOwnerImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner image is required'**
  String get vendorOwnerImageRequired;

  /// No description provided for @vendorVendorDetails.
  ///
  /// In en, this message translates to:
  /// **'Vendor Details'**
  String get vendorVendorDetails;

  /// No description provided for @vendorVendorDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your vendor registration details'**
  String get vendorVendorDetailsSubtitle;

  /// No description provided for @vendorVendorName.
  ///
  /// In en, this message translates to:
  /// **'Vendor Name'**
  String get vendorVendorName;

  /// No description provided for @vendorVendorNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter vendor/store name'**
  String get vendorVendorNameHint;

  /// No description provided for @vendorVendorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Vendor name is required'**
  String get vendorVendorNameRequired;

  /// No description provided for @vendorAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get vendorAddress;

  /// No description provided for @vendorAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter vendor address'**
  String get vendorAddressHint;

  /// No description provided for @vendorAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get vendorAddressRequired;

  /// No description provided for @vendorPincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get vendorPincode;

  /// No description provided for @vendorPincodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter pincode'**
  String get vendorPincodeHint;

  /// No description provided for @vendorPincodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Pincode is required'**
  String get vendorPincodeRequired;

  /// No description provided for @vendorStateId.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get vendorStateId;

  /// No description provided for @vendorStateIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter state ID'**
  String get vendorStateIdHint;

  /// No description provided for @vendorStateIdRequired.
  ///
  /// In en, this message translates to:
  /// **'State is required'**
  String get vendorStateIdRequired;

  /// No description provided for @vendorCityId.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get vendorCityId;

  /// No description provided for @vendorCityIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city ID'**
  String get vendorCityIdHint;

  /// No description provided for @vendorCityIdRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get vendorCityIdRequired;

  /// No description provided for @vendorOwnerImage.
  ///
  /// In en, this message translates to:
  /// **'Owner Image *'**
  String get vendorOwnerImage;

  /// No description provided for @vendorOwnerImageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload owner photo'**
  String get vendorOwnerImageSubtitle;

  /// No description provided for @vendorShopAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop address is required'**
  String get vendorShopAddressRequired;

  /// No description provided for @vendorShopPincodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop pincode is required'**
  String get vendorShopPincodeRequired;

  /// No description provided for @vendorOwnerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner name is required'**
  String get vendorOwnerNameRequired;

  /// No description provided for @vendorOwnerAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner address is required'**
  String get vendorOwnerAddressRequired;

  /// No description provided for @vendorOwnerPincodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner pincode is required'**
  String get vendorOwnerPincodeRequired;

  /// No description provided for @vendorMobileNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get vendorMobileNumberRequired;

  /// No description provided for @vendorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get vendorEmailRequired;

  /// No description provided for @vendorAadhaarNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number is required'**
  String get vendorAadhaarNumberRequired;

  /// No description provided for @vendorAadhaarFileRequired.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar document is required'**
  String get vendorAadhaarFileRequired;

  /// No description provided for @vendorPanFileRequired.
  ///
  /// In en, this message translates to:
  /// **'PAN document is required'**
  String get vendorPanFileRequired;

  /// No description provided for @vendorBankFileRequired.
  ///
  /// In en, this message translates to:
  /// **'Bank document is required'**
  String get vendorBankFileRequired;

  /// No description provided for @vendorGstFileRequired.
  ///
  /// In en, this message translates to:
  /// **'GST document is required'**
  String get vendorGstFileRequired;

  /// No description provided for @vendorGstOrNonGstRequired.
  ///
  /// In en, this message translates to:
  /// **'Upload either GST document or Non-GST certificate'**
  String get vendorGstOrNonGstRequired;

  /// No description provided for @vendorFssaiFileRequired.
  ///
  /// In en, this message translates to:
  /// **'FSSAI certificate is required'**
  String get vendorFssaiFileRequired;

  /// No description provided for @chooseHowToReachUs.
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'d like to reach us'**
  String get chooseHowToReachUs;

  /// No description provided for @requestCallback.
  ///
  /// In en, this message translates to:
  /// **'Request Callback'**
  String get requestCallback;

  /// No description provided for @requestCallbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Get a call from our support team'**
  String get requestCallbackDescription;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @emailSupportDescription.
  ///
  /// In en, this message translates to:
  /// **'Send us an email at customersupport@takshallinone.in'**
  String get emailSupportDescription;

  /// No description provided for @emailAppError.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app. Please email us at customersupport@takshallinone.in'**
  String get emailAppError;

  /// No description provided for @myWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get myWishlist;

  /// No description provided for @addedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to wishlist'**
  String get addedToWishlist;

  /// No description provided for @removedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get removedFromWishlist;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmpty;

  /// No description provided for @wishlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse products and add your favorites here'**
  String get wishlistEmptySubtitle;

  /// No description provided for @removeFromWishlistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist?'**
  String get removeFromWishlistConfirm;

  /// No description provided for @failedToLoadWishlist.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wishlist'**
  String get failedToLoadWishlist;

  /// No description provided for @couldNotAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Could not add item to cart. Please try again.'**
  String get couldNotAddToCart;

  /// No description provided for @couldNotLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Could not load product details. Please try again.'**
  String get couldNotLoadProduct;

  /// No description provided for @noVariantsAvailable.
  ///
  /// In en, this message translates to:
  /// **'This product is currently unavailable.'**
  String get noVariantsAvailable;

  /// No description provided for @cartUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get cartUnexpectedError;

  /// No description provided for @checkDeliveryAvailability.
  ///
  /// In en, this message translates to:
  /// **'Check Delivery Availability'**
  String get checkDeliveryAvailability;

  /// No description provided for @invalidPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit pincode'**
  String get invalidPincode;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @fulfilledBy.
  ///
  /// In en, this message translates to:
  /// **'Fulfilled by {shopName}'**
  String fulfilledBy(String shopName);

  /// No description provided for @couldNotCheckDelivery.
  ///
  /// In en, this message translates to:
  /// **'Could not check delivery availability. Please try again.'**
  String get couldNotCheckDelivery;

  /// No description provided for @homeServices.
  ///
  /// In en, this message translates to:
  /// **'Home Services'**
  String get homeServices;

  /// No description provided for @homeServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book professional services at your doorstep'**
  String get homeServicesSubtitle;

  /// No description provided for @couldNotLoadServices.
  ///
  /// In en, this message translates to:
  /// **'Could not load services'**
  String get couldNotLoadServices;

  /// No description provided for @courierBooking.
  ///
  /// In en, this message translates to:
  /// **'Courier Booking'**
  String get courierBooking;

  /// No description provided for @customerAndPickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer & Pickup Details'**
  String get customerAndPickupDetails;

  /// No description provided for @electrician.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get electrician;

  /// No description provided for @plumber.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get plumber;

  /// No description provided for @salonParlor.
  ///
  /// In en, this message translates to:
  /// **'Salon / Parlor'**
  String get salonParlor;

  /// No description provided for @pickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Pickup Details'**
  String get pickupDetails;

  /// No description provided for @pickupAddress.
  ///
  /// In en, this message translates to:
  /// **'Pickup Address'**
  String get pickupAddress;

  /// No description provided for @enterPickupAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter full pickup address'**
  String get enterPickupAddress;

  /// No description provided for @pickupPincode.
  ///
  /// In en, this message translates to:
  /// **'Pickup Pincode'**
  String get pickupPincode;

  /// No description provided for @deliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get deliveryDetails;

  /// No description provided for @enterDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter full delivery address'**
  String get enterDeliveryAddress;

  /// No description provided for @deliveryPincode.
  ///
  /// In en, this message translates to:
  /// **'Delivery Pincode'**
  String get deliveryPincode;

  /// No description provided for @parcelDetails.
  ///
  /// In en, this message translates to:
  /// **'Parcel Details'**
  String get parcelDetails;

  /// No description provided for @packagingDetails.
  ///
  /// In en, this message translates to:
  /// **'Packaging Details'**
  String get packagingDetails;

  /// No description provided for @enterProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter product name and details'**
  String get enterProductDetails;

  /// No description provided for @enterPackagingDetails.
  ///
  /// In en, this message translates to:
  /// **'Envelope, box, etc.'**
  String get enterPackagingDetails;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @dimensionUnit.
  ///
  /// In en, this message translates to:
  /// **'Dimension Unit'**
  String get dimensionUnit;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additionalInfo;

  /// No description provided for @customerNotes.
  ///
  /// In en, this message translates to:
  /// **'Customer Notes (optional)'**
  String get customerNotes;

  /// No description provided for @addProductImage.
  ///
  /// In en, this message translates to:
  /// **'Add Product Image (optional)'**
  String get addProductImage;

  /// No description provided for @checkPrice.
  ///
  /// In en, this message translates to:
  /// **'Check Price'**
  String get checkPrice;

  /// No description provided for @bookService.
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get bookService;

  /// No description provided for @priceCheckComplete.
  ///
  /// In en, this message translates to:
  /// **'Price Check Complete'**
  String get priceCheckComplete;

  /// No description provided for @bookingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Booking Submitted'**
  String get bookingSubmitted;

  /// No description provided for @tokenAmount.
  ///
  /// In en, this message translates to:
  /// **'Token Amount'**
  String get tokenAmount;

  /// No description provided for @serviceHistory.
  ///
  /// In en, this message translates to:
  /// **'Service History'**
  String get serviceHistory;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noPreviousOrders.
  ///
  /// In en, this message translates to:
  /// **'No previous orders'**
  String get noPreviousOrders;

  /// No description provided for @serviceHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your service booking history will appear here'**
  String get serviceHistoryEmpty;

  /// No description provided for @couldNotLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load history'**
  String get couldNotLoadHistory;

  /// No description provided for @inquiryId.
  ///
  /// In en, this message translates to:
  /// **'Inquiry ID'**
  String get inquiryId;

  /// No description provided for @yourAddress.
  ///
  /// In en, this message translates to:
  /// **'Your Address'**
  String get yourAddress;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// No description provided for @enterCompleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your complete address'**
  String get enterCompleteAddress;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get serviceDescription;

  /// No description provided for @describeServiceNeeded.
  ///
  /// In en, this message translates to:
  /// **'Describe the service you need'**
  String get describeServiceNeeded;

  /// No description provided for @sixDigitPincode.
  ///
  /// In en, this message translates to:
  /// **'6-digit pincode'**
  String get sixDigitPincode;

  /// No description provided for @enterValidPincode.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit pincode'**
  String get enterValidPincode;

  /// No description provided for @guestWallTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to view {contentLabel}'**
  String guestWallTitle(String contentLabel);

  /// No description provided for @guestWallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access {contentLabel} and enjoy a personalised shopping experience with order tracking, saved addresses, and more.'**
  String guestWallSubtitle(String contentLabel);

  /// No description provided for @guestWallLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Login to Continue'**
  String get guestWallLoginButton;

  /// No description provided for @guestWallContinueBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Continue browsing as guest'**
  String get guestWallContinueBrowsing;

  /// No description provided for @loginCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get loginCancelButton;

  /// No description provided for @orderReview.
  ///
  /// In en, this message translates to:
  /// **'Review Order'**
  String get orderReview;

  /// No description provided for @reviewYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Review your order before confirming'**
  String get reviewYourOrder;

  /// No description provided for @reviewOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'Please verify the details below and tap \"Confirm Order\" to place your order.'**
  String get reviewOrderDescription;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @confirmingOrder.
  ///
  /// In en, this message translates to:
  /// **'Placing your order...'**
  String get confirmingOrder;

  /// No description provided for @deliveryTo.
  ///
  /// In en, this message translates to:
  /// **'Delivering to'**
  String get deliveryTo;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @orderSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummaryTitle;

  /// No description provided for @itemTotal.
  ///
  /// In en, this message translates to:
  /// **'Item Total'**
  String get itemTotal;

  /// No description provided for @platformFees.
  ///
  /// In en, this message translates to:
  /// **'Platform Fees'**
  String get platformFees;

  /// No description provided for @otherChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other Charges'**
  String get otherChargesLabel;

  /// No description provided for @orderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlacedTitle;

  /// No description provided for @orderPlacedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully. Pay on delivery.'**
  String get orderPlacedSubtitle;

  /// No description provided for @orderPlacedOnlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully. Redirecting to payment...'**
  String get orderPlacedOnlineSubtitle;

  /// No description provided for @thankYouForOrder.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order!'**
  String get thankYouForOrder;

  /// No description provided for @viewMyOrders.
  ///
  /// In en, this message translates to:
  /// **'View My Orders'**
  String get viewMyOrders;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Shop everything you need'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover thousands of products from local stores, delivered straight to your door.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Fast & reliable delivery'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Track your orders in real-time and get them delivered in minutes, not days.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Safe & secure payments'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Pay with confidence using trusted payment methods, every single time.'**
  String get onboardingSubtitle3;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
