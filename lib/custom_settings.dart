import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/widgets.dart';

// Data used for app information
// 앱정보에 사용되는 데이터
// Refer to pubspec.yaml for version
// 버전은 pubspec.yaml을 참고
const String fullAppName = 'My Applimode';
const String shortAppName = 'AMB';
const String underbarAppName = 'my_applimode';
const String camelAppName = 'myApplimode';
const String androidBundleId = 'applimode.my_applimode';
const String appleBundleId = 'applimode.myApplimode';
const String firebaseProjectId = 'my-applimode';
const String appCreator = 'JongsukOh';
const String appEmail = 'yourEmail@email.com';
const String appEffectiveDate = '2024-08-06';
const String appVersion = '0.3.3+1';

// spare values when admin settings is not set
const String spareHomeBarTitle = 'My Applimode';
// home app bar title style. 0 is text, 1 is image, 2 is image and text
const int spareHomeBarStyle = 0;
const String spareMainColor = 'FCB126';
const String spareMainCategory =
    '[{"index":0,"path":"/cat001","title":"cat001","color":"FF930F"}]';
const String spareHomeBarImageUrl = 'assets/images/app-bar-logo.png';
const bool spareShowAppStyleOption = false;
// Main screen list view style
// Select among small, square, page, round, mixed
const PostsListType sparePostsListType = PostsListType.mixed;
// Color type of basic post box. single, gradient. basic gradient
const BoxColorType spareBoxColorType = BoxColorType.gradient;
// Maximum video file size. Default 50.0 in megabytes
const double spareMediaMaxMBSize = 50.0;
const bool spareUseRecommendation = true;
const bool spareUseRanking = true;
const bool spareUseCategory = true;
const bool spareShowLogoutOnDrawer = false;
const bool spareShowLikeCount = true;
const bool spareShowDislikeCount = true;
const bool spareShowCommentCount = true;
const bool spareShowSumCount = false;
const bool spareShowCommentPlusLikeCount = false;
const bool spareIsThumbUpToHeart = false;
const bool spareShowUserAdminLabel = true;
const bool spareShowUserLikeCount = true;
const bool spareShowUserDislikeCount = true;
const bool spareShowUserSumCount = false;
const bool spareAdminOnlyWrite = false;
const bool spareIsPostsItemVideoMute = false;

// Link that connects when you tap on the Terms of Service
// 서비스약관을 탭했을 경우 연결되는 링크
const String termsUrl = '';
// Link that connects when you tap on the privacy policy
// 개인보호정책을 탭했을 경우 연결되는 링크
const String privacyUrl = '';

// auth providers. email, phone supported
// if the list is empty, email provider is adopted
const List<String> fbAuthProviders = ['email'];

// Change the start screen to the login screen
// 시작 화면을 로그인 화면으로 변경
// To prevent use if not logged in. Security rules must also be changed.
// 로그인을 안할 경우 사용하지 못하도록 할때. 보안 룰도 함께 변경해야 함
const bool isInitialSignIn = false;

// Only verified users can write
// 관리자에 의해 인증된 사용자만 글을 쓸 수 있음
const bool verifiedOnlyWrite = false;

// When using push notifications. default false
// 푸시 알림을 사용할 경우. 기본 false
// Use Blaze plan of Firebase to use push notifications
// 푸시 알림을 사용하기 위해서는 Blaze 요금제 사용
// The default Spark plan is disabled when the basic limit is exceeded
// 기본인 Spark 요금제는 기본 한도를 초과하면 사용 중지
// If you use the Blaze plan, a fee will be charged if you exceed the basic limit
// Blaze 요금제를 사용할 경우, 기본 한도를 초과한면 비용 발생
// After using the Blaze plan, it is necessary to set up Cloud functions
// Blaze 요금제를 사용한 후 Cloud functions 을 설정하고
const bool useFcmMessage = false;

// When using push notifications for web apps.
// 웹앱을 위한 푸쉬 알림을 사용할 경우.
// Firebase -> Project settings -> Cloud messaging -> Web configuration
const String fcmVapidKey = '';

// register as a paid member of the Apple Developer Program for notifications on Apple devices
// 애플 기기의 알림을 위해 애플 개발자 프로그램에 유료 회원으로 등록한 후
// and configure the settings for APNS
// 설정을 해주는 것이 필요
const bool useApns = false;

// generate posts using Google Gemini when writing posts
// need to enable Vertex AI in the firebase console
// 포스트 작성할 때 구글 제미나이를 사용해 포스트 생성
// 파이어베이스 콘솔에서 vertex ai 사용 설정해야 함
const bool useAiAssistant = false;

// ai default instructions
const String aiInstructions =
    'These are the conditions for generating text. The basic prompt starts with <basicPromptStart> and ends with <basicPromptEnd>. The user prompt starts with <userPromptStart> and ends with <userPromptEnd>. The main content starts with <contentStart> and ends with <contentEnd>. The main content should be written using Markdown. Generate the text based on the language used in the main content. If the main content is missing or empty, generate the text based on the user prompt. Include the main content in the generated text and remove the <contentStart> and <contentEnd> tags in the final output. Do not modify any links, URLs, or URIs within the main content. Analyze the main content and if there is no title, add one in the format # Title and add a summary at the bottom of the content in the format * Summary: summary content. Analyze the main content and append search tags at the bottom in the format #tag #tag. Add a blank line before the search tags. For multi-word tags like "miscellaneous travel," format them as #miscellaneous_travel. Unless otherwise specified, only correct spelling errors in the main content.';

// Model type to use as AI assistant
// ai assistant로 사용할 모델 타입
// gemini-2.0-flash, gemini-2.0-flash-lite, gemini-2.0-pro-exp-02-05, gemini-2.0-flash-thinking-exp-01-21
const String aiModelType = 'gemini-2.0-flash';

// Color type of basic post box. single, gradient, animation. basic gradient
// 베이직 포스트 박스의 컬러 타입. single, gradient, animattion. 기본 gradient
// const boxColorType = BoxColorType.gradient;
// Used when specified as single. Colors can be set directly using boxCustomColorPalettes
// single로 지정했을 경우 사용. boxCustomColorPalettes 를 이용해 직접 컬러 설정 가능
const List<Color> boxSingleColors = boxSingleColorPalettes;
// Used when specified as gradient, animation. Colors can be set directly using boxCustomGradientColorPalettes
// gradient, animation을 사용했을 경우 사용. boxCustomGradientColorPalettes 를 이용해 직접 지정 가능
const List<List<Color>> boxGradientColors = boxGradientColorPalettes;

// use r2 storage
// r2 스토리지 사용
const bool useRTwoStorage = false;
// When using r2, use secure read
// r2 사용시 읽기도 보안 가져오기 사용
const bool useRTwoSecureGet = false;
// use Cloudflare CDN
// 클라우드플레어 CDN 사용 (도메인 등록 필수)
const bool useCfCdn = false;
// use Cloudflare D1 for seach
// 검색서비스를 위해 클라우드플레어 D1 사용
const bool useDOneForSearch = false;

// Cloudflare worker base url for r2 storage
// 클라우드플레어 r2 스토리지 사용을 위한 워커 베이스 url
const String rTwoBaseUrl = 'yourR2WorkerUrl';

// Cloudflare custom domain for cdn
// 클라우드플레어 커스텀 도메인 url
const String cfDomainUrl = 'yourCustomDomainUrl';

// Cloudflare worker base url for D1 table
// 클라우드플레어 D1 데이터베이스를 위한 워커 베이스 url
const String dOneBaseUrl = 'yourD1WorkerUrl';

// proxy for youtube image
// 유튜브 이미지를 위한 프록시 주소
const String youtubeImageProxyUrl =
    'yt-thumbnail-worker.jongsukoh80.workers.dev';

// proxy for youtube iframe
// 유튜브 iframe을 위한 프록시 주소
const String youtubeIframeProxyUrl = '';

// Number of items loaded at once in the main screen list view. default 10
// 메인 화면 리스트 뷰에서 한번에 불러오는 아이템 숫자. 기본 10
// As the number increases, the number of reads in the database increases.
// 숫자를 늘릴 수록 데이터베이스의 읽기 수롤 많이 사용함
const int listFetchLimit = 10;
// Number of items loaded in the main head view of the home screen. default 1
// 홈화면 상단 메인 뷰에서 사용하기 위해 블러오는 아이템 숫자. 기본 1
const int mainFetchLimit = 1;

// Refresh cycle through main screen pull-to-refresh. Default 10 seconds
// 메인화면 풀투리프레쉬를 통한 새로고침 주기. 기본 10초
const int mainPostsRefreshTimer = 10;

// Maximum length of video in seconds. default 60
// 비디오 영상 최대 길이 초 단위. 기본 60
const int videoMaxDuration = 60;

// Video frame aspect ratio in post
// 포스트에서 비디오 영상 프레임 비율
const double postVideoAspectRatio = 1.0;

// Profile image max width
// 프로필 이미지 최대 너비
const double profileMaxWidth = 160.0;

// Profile image max height
// 프로필 이미지 최대 높이
const double profileMaxHeight = 160.0;

// Story image max width
// 스토리 이미지 최대 너비
const double storyMaxWidth = 1080.0;

// Story image max height
// 스토리 이미지 최대 높이
const double storyMaxHeight = 1920.0;

// Post image max width
// 포스트 이미지 최대 너비
const double postImageMaxWidth = 1080.0;

// Post image max height
// 포스트 이미지 최대 높이
const double postImageMaxHeight = 1920.0;

// Post image quality
// 포스트 이미지 품질
const int postImageQuality = 90;

// Video thumbnail max width
// 비디오 썸네일 최대 너비
const int videoThumbnailMaxWidth = 1920;

// Video thumbnail height
// 비디오 썸네일 최대 높이
const int videoThumbnailMaxHeight = 1920;

// Video thumbnail quality
// 비디오 썸네일 품질
const int videoThumbnailQuality = 90;

// When get a maximum size YouTube thumbnail
// 유튜브 썸네일 최대 사이즈로 가져올 경우
const bool isMaxResYoutubeThumbnail = false;

// Periodically call admin settings to save database reads
// 데이터 베이스 읽기 수를 절약하기 위해 어드민 세팅값들을 주기적으로 부름
const bool useAdminSettingsInterval = false;

// Frequency of admin Settings calls. default 600 seconds
// 어드민 세팅 호출 빈도. 기본 값 600초.
const Duration adminSettingsInterval = Duration(seconds: 60 * 10);

// Changing this will change the maximum width of the content on the web.
// 변경하면 웹에서 컨텐츠의 최대너비가 바뀜.
// default 720.0
// 기본 720.0
const double pcWidthBreakpoint = 720.0;

// Maximum length of username in sub-info. default 18
// 서브 인포에서 이름 최대 길이. 기본 18
const int usernameMaxLength = 18;

// Show search button on app bar
// 검색 버튼 보이기
const bool showSearchButton = true;

// Administrator icon color. default 0xFFEEAC4D
// 관리자 아이콘 색깔. 기본 0xFFEEAC4D
const int userAdminColor = 0xFFEEAC4D;
// Verified user icon color. default 0xFF00a5e3
// 인증된 사용자 아이콘 색깔. 기본 0xFF00a5e3
const int userVerifiedColor = 0xFF00a5e3;
// User like icon color. default 0xFF00C6C7
// 사용자 좋아요 아이콘 색깔. 기본 0xFF00C6C7
const int userLikeCountColor = 0xFF00C6C7;
// User dislike icon color. default 0xFFFF6F68
// 사용자 싫어요 아이콘 색깔. 기본 0xFFFF6F68
const int userDislikeCountColor = 0xFFFF6F68;
// User Likes Dislikes Total Icon Color. default 0xFF6C88C4
// 사용자 좋아요 싫어요 합계 아이콘 색깔. 기본 0xFF6C88C4
const int userSumCountColor = 0xFF6C88C4;

// Center title text alignment. Specify among start, center, end. default center
// 센터 타이틀 텍스트 정렬. start, center, end 중 지정. 기본 center
const TitleTextAlign basicPostsItemtitleTextAlign = TitleTextAlign.center;
// Maximum number of lines in the center title. basic 2
// 센터 타이틀 최대 줄수. 기본 2
const int basicPostsItemMiddleTitleMaxLines = 2;
// Maximum number of lines in the bottom title. basic 2
// 하단 타이틀 최대 줄수. 기본 2
const int basicPostsItemBottomTitleMaxLines = 1;
// Maximum number of lines in video content title. default 1
// 비디오 컨텐츠 타이틀 최대 줄수. 기본 1
const int basicPostsItemVideoTitleMaxLines = 1;
// Title text size. default 20.0
// 타이틀 텍스트 크기. 기본 20.0
const double basicPostsItemTitleFontsize = 20.0;
// Profile image size. default 48.0
// 프로필 이미지 크기. 기본 48.0
const double basicPostsItemProfileSize = 48.0;
// Username font size. default 18.0
// 사용자 이름 크기. 기본 18.0
const double basicPostsItemNameSize = 18.0;
// Sub-info size. default 14.0
// 서브 인포 크기. 기본 14.0
const double basicPostsItemSubInfoSize = 14.0;
// Side button color. default 0xFFFFFFFF
// 사이드 버튼 컬러. 기본 0xFFFFFFFF
const int basicPostsItemButtonColor = 0xFFFFFFFF;
// Side button size. default 28.0
// 사이드 버튼 크기. 기본 28.0
const double basicPostsItemButtonSize = 20.0;
// Side button count font size. default 14.0
// 사이드 버튼 카운트 글자 크기. 기본 14.0
const double basicPostsItemButtonFontSize = 14.0;

// Center title text alignment. Specify among start, center, end. default center
// 센터 타이틀 텍스트 정렬. start, center, end 중 지정. 기본 center
const TitleTextAlign roundPostsItemtitleTextAlign = TitleTextAlign.center;
// Maximum number of lines in the center title. basic 1
// 센터 타이틀 최대 줄수. 기본 1
const int roundPostsItemMiddleTitleMaxLines = 1;
// Maximum number of lines in the bottom title. basic 1
// 하단 타이틀 최대 줄수. 기본 1
const int roundPostsItemBottomTitleMaxLines = 1;
// Maximum number of lines in video content title. default 1
// 비디오 컨텐츠 타이틀 최대 줄수. 기본 1
const int roundPostsItemVideoTitleMaxLines = 1;
// Title text size. default 16.0
// 타이틀 텍스트 크기. 기본 16.0
const double roundPostsItemTitleFontsize = 16.0;
// Profile image size. default 40.0
// 프로필 이미지 크기. 기본 40.0
const double roundPostsItemProfileSize = 40.0;
// Username font size. default 16.0
// 사용자 이름 크기. 기본 16.0
const double roundPostsItemNameSize = 16.0;
// Sub-info size. default 12.0
// 서브 인포 크기. 기본 12.0
const double roundPostsItemSubInfoSize = 12.0;

// Edit list type (small) main screen style
// 리스트타입 (스몰) 메인 화면 스타일 편집
// List height. default 88.0
// 리스트 높이. 기본 88.0
const double listSmallItemHeight = 88.0;
// Header item aspect ratio. default 16 / 9
// 메인 헤더 비율. 기본 16 / 9
const double smallItemHeaderRatio = 16 / 9;
// Image size. Change it in conjunction with the height of the list above.
// default 56.0
// 이미지 크기. 위의 리스트 높이랑 연동해서 변경할 것. 기본 56.0
const double cachedBorderImageSize = 56.0;
// Image roundness. default 12.0
// 이미지 둥글기. 기본 12.0
// When changing the size to half of the cachedBorderImageSize
// it changes to a circular shape.
// 위의 이미지 사이즈의 절반의 크기로 변경할 경우 원형으로 바뀜
const double cachedBorderImageRedius = 12.0;
// Maximum number of lines in the title. default 1
// 타이틀 최대 줄수. 기본 1
const int smallPostsItemTitleMaxLines = 1;
// Title size. default 16.0
// 타이틀 사이즈. 기본 16.0
const double smallPostsItemTitleSize = 16.0;
// Sub info size. default 12.0
// 서브 인포 사이즈. 기본 12.0
const double smallPostsItemSubInfoSize = 12.0;

// User likes, dislikes, and total label size in profile. default 12.0
// 프로필에서 사용자 좋아요, 싫어요, 합계 라벨 사이즈. 기본 12.0
const double profileUserLabelFontSize = 12.0;

// Change the height of the main screen app bar. default 64.0
// 메인 화면 앱바의 높이를 변경. 기본 64.0
const double mainScreenAppBarHeight = 64.0;
// Change the main screen app bar image padding. default 16.0
// 메인 화면 앱바 이미지의 상하여백를 변경. 기본 16.0
const double mainScreenAppBarPadding = 16.0;
// Change the height of the post screen app bar. default 72.0
// 포스트 화면 앱바의 높이를 변경. 기본 72.0
const double postScreenAppBarHeight = 72.0;
// Change the height of the comment screen app bar. default 72.0
// 코멘트 화면 앱바의 높이를 변경. 기본 72.0
const double commentScreenAppBarHeight = 72.0;

// Change minimum profile size. Not used. default 16.0
// 최소 프로필 사이즈 변경. 사용하지 않음. 기본 16.0
const double profileSizeMicro = 16.0;
// Change the profile size of the main screen drawer. default 24.0
// 메인화면 서랍의 프로필 사이즈 변경. 기본 24.0
const double profileSizeSmall = 24.0;
// Change the default profile size. Not used. default 32.0
// 기본 프로필 사이즈 변경. 사용하지 않음. 기본 32.0
const double profileSizeMedium = 32.0;
// Change the size of all profiles
// except the main screen drawer and profile screen profiles. default 40.0
// 메인화면 서랍, 프로필 스크린 프로필 외 모든 프로필 사이즈 변경. 기본 40.0
const double profileSizeBig = 40.0;
// Change the profile size on the profile screen. default 48.0
// 프로필 화면의 프로필 사이즈 변경. 기본 48.0
const double profileSizeBigger = 48.0;
// Change maximum profile size. Not used. default 64.0
// 최대 프로필 사이즈 변경. 사용하지 않음. 기본 64.0
const double profileSizeMax = 64.0;

// Default padding. Used to limit the maximum size. default 16.0
// 기본 패딩. 최대 크기를 제한하는 경우 사용. 기본 16.0
const double defaultHorizontalPadding = 16.0;

//Padding at the bottom of the card item on the main screen. Not used.
//default 12.0
// 메인 화면의 카드 아이템 하단 패딩. 0.0 일 경우 여백 없음. 기본 12.0
const double cardBottomPadding = 12.0;

//Padding of the round card item.
//default 16.0
// 둥근 카드 아이템 패딩. 기본 16.0
const double roundCardPadding = 16.0;

// size of the icons of the post screen bottom bar.
// default 20.0
// 포스트 화면 하단 바 아이콘 사이즈. 기본 20.0
const double postScreenBottomBarIconSize = 20.0;

// How long the full screen video player overlay (like the play button) stays on
// default 4
// 전체 화면 비디오 플레이어 오버레이(플레이버튼 같은) 유지 시간. 기본 4
const Duration overlayDuration = Duration(seconds: 4);

// 그라디에이션 컬러 애니메이션 구동 시간. 기본 2000
// Gradient color animation running time. default 2000
const int colorAnimationDuration = 2000;

// Minimum bytes to specify long content. default 1200
// 긴 컨텐츠 지정을 위한 최소 바이트. 기본 1200
const int longContentSize = 2400;
// Maximum length saved as a title when specified as long content. default 140
// 긴 컨텐츠로 지정되었을 경우 타이틀로 저장하는 최대 길이. 기본 140
const int contentTitleSize = 140;

// ios, ipados web에서 하단 safearea 사이즈
// Bottom safearea size on iOS, iPadOS web
const double iosWebBottomSafeArea = 24.0;

// Text displayed if there is no self-introduction on the bio edit screen.
// default noBio
// 프로필의 자기소개 변경 화면에서 자기 소개 없을 경우 표시되는 문구. 기본 noBio
const String noBio = 'noBio';

// Single color box basic color. If you set it yourself, use boxCustomColorPalettes at the bottom.
// 싱글 컬러 박스 기본 컬러. 직접 설정할 경우 하단의 boxCustomColorPalettes를 사용
const List<Color> boxSingleColorPalettes = [
  Color(0xFFFF930F),
  Color(0xFF4CB0A6),
  Color(0xFFFF6F68),
  Color(0xFF5cb270),
  Color(0xFFffa8bd),
  Color(0xFFb79c05),
  Color(0xFF00ACA5),
  Color(0xFFEE84B3),
  Color(0xFF20503E),
  Color(0xFFB57E79),
];

// Gradient and animation color box default colors. If you set it yourself, use boxCustomGradientColorPalettes at the bottom.
// 그라디언트 및 애니메이션 컬러 박스 기본 컬러. 직접 설정할 경우 하단의 boxCustomGradientColorPalettes를 사용
const List<List<Color>> boxGradientColorPalettes = [
  [Color(0xFFede342), Color(0xFFff51eb)],
  [Color(0xFF439cfb), Color(0xFFf187fb)],
  [Color(0xFF0061FF), Color(0xFF60efff)],
  [Color(0xFFf4f269), Color(0xFF5cb270)],
  [Color(0xFFff0f7b), Color(0xFFf89b29)],
  [Color(0xFF5D4157), Color(0xFFA8CABA)],
  [Color(0xFF61f4de), Color(0xFF6e78ff)],
  [Color(0xFFb79c05), Color(0xFF161616)],
  [Color(0xFF42047e), Color(0xFF07f49e)],
  [Color(0xFF40c9ff), Color(0xFFe81cff)],
];

// Used when directly specifying single color box.
// 싱글 컬러 박스 직접 지정할 경우 사용.
const List<Color> boxCustomColorPalettes = [
  Color(0xFFFF930F),
  Color(0xFF4CB0A6),
  Color(0xFFFF6F68),
  Color(0xFF5cb270),
  Color(0xFFffa8bd),
  Color(0xFFb79c05),
  Color(0xFF00ACA5),
  Color(0xFFEE84B3),
  Color(0xFF20503E),
  Color(0xFFB57E79),
];

// Used when directly specifying gradient and animation color box.
// 그라디언트 및 애니메이션 컬러 박스 직접 지정할 경우 사용.
const List<List<Color>> boxCustomGradientColorPalettes = [
  [Color(0xFFede342), Color(0xFFff51eb)],
  [Color(0xFF439cfb), Color(0xFFf187fb)],
  [Color(0xFF0061FF), Color(0xFF60efff)],
  [Color(0xFFf4f269), Color(0xFF5cb270)],
  [Color(0xFFff0f7b), Color(0xFFf89b29)],
  [Color(0xFF5D4157), Color(0xFFA8CABA)],
  [Color(0xFF61f4de), Color(0xFF6e78ff)],
  [Color(0xFFb79c05), Color(0xFF161616)],
  [Color(0xFF42047e), Color(0xFF07f49e)],
  [Color(0xFF40c9ff), Color(0xFFe81cff)],
];

// basic colors for color picker.
// 컬러 선택기 기본 색상
const List<Color> colorPickerBasicPalettes = [
  Color(0xFFEB5757),
  Color(0xFFF37D76),
  Color(0xFFF2994A),
  Color(0xFFFCB126),
  Color(0xFF219653),
  Color(0xFF6FCF97),
  Color(0xFF00ACA5),
  Color(0xFF00AFFE),
  Color(0xFF967ADC),
  Color(0xFFb79c05),
];
