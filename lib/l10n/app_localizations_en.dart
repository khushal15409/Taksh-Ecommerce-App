// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taksh E-Commerce';

  @override
  String get madeInIndia => 'Made in India';

  @override
  String get initializing => 'Initializing...';

  @override
  String get checkingAuthentication => 'Checking authentication...';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get login => 'Login';

  @override
  String get loginTagline => 'Food delivered to your doorstep';

  @override
  String get enterPhoneDescription => 'Enter your phone number to receive OTP';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumberHint => 'Enter 10-digit phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get termsAndPrivacy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String enterOtpDescription(String phone) {
    return 'Enter the 4-digit code sent to $phone';
  }

  @override
  String get otpHint => '0000';

  @override
  String get verifyOtpButton => 'Verify OTP';

  @override
  String get didNotReceiveCode => 'Didn\'t receive the code? ';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get otpResentSuccess => 'OTP resent successfully';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get invalidPhone => 'Enter a valid 10-digit phone number';

  @override
  String get otpRequired => 'OTP is required';

  @override
  String get invalidOtp => 'Enter a valid 4-digit OTP';

  @override
  String get profile => 'Profile';

  @override
  String get appearance => 'Appearance';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String themeChanged(String theme) {
    return 'Theme changed to $theme';
  }

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get general => 'General';

  @override
  String get myAddress => 'My Address';

  @override
  String get coupons => 'Coupons';

  @override
  String get paymentMethodsComingSoon => 'Payment Methods - Coming Soon';

  @override
  String get earnings => 'Earnings';

  @override
  String get joinAsDeliveryMan => 'Join as Delivery Man';

  @override
  String get openVendor => 'Open Vendor';

  @override
  String get languageSettingsComingSoon => 'Language Settings - Coming Soon';

  @override
  String get createApplication => 'Create Application';

  @override
  String get createWebsite => 'Create Website';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get liveChat => 'Live Chat';

  @override
  String get aboutUs => 'About Us';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get refundPolicy => 'Refund Policy';

  @override
  String get support => 'Support';

  @override
  String get remove => 'Remove';

  @override
  String get clear => 'Clear';

  @override
  String get logout => 'Logout';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get standardDelivery => 'Standard Delivery';

  @override
  String get standardDeliveryDescription =>
      'Standard Delivery - Shop Your Favorites!';

  @override
  String get quickDelivery => 'Quick Delivery';

  @override
  String get quickDeliveryDescription => 'Quick Delivery - Express 30';

  @override
  String get homeService => 'Home Service';

  @override
  String get homeServiceDescription => 'Explore home services coming soon';

  @override
  String get searchHint => 'Search for products...';

  @override
  String get somethingWentWrong => 'Oops! Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get exitAppTitle => 'Exit app?';

  @override
  String get exitAppContent => 'Are you sure you want to exit?';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get homeTab => 'Home';

  @override
  String get categoriesTab => 'Categories';

  @override
  String get cartTab => 'Cart';

  @override
  String get ordersTab => 'Orders';

  @override
  String get profileTab => 'Profile';

  @override
  String get cart => 'Cart';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get cartEmptyTitle => 'Your Cart is Empty';

  @override
  String get cartEmptySubtitle => 'Add items to get started';

  @override
  String get startShopping => 'Start Shopping';

  @override
  String sku(String sku) {
    return 'SKU: $sku';
  }

  @override
  String total(String amount) {
    return 'Total: ₹$amount';
  }

  @override
  String get removeItemTitle => 'Remove Item';

  @override
  String removeItemConfirm(String product) {
    return 'Remove $product from cart?';
  }

  @override
  String get clearCartConfirm => 'Remove all items from cart?';

  @override
  String totalItemsLabel(int count) {
    return 'Total Items: $count';
  }

  @override
  String get proceedToCheckout => 'Proceed to Checkout';

  @override
  String get myOrders => 'My Orders';

  @override
  String get filterByStatus => 'Filter by Status';

  @override
  String get allOrders => 'All Orders';

  @override
  String get readyForDispatch => 'Ready for Dispatch';

  @override
  String get dispatched => 'Dispatched';

  @override
  String get delivered => 'Delivered';

  @override
  String get dateNewestFirst => 'Date: Newest First';

  @override
  String get dateOldestFirst => 'Date: Oldest First';

  @override
  String get amountHighToLow => 'Amount: High to Low';

  @override
  String get amountLowToHigh => 'Amount: Low to High';

  @override
  String get recentlyUpdated => 'Recently Updated';

  @override
  String get leastRecentlyUpdated => 'Least Recently Updated';

  @override
  String get noOrdersFound => 'No orders found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get clearDateFilter => 'Clear date filter';

  @override
  String get noOrdersYet => 'No Orders Yet';

  @override
  String get yourOrdersAppearHere => 'Your orders will appear here';

  @override
  String orderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String estDelivery(String date) {
    return 'Est. delivery: $date';
  }

  @override
  String get orderDetails => 'Order Details';

  @override
  String placedOn(String date) {
    return 'Placed on $date';
  }

  @override
  String get deliveryType => 'Delivery Type';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get estimatedDelivery => 'Estimated Delivery';

  @override
  String get invoice => 'Invoice';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String orderItems(int count) {
    return 'Order Items ($count)';
  }

  @override
  String qtyPrice(int qty, String price) {
    return 'Qty: $qty × ₹$price';
  }

  @override
  String get returnItem => 'Return Item';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get paymentInformation => 'Payment Information';

  @override
  String paidVia(String method) {
    return 'Paid via $method';
  }

  @override
  String get orders => 'Orders';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get reviews => 'Reviews';

  @override
  String get whatsappError =>
      'Could not open WhatsApp. Please make sure WhatsApp is installed.';

  @override
  String lastUpdated(String date) {
    return 'Last Updated: $date';
  }

  @override
  String get termsIntroTitle => '1. Introduction';

  @override
  String get termsIntroContent =>
      'Welcome to our E-Commerce platform. These Terms and Conditions govern your use of our mobile application and services. By accessing or using our app, you agree to be bound by these terms. If you disagree with any part of these terms, you may not access our service.';

  @override
  String get termsAccountTitle => '2. Account Registration';

  @override
  String get termsAccountContent =>
      'To use certain features of our service, you must register for an account. You agree to:\n\n• Provide accurate and complete information\n• Maintain the security of your password\n• Notify us immediately of any unauthorized use\n• Accept responsibility for all activities under your account';

  @override
  String get termsUserRespTitle => '3. User Responsibilities';

  @override
  String get termsUserRespContent =>
      'As a user of our platform, you agree to:\n\n• Use the service only for lawful purposes\n• Not violate any applicable laws or regulations\n• Not infringe on intellectual property rights\n• Not transmit harmful or malicious code\n• Not attempt to gain unauthorized access to our systems';

  @override
  String get termsProductsTitle => '4. Products and Services';

  @override
  String get termsProductsContent =>
      'We strive to provide accurate product descriptions and pricing. However:\n\n• Product images are for illustration purposes\n• We reserve the right to modify prices without notice\n• Product availability may vary\n• We are not liable for pricing or description errors';

  @override
  String get termsOrdersTitle => '5. Orders and Payment';

  @override
  String get termsOrdersContent =>
      'When placing an order, you agree that:\n\n• All information provided is accurate\n• You are authorized to use the payment method\n• You will pay all applicable charges\n• Orders are subject to acceptance and availability\n• We may cancel orders for any reason';

  @override
  String get termsShippingTitle => '6. Shipping and Delivery';

  @override
  String get termsShippingContent =>
      'For shipping and delivery:\n\n• Delivery times are estimates only\n• We are not responsible for delays beyond our control\n• Risk of loss passes to you upon delivery\n• You must inspect items upon delivery\n• Delivery address must be accurate and complete';

  @override
  String get termsReturnsTitle => '7. Returns and Refunds';

  @override
  String get termsReturnsContent =>
      'Our return and refund policy includes:\n\n• Items must be returned within the specified period\n• Products must be in original condition\n• Proof of purchase is required\n• Refunds will be processed to the original payment method\n• Some items may not be eligible for return';

  @override
  String get termsIpTitle => '8. Intellectual Property';

  @override
  String get termsIpContent =>
      'All content on our platform, including but not limited to text, graphics, logos, images, and software, is our property or that of our licensors and is protected by copyright, trademark, and other intellectual property laws.';

  @override
  String get termsPrivacyTitle => '9. Privacy and Data Protection';

  @override
  String get termsPrivacyContent =>
      'Your privacy is important to us. We collect and use your personal information in accordance with our Privacy Policy. By using our service, you consent to our collection and use of your information as described.';

  @override
  String get termsLiabilityTitle => '10. Limitation of Liability';

  @override
  String get termsLiabilityContent =>
      'To the maximum extent permitted by law:\n\n• We are not liable for indirect or consequential damages\n• Our total liability is limited to the amount paid by you\n• We do not guarantee uninterrupted or error-free service\n• We are not responsible for third-party content or services';

  @override
  String get termsIndemnifyTitle => '11. Indemnification';

  @override
  String get termsIndemnifyContent =>
      'You agree to indemnify and hold us harmless from any claims, damages, losses, liabilities, and expenses arising from your use of our service or violation of these terms.';

  @override
  String get termsModTitle => '12. Modifications to Terms';

  @override
  String get termsModContent =>
      'We reserve the right to modify these terms at any time. We will notify you of significant changes. Your continued use of the service after changes constitutes acceptance of the modified terms.';

  @override
  String get termsTerminationTitle => '13. Termination';

  @override
  String get termsTerminationContent =>
      'We may terminate or suspend your account and access to our service immediately, without prior notice, for any reason, including breach of these terms.';

  @override
  String get termsLawTitle => '14. Governing Law';

  @override
  String get termsLawContent =>
      'These terms are governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.';

  @override
  String get termsContactTitle => '15. Contact Information';

  @override
  String get termsContactContent =>
      'If you have any questions about these Terms and Conditions, please contact us:\n\nEmail: support@taksh-ecommerce.com\nPhone: +91 1800-123-4567\nAddress: Mumbai, Maharashtra, India';

  @override
  String get termsAck =>
      'By using our service, you acknowledge that you have read and understood these Terms & Conditions.';

  @override
  String get refundCommitmentTitle => 'Our Commitment';

  @override
  String get refundCommitmentContent =>
      'At Taksh E-Commerce, customer satisfaction is our top priority. We want you to be completely satisfied with your purchase. If you\'re not happy with your order, we\'re here to help with our easy return and refund process.';

  @override
  String get refundReadPolicy =>
      'Please read this policy carefully to understand your rights and responsibilities regarding returns and refunds.';

  @override
  String get refundEligibilityTitle => '1. Return Eligibility';

  @override
  String get refundEligibilityContent =>
      'You can return most items within 7 days of delivery if:';

  @override
  String get refundEligibilityItem1 =>
      'The item is unused and in its original condition';

  @override
  String get refundEligibilityItem2 =>
      'All original packaging, tags, and labels are intact';

  @override
  String get refundEligibilityItem3 =>
      'You have proof of purchase (order confirmation or invoice)';

  @override
  String get refundEligibilityItem4 =>
      'The product is not on the non-returnable list';

  @override
  String get refundEligibilityItem5 =>
      'The item has not been damaged or altered';

  @override
  String get refundNonReturnableTitle => '2. Non-Returnable Items';

  @override
  String get refundNonReturnableContent =>
      'The following items cannot be returned:';

  @override
  String get refundNonReturnableItem1 =>
      'Perishable goods (food, flowers, etc.)';

  @override
  String get refundNonReturnableItem2 => 'Intimate or sanitary products';

  @override
  String get refundNonReturnableItem3 => 'Customized or personalized items';

  @override
  String get refundNonReturnableItem4 => 'Digital products and downloads';

  @override
  String get refundNonReturnableItem5 => 'Gift cards and vouchers';

  @override
  String get refundNonReturnableItem6 =>
      'Products marked as \"non-returnable\" at the time of purchase';

  @override
  String get refundProcessTitle => '3. Return Process';

  @override
  String get refundProcessContent =>
      'Follow these simple steps to initiate a return:';

  @override
  String get refundStep1Title => 'Initiate Return Request';

  @override
  String get refundStep1Desc =>
      'Go to \"Your Orders\" section in the app and select the item you want to return. Choose the return reason and submit your request.';

  @override
  String get refundStep2Title => 'Return Approval';

  @override
  String get refundStep2Desc =>
      'Our team will review your request within 24 hours. You\'ll receive a confirmation email with return instructions.';

  @override
  String get refundStep3Title => 'Pack the Item';

  @override
  String get refundStep3Desc =>
      'Pack the item securely in its original packaging with all accessories, tags, and invoice.';

  @override
  String get refundStep4Title => 'Pickup or Drop-off';

  @override
  String get refundStep4Desc =>
      'Choose between free pickup from your address or drop-off at our partner locations.';

  @override
  String get refundTimelineTitle => '4. Refund Timeline';

  @override
  String get refundTimelineContent => 'After we receive your returned item:';

  @override
  String get refundTimelineItem1Day => 'Day 1-2';

  @override
  String get refundTimelineItem1Desc =>
      'Item received at our facility and quality check initiated';

  @override
  String get refundTimelineItem2Day => 'Day 3-4';

  @override
  String get refundTimelineItem2Desc =>
      'Quality inspection completed and refund approved';

  @override
  String get refundTimelineItem3Day => 'Day 5-7';

  @override
  String get refundTimelineItem3Desc =>
      'Refund processed to your original payment method';

  @override
  String get refundProcessingNote =>
      'Bank processing may take an additional 3-5 business days depending on your bank.';

  @override
  String get refundMethodsTitle => '5. Refund Methods';

  @override
  String get refundMethodsContent => 'Refunds will be processed through:';

  @override
  String get refundMethodOriginalTitle => 'Original Payment Method';

  @override
  String get refundMethodOriginalDesc =>
      'Refunded to the same card/UPI/wallet used for purchase';

  @override
  String get refundMethodOriginalDays => '5-7 days';

  @override
  String get refundMethodCreditTitle => 'Store Credit';

  @override
  String get refundMethodCreditDesc =>
      'Instant credit to your Taksh E-Commerce wallet for future purchases';

  @override
  String get refundMethodCreditDays => 'Instant';

  @override
  String get refundMethodBankTitle => 'Bank Transfer';

  @override
  String get refundMethodBankDesc =>
      'Direct transfer to your bank account (requires account details)';

  @override
  String get refundMethodBankDays => '7-10 days';

  @override
  String get refundDamagedTitle => '6. Damaged or Defective Products';

  @override
  String get refundDamagedContent =>
      'If you receive a damaged or defective product:\n\n• Report within 48 hours of delivery\n• Provide clear photos of the damage/defect\n• We will arrange immediate pickup\n• Replacement or full refund will be processed\n• No questions asked for genuine cases';

  @override
  String get refundWrongTitle => '7. Wrong Product Delivered';

  @override
  String get refundWrongContent =>
      'If you receive the wrong product:\n\n• Contact us immediately through the app\n• We will arrange free return pickup\n• Correct product will be shipped immediately\n• If correct product is unavailable, full refund will be issued';

  @override
  String get refundPartialTitle => '8. Partial Refunds';

  @override
  String get refundPartialContent =>
      'In certain situations, partial refunds may be granted:';

  @override
  String get refundPartialItem1 =>
      'Items returned after the return window but within 15 days';

  @override
  String get refundPartialItem2 => 'Products with signs of use or minor damage';

  @override
  String get refundPartialItem3 => 'Items missing accessories or packaging';

  @override
  String get refundPartialItem4 => 'Discounted or sale items (as per terms)';

  @override
  String get refundExchangeTitle => '9. Exchange Policy';

  @override
  String get refundExchangeContent =>
      'We offer easy exchanges for:\n\n• Size or color variations\n• Different product models\n• Upgraded versions\n\nThe exchange process is similar to returns, but you can select a replacement product during the return request.';

  @override
  String get refundCancelTitle => '10. Cancellation Policy';

  @override
  String get refundCancelContent =>
      'You can cancel your order before it is shipped:\n\n• Full refund for pre-shipment cancellations\n• Instant processing to original payment method\n• No cancellation charges\n• Refund within 3-5 business days';

  @override
  String get refundContactTitle => '11. Contact for Returns';

  @override
  String get refundContactContent =>
      'Need help with returns or refunds? Reach out to us:\n\nEmail: returns@taksh-ecommerce.com\nLive Chat: Available 24/7 in the app\n\nOur customer support team is here to assist you throughout the return and refund process.';

  @override
  String get refundSatisfactionTitle => '100% Satisfaction Guarantee';

  @override
  String get refundSatisfactionContent =>
      'We stand behind our products and are committed to your satisfaction.';

  @override
  String get privacyIntroTitle => 'Introduction';

  @override
  String get privacyIntroContent =>
      'At Taksh E-Commerce, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.';

  @override
  String get privacyAgreeContent =>
      'By using our app, you agree to the collection and use of information in accordance with this policy.';

  @override
  String get privacyCollectTitle => '1. Information We Collect';

  @override
  String get privacyCollectContent =>
      'We collect several types of information for various purposes:';

  @override
  String get privacyPersonalTitle => 'Personal Information';

  @override
  String get privacyPersonalContent =>
      '• Name, email address, and phone number\n• Shipping and billing addresses\n• Payment information (securely processed)\n• Date of birth (optional)\n• Profile picture (optional)';

  @override
  String get privacyUsageTitle => 'Usage Data';

  @override
  String get privacyUsageContent =>
      '• App usage statistics and preferences\n• Device information (model, OS version)\n• IP address and location data\n• Cookies and similar tracking technologies\n• Search queries and browsing history';

  @override
  String get privacyTransactionTitle => 'Transaction Data';

  @override
  String get privacyTransactionContent =>
      '• Purchase history and order details\n• Payment transaction information\n• Delivery and shipping information\n• Product reviews and ratings';

  @override
  String get privacyUseTitle => '2. How We Use Your Information';

  @override
  String get privacyUseContent =>
      'We use your information for the following purposes:';

  @override
  String get privacyUseItem1 => 'Process and fulfill your orders';

  @override
  String get privacyUseItem2 =>
      'Provide customer support and respond to inquiries';

  @override
  String get privacyUseItem3 => 'Send order confirmations and shipping updates';

  @override
  String get privacyUseItem4 => 'Personalize your shopping experience';

  @override
  String get privacyUseItem5 => 'Improve our products and services';

  @override
  String get privacyUseItem6 =>
      'Send promotional offers and marketing communications';

  @override
  String get privacyUseItem7 => 'Detect and prevent fraud and security issues';

  @override
  String get privacyUseItem8 => 'Comply with legal obligations';

  @override
  String get privacyUseItem9 =>
      'Analyze usage trends and optimize app performance';

  @override
  String get privacySharingTitle => '3. Information Sharing and Disclosure';

  @override
  String get privacySharingContent => 'We may share your information with:';

  @override
  String get privacyProvidersTitle => 'Service Providers';

  @override
  String get privacyProvidersContent =>
      'Third-party vendors who assist us in operating our platform, processing payments, shipping orders, and providing customer service.';

  @override
  String get privacyPartnersTitle => 'Business Partners';

  @override
  String get privacyPartnersContent =>
      'Trusted partners who offer complementary services or products that may interest you.';

  @override
  String get privacyLegalTitle => 'Legal Requirements';

  @override
  String get privacyLegalContent =>
      'When required by law, regulation, legal process, or governmental request.';

  @override
  String get privacyTransferTitle => 'Business Transfers';

  @override
  String get privacyTransferContent =>
      'In connection with a merger, acquisition, or sale of assets.';

  @override
  String get privacySecurityTitle => '4. Data Security';

  @override
  String get privacySecurityContent =>
      'We implement appropriate technical and organizational measures to protect your personal information:\n\n• Encryption of sensitive data in transit and at rest\n• Secure servers and regular security audits\n• Access controls and authentication mechanisms\n• Regular security training for our staff\n• Compliance with industry security standards';

  @override
  String get privacySecurityNote =>
      'While we strive to protect your information, no method of transmission over the internet is 100% secure.';

  @override
  String get privacyRightsTitle => '5. Your Privacy Rights';

  @override
  String get privacyRightsContent =>
      'You have the following rights regarding your personal information:';

  @override
  String get privacyRightsItem1 =>
      'Access: Request a copy of your personal data';

  @override
  String get privacyRightsItem2 =>
      'Correction: Update or correct inaccurate information';

  @override
  String get privacyRightsItem3 =>
      'Deletion: Request deletion of your personal data';

  @override
  String get privacyRightsItem4 =>
      'Opt-out: Unsubscribe from marketing communications';

  @override
  String get privacyRightsItem5 =>
      'Data Portability: Receive your data in a portable format';

  @override
  String get privacyRightsItem6 =>
      'Object: Object to certain data processing activities';

  @override
  String get privacyRightsItem7 =>
      'Withdraw Consent: Withdraw previously given consent';

  @override
  String get privacyCookiesTitle => '6. Cookies and Tracking Technologies';

  @override
  String get privacyCookiesContent =>
      'We use cookies and similar technologies to:\n\n• Remember your preferences and settings\n• Understand how you use our app\n• Provide personalized content and advertisements\n• Analyze app performance and user behavior\n\nYou can control cookies through your device settings, though some features may not function properly if disabled.';

  @override
  String get privacyLinksTitle => '7. Third-Party Links';

  @override
  String get privacyLinksContent =>
      'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies.';

  @override
  String get privacyChildrenTitle => '8. Children\'s Privacy';

  @override
  String get privacyChildrenContent =>
      'Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.';

  @override
  String get privacyRetentionTitle => '9. Data Retention';

  @override
  String get privacyRetentionContent =>
      'We retain your personal information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.';

  @override
  String get privacyInternationalTitle => '10. International Data Transfers';

  @override
  String get privacyInternationalContent =>
      'Your information may be transferred to and maintained on servers located outside your country. We ensure appropriate safeguards are in place for such transfers.';

  @override
  String get privacyChangesTitle => '11. Changes to This Privacy Policy';

  @override
  String get privacyChangesContent =>
      'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy on this page and updating the \"Last Updated\" date.';

  @override
  String get privacyContactTitle => '12. Contact Us';

  @override
  String get privacyContactContent =>
      'If you have any questions about this Privacy Policy or our data practices, please contact us:\n\nEmail: privacy@taksh-ecommerce.com\nPhone: +91 1800-123-4567\nAddress: Mumbai, Maharashtra, India';

  @override
  String get privacyMattersTitle => 'Your Privacy Matters';

  @override
  String get privacyMattersContent =>
      'We are committed to protecting your privacy and handling your data responsibly.';

  @override
  String get ourStoryContent =>
      'Founded in 2020, Taksh E-Commerce emerged with a vision to revolutionize online shopping in India. We started with a simple idea: to make quality products accessible to everyone, everywhere. Today, we serve millions of customers across the country, offering a diverse range of products from electronics to fashion, home essentials to groceries.';

  @override
  String get ourMissionContent =>
      'Our mission is to empower consumers by providing a seamless, trustworthy, and delightful shopping experience. We strive to connect people with products they love while supporting local businesses and promoting sustainable practices.';

  @override
  String get ourVisionContent =>
      'To become India\'s most customer-centric e-commerce platform, where people can discover, explore, and purchase anything they want with complete confidence and convenience.';

  @override
  String get trustTransparencyDesc =>
      'We believe in building lasting relationships through honest communication and reliable service.';

  @override
  String get qualityFirstDesc =>
      'Every product we offer meets our stringent quality standards to ensure customer satisfaction.';

  @override
  String get customerCentricityDesc =>
      'Our customers are at the heart of everything we do. Their satisfaction is our success.';

  @override
  String get sustainabilityDesc =>
      'We are committed to eco-friendly practices and reducing our environmental footprint.';

  @override
  String get innovationDesc =>
      'We continuously evolve our technology and services to provide the best shopping experience.';

  @override
  String get whatWeOfferContent =>
      '• Wide Range of Products: From electronics to fashion, home & kitchen to beauty products\n\n• Competitive Prices: Best deals and offers on quality products\n\n• Fast Delivery: Quick and reliable shipping across India\n\n• Secure Payments: Multiple payment options with top-notch security\n\n• 24/7 Support: Our customer service team is always here to help\n\n• Easy Returns: Hassle-free returns and refunds';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get addressValue => 'Bhopal, Madhya Pradesh, India';

  @override
  String get updateProfileTitle => 'Update Profile';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get mobileLabel => 'Mobile';

  @override
  String get saveDetails => 'Save Details';

  @override
  String get enterValidName => 'Please enter valid name';

  @override
  String get joinDeliveryManTitle => 'Join as Delivery Man';

  @override
  String get fillDetailsDelivery =>
      'Fill in your details to join as a delivery partner';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get mobileRequired => 'Mobile number is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get pincodeLabel => 'Pincode';

  @override
  String get pincodeInvalidLength => 'Pincode must be 6 digits';

  @override
  String get pincodeInvalidFormat => 'Pincode must contain only numbers';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get requiredFieldsNote => '* Required fields';

  @override
  String fillDetailsRequest(String type) {
    return 'Fill in your details to request $type';
  }

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordComplexity =>
      'Password must contain uppercase, lowercase, and number';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameMinLength => 'Name must be at least 2 characters';

  @override
  String get appDevelopment => 'App Development';

  @override
  String get webDevelopment => 'Web Development';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryCharges => 'Delivery Charges';

  @override
  String get platformFee => 'Platform Fee';

  @override
  String get cgst => 'CGST';

  @override
  String get sgst => 'SGST';

  @override
  String get discountLabel => 'Discount';

  @override
  String get otherCharges => 'Other Charges';

  @override
  String get free => 'FREE';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get returnOrder => 'Return Order';

  @override
  String get needHelp => 'Need Help';

  @override
  String get orderIssues => 'Do you have any issues with this order?';

  @override
  String get chatWithUs => 'Chat with us';

  @override
  String get sendEmail => 'Send us an email';

  @override
  String get returnFunctionalityComing =>
      'Return functionality will be available soon. You can contact support for assistance.';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String get description => 'Description';

  @override
  String get similarProducts => 'Similar Products';

  @override
  String get selectVariant => 'Select Variant';

  @override
  String get ratings => 'Ratings';

  @override
  String get failedToLoadProduct => 'Failed to load product';

  @override
  String get retry => 'Retry';

  @override
  String get searching => 'Searching...';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String typeMinCharsToSearch(int count) {
    return 'Type at least $count characters to start searching';
  }

  @override
  String get inStock => 'In stock';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get checkout => 'Checkout';

  @override
  String get deliveryOptions => 'Delivery Options';

  @override
  String get priceDetails => 'Price Details';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get proceedToPay => 'Proceed to Pay';

  @override
  String get addAddress => 'Add Address';

  @override
  String get loadingOrderDetails => 'Loading order details...';

  @override
  String get addAddressToContinue =>
      'Please add a delivery address to continue';

  @override
  String get paymentSuccess => 'Payment Successful';

  @override
  String get paymentFailed => 'Payment Failed';

  @override
  String get orderPlacedSuccessfully =>
      'Your order has been placed successfully!';

  @override
  String get somethingWentWrongPayment =>
      'Something went wrong with your payment';

  @override
  String get viewOrder => 'View Order';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get selectAddress => 'Select Address';

  @override
  String get myAddresses => 'My Addresses';

  @override
  String get noAddressesSaved => 'No addresses saved';

  @override
  String get addFirstAddress => 'Add your first address to get started';

  @override
  String get deleteAddress => 'Delete Address';

  @override
  String get deleteAddressConfirm =>
      'Are you sure you want to delete this address? This action cannot be undone.';

  @override
  String get setDefault => 'Set Default';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get selectLocationOnMap => 'Select Location on Map';

  @override
  String get locationSelected => 'Location Selected';

  @override
  String get tapToPickLocation => 'Tap to pick location on map';

  @override
  String get addressType => 'Address Type';

  @override
  String get recipientName => 'Recipient Name';

  @override
  String get enterRecipientName => 'Enter recipient\'s full name';

  @override
  String get labelOther => 'Label (e.g., Friend\'s House)';

  @override
  String get enterLabel => 'Enter a label for this address';

  @override
  String get houseFlatNo => 'House/Flat/Block No.';

  @override
  String get enterHouseNo => 'Enter house or flat number';

  @override
  String get landmarkOptional => 'Landmark (Optional)';

  @override
  String get landmarkHint => 'E.g., Near City Mall';

  @override
  String get city => 'City';

  @override
  String get enterCity => 'Enter city';

  @override
  String get state => 'State';

  @override
  String get enterState => 'Enter state';

  @override
  String get pincode => 'Pincode';

  @override
  String get enterPincode => 'Enter Pincode';

  @override
  String get pincodeLengthError => 'Pincode must be 6 digits';

  @override
  String get setAsDefaultAddress => 'Set as default address';

  @override
  String get setAsDefaultSubtitle =>
      'This address will be used by default for deliveries';

  @override
  String get updateAddress => 'Update Address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get pleaseEnterRecipientName => 'Please enter recipient name';

  @override
  String get pleaseEnterHouseNo => 'Please enter house/flat number';

  @override
  String get required => 'Required';

  @override
  String get pleaseSelectLocation => 'Please select a location on the map';

  @override
  String get ourStory => 'Our Story';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get ourVision => 'Our Vision';

  @override
  String get ourCoreValues => 'Our Core Values';

  @override
  String get trustTransparency => 'Trust & Transparency';

  @override
  String get qualityFirst => 'Quality First';

  @override
  String get customerCentricity => 'Customer Centricity';

  @override
  String get sustainability => 'Sustainability';

  @override
  String get innovation => 'Innovation';

  @override
  String get whatWeOffer => 'What We Offer';

  @override
  String get ourImpact => 'Our Impact';

  @override
  String get happyCustomers => 'Happy Customers';

  @override
  String get products => 'Products';

  @override
  String get brands => 'Brands';

  @override
  String get cities => 'Cities';

  @override
  String get rating => 'Rating';

  @override
  String get getInTouch => 'Get in Touch';

  @override
  String redirectingToCart(String seconds) {
    return 'Redirecting to cart in $seconds seconds';
  }

  @override
  String errorCode(String code) {
    return 'Error Code: $code';
  }

  @override
  String get backToHome => 'Back to Home';

  @override
  String get orderNumberLabel => 'Order Number';

  @override
  String get searchForProducts => 'Search for products';

  @override
  String get searchForProductsHint => 'Search for products';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get productDetails => 'Product Details';

  @override
  String get searchProducts => 'Search Products';

  @override
  String get quick => 'Quick';

  @override
  String get services => 'Services';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get standard => 'Standard';

  @override
  String get failedToLoadAddresses => 'Failed to load addresses';

  @override
  String get couldNotDeleteAddress =>
      'Could not delete the address. Please try again.';

  @override
  String get couldNotUpdateAddress =>
      'Could not update the address. Please try again.';

  @override
  String get couldNotAddAddress =>
      'Could not add the address. Please try again.';

  @override
  String get couldNotSetDefaultAddress =>
      'Could not set the default address. Please try again.';

  @override
  String get delete => 'Delete';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get enable => 'Enable';

  @override
  String get enableLocation => 'Enable Location';

  @override
  String get home => 'Home';

  @override
  String get locationEnabledMessage =>
      'Location enabled! Showing nearby stores...';

  @override
  String get nearbyStores => 'Nearby Stores';

  @override
  String get findNearbyStores => 'Find Nearby Stores';

  @override
  String get loadingNearbyStores => 'Loading nearby stores...';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get autoDetectLocation => 'Auto-detect your delivery address';

  @override
  String get yourAppContent => 'Your App Content';

  @override
  String get settings => 'Settings';

  @override
  String get locationServices => 'Location Services';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get disableLocation => 'Disable Location';

  @override
  String get ok => 'OK';

  @override
  String get locationAccess => 'Location Access';

  @override
  String get notNow => 'Not Now';

  @override
  String get allow => 'Allow';

  @override
  String get locationPermissionRequired => 'Location Permission Required';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get permissionPermanentlyDenied => 'Permission Permanently Denied';

  @override
  String get appSettings => 'App Settings';

  @override
  String get locationServicesDisabled => 'Location Services Disabled';

  @override
  String get allowLocationAccess => 'Allow Location Access';

  @override
  String get permissionUIComponents => 'Location Permission UI Components';

  @override
  String get showBottomSheet => 'Show Bottom Sheet';

  @override
  String get showRationaleDialog => 'Show Rationale Dialog';

  @override
  String get showSettingsDialog => 'Show Settings Dialog';

  @override
  String get requestPermissionFullFlow => 'Request Permission (Full Flow)';

  @override
  String get getCurrentLocation => 'Get Current Location';

  @override
  String get locationPermissionGranted => 'Location permission granted';

  @override
  String get grantLocationPermission => 'Grant Location Permission';

  @override
  String get dataAlreadyLoaded => 'Data already loaded - instant display!';

  @override
  String get searchSavedAddresses => 'Search saved addresses';

  @override
  String get searchCategories => 'Search categories...';

  @override
  String get searchRestaurantsDishes => 'Search for restaurants, dishes...';

  @override
  String get searchAreaStreetName => 'Search for area, street name...';

  @override
  String get joinAsVendorTitle => 'Join as Vendor';

  @override
  String get vendorFillDetails =>
      'Fill in your vendor shop details. Required fields are marked with *';

  @override
  String get vendorShopDetails => 'Shop Details';

  @override
  String get vendorShopDetailsSubtitle => 'Enter your shop information';

  @override
  String get vendorOwnerDetails => 'Owner Details';

  @override
  String get vendorOwnerDetailsSubtitle => 'Enter owner information';

  @override
  String get vendorDocuments => 'Documents';

  @override
  String get vendorDocumentsSubtitle =>
      'Upload required documents for verification';

  @override
  String get vendorShopName => 'Shop Name';

  @override
  String get vendorShopNameHint => 'Enter shop name';

  @override
  String get vendorShopAddress => 'Shop Address';

  @override
  String get vendorShopAddressHint => 'Enter complete shop address';

  @override
  String get vendorShopPincode => 'Shop Pincode';

  @override
  String get vendorShopPincodeHint => 'Enter 6-digit pincode';

  @override
  String get vendorShopLocation => 'Shop Location *';

  @override
  String get vendorShopImages => 'Shop Images *';

  @override
  String get vendorShopImagesSubtitle => 'Upload up to 5 shop images';

  @override
  String get vendorOwnerName => 'Owner Name';

  @override
  String get vendorOwnerNameHint => 'Enter owner full name';

  @override
  String get vendorOwnerAddress => 'Owner Address';

  @override
  String get vendorOwnerAddressHint => 'Enter complete owner address';

  @override
  String get vendorOwnerPincode => 'Owner Pincode';

  @override
  String get vendorOwnerPincodeHint => 'Enter 6-digit pincode';

  @override
  String get vendorOwnerLocation => 'Owner Location *';

  @override
  String get vendorMobileNumber => 'Mobile Number';

  @override
  String get vendorMobileNumberHint => 'Enter 10-digit mobile number';

  @override
  String get vendorEmailId => 'Email ID';

  @override
  String get vendorEmailIdHint => 'Enter email address';

  @override
  String get vendorOwnerImages => 'Owner Images *';

  @override
  String get vendorOwnerImagesSubtitle => 'Upload up to 2 owner images';

  @override
  String get vendorPickLocation => 'Pick Location from Map';

  @override
  String get vendorAadharCard => 'Aadhar Card';

  @override
  String get vendorPanCard => 'PAN Card';

  @override
  String get vendorBankAccount => 'Bank Account';

  @override
  String get vendorGstNumber => 'GST Number';

  @override
  String get vendorNonGstCertificate => 'Non GST Certificate';

  @override
  String get vendorNonGstCertificateSubtitle => 'Upload Non GST certificate';

  @override
  String get vendorMsmeCertificate => 'MSME Certificate';

  @override
  String get vendorMsmeCertificateSubtitle =>
      'Upload MSME certificate (if applicable)';

  @override
  String get vendorFssaiCertificate => 'FSSAI Certificate *';

  @override
  String get vendorFssaiCertificateSubtitle =>
      'Upload FSSAI license for food businesses';

  @override
  String get vendorShopAgreement => 'Shop Agreement';

  @override
  String get vendorShopAgreementSubtitle => 'Upload shop agreement (optional)';

  @override
  String get vendorSubmitApplication => 'Submit Application';

  @override
  String get vendorAadharDetails => 'Aadhar Details';

  @override
  String get vendorAadharNumber => 'Aadhar Number *';

  @override
  String get vendorAadharNumberHint => 'Enter 12-digit Aadhar number';

  @override
  String get vendorAadharDocument => 'Aadhar Number Document *';

  @override
  String get vendorPanDetails => 'PAN Details';

  @override
  String get vendorPanCardNumber => 'PAN Card Number *';

  @override
  String get vendorPanCardNumberHint =>
      'Enter PAN card number (e.g., ABCDE1234F)';

  @override
  String get vendorPanDocument => 'PAN Card Number Document *';

  @override
  String get vendorBankDetails => 'Bank Details';

  @override
  String get vendorAccountNumber => 'Account Number *';

  @override
  String get vendorAccountNumberHint => 'Enter bank account number';

  @override
  String get vendorIfscCode => 'IFSC Code *';

  @override
  String get vendorIfscCodeHint => 'Enter IFSC code';

  @override
  String get vendorAccountHolderName => 'Account Holder Name *';

  @override
  String get vendorAccountHolderNameHint => 'Enter account holder name';

  @override
  String get vendorBankName => 'Bank Name *';

  @override
  String get vendorBankNameHint => 'Enter bank name (optional)';

  @override
  String get vendorBranchName => 'Branch Name';

  @override
  String get vendorBranchNameHint => 'Enter branch name (optional)';

  @override
  String get vendorUploadBankProof => 'Upload Bank Proof';

  @override
  String get vendorUploadBankProofSubtitle =>
      'Upload either Bank Passbook or Cancelled Cheque';

  @override
  String get vendorBankDocument => 'Bank Document *';

  @override
  String get vendorGstDetails => 'GST Details';

  @override
  String get vendorGstNumberLabel => 'GST Number *';

  @override
  String get vendorGstNumberHint => 'Enter 15-digit GST number';

  @override
  String get vendorGstDocument => 'GST Number Document *';

  @override
  String get vendorSaveAndVerify => 'Save & Verify';

  @override
  String get vendorUploadDocument => 'Upload Document';

  @override
  String get vendorUploadDocumentHint => 'PDF, JPG, PNG (Max 5MB)';

  @override
  String get vendorAddImage => 'Add';

  @override
  String get vendorJoinSuccess => 'Vendor application submitted successfully!';

  @override
  String get vendorShopNameRequired => 'Shop name is required';

  @override
  String get vendorShopLocationRequired => 'Shop location is required';

  @override
  String get vendorShopImagesRequired => 'At least one shop image is required';

  @override
  String get vendorOwnerLocationRequired => 'Owner location is required';

  @override
  String get vendorOwnerImagesRequired =>
      'At least one owner image is required';

  @override
  String get vendorOwnerImageRequired => 'Owner image is required';

  @override
  String get vendorVendorDetails => 'Vendor Details';

  @override
  String get vendorVendorDetailsSubtitle =>
      'Enter your vendor registration details';

  @override
  String get vendorVendorName => 'Vendor Name';

  @override
  String get vendorVendorNameHint => 'Enter vendor/store name';

  @override
  String get vendorVendorNameRequired => 'Vendor name is required';

  @override
  String get vendorAddress => 'Address';

  @override
  String get vendorAddressHint => 'Enter vendor address';

  @override
  String get vendorAddressRequired => 'Address is required';

  @override
  String get vendorPincode => 'Pincode';

  @override
  String get vendorPincodeHint => 'Enter pincode';

  @override
  String get vendorPincodeRequired => 'Pincode is required';

  @override
  String get vendorStateId => 'State';

  @override
  String get vendorStateIdHint => 'Enter state ID';

  @override
  String get vendorStateIdRequired => 'State is required';

  @override
  String get vendorCityId => 'City';

  @override
  String get vendorCityIdHint => 'Enter city ID';

  @override
  String get vendorCityIdRequired => 'City is required';

  @override
  String get vendorOwnerImage => 'Owner Image *';

  @override
  String get vendorOwnerImageSubtitle => 'Upload owner photo';

  @override
  String get vendorShopAddressRequired => 'Shop address is required';

  @override
  String get vendorShopPincodeRequired => 'Shop pincode is required';

  @override
  String get vendorOwnerNameRequired => 'Owner name is required';

  @override
  String get vendorOwnerAddressRequired => 'Owner address is required';

  @override
  String get vendorOwnerPincodeRequired => 'Owner pincode is required';

  @override
  String get vendorMobileNumberRequired => 'Mobile number is required';

  @override
  String get vendorEmailRequired => 'Email is required';

  @override
  String get vendorAadhaarNumberRequired => 'Aadhaar number is required';

  @override
  String get vendorAadhaarFileRequired => 'Aadhaar document is required';

  @override
  String get vendorPanFileRequired => 'PAN document is required';

  @override
  String get vendorBankFileRequired => 'Bank document is required';

  @override
  String get vendorGstFileRequired => 'GST document is required';

  @override
  String get vendorGstOrNonGstRequired =>
      'Upload either GST document or Non-GST certificate';

  @override
  String get vendorFssaiFileRequired => 'FSSAI certificate is required';

  @override
  String get chooseHowToReachUs => 'Choose how you\'d like to reach us';

  @override
  String get requestCallback => 'Request Callback';

  @override
  String get requestCallbackDescription => 'Get a call from our support team';

  @override
  String get emailSupport => 'Email Support';

  @override
  String get emailSupportDescription =>
      'Send us an email at customersupport@takshallinone.in';

  @override
  String get emailAppError =>
      'Could not open email app. Please email us at customersupport@takshallinone.in';

  @override
  String get myWishlist => 'My Wishlist';

  @override
  String get addedToWishlist => 'Added to wishlist';

  @override
  String get removedFromWishlist => 'Removed from wishlist';

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get wishlistEmptySubtitle =>
      'Browse products and add your favorites here';

  @override
  String get removeFromWishlistConfirm => 'Remove from wishlist?';

  @override
  String get failedToLoadWishlist => 'Failed to load wishlist';

  @override
  String get couldNotAddToCart =>
      'Could not add item to cart. Please try again.';

  @override
  String get couldNotLoadProduct =>
      'Could not load product details. Please try again.';

  @override
  String get noVariantsAvailable => 'This product is currently unavailable.';

  @override
  String get cartUnexpectedError => 'Something went wrong. Please try again.';

  @override
  String get checkDeliveryAvailability => 'Check Delivery Availability';

  @override
  String get invalidPincode => 'Please enter a valid 6-digit pincode';

  @override
  String get check => 'Check';

  @override
  String fulfilledBy(String shopName) {
    return 'Fulfilled by $shopName';
  }

  @override
  String get couldNotCheckDelivery =>
      'Could not check delivery availability. Please try again.';

  @override
  String get homeServices => 'Home Services';

  @override
  String get homeServicesSubtitle =>
      'Book professional services at your doorstep';

  @override
  String get couldNotLoadServices => 'Could not load services';

  @override
  String get courierBooking => 'Courier Booking';

  @override
  String get customerAndPickupDetails => 'Customer & Pickup Details';

  @override
  String get electrician => 'Electrician';

  @override
  String get plumber => 'Plumber';

  @override
  String get salonParlor => 'Salon / Parlor';

  @override
  String get pickupDetails => 'Pickup Details';

  @override
  String get pickupAddress => 'Pickup Address';

  @override
  String get enterPickupAddress => 'Enter full pickup address';

  @override
  String get pickupPincode => 'Pickup Pincode';

  @override
  String get deliveryDetails => 'Delivery Details';

  @override
  String get enterDeliveryAddress => 'Enter full delivery address';

  @override
  String get deliveryPincode => 'Delivery Pincode';

  @override
  String get parcelDetails => 'Parcel Details';

  @override
  String get packagingDetails => 'Packaging Details';

  @override
  String get enterProductDetails => 'Enter product name and details';

  @override
  String get enterPackagingDetails => 'Envelope, box, etc.';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get dimensionUnit => 'Dimension Unit';

  @override
  String get additionalInfo => 'Additional Info';

  @override
  String get customerNotes => 'Customer Notes (optional)';

  @override
  String get addProductImage => 'Add Product Image (optional)';

  @override
  String get checkPrice => 'Check Price';

  @override
  String get bookService => 'Book Service';

  @override
  String get priceCheckComplete => 'Price Check Complete';

  @override
  String get bookingSubmitted => 'Booking Submitted';

  @override
  String get tokenAmount => 'Token Amount';

  @override
  String get serviceHistory => 'Service History';

  @override
  String get history => 'History';

  @override
  String get noPreviousOrders => 'No previous orders';

  @override
  String get serviceHistoryEmpty =>
      'Your service booking history will appear here';

  @override
  String get couldNotLoadHistory => 'Could not load history';

  @override
  String get inquiryId => 'Inquiry ID';

  @override
  String get yourAddress => 'Your Address';

  @override
  String get fullAddress => 'Full Address';

  @override
  String get enterCompleteAddress => 'Enter your complete address';

  @override
  String get serviceDescription => 'Service Description';

  @override
  String get describeServiceNeeded => 'Describe the service you need';

  @override
  String get sixDigitPincode => '6-digit pincode';

  @override
  String get enterValidPincode => 'Enter a valid 6-digit pincode';

  @override
  String guestWallTitle(String contentLabel) {
    return 'Login to view $contentLabel';
  }

  @override
  String guestWallSubtitle(String contentLabel) {
    return 'Sign in to access $contentLabel and enjoy a personalised shopping experience with order tracking, saved addresses, and more.';
  }

  @override
  String get guestWallLoginButton => 'Login to Continue';

  @override
  String get guestWallContinueBrowsing => 'Continue browsing as guest';

  @override
  String get loginCancelButton => 'Cancel';

  @override
  String get orderReview => 'Review Order';

  @override
  String get reviewYourOrder => 'Review your order before confirming';

  @override
  String get reviewOrderDescription =>
      'Please verify the details below and tap \"Confirm Order\" to place your order.';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get confirmingOrder => 'Placing your order...';

  @override
  String get deliveryTo => 'Delivering to';

  @override
  String get payment => 'Payment';

  @override
  String get orderSummaryTitle => 'Order Summary';

  @override
  String get itemTotal => 'Item Total';

  @override
  String get platformFees => 'Platform Fees';

  @override
  String get otherChargesLabel => 'Other Charges';

  @override
  String get orderPlacedTitle => 'Order Placed';

  @override
  String get orderPlacedSubtitle =>
      'Your order has been placed successfully. Pay on delivery.';

  @override
  String get orderPlacedOnlineSubtitle =>
      'Your order has been placed successfully. Redirecting to payment...';

  @override
  String get thankYouForOrder => 'Thank you for your order!';

  @override
  String get viewMyOrders => 'View My Orders';

  @override
  String get back => 'Back';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Shop everything you need';

  @override
  String get onboardingSubtitle1 =>
      'Discover thousands of products from local stores, delivered straight to your door.';

  @override
  String get onboardingTitle2 => 'Fast & reliable delivery';

  @override
  String get onboardingSubtitle2 =>
      'Track your orders in real-time and get them delivered in minutes, not days.';

  @override
  String get onboardingTitle3 => 'Safe & secure payments';

  @override
  String get onboardingSubtitle3 =>
      'Pay with confidence using trusted payment methods, every single time.';
}
