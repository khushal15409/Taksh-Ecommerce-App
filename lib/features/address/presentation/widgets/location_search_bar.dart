import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// A search bar widget for searching locations
class LocationSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final ValueChanged<Location>? onLocationSelected;
  final List<Location> searchResults;
  final bool isLoading;

  const LocationSearchBar({
    super.key,
    required this.onSearch,
    this.onLocationSelected,
    this.searchResults = const [],
    this.isLoading = false,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showResults = _focusNode.hasFocus && widget.searchResults.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(LocationSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchResults != oldWidget.searchResults) {
      setState(() {
        _showResults = _focusNode.hasFocus && widget.searchResults.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchAreaStreetName,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _showResults = false;
                            });
                          },
                        )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: (value) {
              if (value.length >= 3) {
                widget.onSearch(value);
              } else if (value.isEmpty) {
                setState(() {
                  _showResults = false;
                });
              }
            },
          ),
        ),

        // Search results
        if (_showResults && widget.searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final location = widget.searchResults[index];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(
                    location.formattedAddress ?? 'Unknown location',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  onTap: () {
                    _controller.text = location.formattedAddress ?? '';
                    setState(() {
                      _showResults = false;
                    });
                    _focusNode.unfocus();
                    widget.onLocationSelected?.call(location);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
