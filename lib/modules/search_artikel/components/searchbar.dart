import 'package:flutter/material.dart';
import 'package:recreate_project/core/styles/app_colors.dart';

class SearchBarComponent extends StatefulWidget {
  final Function(String) onSearch; 
  final TextEditingController? controller; 

  const SearchBarComponent({
    required this.onSearch,
    this.controller,
    super.key
  });

  @override
  State<SearchBarComponent> createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasFocus = _focusNode.hasFocus;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        onChanged: (value) {
          if (value.isNotEmpty) {
            widget.onSearch(value);
          } else {
            widget.onSearch('');
          }
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onSearch(value);
          }
        },
        decoration: InputDecoration(
          hintText: 'Cari artikel berita...',
          prefixIcon: Icon(Icons.search, color: AppColors.secondary),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.secondary),
                  onPressed: () {
                    _textController.clear();
                    widget.onSearch('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: hasFocus ? AppColors.primary : AppColors.secondary,
              width: hasFocus ? 2.0 : 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors.primary, width: 2.0),
          ),
          filled: true,
          fillColor: AppColors.textLight,
        ),
        autofocus: false,
      ),
    );
  }
}