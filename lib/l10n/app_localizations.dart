import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeAppBarTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @notFound404.
  ///
  /// In en, this message translates to:
  /// **'404 - Page not found!'**
  String get notFound404;

  /// No description provided for @emptyPlaceholderDefault.
  ///
  /// In en, this message translates to:
  /// **'Oops something went wrong.\nPlease try again later.'**
  String get emptyPlaceholderDefault;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appTheme;

  /// No description provided for @systemThemeMode.
  ///
  /// In en, this message translates to:
  /// **'System Setting'**
  String get systemThemeMode;

  /// No description provided for @lightThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightThemeMode;

  /// No description provided for @darkThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkThemeMode;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appLanguage;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System Setting'**
  String get systemLanguage;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @allPosts.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allPosts;

  /// No description provided for @recommendedPosts.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommendedPosts;

  /// No description provided for @hotPosts.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hotPosts;

  /// No description provided for @popularPosts.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularPosts;

  /// No description provided for @noPost.
  ///
  /// In en, this message translates to:
  /// **'No Post'**
  String get noPost;

  /// No description provided for @noComment.
  ///
  /// In en, this message translates to:
  /// **'No Comment'**
  String get noComment;

  /// No description provided for @noLike.
  ///
  /// In en, this message translates to:
  /// **'No Like'**
  String get noLike;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content'**
  String get noContent;

  /// No description provided for @startFirstPost.
  ///
  /// In en, this message translates to:
  /// **'Start by sharing the first post.'**
  String get startFirstPost;

  /// No description provided for @startFirstComment.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation with a comment.'**
  String get startFirstComment;

  /// No description provided for @deletedPost.
  ///
  /// In en, this message translates to:
  /// **'This post has been deleted.'**
  String get deletedPost;

  /// No description provided for @blockedPost.
  ///
  /// In en, this message translates to:
  /// **'This post has been blocked.'**
  String get blockedPost;

  /// No description provided for @blockedUser.
  ///
  /// In en, this message translates to:
  /// **'This user has been blocked.'**
  String get blockedUser;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **' days ago'**
  String get daysAgo;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **' day ago'**
  String get dayAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **' hours ago'**
  String get hoursAgo;

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **' hour ago'**
  String get hourAgo;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **' minutes ago'**
  String get minutesAgo;

  /// No description provided for @minuteAgo.
  ///
  /// In en, this message translates to:
  /// **' minute ago'**
  String get minuteAgo;

  /// No description provided for @writeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get writeAppBarTitle;

  /// No description provided for @editAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAppBarTitle;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editPost;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePost;

  /// No description provided for @recommendPost.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get recommendPost;

  /// No description provided for @specifyMainPost.
  ///
  /// In en, this message translates to:
  /// **'Specify Main Post'**
  String get specifyMainPost;

  /// No description provided for @blockPost.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get blockPost;

  /// No description provided for @unrecommendPost.
  ///
  /// In en, this message translates to:
  /// **'Unrecommend'**
  String get unrecommendPost;

  /// No description provided for @specifyGeneralPost.
  ///
  /// In en, this message translates to:
  /// **'Specify General Post'**
  String get specifyGeneralPost;

  /// No description provided for @unblockPost.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblockPost;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblockUser;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @completing.
  ///
  /// In en, this message translates to:
  /// **'Completing...'**
  String get completing;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading Image'**
  String get uploadingImage;

  /// No description provided for @uploadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Uploading Video'**
  String get uploadingVideo;

  /// No description provided for @uploadingFile.
  ///
  /// In en, this message translates to:
  /// **'Uploading File'**
  String get uploadingFile;

  /// No description provided for @fileError.
  ///
  /// In en, this message translates to:
  /// **'This file cannot be loaded.'**
  String get fileError;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'This email is invalid.'**
  String get invalidEmail;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user is disabled.'**
  String get userDisabled;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Please create an account first.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'This password is wrong.'**
  String get wrongPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'This password is weak. Please change the password.'**
  String get weakPassword;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Your email or password is incorrect.'**
  String get invalidLoginCredentials;

  /// No description provided for @invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Please check your email or password.'**
  String get invalidCredential;

  /// No description provided for @unknownIssueWithAuth.
  ///
  /// In en, this message translates to:
  /// **'Something is wrong. Please try later.'**
  String get unknownIssueWithAuth;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password that is at least 6 characters long'**
  String get shortPassword;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @wrongMessage.
  ///
  /// In en, this message translates to:
  /// **'Something is wrong'**
  String get wrongMessage;

  /// No description provided for @tryLater.
  ///
  /// In en, this message translates to:
  /// **'Something is wrong. Please try later.'**
  String get tryLater;

  /// No description provided for @failedInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed. Try again.'**
  String get failedInitializing;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @failedPostSubmit.
  ///
  /// In en, this message translates to:
  /// **'Please check your network or media files. Square brackets ([]) cannot be used in file names.'**
  String get failedPostSubmit;

  /// No description provided for @failedMediaFile.
  ///
  /// In en, this message translates to:
  /// **'The media files could not be recognized. Please check the files'**
  String get failedMediaFile;

  /// No description provided for @failedUploadMediaFile.
  ///
  /// In en, this message translates to:
  /// **'Unable to upload the media files. Please check your network connection.'**
  String get failedUploadMediaFile;

  /// No description provided for @ooops.
  ///
  /// In en, this message translates to:
  /// **'Ooops'**
  String get ooops;

  /// No description provided for @emptyContent.
  ///
  /// In en, this message translates to:
  /// **'Your content is empty. Please enter content.'**
  String get emptyContent;

  /// No description provided for @needLogin.
  ///
  /// In en, this message translates to:
  /// **'Login is required.'**
  String get needLogin;

  /// No description provided for @needPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission is required'**
  String get needPermission;

  /// No description provided for @cannotEdit.
  ///
  /// In en, this message translates to:
  /// **'You cannot edit this post.'**
  String get cannotEdit;

  /// No description provided for @commentsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsAppBarTitle;

  /// No description provided for @byCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get byCreatedAt;

  /// No description provided for @byCommentCount.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get byCommentCount;

  /// No description provided for @byLikeCount.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get byLikeCount;

  /// No description provided for @byDislikeCount.
  ///
  /// In en, this message translates to:
  /// **'DisLikes'**
  String get byDislikeCount;

  /// No description provided for @bySumCount.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bySumCount;

  /// No description provided for @leaveComment.
  ///
  /// In en, this message translates to:
  /// **'leave comment...'**
  String get leaveComment;

  /// No description provided for @deleteComment.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteComment;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @leaveReply.
  ///
  /// In en, this message translates to:
  /// **'leave reply...'**
  String get leaveReply;

  /// No description provided for @editUsername.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editUsername;

  /// No description provided for @changeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Change profile image'**
  String get changeProfileImage;

  /// No description provided for @changeStoryImage.
  ///
  /// In en, this message translates to:
  /// **'Change Story image'**
  String get changeStoryImage;

  /// No description provided for @editBio.
  ///
  /// In en, this message translates to:
  /// **'Edit bio'**
  String get editBio;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @defaultImage.
  ///
  /// In en, this message translates to:
  /// **'Default image'**
  String get defaultImage;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get username;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name...'**
  String get enterYourName;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @userNotExist.
  ///
  /// In en, this message translates to:
  /// **'This user does not exist.'**
  String get userNotExist;

  /// No description provided for @enterPasswordForEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to change your email address.'**
  String get enterPasswordForEmail;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsNotMatch;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @likesPosts.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likesPosts;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deletingAccount;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @videoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Video not found'**
  String get videoNotFound;

  /// No description provided for @imageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imageNotFound;

  /// No description provided for @postNotFound.
  ///
  /// In en, this message translates to:
  /// **'Post not found'**
  String get postNotFound;

  /// No description provided for @commentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Comment not found'**
  String get commentNotFound;

  /// No description provided for @postWriterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Post writer not found'**
  String get postWriterNotFound;

  /// No description provided for @commentWriterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Comment writer not found'**
  String get commentWriterNotFound;

  /// No description provided for @mainLabel.
  ///
  /// In en, this message translates to:
  /// **'Editor Pick'**
  String get mainLabel;

  /// No description provided for @likedBy.
  ///
  /// In en, this message translates to:
  /// **'Liked by'**
  String get likedBy;

  /// No description provided for @dislikedBy.
  ///
  /// In en, this message translates to:
  /// **'Disliked by'**
  String get dislikedBy;

  /// No description provided for @tagSearch.
  ///
  /// In en, this message translates to:
  /// **'tag search...'**
  String get tagSearch;

  /// No description provided for @loadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Loading video...'**
  String get loadingVideo;

  /// No description provided for @likesCount.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likesCount;

  /// No description provided for @dislikesCount.
  ///
  /// In en, this message translates to:
  /// **'Dislikes'**
  String get dislikesCount;

  /// No description provided for @sumCount.
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get sumCount;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @rankPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get rankPost;

  /// No description provided for @rankComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get rankComment;

  /// No description provided for @rankUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get rankUser;

  /// No description provided for @rankLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get rankLike;

  /// No description provided for @rankDislike.
  ///
  /// In en, this message translates to:
  /// **'Dislike'**
  String get rankDislike;

  /// No description provided for @rankSum.
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get rankSum;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @allMonths.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get allMonths;

  /// No description provided for @allDays.
  ///
  /// In en, this message translates to:
  /// **'All days'**
  String get allDays;

  /// No description provided for @maxFileSizeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size exceeded'**
  String get maxFileSizeErrorTitle;

  /// No description provided for @maxFileSizedErrorContent.
  ///
  /// In en, this message translates to:
  /// **'The maximum file size has been exceeded. Please reduce the file size and try again.'**
  String get maxFileSizedErrorContent;

  /// No description provided for @appStyle.
  ///
  /// In en, this message translates to:
  /// **'App style'**
  String get appStyle;

  /// No description provided for @listType.
  ///
  /// In en, this message translates to:
  /// **'List style'**
  String get listType;

  /// No description provided for @cardType.
  ///
  /// In en, this message translates to:
  /// **'Card style'**
  String get cardType;

  /// No description provided for @pageType.
  ///
  /// In en, this message translates to:
  /// **'Page style'**
  String get pageType;

  /// No description provided for @roundCardType.
  ///
  /// In en, this message translates to:
  /// **'Round card style'**
  String get roundCardType;

  /// No description provided for @mixedType.
  ///
  /// In en, this message translates to:
  /// **'Mixed style'**
  String get mixedType;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get appInfo;

  /// No description provided for @newPostNoti.
  ///
  /// In en, this message translates to:
  /// **'New post noti'**
  String get newPostNoti;

  /// No description provided for @likeCommentNoti.
  ///
  /// In en, this message translates to:
  /// **'Comment·like noti'**
  String get likeCommentNoti;

  /// No description provided for @postNoti.
  ///
  /// In en, this message translates to:
  /// **'has posted a new post.'**
  String get postNoti;

  /// No description provided for @commentNoti.
  ///
  /// In en, this message translates to:
  /// **'left a comment.'**
  String get commentNoti;

  /// No description provided for @replyNoti.
  ///
  /// In en, this message translates to:
  /// **'left a reply.'**
  String get replyNoti;

  /// No description provided for @postLikeNoti.
  ///
  /// In en, this message translates to:
  /// **'likes your post.'**
  String get postLikeNoti;

  /// No description provided for @commentLikeNoti.
  ///
  /// In en, this message translates to:
  /// **'likes your comment.'**
  String get commentLikeNoti;

  /// No description provided for @signUpAgain.
  ///
  /// In en, this message translates to:
  /// **'Something is wrong. Please try signing up again.'**
  String get signUpAgain;

  /// No description provided for @signInAgain.
  ///
  /// In en, this message translates to:
  /// **'User initialization failed. Please try signing in.'**
  String get signInAgain;

  /// No description provided for @adminSettings.
  ///
  /// In en, this message translates to:
  /// **'Admin settings'**
  String get adminSettings;

  /// No description provided for @homeTitleSetting.
  ///
  /// In en, this message translates to:
  /// **'Home screen app bar title setting'**
  String get homeTitleSetting;

  /// No description provided for @mainColorSetting.
  ///
  /// In en, this message translates to:
  /// **'Main color setting'**
  String get mainColorSetting;

  /// No description provided for @categorySetting.
  ///
  /// In en, this message translates to:
  /// **'Category setting'**
  String get categorySetting;

  /// No description provided for @homeAppBarTitleStyle.
  ///
  /// In en, this message translates to:
  /// **'Home title style'**
  String get homeAppBarTitleStyle;

  /// No description provided for @textStyle.
  ///
  /// In en, this message translates to:
  /// **'Text type'**
  String get textStyle;

  /// No description provided for @imageStyle.
  ///
  /// In en, this message translates to:
  /// **'Image type'**
  String get imageStyle;

  /// No description provided for @textImageStyle.
  ///
  /// In en, this message translates to:
  /// **'Text + Image'**
  String get textImageStyle;

  /// No description provided for @homeAppBarTitleText.
  ///
  /// In en, this message translates to:
  /// **'Title text'**
  String get homeAppBarTitleText;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get enterTitle;

  /// No description provided for @changeHomeAppBarTitleImage.
  ///
  /// In en, this message translates to:
  /// **'Title image'**
  String get changeHomeAppBarTitleImage;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get selectColor;

  /// No description provided for @enterValidColor.
  ///
  /// In en, this message translates to:
  /// **'Invalid color'**
  String get enterValidColor;

  /// No description provided for @changeMainColor.
  ///
  /// In en, this message translates to:
  /// **'Change main color'**
  String get changeMainColor;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCategory;

  /// No description provided for @pathName.
  ///
  /// In en, this message translates to:
  /// **'Path name'**
  String get pathName;

  /// No description provided for @titleName.
  ///
  /// In en, this message translates to:
  /// **'Title name'**
  String get titleName;

  /// No description provided for @onlyLowercase.
  ///
  /// In en, this message translates to:
  /// **'alphabet lowercase, numbers, hyphens'**
  String get onlyLowercase;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Invalid name'**
  String get invalidName;

  /// No description provided for @duplicateName.
  ///
  /// In en, this message translates to:
  /// **'Duplicate name'**
  String get duplicateName;

  /// No description provided for @showAppStyleButton.
  ///
  /// In en, this message translates to:
  /// **'Show app style button'**
  String get showAppStyleButton;

  /// No description provided for @boxColorType.
  ///
  /// In en, this message translates to:
  /// **'Post box color type'**
  String get boxColorType;

  /// No description provided for @singleColor.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get singleColor;

  /// No description provided for @gradientColor.
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get gradientColor;

  /// No description provided for @animationColor.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get animationColor;

  /// No description provided for @mediaMaxMBSize.
  ///
  /// In en, this message translates to:
  /// **'Media file max size (MB)'**
  String get mediaMaxMBSize;

  /// No description provided for @useRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Use recommendation screen'**
  String get useRecommendation;

  /// No description provided for @useRanking.
  ///
  /// In en, this message translates to:
  /// **'Use ranking screen'**
  String get useRanking;

  /// No description provided for @useCategory.
  ///
  /// In en, this message translates to:
  /// **'Use category screen'**
  String get useCategory;

  /// No description provided for @showLogoutOnDrawer.
  ///
  /// In en, this message translates to:
  /// **'Show signout button in drawer'**
  String get showLogoutOnDrawer;

  /// No description provided for @showLikeCount.
  ///
  /// In en, this message translates to:
  /// **'Use like button'**
  String get showLikeCount;

  /// No description provided for @showDislikeCount.
  ///
  /// In en, this message translates to:
  /// **'Use dislike button'**
  String get showDislikeCount;

  /// No description provided for @showCommentCount.
  ///
  /// In en, this message translates to:
  /// **'Use comment function'**
  String get showCommentCount;

  /// No description provided for @showSumCount.
  ///
  /// In en, this message translates to:
  /// **'Show likes + dislikes sum'**
  String get showSumCount;

  /// No description provided for @showCommentPlusLikeCount.
  ///
  /// In en, this message translates to:
  /// **'Show comments + likes sum'**
  String get showCommentPlusLikeCount;

  /// No description provided for @isThumbUpToHeart.
  ///
  /// In en, this message translates to:
  /// **'Show likes with hearts'**
  String get isThumbUpToHeart;

  /// No description provided for @showUserAdminLabel.
  ///
  /// In en, this message translates to:
  /// **'Show administrator icon'**
  String get showUserAdminLabel;

  /// No description provided for @showUserLikeCount.
  ///
  /// In en, this message translates to:
  /// **'Show user likes count'**
  String get showUserLikeCount;

  /// No description provided for @showUserDislikeCount.
  ///
  /// In en, this message translates to:
  /// **'Show user dislikes count'**
  String get showUserDislikeCount;

  /// No description provided for @showUserSumCount.
  ///
  /// In en, this message translates to:
  /// **'Show user likes + dislikes sum'**
  String get showUserSumCount;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @argeeStart.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to '**
  String get argeeStart;

  /// No description provided for @argeeMiddle.
  ///
  /// In en, this message translates to:
  /// **'and acknowledge you have read our'**
  String get argeeMiddle;

  /// No description provided for @argeeEnd.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get argeeEnd;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'System Maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'The system is currently under maintenance.'**
  String get maintenanceMessage;

  /// No description provided for @maintenanceAccess.
  ///
  /// In en, this message translates to:
  /// **'Administrator access only.'**
  String get maintenanceAccess;

  /// No description provided for @systemMaintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'System maintenance mode'**
  String get systemMaintenanceMode;

  /// No description provided for @withAiButton.
  ///
  /// In en, this message translates to:
  /// **'With AI'**
  String get withAiButton;

  /// No description provided for @withAiTitle.
  ///
  /// In en, this message translates to:
  /// **'With AI (Gemini)'**
  String get withAiTitle;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// No description provided for @formatIsMarkdown.
  ///
  /// In en, this message translates to:
  /// **'The format is Markdown.'**
  String get formatIsMarkdown;

  /// No description provided for @prompt.
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get prompt;

  /// No description provided for @previousPrompts.
  ///
  /// In en, this message translates to:
  /// **'Previous Prompts'**
  String get previousPrompts;

  /// No description provided for @promptHint.
  ///
  /// In en, this message translates to:
  /// **'If no message is entered, a generated text will include a title, summary, and search tags for the written content.'**
  String get promptHint;

  /// No description provided for @predefinedPrompt.
  ///
  /// In en, this message translates to:
  /// **'Predefined Prompt'**
  String get predefinedPrompt;

  /// No description provided for @predefinedPromptHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a prompt that is entered repeatedly'**
  String get predefinedPromptHint;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get reportIssue;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitReport;

  /// No description provided for @reportProcessed.
  ///
  /// In en, this message translates to:
  /// **'Your report has been processed. Thank you.'**
  String get reportProcessed;

  /// No description provided for @alreadyReport.
  ///
  /// In en, this message translates to:
  /// **'You have already reported this issue.'**
  String get alreadyReport;

  /// No description provided for @illegalReport.
  ///
  /// In en, this message translates to:
  /// **'Illegal filming content'**
  String get illegalReport;

  /// No description provided for @obsceneReport.
  ///
  /// In en, this message translates to:
  /// **'Pornography/Obscene content'**
  String get obsceneReport;

  /// No description provided for @spamReport.
  ///
  /// In en, this message translates to:
  /// **'Spam/Promotion/Repetitive'**
  String get spamReport;

  /// No description provided for @profanityReport.
  ///
  /// In en, this message translates to:
  /// **'Profanity/Violent/Hateful/Discriminatory'**
  String get profanityReport;

  /// No description provided for @defamationReport.
  ///
  /// In en, this message translates to:
  /// **'Defamation/Privacy Violation/Personal Information Exposure'**
  String get defamationReport;

  /// No description provided for @scamReport.
  ///
  /// In en, this message translates to:
  /// **'Scam/Fraud/False Information'**
  String get scamReport;

  /// No description provided for @suicideReport.
  ///
  /// In en, this message translates to:
  /// **'Suicide/Self-Harm'**
  String get suicideReport;

  /// No description provided for @customReport.
  ///
  /// In en, this message translates to:
  /// **'Other (Please specify)'**
  String get customReport;

  /// No description provided for @adminsOnlyPosting.
  ///
  /// In en, this message translates to:
  /// **'Admins Only Posting'**
  String get adminsOnlyPosting;

  /// No description provided for @defaultVideoMute.
  ///
  /// In en, this message translates to:
  /// **'Default Video Mute'**
  String get defaultVideoMute;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
