import 'package:flutter/material.dart';
// import 'package:del_pick/app/themes/app_colors.dart';

class StoreSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClear;

  const StoreSearchBar({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<StoreSearchBar> createState() => _StoreSearchBarState();
}

class _StoreSearchBarState extends State<StoreSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search restaurants...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                widget.onClear();
              } else {
                widget.onSearch(value);
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _controller.clear();
                  widget.onClear();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
