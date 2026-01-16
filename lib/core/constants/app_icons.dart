import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_spacing.dart';

/// Central SVG icon registry
/// Uses asset-based icons (design-system correct)
class AppIcons {
  // --------------------------------------------------
  // Navigation / actions
  // --------------------------------------------------
  static const String back = 'lib/assets/icons/back.svg';
  static const String close = 'lib/assets/icons/close.svg';
  static const String add = 'lib/assets/icons/add.svg';
  static const String more = 'lib/assets/icons/more.svg';
  static const String search = 'lib/assets/icons/search.svg';
  static const String calendar = 'lib/assets/icons/calendar.svg';
  static const String clock = 'lib/assets/icons/clock.svg';
  static const String link = 'lib/assets/icons/link.svg';
  static const String notification =
      'lib/assets/icons/notification.svg';
  static const String setting =
      'lib/assets/icons/setting.svg';
  static const String danger =
      'lib/assets/icons/danger.svg';
  static const String delete =
      'lib/assets/icons/delete.svg';
  static const String edit =
      'lib/assets/icons/edit.svg';
  static const String lock =
      'lib/assets/icons/lock.svg';
  static const String otp =
      'lib/assets/icons/otp.svg';
  static const String passHide =
      'lib/assets/icons/pass_hide.svg';
  static const String passShow =
      'lib/assets/icons/pass_show.svg';
  static const String open_new =
      'lib/assets/icons/open_new.svg';
  static const String logout =
      'lib/assets/icons/logout.svg';

  // --------------------------------------------------
  // Task status
  // --------------------------------------------------
  static const String square =
      'lib/assets/icons/square.svg';
  static const String checkedSquare =
      'lib/assets/icons/checked_square.svg';
  static const String important =
      'lib/assets/icons/important.svg';

  // --------------------------------------------------
  // Category icons
  // --------------------------------------------------
  static const String person =
      'lib/assets/icons/person.svg';
  static const String work =
      'lib/assets/icons/work.svg';
  static const String school =
      'lib/assets/icons/school.svg';
  static const String home =
      'lib/assets/icons/home.svg';
  static const String star =
      'lib/assets/icons/star.svg';
  static const String travel =
      'lib/assets/icons/travel.svg';
  static const String art =
      'lib/assets/icons/art.svg';
  static const String camera =
      'lib/assets/icons/camera.svg';
  static const String mail =
      'lib/assets/icons/mail.svg';
  static const String file =
      'lib/assets/icons/file.svg';
  static const String gift =
      'lib/assets/icons/gift.svg';
  static const String music =
      'lib/assets/icons/music.svg';
  static const String heart =
      'lib/assets/icons/heart.svg';
  static const String shop =
      'lib/assets/icons/shop.svg';
  static const String document =
      'lib/assets/icons/document.svg';

  // ------------------------------
  // Empty state
  // ------------------------------
  static const IconData empty = Icons.playlist_add_check_rounded;

  // --------------------------------------------------
  // SVG Icon Builder (USE THIS EVERYWHERE)
  // --------------------------------------------------
  static Widget svg(
    String asset, {
    double size = AppSpacing.iconMd,
    Color? color,
  }) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(
              color,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
