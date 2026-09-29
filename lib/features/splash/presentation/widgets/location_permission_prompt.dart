import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_handler.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Widget that prompts for location permission after the initial splash
/// This can be shown on the home page or as part of onboarding
class LocationPermissionPrompt extends StatelessWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onSkip;

  const LocationPermissionPrompt({
    super.key,
    this.onPermissionGranted,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          // Title
           Text(
            AppLocalizations.of(context)!.enableLocation,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            'Get personalized recommendations and faster delivery by allowing location access', // TODO: Add key if missing or use existing
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.light ? Colors.white70 : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    onSkip?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                    side: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.white : (Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(AppLocalizations.of(context)!.maybeLater),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    final granted =
                        await LocationPermissionHandler.requestPermissionWithUI(
                            context);
                    if (granted) {
                      onPermissionGranted?.call();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).cardColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(AppLocalizations.of(context)!.enable),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact banner widget for location permission
class LocationPermissionBanner extends StatelessWidget {
  const LocationPermissionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: () async {
          await LocationPermissionHandler.requestPermissionWithUI(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.location_off, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Location access disabled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      'Tap to enable for better experience',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: Theme.of(context).disabledColor),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating action button for location permission
class LocationPermissionFAB extends StatelessWidget {
  const LocationPermissionFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final granted = await LocationPermissionBottomSheet.show(context);
        if (granted == true && context.mounted) {
          LocationPermissionHandler.showLocationStatus(context, true);
        }
      },
      icon: const Icon(Icons.my_location),
      label: Text(AppLocalizations.of(context)!.enableLocation),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
