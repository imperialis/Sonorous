import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum TagChipSize { small, medium, large }

enum TagChipType { manual, ai, genre, mood, instrument }

class TagChip extends StatelessWidget {
  final String label;
  final TagChipType type;
  final TagChipSize size;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isInteractive;
  final Color? customColor;

  const TagChip({
    Key? key,
    required this.label,
    this.type = TagChipType.manual,
    this.size = TagChipSize.medium,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
    this.isInteractive = true,
    this.customColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chipColor = customColor ?? _getColorForType(type);
    final chipSize = _getSizeProperties(size);
    
    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected 
            ? chipColor 
            : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(chipSize.borderRadius),
          border: Border.all(
            color: chipColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: chipSize.horizontalPadding,
          vertical: chipSize.verticalPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_shouldShowIcon(type)) ...[
              Icon(
                _getIconForType(type),
                size: chipSize.iconSize,
                color: isSelected ? Colors.white : chipColor,
              ),
              SizedBox(width: chipSize.spacing),
            ],
            
            Text(
              label,
              style: TextStyle(
                fontSize: chipSize.fontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : chipColor,
              ),
            ),
            
            if (onDelete != null) ...[
              SizedBox(width: chipSize.spacing),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: chipSize.iconSize,
                  color: isSelected ? Colors.white : chipColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getColorForType(TagChipType type) {
    switch (type) {
      case TagChipType.manual:
        return AppColors.primary;
      case TagChipType.ai:
        return Colors.purple;
      case TagChipType.genre:
        return Colors.orange;
      case TagChipType.mood:
        return Colors.green;
      case TagChipType.instrument:
        return Colors.blue;
    }
  }

  IconData _getIconForType(TagChipType type) {
    switch (type) {
      case TagChipType.manual:
        return Icons.label;
      case TagChipType.ai:
        return Icons.auto_awesome;
      case TagChipType.genre:
        return Icons.music_note;
      case TagChipType.mood:
        return Icons.mood;
      case TagChipType.instrument:
        return Icons.piano;
    }
  }

  bool _shouldShowIcon(TagChipType type) {
    return size != TagChipSize.small;
  }

  _ChipSizeProperties _getSizeProperties(TagChipSize size) {
    switch (size) {
      case TagChipSize.small:
        return _ChipSizeProperties(
          fontSize: 12,
          horizontalPadding: 8,
          verticalPadding: 4,
          iconSize: 14,
          borderRadius: 12,
          spacing: 4,
        );
      case TagChipSize.medium:
        return _ChipSizeProperties(
          fontSize: 14,
          horizontalPadding: 12,
          verticalPadding: 6,
          iconSize: 16,
          borderRadius: 16,
          spacing: 6,
        );
      case TagChipSize.large:
        return _ChipSizeProperties(
          fontSize: 16,
          horizontalPadding: 16,
          verticalPadding: 8,
          iconSize: 18,
          borderRadius: 20,
          spacing: 8,
        );
    }
  }
}

class _ChipSizeProperties {
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double borderRadius;
  final double spacing;

  _ChipSizeProperties({
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.borderRadius,
    required this.spacing,
  });
}

// Custom tag chip for filtering
class FilterTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const FilterTagChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primary 
            : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? AppColors.primary 
              : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Colors.white.withOpacity(0.2) 
                    : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Tag input widget for adding new tags
class TagInputWidget extends StatefulWidget {
  final Function(String) onTagAdded;
  final List<String> existingTags;
  final String hintText;

  const TagInputWidget({
    Key? key,
    required this.onTagAdded,
    this.existingTags = const [],
    this.hintText = 'Add a tag...',
  }) : super(key: key);

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final query = _controller.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() {
      _suggestions = widget.existingTags
          .where((tag) => tag.toLowerCase().contains(query))
          .take(5)
          .toList();
    });
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty) {
      widget.onTagAdded(tag.trim());
      _controller.clear();
      _focusNode.unfocus();
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: IconButton(
                onPressed: () => _addTag(_controller.text),
                icon: const Icon(Icons.add),
              ),
            ),
            onSubmitted: _addTag,
          ),
        ),
        
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _suggestions.map((suggestion) => ListTile(
                dense: true,
                title: Text(suggestion),
                onTap: () => _addTag(suggestion),
              )).toList(),
            ),
          ),
        ],
      ],
    );
  }
}