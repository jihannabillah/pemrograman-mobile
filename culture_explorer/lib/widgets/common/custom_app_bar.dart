import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.leading,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.elevation = 0,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : leading,
      actions: actions,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }
}

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onCancel;
  final bool automaticallyImplyLeading;

  const SearchAppBar({
    Key? key,
    this.hintText = 'Search...',
    required this.onSearchChanged,
    this.onCancel,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.automaticallyImplyLeading
          ? IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.arrow_back),
              onPressed: () {
                if (_isSearching) {
                  setState(() {
                    _isSearching = false;
                    _controller.clear();
                    widget.onSearchChanged('');
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            )
          : null,
      title: _isSearching
          ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: widget.onSearchChanged,
            )
          : Text('Search'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      actions: [
        if (!_isSearching)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        if (_isSearching && widget.onCancel != null)
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              widget.onCancel!();
              setState(() {
                _isSearching = false;
                _controller.clear();
              });
            },
          ),
      ],
    );
  }
}