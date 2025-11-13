import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/utils/app_routes.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';

class TitleAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final AppIcon? icon;

  const TitleAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  State<TitleAppBar> createState() => _TitleAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(125);
}

class _TitleAppBarState extends State<TitleAppBar> {
  final AuthService _authService = AuthService();
  Restaurant? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getRestaurant();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: isMobile,
          flexibleSpace: Stack(
            children: [
              if (!isMobile)
                _buildDesktopHeader()
              else
                _buildMobileHeader(),

              // line bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 1, color: Colors.grey.shade300),
              ),
            ],
          ),
          toolbarHeight: 140,
        );
      },
    );
  }

  /// Desktop layout: title trái, user phải
  Widget _buildDesktopHeader() {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SectionHeaderIconLead(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  icon: widget.icon ?? AppIcon(size: 46),
                ),
              ),
            ),
            if (_authService.currentUser != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _outlinedAuth(context),
              ),
          ],
        ),
      ],
    );
  }

  /// Mobile layout: title + nút đăng xuất nằm giữa
  Widget _buildMobileHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16,),
                SectionHeaderIconLead(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  icon: widget.icon ?? AppIcon(size: 32),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_authService.currentUser != null)
              _outlinedAuth(context),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị tên và nút đăng xuất
  Widget _outlinedAuth(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // để nội dung không chiếm hết chiều ngang
      children: [
        if (!_isLoading)
          Text(
            _user != null ? "Xin chào, ${_user!.name}" : "",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        const SizedBox(width: 8.0),
        OutlinedButton(
          onPressed: () async {
            await _authService.logout();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.WELCOME,
                (route) => false,
              );
            }
          },
          child: const Text("Đăng xuất"),
        ),
      ],
    );
  }
}
