import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Request entity for development request (app/web)
class DevelopmentRequest extends Equatable {
  final String? name;
  final String mobile;
  final String email;
  final String requestType;
  final String description;

  const DevelopmentRequest({
    this.name,
    required this.mobile,
    required this.email,
    required this.requestType,
    required this.description,
  });

  @override
  List<Object?> get props => [name, mobile, email, requestType, description];
}

/// Enum for development request types
enum DevelopmentRequestType {
  appDevelopment('app_development', 'Application Development'),
  webDevelopment('web_development', 'Website Development');

  final String value;
  final String displayName;

  const DevelopmentRequestType(this.value, this.displayName);

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case DevelopmentRequestType.appDevelopment:
        return l10n.appDevelopment;
      case DevelopmentRequestType.webDevelopment:
        return l10n.webDevelopment;
    }
  }
}
