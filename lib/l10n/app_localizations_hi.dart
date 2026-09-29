// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'तक्ष ई-कॉमर्स';

  @override
  String get madeInIndia => 'भारत में निर्मित';

  @override
  String get initializing => 'आरंभ हो रहा है...';

  @override
  String get checkingAuthentication => 'प्रमाणीकरण की जाँच हो रही है...';

  @override
  String get loadingData => 'डेटा लोड हो रहा है...';

  @override
  String get login => 'लॉगिन';

  @override
  String get loginTagline => 'भोजन आपके दरवाजे तक पहुँचाया गया';

  @override
  String get enterPhoneDescription =>
      'ओटीपी प्राप्त करने के लिए अपना फोन नंबर दर्ज करें';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get enterPhoneNumberHint => '10 अंकों का फोन नंबर दर्ज करें';

  @override
  String get sendOtp => 'ओटीपी भेजें';

  @override
  String get termsAndPrivacy =>
      'जारी रखकर, आप हमारी सेवा की शर्तों और गोपनीयता नीति से सहमत होते हैं';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करें';

  @override
  String enterOtpDescription(String phone) {
    return '$phone पर भेजा गया 4-अंकीय कोड दर्ज करें';
  }

  @override
  String get otpHint => '0000';

  @override
  String get verifyOtpButton => 'ओटीपी सत्यापित करें';

  @override
  String get didNotReceiveCode => 'कोड प्राप्त नहीं हुआ? ';

  @override
  String resendIn(int seconds) {
    return '${seconds}s में पुनः भेजें';
  }

  @override
  String get resendOtp => 'ओटीपी पुनः भेजें';

  @override
  String get otpResentSuccess => 'ओटीपी सफलतापूर्वक पुनः भेजा गया';

  @override
  String get loginSuccess => 'लॉगिन सफल रहा';

  @override
  String get phoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get invalidPhone => 'एक मान्य 10-अंकीय फ़ोन नंबर दर्ज करें';

  @override
  String get otpRequired => 'ओटीपी आवश्यक है';

  @override
  String get invalidOtp => 'एक मान्य 4-अंकीय ओटीपी दर्ज करें';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get appearance => 'दिखावट';

  @override
  String get light => 'हल्का';

  @override
  String get dark => 'डार्क';

  @override
  String get system => 'सिस्टम';

  @override
  String themeChanged(String theme) {
    return 'थीम बदलकर $theme कर दी गई';
  }

  @override
  String get preferences => 'वरीयताएँ';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String languageChanged(String language) {
    return 'भाषा बदलकर $language कर दी गई';
  }

  @override
  String get general => 'सामान्य';

  @override
  String get myAddress => 'मेरा पता';

  @override
  String get coupons => 'कूपन';

  @override
  String get paymentMethodsComingSoon => 'भुगतान के तरीके - जल्द ही आ रहे हैं';

  @override
  String get earnings => 'कमाई';

  @override
  String get joinAsDeliveryMan => 'डिलीवरी मैन के रूप में शामिल हों';

  @override
  String get openVendor => 'वेंडर खोलें';

  @override
  String get languageSettingsComingSoon => 'भाषा सेटिंग्स - जल्द ही आ रही हैं';

  @override
  String get createApplication => 'एप्लिकेशन बनाएं';

  @override
  String get createWebsite => 'वेबसाइट बनाएं';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get liveChat => 'लाइव चैट';

  @override
  String get aboutUs => 'हमारे बारे में';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get refundPolicy => 'धनवापसी नीति';

  @override
  String get support => 'सहायता';

  @override
  String get remove => 'हटाएं';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String version(String version) {
    return 'संस्करण $version';
  }

  @override
  String get standardDelivery => 'स्टैंडर्ड डिलीवरी';

  @override
  String get standardDeliveryDescription =>
      'स्टैंडर्ड डिलीवरी - अपने पसंदीदा सामान की खरीदारी करें!';

  @override
  String get quickDelivery => 'क्विक डिलीवरी';

  @override
  String get quickDeliveryDescription => 'क्विक डिलीवरी - एक्सप्रेस 30';

  @override
  String get homeService => 'होम सर्विस';

  @override
  String get homeServiceDescription => 'होम सर्विसेज जल्द ही आ रही हैं';

  @override
  String get searchHint => 'उत्पादों की खोज करें...';

  @override
  String get somethingWentWrong => 'ओह! कुछ गलत हो गया';

  @override
  String get tryAgain => 'फिर से प्रयास करें';

  @override
  String get exitAppTitle => 'ऐप से बाहर निकलें?';

  @override
  String get exitAppContent => 'क्या आप वाकई बाहर निकलना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get homeTab => 'होम';

  @override
  String get categoriesTab => 'श्रेणियाँ';

  @override
  String get cartTab => 'कार्ट';

  @override
  String get ordersTab => 'ऑर्डर';

  @override
  String get profileTab => 'प्रोफ़ाइल';

  @override
  String get cart => 'कार्ट';

  @override
  String get clearCart => 'कार्ट खाली करें';

  @override
  String get cartEmptyTitle => 'आपकी कार्ट खाली है';

  @override
  String get cartEmptySubtitle => 'शुरू करने के लिए आइटम जोड़ें';

  @override
  String get startShopping => 'खरीदारी शुरू करें';

  @override
  String sku(String sku) {
    return 'SKU: $sku';
  }

  @override
  String total(String amount) {
    return 'कुल: ₹$amount';
  }

  @override
  String get removeItemTitle => 'आइटम हटाएं';

  @override
  String removeItemConfirm(String product) {
    return 'कार्ट से $product हटाएं?';
  }

  @override
  String get clearCartConfirm => 'कार्ट से सभी आइटम हटाएं?';

  @override
  String totalItemsLabel(int count) {
    return 'कुल आइटम: $count';
  }

  @override
  String get proceedToCheckout => 'चेकआउट के लिए आगे बढ़ें';

  @override
  String get myOrders => 'मेरे ऑर्डर';

  @override
  String get filterByStatus => 'स्थिति के अनुसार फ़िल्टर करें';

  @override
  String get allOrders => 'सभी ऑर्डर';

  @override
  String get readyForDispatch => 'शिपमेंट के लिए तैयार';

  @override
  String get dispatched => 'भेज दिया गया';

  @override
  String get delivered => 'पहुँचा दिया गया';

  @override
  String get dateNewestFirst => 'दिनांक: नवीनतम पहले';

  @override
  String get dateOldestFirst => 'दिनांक: सबसे पुराना पहले';

  @override
  String get amountHighToLow => 'राशि: उच्च से निम्न';

  @override
  String get amountLowToHigh => 'राशि: निम्न से उच्च';

  @override
  String get recentlyUpdated => 'हाल ही में अपडेट किया गया';

  @override
  String get leastRecentlyUpdated => 'सबसे कम हाल ही में अपडेट किया गया';

  @override
  String get noOrdersFound => 'कोई ऑर्डर नहीं मिला';

  @override
  String get tryAdjustingFilters =>
      'अपने फ़िल्टर को समायोजित करने का प्रयास करें';

  @override
  String get filterByDate => 'तारीख़ से फ़िल्टर करें';

  @override
  String get clearDateFilter => 'तारीख़ फ़िल्टर हटाएँ';

  @override
  String get noOrdersYet => 'अभी तक कोई ऑर्डर नहीं';

  @override
  String get yourOrdersAppearHere => 'आपके ऑर्डर यहाँ दिखाई देंगे';

  @override
  String orderNumber(String number) {
    return 'ऑर्डर # $number';
  }

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(int days) {
    return '$days दिन पहले';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0';
  }

  @override
  String estDelivery(String date) {
    return 'अनुमानित डिलीवरी: $date';
  }

  @override
  String get orderDetails => 'ऑर्डर विवरण';

  @override
  String placedOn(String date) {
    return '$date को दिया गया';
  }

  @override
  String get deliveryType => 'डिलीवरी का प्रकार';

  @override
  String get paymentMethod => 'भुगतान का तरीका';

  @override
  String get paymentStatus => 'भुगतान की स्थिति';

  @override
  String get estimatedDelivery => 'अनुमानित डिलीवरी';

  @override
  String get invoice => 'इनवॉइस';

  @override
  String get cancelOrder => 'ऑर्डर रद्द करें';

  @override
  String orderItems(int count) {
    return 'ऑर्डर आइटम ($count)';
  }

  @override
  String qtyPrice(int qty, String price) {
    return 'मात्रा: $qty × ₹$price';
  }

  @override
  String get returnItem => 'आइटम वापस करें';

  @override
  String get deliveryAddress => 'डिलीवरी का पता';

  @override
  String get paymentInformation => 'भुगतान की जानकारी';

  @override
  String paidVia(String method) {
    return '$method के माध्यम से भुगतान किया गया';
  }

  @override
  String get orders => 'ऑर्डर';

  @override
  String get wishlist => 'विशलिस्ट';

  @override
  String get reviews => 'समीक्षाएं';

  @override
  String get whatsappError =>
      'WhatsApp नहीं खुल सका। कृपया सुनिश्चित करें कि WhatsApp इंस्टॉल है।';

  @override
  String lastUpdated(String date) {
    return 'अंतिम अपडेट: $date';
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
  String get refundMethodBankTitle => 'बैंक ट्रांसफर';

  @override
  String get refundMethodBankDesc =>
      'सीधे आपके बैंक खाते में ट्रांसफर (खाता विवरण आवश्यक)';

  @override
  String get refundMethodBankDays => '7-10 दिन';

  @override
  String get refundDamagedTitle => '6. क्षतिग्रस्त या दोषपूर्ण उत्पाद';

  @override
  String get refundDamagedContent =>
      'यदि आपको क्षतिग्रस्त या दोषपूर्ण उत्पाद प्राप्त होता है:\n\n• डिलीवरी के 48 घंटों के भीतर रिपोर्ट करें\n• क्षति/दोष की स्पष्ट तस्वीरें प्रदान करें\n• हम तत्काल पिकअप की व्यवस्था करेंगे\n• प्रतिस्थापन या पूर्ण धनवापसी संसाधित की जाएगी\n• वास्तविक मामलों के लिए कोई प्रश्न नहीं पूछा जाएगा';

  @override
  String get refundWrongTitle => '7. गलत उत्पाद वितरित';

  @override
  String get refundWrongContent =>
      'यदि आपको गलत उत्पाद प्राप्त होता है:\n\n• ऐप के माध्यम से तुरंत हमसे संपर्क करें\n• हम मुफ्त वापसी पिकअप की व्यवस्था करेंगे\n• सही उत्पाद तुरंत भेज दिया जाएगा\n• यदि सही उत्पाद अनुपलब्ध है, तो पूर्ण धनवापसी जारी की जाएगी';

  @override
  String get refundPartialTitle => '8. आंशिक धनवापसी';

  @override
  String get refundPartialContent =>
      'कुछ स्थितियों में, आंशिक धनवापसी दी जा सकती है:';

  @override
  String get refundPartialItem1 =>
      'वापसी खिड़की के बाद लेकिन 15 दिनों के भीतर लौटाई गई वस्तुएं';

  @override
  String get refundPartialItem2 =>
      'उपयोग के संकेतों या मामूली क्षति वाले उत्पाद';

  @override
  String get refundPartialItem3 => 'सामान या पैकेजिंग गायब होने वाली वस्तुएं';

  @override
  String get refundPartialItem4 =>
      'रियायती या बिक्री वाली वस्तुएं (शर्तों के अनुसार)';

  @override
  String get refundExchangeTitle => '9. विनिमय नीति';

  @override
  String get refundExchangeContent =>
      'हम इसके लिए आसान विनिमय प्रदान करते हैं:\n\n• आकार या रंग विविधताएं\n• विभिन्न उत्पाद मॉडल\n• उन्नत संस्करण\n\nविनिमय प्रक्रिया रिटर्न के समान है, लेकिन आप वापसी अनुरोध के दौरान एक प्रतिस्थापन उत्पाद का चयन कर सकते हैं।';

  @override
  String get refundCancelTitle => '10. रद्दीकरण नीति';

  @override
  String get refundCancelContent =>
      'आप अपने ऑर्डर को शिप किए जाने से पहले रद्द कर सकते हैं:\n\n• प्री-शिपमेंट रद्दीकरण के लिए पूर्ण धनवापसी\n• मूल भुगतान विधि में त्वरित प्रसंस्करण\n• कोई रद्दीकरण शुल्क नहीं\n• 3-5 व्यावसायिक दिनों के भीतर धनवापसी';

  @override
  String get refundContactTitle => '11. रिटर्न के लिए संपर्क करें';

  @override
  String get refundContactContent =>
      'रिटर्न या रिफंड के साथ मदद चाहिए? हमसे संपर्क करें:\n\nईमेल: returns@taksh-ecommerce.com\nलाइव चैट: ऐप में 24/7 उपलब्ध\n\nहमारी ग्राहक सहायता टीम रिटर्न और रिफंड प्रक्रिया के दौरान आपकी सहायता के लिए यहां है।';

  @override
  String get refundSatisfactionTitle => '100% संतुष्टि की गारंटी';

  @override
  String get refundSatisfactionContent =>
      'हम अपने उत्पादों के साथ खड़े हैं और आपकी संतुष्टि के लिए प्रतिबद्ध हैं।';

  @override
  String get privacyIntroTitle => 'परिचय';

  @override
  String get privacyIntroContent =>
      'Taksh E-Commerce में, हम आपकी गोपनीयता की रक्षा करने और आपकी व्यक्तिगत जानकारी की सुरक्षा सुनिश्चित करने के लिए प्रतिबद्ध हैं। यह गोपनीयता नीति बताती है कि जब आप हमारे मोबाइल एप्लिकेशन और सेवाओं का उपयोग करते हैं तो हम आपकी जानकारी कैसे एकत्र करते हैं, उपयोग करते हैं, प्रकट करते हैं और सुरक्षित करते हैं।';

  @override
  String get privacyAgreeContent =>
      'हमारे ऐप का उपयोग करके, आप इस नीति के अनुसार जानकारी के संग्रह और उपयोग के लिए सहमत हैं।';

  @override
  String get privacyCollectTitle => '1. जानकारी जो हम एकत्र करते हैं';

  @override
  String get privacyCollectContent =>
      'हम विभिन्न उद्देश्यों के लिए कई प्रकार की जानकारी एकत्र करते हैं:';

  @override
  String get privacyPersonalTitle => 'व्यक्तिगत जानकारी';

  @override
  String get privacyPersonalContent =>
      '• नाम, ईमेल पता, और फोन नंबर\n• शिपिंग और बिलिंग पते\n• भुगतान जानकारी (सुरक्षित रूप से संसाधित)\n• जन्म तिथि (वैकल्पिक)\n• प्रोफ़ाइल चित्र (वैकल्पिक)';

  @override
  String get privacyUsageTitle => 'उपयोग डेटा';

  @override
  String get privacyUsageContent =>
      '• ऐप उपयोग के आंकड़े और प्राथमिकताएं\n• डिवाइस जानकारी (मॉडल, ओएस संस्करण)\n• आईपी पता और स्थान डेटा\n• कुकीज़ और समान ट्रैकिंग प्रौद्योगिकियां\n• खोज प्रश्न और ब्राउज़िंग इतिहास';

  @override
  String get privacyTransactionTitle => 'लेनदेन डेटा';

  @override
  String get privacyTransactionContent =>
      '• खरीद इतिहास और ऑर्डर विवरण\n• भुगतान लेनदेन की जानकारी\n• डिलीवरी और शिपिंग जानकारी\n• उत्पाद समीक्षा और रेटिंग';

  @override
  String get privacyUseTitle => '2. हम आपकी जानकारी का उपयोग कैसे करते हैं';

  @override
  String get privacyUseContent =>
      'हम आपकी जानकारी का उपयोग निम्नलिखित उद्देश्यों के लिए करते हैं:';

  @override
  String get privacyUseItem1 => 'आपके ऑर्डर को संसाधित और पूरा करने के लिए';

  @override
  String get privacyUseItem2 =>
      'ग्राहक सहायता प्रदान करने और पूछताछ का जवाब देने के लिए';

  @override
  String get privacyUseItem3 => 'ऑर्डर पुष्टि और शिपिंग अपडेट भेजने के लिए';

  @override
  String get privacyUseItem4 => 'आपकी खरीदारी के अनुभव को निजीकृत करने के लिए';

  @override
  String get privacyUseItem5 =>
      'हमारे उत्पादों और सेवाओं में सुधार करने के लिए';

  @override
  String get privacyUseItem6 => 'प्रचार प्रस्ताव और विपणन संचार भेजने के लिए';

  @override
  String get privacyUseItem7 =>
      'धोखाधड़ी और सुरक्षा मुद्दों का पता लगाने और रोकने के लिए';

  @override
  String get privacyUseItem8 => 'कानूनी दायित्वों का पालन करने के लिए';

  @override
  String get privacyUseItem9 =>
      'उपयोग के रुझानों का विश्लेषण और ऐप के प्रदर्शन को अनुकूलित करने के लिए';

  @override
  String get privacySharingTitle => '3. सूचना साझाकरण और प्रकटीकरण';

  @override
  String get privacySharingContent =>
      'हम आपकी जानकारी इनके साथ साझा कर सकते हैं:';

  @override
  String get privacyProvidersTitle => 'सेवा प्रदाता';

  @override
  String get privacyProvidersContent =>
      'तृतीय-पक्ष विक्रेता जो हमारे प्लेटफॉर्म को संचालित करने, भुगतान संसाधित करने, ऑर्डर शिप करने और ग्राहक सेवा प्रदान करने में हमारी सहायता करते हैं।';

  @override
  String get privacyPartnersTitle => 'व्यापार भागीदार';

  @override
  String get privacyPartnersContent =>
      'विश्वसनीय भागीदार जो पूरक सेवाएं या उत्पाद प्रदान करते हैं जो आपकी रुचि के हो सकते हैं।';

  @override
  String get privacyLegalTitle => 'कानूनी आवश्यकताएं';

  @override
  String get privacyLegalContent =>
      'जब कानून, विनियमन, कानूनी प्रक्रिया या सरकारी अनुरोध द्वारा आवश्यक हो।';

  @override
  String get privacyTransferTitle => 'व्यापार हस्तांतरण';

  @override
  String get privacyTransferContent =>
      'विलय, अधिग्रहण, या संपत्ति की बिक्री के संबंध में।';

  @override
  String get privacySecurityTitle => '4. डेटा सुरक्षा';

  @override
  String get privacySecurityContent =>
      'हम आपकी व्यक्तिगत जानकारी की सुरक्षा के लिए उचित तकनीकी और संगठनात्मक उपाय लागू करते हैं:\n\n• पारगमन और आराम में संवेदनशील डेटा का एन्क्रिप्शन\n• सुरक्षित सर्वर और नियमित सुरक्षा ऑडिट\n• एक्सेस नियंत्रण और प्रमाणीकरण तंत्र\n• हमारे कर्मचारियों के लिए नियमित सुरक्षा प्रशिक्षण\n• उद्योग सुरक्षा मानकों का अनुपालन';

  @override
  String get privacySecurityNote =>
      'जबकि हम आपकी जानकारी की रक्षा करने का प्रयास करते हैं, इंटरनेट पर संचरण का कोई भी तरीका 100% सुरक्षित नहीं है।';

  @override
  String get privacyRightsTitle => '5. आपके गोपनीयता अधिकार';

  @override
  String get privacyRightsContent =>
      'आपकी व्यक्तिगत जानकारी के संबंध में आपके पास निम्नलिखित अधिकार हैं:';

  @override
  String get privacyRightsItem1 =>
      'एक्सेस: अपने व्यक्तिगत डेटा की एक प्रति का अनुरोध करें';

  @override
  String get privacyRightsItem2 => 'सुधार: गलत जानकारी को अपडेट या सही करें';

  @override
  String get privacyRightsItem3 =>
      'हटाना: अपने व्यक्तिगत डेटा को हटाने का अनुरोध करें';

  @override
  String get privacyRightsItem4 =>
      'ऑप्ट-आउट: मार्केटिंग संचार से सदस्यता समाप्त करें';

  @override
  String get privacyRightsItem5 =>
      'डेटा पोर्टेबिलिटी: पोर्टेबल प्रारूप में अपना डेटा प्राप्त करें';

  @override
  String get privacyRightsItem6 =>
      'आपत्ति: कुछ डेटा प्रसंस्करण गतिविधियों पर आपत्ति करें';

  @override
  String get privacyRightsItem7 => 'सहमति वापस लेना: पहले दी गई सहमति वापस लें';

  @override
  String get privacyCookiesTitle => '6. कुकीज़ और ट्रैकिंग प्रौद्योगिकियां';

  @override
  String get privacyCookiesContent =>
      'हम कुकीज़ और समान तकनीकों का उपयोग करते हैं:\n\n• अपनी प्राथमिकताओं और सेटिंग्स को याद रखने के लिए\n• यह समझने के लिए कि आप हमारे ऐप का उपयोग कैसे करते हैं\n• व्यक्तिगत सामग्री और विज्ञापन प्रदान करने के लिए\n• ऐप के प्रदर्शन और उपयोगकर्ता व्यवहार का विश्लेषण करने के लिए\n\nआप अपनी डिवाइस सेटिंग्स के माध्यम से कुकीज़ को नियंत्रित कर सकते हैं, हालांकि अक्षम होने पर कुछ सुविधाएं ठीक से काम नहीं कर सकती हैं।';

  @override
  String get privacyLinksTitle => '7. तृतीय-पक्ष लिंक';

  @override
  String get privacyLinksContent =>
      'हमारे ऐप में तृतीय-पक्ष वेबसाइटों या सेवाओं के लिंक हो सकते हैं। हम इन तृतीय पक्षों की गोपनीयता प्रथाओं के लिए जिम्मेदार नहीं हैं। हम आपको उनकी गोपनीयता नीतियों की समीक्षा करने के लिए प्रोत्साहित करते हैं।';

  @override
  String get privacyChildrenTitle => '8. बच्चों की गोपनीयता';

  @override
  String get privacyChildrenContent =>
      'हमारी सेवा 13 वर्ष से कम उम्र के बच्चों के लिए नहीं है। हम जानबूझकर बच्चों से व्यक्तिगत जानकारी एकत्र नहीं करते हैं। यदि आप माता-पिता या अभिभावक हैं और मानते हैं कि आपके बच्चे ने हमें व्यक्तिगत जानकारी प्रदान की है, तो कृपया हमसे संपर्क करें।';

  @override
  String get privacyRetentionTitle => '9. डेटा प्रतिधारण';

  @override
  String get privacyRetentionContent =>
      'हम आपकी व्यक्तिगत जानकारी को तब तक बनाए रखते हैं जब तक कि इस गोपनीयता नीति में उल्लिखित उद्देश्यों को पूरा करने के लिए आवश्यक हो, जब तक कि कानून द्वारा लंबी प्रतिधारण अवधि की आवश्यकता न हो।';

  @override
  String get privacyInternationalTitle => '10. अंतर्राष्ट्रीय डेटा हस्तांतरण';

  @override
  String get privacyInternationalContent =>
      'आपकी जानकारी आपके देश के बाहर स्थित सर्वरों पर स्थानांतरित और बनाए रखी जा सकती है। हम ऐसे हस्तांतरणों के लिए उचित सुरक्षा उपाय सुनिश्चित करते हैं।';

  @override
  String get privacyChangesTitle => '11. इस गोपनीयता नीति में परिवर्तन';

  @override
  String get privacyChangesContent =>
      'हम समय-समय पर इस गोपनीयता नीति को अपडेट कर सकते हैं। हम इस पृष्ठ पर नई नीति पोस्ट करके और \"अंतिम अपडेट\" तिथि को अपडेट करके आपको किसी भी महत्वपूर्ण परिवर्तन के बारे में सूचित करेंगे।';

  @override
  String get privacyContactTitle => '12. हमसे संपर्क करें';

  @override
  String get privacyContactContent =>
      'यदि आपके पास इस गोपनीयता नीति या हमारे डेटा प्रथाओं के बारे में कोई प्रश्न हैं, तो कृपया हमसे संपर्क करें:\n\nईमेल: privacy@taksh-ecommerce.com\nफोन: +91 1800-123-4567\nपता: मुंबई, महाराष्ट्र, भारत';

  @override
  String get privacyMattersTitle => 'आपकी गोपनीयता मायने रखती है';

  @override
  String get privacyMattersContent =>
      'हम आपकी गोपनीयता की रक्षा करने और आपके डेटा को जिम्मेदारी से संभालने के लिए प्रतिबद्ध हैं।';

  @override
  String get ourStoryContent =>
      '2020 में स्थापित, तक्ष ई-कॉमर्स भारत में ऑनलाइन शॉपिंग में क्रांति लाने के दृष्टिकोण के साथ उभरा। हमने एक साधारण विचार के साथ शुरुआत की: गुणवत्ता वाले उत्पादों को सभी के लिए, हर जगह सुलभ बनाना। आज, हम देश भर में लाखों ग्राहकों की सेवा करते हैं, इलेक्ट्रॉनिक्स से लेकर फैशन, घरेलू आवश्यक वस्तुओं से लेकर किराने का सामान तक विविध प्रकार के उत्पादों की पेशकश करते हैं।';

  @override
  String get ourMissionContent =>
      'हमारा मिशन उपभोक्ताओं को एक सहज, भरोसेमंद और सुखद खरीदारी अनुभव प्रदान करके सशक्त बनाना है। हम स्थानीय व्यवसायों का समर्थन करते हुए और टिकाऊ प्रथाओं को बढ़ावा देते हुए लोगों को उन उत्पादों से जोड़ने का प्रयास करते हैं जिन्हें वे प्यार करते हैं।';

  @override
  String get ourVisionContent =>
      'भारत का सबसे ग्राहक-केंद्रित ई-कॉमर्स प्लेटफॉर्म बनना, जहां लोग पूरी आत्मविश्वास और सुविधा के साथ कुछ भी खोज, अन्वेषण और खरीद सकें।';

  @override
  String get trustTransparencyDesc =>
      'हम ईमानदार संचार और विश्वसनीय सेवा के माध्यम से स्थायी संबंध बनाने में विश्वास करते हैं।';

  @override
  String get qualityFirstDesc =>
      'हम जो भी उत्पाद पेश करते हैं वह ग्राहकों की संतुष्टि सुनिश्चित करने के लिए हमारे कड़े गुणवत्ता मानकों को पूरा करता है।';

  @override
  String get customerCentricityDesc =>
      'हमारे ग्राहक हम जो कुछ भी करते हैं उसके केंद्र में हैं। उनकी संतुष्टि ही हमारी सफलता है।';

  @override
  String get sustainabilityDesc =>
      'हम पर्यावरण के अनुकूल प्रथाओं और अपने पर्यावरणीय पदचिह्न को कम करने के लिए प्रतिबद्ध हैं।';

  @override
  String get innovationDesc =>
      'हम खरीदारी का सर्वोत्तम अनुभव प्रदान करने के लिए अपनी तकनीक और सेवाओं को लगातार विकसित करते हैं।';

  @override
  String get whatWeOfferContent =>
      '• उत्पादों की विस्तृत श्रृंखला: इलेक्ट्रॉनिक्स से फैशन, घर और रसोई से सौंदर्य उत्पादों तक\n\n• प्रतिस्पर्धी मूल्य: गुणवत्ता वाले उत्पादों पर सर्वोत्तम सौदे और ऑफ़र\n\n• तेज़ डिलीवरी: पूरे भारत में त्वरित और विश्वसनीय शिपिंग\n\n• सुरक्षित भुगतान: शीर्ष पायदान सुरक्षा के साथ कई भुगतान विकल्प\n\n• 24/7 सहायता: हमारी ग्राहक सेवा टीम हमेशा मदद के लिए यहां है\n\n• आसान रिटर्न: परेशानी मुक्त रिटर्न और रिफंड';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get addressLabel => 'पता';

  @override
  String get addressValue => 'भोपाल, मध्य प्रदेश, भारत';

  @override
  String get updateProfileTitle => 'प्रोफ़ाइल अपडेट करें';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'अंतिम नाम';

  @override
  String get mobileLabel => 'मोबाइल';

  @override
  String get saveDetails => 'विवरण सहेजें';

  @override
  String get enterValidName => 'कृपया मान्य नाम दर्ज करें';

  @override
  String get joinDeliveryManTitle => 'डिलीवरी मैन के रूप में शामिल हों';

  @override
  String get fillDetailsDelivery =>
      'डिलीवरी पार्टनर के रूप में शामिल होने के लिए अपना विवरण भरें';

  @override
  String get nameLabel => 'नाम';

  @override
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get mobileRequired => 'मोबाइल नंबर आवश्यक है';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get pincodeLabel => 'पिन कोड';

  @override
  String get pincodeInvalidLength => 'पिन कोड 6 अंकों का होना चाहिए';

  @override
  String get pincodeInvalidFormat => 'पिन कोड में केवल नंबर होने चाहिए';

  @override
  String get descriptionLabel => 'विवरण';

  @override
  String get descriptionRequired => 'विवरण आवश्यक है';

  @override
  String get submitRequest => 'अनुरोध जमा करें';

  @override
  String get requiredFieldsNote => '* आवश्यक क्षेत्र';

  @override
  String fillDetailsRequest(String type) {
    return '$type का अनुरोध करने के लिए अपना विवरण भरें';
  }

  @override
  String get invalidEmail => 'एक मान्य ईमेल पता दर्ज करें';

  @override
  String get passwordRequired => 'पसवर्ड आवश्यक है';

  @override
  String get passwordMinLength => 'पासवर्ड कम से कम 8 वर्णों का होना चाहिए';

  @override
  String get passwordComplexity =>
      'पासवर्ड में अपरकेस, लोअरकेस और नंबर होना चाहिए';

  @override
  String get confirmPasswordRequired => 'पुष्टि पासवर्ड आवश्यक है';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get nameMinLength => 'नाम कम से कम 2 वर्णों का होना चाहिए';

  @override
  String get appDevelopment => 'ऐप डेवलपमेंट';

  @override
  String get webDevelopment => 'वेब डेवलपमेंट';

  @override
  String get orderSummary => 'ऑर्डर सारांश';

  @override
  String get subtotal => 'उप-योग';

  @override
  String get deliveryCharges => 'डिलीवरी शुल्क';

  @override
  String get platformFee => 'प्लेटफ़ॉर्म शुल्क';

  @override
  String get cgst => 'सीजीएसटी';

  @override
  String get sgst => 'एसजीएसटी';

  @override
  String get discountLabel => 'छूट';

  @override
  String get otherCharges => 'अन्य शुल्क';

  @override
  String get free => 'मुफ़्त';

  @override
  String get totalAmount => 'कुल राशि';

  @override
  String get returnOrder => 'ऑर्डर वापस करें';

  @override
  String get needHelp => 'सहायता की आवश्यकता है';

  @override
  String get orderIssues => 'क्या आपको इस ऑर्डर में कोई समस्या है?';

  @override
  String get chatWithUs => 'हमसे चैट करें';

  @override
  String get sendEmail => 'हमें ईमेल भेजें';

  @override
  String get returnFunctionalityComing =>
      'वापसी की सुविधा जल्द ही उपलब्ध होगी। आप सहायता के लिए समर्थन से संपर्क कर सकते हैं।';

  @override
  String get noCategoriesAvailable => 'कोई श्रेणी उपलब्ध नहीं है';

  @override
  String get description => 'विवरण';

  @override
  String get similarProducts => 'समान उत्पाद';

  @override
  String get selectVariant => 'वेरिएंट चुनें';

  @override
  String get ratings => 'रेटिंग';

  @override
  String get failedToLoadProduct => 'उत्पाद लोड करने में विफल';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get searching => 'खोज रहा है...';

  @override
  String get recentSearches => 'हाल की खोजें';

  @override
  String typeMinCharsToSearch(int count) {
    return 'खोज शुरू करने के लिए कम से कम $count अक्षर टाइप करें';
  }

  @override
  String get inStock => 'स्टॉक में है';

  @override
  String get outOfStock => 'स्टॉक में नहीं है';

  @override
  String get checkout => 'चेकआउट';

  @override
  String get deliveryOptions => 'डिलीवरी विकल्प';

  @override
  String get priceDetails => 'मूल्य विवरण';

  @override
  String get placeOrder => 'ऑर्डर दें';

  @override
  String get proceedToPay => 'भुगतान के लिए आगे बढ़ें';

  @override
  String get addAddress => 'पता जोड़ें';

  @override
  String get loadingOrderDetails => 'ऑर्डर विवरण लोड हो रहा है...';

  @override
  String get addAddressToContinue =>
      'जारी रखने के लिए कृपया एक डिलीवरी पता जोड़ें';

  @override
  String get paymentSuccess => 'भुगतान सफल';

  @override
  String get paymentFailed => 'भुगतान विफल';

  @override
  String get orderPlacedSuccessfully => 'आपका ऑर्डर सफलतापूर्वक दिया गया!';

  @override
  String get somethingWentWrongPayment => 'आपके भुगतान में कुछ गलत हो गया';

  @override
  String get viewOrder => 'ऑर्डर देखें';

  @override
  String get continueShopping => 'खरीदारी जारी रखें';

  @override
  String get selectAddress => 'पता चुनें';

  @override
  String get myAddresses => 'मेरे पते';

  @override
  String get noAddressesSaved => 'कोई पता सहेजा नहीं गया';

  @override
  String get addFirstAddress => 'शुरू करने के लिए अपना पहला पता जोड़ें';

  @override
  String get deleteAddress => 'पता हटाएं';

  @override
  String get deleteAddressConfirm =>
      'क्या आप वाकई इस पते को हटाना चाहते हैं? यह कार्रवाई पूर्ववत नहीं की जा सकती।';

  @override
  String get setDefault => 'डिफ़ॉल्ट सेट करें';

  @override
  String get addNewAddress => 'नया पता जोड़ें';

  @override
  String get editAddress => 'पता संपादित करें';

  @override
  String get selectLocationOnMap => 'मानचित्र पर स्थान चुनें';

  @override
  String get locationSelected => 'स्थान चुना गया';

  @override
  String get tapToPickLocation => 'मानचित्र पर स्थान चुनने के लिए टैप करें';

  @override
  String get addressType => 'पता प्रकार';

  @override
  String get recipientName => 'प्राप्तकर्ता का नाम';

  @override
  String get enterRecipientName => 'प्राप्तकर्ता का पूरा नाम दर्ज करें';

  @override
  String get labelOther => 'लेबल (जैसे, मित्र का घर)';

  @override
  String get enterLabel => 'इस पते के लिए एक लेबल दर्ज करें';

  @override
  String get houseFlatNo => 'घर/फ्लैट/ब्लॉक नंबर';

  @override
  String get enterHouseNo => 'घर या फ्लैट नंबर दर्ज करें';

  @override
  String get landmarkOptional => 'लैंडमार्क (वैकल्पिक)';

  @override
  String get landmarkHint => 'उदाहरण: सिटी मॉल के पास';

  @override
  String get city => 'शहर';

  @override
  String get enterCity => 'शहर दर्ज करें';

  @override
  String get state => 'राज्य';

  @override
  String get enterState => 'राज्य दर्ज करें';

  @override
  String get pincode => 'पिनकोड';

  @override
  String get enterPincode => 'पिनकोड दर्ज करें';

  @override
  String get pincodeLengthError => 'पिनकोड 6 अंकों का होना चाहिए';

  @override
  String get setAsDefaultAddress => 'डिफ़ॉल्ट पते के रूप में सेट करें';

  @override
  String get setAsDefaultSubtitle =>
      'इस पते का उपयोग डिलीवरी के लिए डिफ़ॉल्ट रूप से किया जाएगा';

  @override
  String get updateAddress => 'पता अपडेट करें';

  @override
  String get saveAddress => 'पता सहेजें';

  @override
  String get pleaseEnterRecipientName => 'कृपया प्राप्तकर्ता का नाम दर्ज करें';

  @override
  String get pleaseEnterHouseNo => 'कृपया घर/फ्लैट नंबर दर्ज करें';

  @override
  String get required => 'आवश्यक';

  @override
  String get pleaseSelectLocation => 'कृपया मानचित्र पर एक स्थान चुनें';

  @override
  String get ourStory => 'हमारी कहानी';

  @override
  String get ourMission => 'हमारा मिशन';

  @override
  String get ourVision => 'हमारा विजन';

  @override
  String get ourCoreValues => 'हमारे मुख्य मूल्य';

  @override
  String get trustTransparency => 'विश्वास और पारदर्शिता';

  @override
  String get qualityFirst => 'गुणवत्ता पहले';

  @override
  String get customerCentricity => 'ग्राहक केंद्रितता';

  @override
  String get sustainability => 'स्थिरता';

  @override
  String get innovation => 'नवाचार';

  @override
  String get whatWeOffer => 'हम क्या प्रदान करते हैं';

  @override
  String get ourImpact => 'हमारा प्रभाव';

  @override
  String get happyCustomers => 'खुश ग्राहक';

  @override
  String get products => 'उत्पाद';

  @override
  String get brands => 'ब्रांड';

  @override
  String get cities => 'शहर';

  @override
  String get rating => 'रेटिंग';

  @override
  String get getInTouch => 'संपर्क करें';

  @override
  String redirectingToCart(String seconds) {
    return '$seconds सेकंड में कार्ट पर रीडायरेक्ट किया जा रहा है';
  }

  @override
  String errorCode(String code) {
    return 'त्रुटि कोड: $code';
  }

  @override
  String get backToHome => 'मुखपृष्ठ पर वापस जाएं';

  @override
  String get orderNumberLabel => 'ऑर्डर संख्या';

  @override
  String get searchForProducts => 'उत्पादों की खोज करें';

  @override
  String get searchForProductsHint => 'उत्पादों की खोज करें';

  @override
  String get noResultsFound => 'कोई परिणाम नहीं मिला';

  @override
  String get noProductsFound => 'कोई उत्पाद नहीं मिला';

  @override
  String get edit => 'संपादित करें';

  @override
  String get search => 'खोजें';

  @override
  String get productDetails => 'उत्पाद विवरण';

  @override
  String get searchProducts => 'उत्पाद खोजें';

  @override
  String get quick => 'त्वरित';

  @override
  String get services => 'सेवाएं';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get standard => 'मानक';

  @override
  String get failedToLoadAddresses => 'पते लोड करने में विफल';

  @override
  String get couldNotDeleteAddress =>
      'पता हटाया नहीं जा सका। कृपया पुनः प्रयास करें।';

  @override
  String get couldNotUpdateAddress =>
      'पता अपडेट नहीं किया जा सका। कृपया पुनः प्रयास करें।';

  @override
  String get couldNotAddAddress =>
      'पता जोड़ा नहीं जा सका। कृपया पुनः प्रयास करें।';

  @override
  String get couldNotSetDefaultAddress =>
      'डिफ़ॉल्ट पता सेट नहीं किया जा सका। कृपया पुनः प्रयास करें।';

  @override
  String get delete => 'हटाएं';

  @override
  String get maybeLater => 'शायद बाद में';

  @override
  String get enable => 'सक्षम करें';

  @override
  String get enableLocation => 'स्थान सक्षम करें';

  @override
  String get home => 'होम';

  @override
  String get locationEnabledMessage =>
      'स्थान सक्षम! आस-पास की दुकानें दिखाई जा रही हैं...';

  @override
  String get nearbyStores => 'नज़दीकी दुकानें';

  @override
  String get findNearbyStores => 'नज़दीकी दुकानें खोजें';

  @override
  String get loadingNearbyStores => 'नज़दीकी दुकानें लोड हो रही हैं...';

  @override
  String get skipForNow => 'अभी के लिए छोड़ें';

  @override
  String get useCurrentLocation => 'वर्तमान स्थान का उपयोग करें';

  @override
  String get autoDetectLocation => 'अपना डिलीवरी पता ऑटो-डिटेक्ट करें';

  @override
  String get yourAppContent => 'आपकी ऐप सामग्री';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get locationServices => 'स्थान सेवाएं';

  @override
  String get currentLocation => 'वर्तमान स्थान';

  @override
  String get disableLocation => 'स्थान अक्षम करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get locationAccess => 'स्थान पहुंच';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get locationPermissionRequired => 'स्थान अनुमति आवश्यक';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get permissionPermanentlyDenied =>
      'अनुमति स्थायी रूप से अस्वीकार कर दी गई';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get locationServicesDisabled => 'स्थान सेवाएं अक्षम हैं';

  @override
  String get allowLocationAccess => 'स्थान पहुंच की अनुमति दें';

  @override
  String get permissionUIComponents => 'स्थान अनुमति यूआई घटक';

  @override
  String get showBottomSheet => 'बॉटम शीट दिखाएं';

  @override
  String get showRationaleDialog => 'तर्क संवाद दिखाएं';

  @override
  String get showSettingsDialog => 'सेटिंग्स संवाद दिखाएं';

  @override
  String get requestPermissionFullFlow =>
      'अनुमति का अनुरोध करें (पूर्ण प्रवाह)';

  @override
  String get getCurrentLocation => 'वर्तमान स्थान प्राप्त करें';

  @override
  String get locationPermissionGranted => 'स्थान अनुमति प्रदान की गई';

  @override
  String get grantLocationPermission => 'स्थान अनुमति प्रदान करें';

  @override
  String get dataAlreadyLoaded =>
      'डेटा पहले ही लोड हो चुका है - तुरंत प्रदर्शन!';

  @override
  String get searchSavedAddresses => 'सहेजे गए पते खोजें';

  @override
  String get searchCategories => 'श्रेणियां खोजें...';

  @override
  String get searchRestaurantsDishes => 'रेस्तरां, व्यंजन खोजें...';

  @override
  String get searchAreaStreetName => 'क्षेत्र, सड़क का नाम खोजें...';

  @override
  String get joinAsVendorTitle => 'विक्रेता के रूप में जुड़ें';

  @override
  String get vendorFillDetails =>
      'अपने विक्रेता दुकान का विवरण भरें। आवश्यक फ़ील्ड * से चिह्नित हैं';

  @override
  String get vendorShopDetails => 'दुकान विवरण';

  @override
  String get vendorShopDetailsSubtitle => 'अपनी दुकान की जानकारी दर्ज करें';

  @override
  String get vendorOwnerDetails => 'मालिक विवरण';

  @override
  String get vendorOwnerDetailsSubtitle => 'मालिक की जानकारी दर्ज करें';

  @override
  String get vendorDocuments => 'दस्तावेज़';

  @override
  String get vendorDocumentsSubtitle =>
      'सत्यापन के लिए आवश्यक दस्तावेज़ अपलोड करें';

  @override
  String get vendorShopName => 'दुकान का नाम';

  @override
  String get vendorShopNameHint => 'दुकान का नाम दर्ज करें';

  @override
  String get vendorShopAddress => 'दुकान का पता';

  @override
  String get vendorShopAddressHint => 'पूरा दुकान पता दर्ज करें';

  @override
  String get vendorShopPincode => 'दुकान पिनकोड';

  @override
  String get vendorShopPincodeHint => '6 अंकों का पिनकोड दर्ज करें';

  @override
  String get vendorShopLocation => 'दुकान स्थान *';

  @override
  String get vendorShopImages => 'दुकान की तस्वीरें *';

  @override
  String get vendorShopImagesSubtitle => '5 तक दुकान की तस्वीरें अपलोड करें';

  @override
  String get vendorOwnerName => 'मालिक का नाम';

  @override
  String get vendorOwnerNameHint => 'मालिक का पूरा नाम दर्ज करें';

  @override
  String get vendorOwnerAddress => 'मालिक का पता';

  @override
  String get vendorOwnerAddressHint => 'पूरा मालिक पता दर्ज करें';

  @override
  String get vendorOwnerPincode => 'मालिक पिनकोड';

  @override
  String get vendorOwnerPincodeHint => '6 अंकों का पिनकोड दर्ज करें';

  @override
  String get vendorOwnerLocation => 'मालिक स्थान *';

  @override
  String get vendorMobileNumber => 'मोबाइल नंबर';

  @override
  String get vendorMobileNumberHint => '10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get vendorEmailId => 'ईमेल आईडी';

  @override
  String get vendorEmailIdHint => 'ईमेल पता दर्ज करें';

  @override
  String get vendorOwnerImages => 'मालिक की तस्वीरें *';

  @override
  String get vendorOwnerImagesSubtitle => '2 तक मालिक की तस्वीरें अपलोड करें';

  @override
  String get vendorPickLocation => 'मानचित्र से स्थान चुनें';

  @override
  String get vendorAadharCard => 'आधार कार्ड';

  @override
  String get vendorPanCard => 'पैन कार्ड';

  @override
  String get vendorBankAccount => 'बैंक खाता';

  @override
  String get vendorGstNumber => 'जीएसटी नंबर';

  @override
  String get vendorNonGstCertificate => 'गैर जीएसटी प्रमाण पत्र';

  @override
  String get vendorNonGstCertificateSubtitle =>
      'गैर जीएसटी प्रमाण पत्र अपलोड करें';

  @override
  String get vendorMsmeCertificate => 'एमएसएमई प्रमाण पत्र';

  @override
  String get vendorMsmeCertificateSubtitle =>
      'एमएसएमई प्रमाण पत्र अपलोड करें (यदि लागू हो)';

  @override
  String get vendorFssaiCertificate => 'एफएसएसएआई प्रमाण पत्र *';

  @override
  String get vendorFssaiCertificateSubtitle =>
      'खाद्य व्यवसायों के लिए एफएसएसएआई लाइसेंस अपलोड करें';

  @override
  String get vendorShopAgreement => 'दुकान समझौता';

  @override
  String get vendorShopAgreementSubtitle =>
      'दुकान समझौता अपलोड करें (वैकल्पिक)';

  @override
  String get vendorSubmitApplication => 'आवेदन जमा करें';

  @override
  String get vendorAadharDetails => 'आधार विवरण';

  @override
  String get vendorAadharNumber => 'आधार नंबर *';

  @override
  String get vendorAadharNumberHint => '12 अंकों का आधार नंबर दर्ज करें';

  @override
  String get vendorAadharDocument => 'आधार नंबर दस्तावेज़ *';

  @override
  String get vendorPanDetails => 'पैन विवरण';

  @override
  String get vendorPanCardNumber => 'पैन कार्ड नंबर *';

  @override
  String get vendorPanCardNumberHint =>
      'पैन कार्ड नंबर दर्ज करें (जैसे, ABCDE1234F)';

  @override
  String get vendorPanDocument => 'पैन कार्ड नंबर दस्तावेज़ *';

  @override
  String get vendorBankDetails => 'बैंक विवरण';

  @override
  String get vendorAccountNumber => 'खाता नंबर *';

  @override
  String get vendorAccountNumberHint => 'बैंक खाता नंबर दर्ज करें';

  @override
  String get vendorIfscCode => 'आईएफएससी कोड *';

  @override
  String get vendorIfscCodeHint => 'आईएफएससी कोड दर्ज करें';

  @override
  String get vendorAccountHolderName => 'खाताधारक का नाम *';

  @override
  String get vendorAccountHolderNameHint => 'खाताधारक का नाम दर्ज करें';

  @override
  String get vendorBankName => 'बैंक का नाम *';

  @override
  String get vendorBankNameHint => 'बैंक का नाम दर्ज करें (वैकल्पिक)';

  @override
  String get vendorBranchName => 'शाखा का नाम';

  @override
  String get vendorBranchNameHint => 'शाखा का नाम दर्ज करें (वैकल्पिक)';

  @override
  String get vendorUploadBankProof => 'बैंक प्रमाण अपलोड करें';

  @override
  String get vendorUploadBankProofSubtitle =>
      'बैंक पासबुक या रद्द चेक अपलोड करें';

  @override
  String get vendorBankDocument => 'बैंक दस्तावेज़ *';

  @override
  String get vendorGstDetails => 'जीएसटी विवरण';

  @override
  String get vendorGstNumberLabel => 'जीएसटी नंबर *';

  @override
  String get vendorGstNumberHint => '15 अंकों का जीएसटी नंबर दर्ज करें';

  @override
  String get vendorGstDocument => 'जीएसटी नंबर दस्तावेज़ *';

  @override
  String get vendorSaveAndVerify => 'सहेजें और सत्यापित करें';

  @override
  String get vendorUploadDocument => 'दस्तावेज़ अपलोड करें';

  @override
  String get vendorUploadDocumentHint =>
      'पीडीएफ, जेपीजी, पीएनजी (अधिकतम 5एमबी)';

  @override
  String get vendorAddImage => 'जोड़ें';

  @override
  String get vendorJoinSuccess => 'विक्रेता आवेदन सफलतापूर्वक जमा किया गया!';

  @override
  String get vendorShopNameRequired => 'दुकान का नाम आवश्यक है';

  @override
  String get vendorShopLocationRequired => 'दुकान का स्थान आवश्यक है';

  @override
  String get vendorShopImagesRequired =>
      'कम से कम एक दुकान की तस्वीर आवश्यक है';

  @override
  String get vendorOwnerLocationRequired => 'मालिक का स्थान आवश्यक है';

  @override
  String get vendorOwnerImagesRequired =>
      'कम से कम एक मालिक की तस्वीर आवश्यक है';

  @override
  String get vendorOwnerImageRequired => 'मालिक की तस्वीर आवश्यक है';

  @override
  String get vendorVendorDetails => 'विक्रेता विवरण';

  @override
  String get vendorVendorDetailsSubtitle =>
      'अपना विक्रेता पंजीकरण विवरण दर्ज करें';

  @override
  String get vendorVendorName => 'विक्रेता का नाम';

  @override
  String get vendorVendorNameHint => 'विक्रेता/स्टोर का नाम दर्ज करें';

  @override
  String get vendorVendorNameRequired => 'विक्रेता का नाम आवश्यक है';

  @override
  String get vendorAddress => 'पता';

  @override
  String get vendorAddressHint => 'विक्रेता का पता दर्ज करें';

  @override
  String get vendorAddressRequired => 'पता आवश्यक है';

  @override
  String get vendorPincode => 'पिनकोड';

  @override
  String get vendorPincodeHint => 'पिनकोड दर्ज करें';

  @override
  String get vendorPincodeRequired => 'पिनकोड आवश्यक है';

  @override
  String get vendorStateId => 'राज्य';

  @override
  String get vendorStateIdHint => 'राज्य आईडी दर्ज करें';

  @override
  String get vendorStateIdRequired => 'राज्य आवश्यक है';

  @override
  String get vendorCityId => 'शहर';

  @override
  String get vendorCityIdHint => 'शहर आईडी दर्ज करें';

  @override
  String get vendorCityIdRequired => 'शहर आवश्यक है';

  @override
  String get vendorOwnerImage => 'मालिक की तस्वीर *';

  @override
  String get vendorOwnerImageSubtitle => 'मालिक की फोटो अपलोड करें';

  @override
  String get vendorShopAddressRequired => 'दुकान का पता आवश्यक है';

  @override
  String get vendorShopPincodeRequired => 'दुकान का पिनकोड आवश्यक है';

  @override
  String get vendorOwnerNameRequired => 'मालिक का नाम आवश्यक है';

  @override
  String get vendorOwnerAddressRequired => 'मालिक का पता आवश्यक है';

  @override
  String get vendorOwnerPincodeRequired => 'मालिक का पिनकोड आवश्यक है';

  @override
  String get vendorMobileNumberRequired => 'मोबाइल नंबर आवश्यक है';

  @override
  String get vendorEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get vendorAadhaarNumberRequired => 'आधार नंबर आवश्यक है';

  @override
  String get vendorAadhaarFileRequired => 'आधार दस्तावेज़ आवश्यक है';

  @override
  String get vendorPanFileRequired => 'पैन दस्तावेज़ आवश्यक है';

  @override
  String get vendorBankFileRequired => 'बैंक दस्तावेज़ आवश्यक है';

  @override
  String get vendorGstFileRequired => 'जीएसटी दस्तावेज़ आवश्यक है';

  @override
  String get vendorGstOrNonGstRequired =>
      'जीएसटी दस्तावेज़ या नॉन-जीएसटी प्रमाणपत्र अपलोड करें';

  @override
  String get vendorFssaiFileRequired => 'FSSAI प्रमाणपत्र आवश्यक है';

  @override
  String get chooseHowToReachUs => 'हमसे कैसे संपर्क करना चाहेंगे चुनें';

  @override
  String get requestCallback => 'कॉलबैक अनुरोध';

  @override
  String get requestCallbackDescription =>
      'हमारी सहायता टीम से कॉल प्राप्त करें';

  @override
  String get emailSupport => 'ईमेल सहायता';

  @override
  String get emailSupportDescription =>
      'customersupport@takshallinone.in पर हमें ईमेल भेजें';

  @override
  String get emailAppError =>
      'ईमेल ऐप खोलने में असमर्थ। कृपया customersupport@takshallinone.in पर ईमेल करें';

  @override
  String get myWishlist => 'मेरी विशलिस्ट';

  @override
  String get addedToWishlist => 'विशलिस्ट में जोड़ा गया';

  @override
  String get removedFromWishlist => 'विशलिस्ट से हटाया गया';

  @override
  String get wishlistEmpty => 'आपकी विशलिस्ट खाली है';

  @override
  String get wishlistEmptySubtitle =>
      'उत्पादों को ब्राउज़ करें और अपने पसंदीदा यहां जोड़ें';

  @override
  String get removeFromWishlistConfirm => 'विशलिस्ट से हटाएं?';

  @override
  String get failedToLoadWishlist => 'विशलिस्ट लोड करने में विफल';

  @override
  String get couldNotAddToCart =>
      'कार्ट में आइटम जोड़ने में असमर्थ। कृपया पुनः प्रयास करें।';

  @override
  String get couldNotLoadProduct =>
      'उत्पाद विवरण लोड करने में असमर्थ। कृपया पुनः प्रयास करें।';

  @override
  String get noVariantsAvailable => 'यह उत्पाद वर्तमान में उपलब्ध नहीं है।';

  @override
  String get cartUnexpectedError => 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';

  @override
  String get checkDeliveryAvailability => 'डिलीवरी उपलब्धता जांचें';

  @override
  String get invalidPincode => 'कृपया एक मान्य 6-अंकीय पिनकोड दर्ज करें';

  @override
  String get check => 'जांचें';

  @override
  String fulfilledBy(String shopName) {
    return '$shopName द्वारा पूर्ण';
  }

  @override
  String get couldNotCheckDelivery =>
      'डिलीवरी उपलब्धता जांचने में असमर्थ। कृपया पुनः प्रयास करें।';

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
  String get customerAndPickupDetails => 'ग्राहक और पिकअप विवरण';

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
  String get packagingDetails => 'पैकेजिंग विवरण';

  @override
  String get enterProductDetails => 'उत्पाद का नाम और विवरण दर्ज करें';

  @override
  String get enterPackagingDetails => 'लिफाफा, बॉक्स आदि दर्ज करें';

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
    return '$contentLabel देखने के लिए लॉगिन करें';
  }

  @override
  String guestWallSubtitle(String contentLabel) {
    return '$contentLabel एक्सेस करने के लिए साइन इन करें और ऑर्डर ट्रैकिंग, सेव किए गए पतों और बहुत कुछ के साथ व्यक्तिगत खरीदारी अनुभव का आनंद लें।';
  }

  @override
  String get guestWallLoginButton => 'लॉगिन करें';

  @override
  String get guestWallContinueBrowsing => 'गेस्ट के रूप में ब्राउज़ करें';

  @override
  String get loginCancelButton => 'रद्द करें';

  @override
  String get orderReview => 'ऑर्डर की समीक्षा करें';

  @override
  String get reviewYourOrder =>
      'पुष्टि करने से पहले अपने ऑर्डर की समीक्षा करें';

  @override
  String get reviewOrderDescription =>
      'कृपया नीचे दिए गए विवरणों को सत्यापित करें और अपना ऑर्डर देने के लिए \"ऑर्डर की पुष्टि करें\" पर टैप करें।';

  @override
  String get confirmOrder => 'ऑर्डर की पुष्टि करें';

  @override
  String get confirmingOrder => 'आपका ऑर्डर दिया जा रहा है...';

  @override
  String get deliveryTo => 'डिलीवरी पता';

  @override
  String get payment => 'भुगतान';

  @override
  String get orderSummaryTitle => 'ऑर्डर सारांश';

  @override
  String get itemTotal => 'आइटम कुल';

  @override
  String get platformFees => 'प्लेटफ़ॉर्म शुल्क';

  @override
  String get otherChargesLabel => 'अन्य शुल्क';

  @override
  String get orderPlacedTitle => 'ऑर्डर दिया गया';

  @override
  String get orderPlacedSubtitle =>
      'आपका ऑर्डर सफलतापूर्वक दिया गया है। डिलीवरी पर भुगतान करें।';

  @override
  String get orderPlacedOnlineSubtitle =>
      'आपका ऑर्डर सफलतापूर्वक दिया गया है। भुगतान पर पुनः निर्देशित किया जा रहा है...';

  @override
  String get thankYouForOrder => 'आपके ऑर्डर के लिए धन्यवाद!';

  @override
  String get viewMyOrders => 'मेरे ऑर्डर देखें';

  @override
  String get back => 'वापस';

  @override
  String get readMore => 'और पढ़ें';

  @override
  String get readLess => 'कम पढ़ें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'आगे';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get onboardingTitle1 => 'जो चाहिए वो सब खरीदें';

  @override
  String get onboardingSubtitle1 =>
      'स्थानीय स्टोर्स से हज़ारों उत्पाद खोजें, सीधे आपके दरवाज़े तक।';

  @override
  String get onboardingTitle2 => 'तेज़ और भरोसेमंद डिलीवरी';

  @override
  String get onboardingSubtitle2 =>
      'अपने ऑर्डर को रियल-टाइम में ट्रैक करें और मिनटों में डिलीवरी पाएं।';

  @override
  String get onboardingTitle3 => 'सुरक्षित भुगतान';

  @override
  String get onboardingSubtitle3 =>
      'भरोसेमंद भुगतान विधियों के साथ निश्चिंत होकर भुगतान करें।';
}
