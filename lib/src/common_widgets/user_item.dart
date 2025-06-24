// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/color_circle.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_circle_image.dart';
import 'package:applimode_app/src/common_widgets/writer_label.dart';

// features
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';

class UserItem extends ConsumerWidget {
  const UserItem({
    super.key,
    required this.appUser,
    this.isTwoLine = false,
    this.isProfileScreen = false,
    this.profileImageSize,
    this.padding,
    this.secondLine,
    this.titleSize,
    this.titleColor,
    this.subtitleSize,
    this.subtitleColor,
    this.onTap,
    this.index,
    this.isRanking = false,
  });

  final AppUser appUser;
  final bool isTwoLine;
  final bool isProfileScreen;
  final double? profileImageSize;
  final EdgeInsetsGeometry? padding;
  final String? secondLine;
  final double? titleSize;
  final Color? titleColor;
  final double? subtitleSize;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final int? index;
  final bool isRanking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminSettings = ref.watch(adminSettingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: isProfileScreen
          ? null
          : () => context.push(ScreenPaths.profile(appUser.uid)),
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
        child: Row(
          children: [
            appUser.photoUrl == null
                ? ColorCircle(size: profileImageSize, index: index)
                : CachedCircleImage(
                    imageUrl: appUser.photoUrl!,
                    size: profileImageSize,
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isRanking && [0, 1, 2].contains(index))
                        Icon(
                          Icons.military_tech_outlined,
                          size: titleSize ?? 16,
                          color: index == 0
                              ? const Color(0xFFFFD700)
                              : index == 1
                                  ? const Color(0xFFC0C0C0)
                                  : const Color(0xFFCD7F32),
                        ),
                      if (adminSettings.showUserAdminLabel && appUser.isAdmin)
                        Icon(
                          Icons.verified_user,
                          color: const Color(userAdminColor),
                          size: titleSize ?? 16,
                        ),
                      if (appUser.verified)
                        Icon(
                          Icons.verified,
                          color: const Color(0xFF00a5e3),
                          size: titleSize ?? 16,
                        ),
                      if (appUser.verified ||
                          (adminSettings.showUserAdminLabel && appUser.isAdmin))
                        const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          appUser.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: titleSize ?? 16,
                            color: titleColor ?? colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (adminSettings.showUserLikeCount) ...[
                        const SizedBox(width: 4),
                        WriterLabel(
                          // label: context.loc.likesCount,
                          iconData: Icons.arrow_upward_rounded,
                          color: const Color(userLikeCountColor),
                          count: appUser.likeCount,
                          labelSize: profileUserLabelFontSize,
                        ),
                      ],
                      if (adminSettings.showUserDislikeCount) ...[
                        const SizedBox(width: 4),
                        WriterLabel(
                          // label: context.loc.dislikesCount,
                          iconData: Icons.arrow_downward_rounded,
                          color: const Color(userDislikeCountColor),
                          count: appUser.dislikeCount,
                          labelSize: profileUserLabelFontSize,
                        ),
                      ],
                      if (adminSettings.showUserSumCount) ...[
                        const SizedBox(width: 4),
                        WriterLabel(
                          // label: context.loc.sumCount,
                          iconData: Icons.swap_vert_rounded,
                          color: const Color(userSumCountColor),
                          count: appUser.sumCount,
                          labelSize: profileUserLabelFontSize,
                        ),
                      ]
                    ],
                  ),
                  if (isTwoLine)
                    Text(
                      secondLine ?? context.loc.noContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subtitleSize ?? 14,
                        color: subtitleColor ?? colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
