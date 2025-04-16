<p align="center">
    <img src="https://github.com/mycalls/applimode-examples/blob/main/assets/am-campaign-head-v2.png?raw=true">
</p>


# 어플리모드 (Applimode)

[English](README.md) | 한글

어플리모드는 다음과 같은 고민에서 출발한 오픈소스 프로젝트입니다.

* 개발 경험이 없어도 누구나 자신의 블로그나 커뮤니티 서비스를 쉽게 만들 수 있으면 좋겠다.
* 초기 비용 부담 없이 서비스를 시작하고, 규모가 커져도 저렴하게 운영할 수 있으면 좋겠다.
* 다양한 플랫폼에서 서비스가 원활히 동작했으면 좋겠다.

Firebase와 Flutter를 기반으로 개발된 Applimode는 현재 Android, iOS, Web(PWA)에서 원활히 동작합니다. 이 프로젝트를 사용하면 단 몇 시간 만에 여러분만의 블로그나 커뮤니티 서비스를 손쉽게 구축할 수 있습니다.

<p align="center">
    <img src="https://github.com/mycalls/applimode-examples/blob/main/assets/am-preview-480p-10f-240829.gif?raw=true" width="320">
</p>


## 데모 보기
* [Applimode Demo Web](https://applimode-demo.web.app/)
* [Applimode Dev Web (WASM)](https://applimode-type-b.web.app/)


## 어플리모드 앱 구성하기
* [윈도우에서 구성하기](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md)
* [macOS에서 구성하기](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md)


## 어플리모드 앱 구성하기 요약
> [!IMPORTANT]
> * 이 가이드는 요약본입니다. 플러터나 파이어베이스, 프로그래밍에 익숙하지 않거나, 구성하는 중 문제가 발생하면, 이 섹션을 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md)) 참고하세요.
> * 웹(PWA)에서만 배포할 경우, **Android Studio**, **Xcode**, **Homebrew**, **rbenv** · **Ruby** · **CocoaPods** 등의 패키지를 설치할 필요가 없습니다.

* 다음 패키지를 다운로드하고 설치하세요:
**Git** (only [Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#git-설치)), **VSCode** · **Flutter SDK** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#vscode-및-flutter-sdk-설치), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#vscode-및-flutter-sdk-설치)), **Android Studio** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#android-studio-설치), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#android-studio-설치)), **Xcode** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#xcode-설치-및-구성)), **Rosetta 2** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#rosetta-2-설치)), **Homebrew** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#homebrew-설치)), **rbenv** · **Ruby** · **CocoaPods** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#rbenv-ruby-및-cocoapods-설치)), **Node.js** · **Firebase CLI** · **Flutterfire CLI** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#nodejs-firebase-cli-및-futterfire-cli-설치), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#nodejs-firebase-cli-및-futterfire-cli-설치))
* [Firebase console](https://console.firebase.google.com/)을 방문하여 새 프로젝트를 생성하고 [Authentication](https://console.firebase.google.com/project/_/authentication), [Firestore Database](https://console.firebase.google.com/project/_/firestore), [Storage](https://console.firebase.google.com/project/_/storage)를 활성화합니다.
* 어플리모드 저장소를 복제하고 초기화하기 위해, 다음 명령들을 실행하세요.
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
cp -r ./applimode/applimode-tool ./; node ./applimode-tool/index.js init; rm -r ./applimode-tool
```
* 초기화된 사용자의 어플리모드 프로젝트를 **VSCode**에서 열고, 다음 명령어들을 실행하세요.
```sh
flutter pub get
```
```sh
dart run build_runner build -d
```
```sh
flutterfire configure --platforms=android,ios,web
```
> [!NOTE]
> 질문이 나오면 **n** 또는 **N**을 누르십시오.
```sh
node ./applimode-tool/index.js firebaserc
```
```sh
firebase deploy --only firestore
```
```sh
firebase deploy --only storage
```
<!--
```sh
flutter pub get; dart run build_runner build -d; flutterfire configure --platforms=android,ios,web; node ./applimode-tool/index.js firebaserc; firebase deploy --only firestore; firebase deploy --only storage;
```
> [!NOTE]
> 질문이 나오면 **n** 또는 **N**을 누르십시오.
-->
* 웹에서 빌드할 때, 업로드한 게시물의 이미지나 비디오가 보이지 않는 경우 [해당 섹션](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md##업로드한-게시물에-이미지나-비디오가-보이지-않는-경우-다음-단계를-따르십시오-cors-문제)을 따르십시오. (CORS 문제)

추가로, 다음 항목을 설정 또는 구성할 수 있습니다:
* Applimode 앱 빌드 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#applimode-앱-빌드), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#applimode-앱-빌드))
* 웹 앱 빌드 및 배포 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#웹-앱-빌드-및-배포), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#웹-앱-빌드-및-배포))
* Android용 APK 빌드 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#android용-apk-빌드), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#android용-apk-빌드))
* 앱 아이콘 및 시작 화면 이미지 변경 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#앱-아이콘-및-시작-화면-이미지-변경), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#앱-아이콘-및-시작-화면-이미지-변경))
* 관리자 추가 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#관리자-추가), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#관리자-추가))
* 관리자 설정 및 custom_settings.dart ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#관리자-설정-및-custom_settingsdart), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#관리자-설정-및-custom_settingsdart))
* Cloudflare R2 구성 (선택 사항) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#cloudflare-r2-구성-선택-사항), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#cloudflare-r2-구성-선택-사항))
> [!NOTE]
> * Firebase Cloud Storage 대신 Cloudflare R2를 미디어 파일 저장소로 설정할 수 있습니다.
> * R2의 가장 큰 장점은 전송 비용이 무료라는 것입니다. 동영상과 같은 미디어 중심의 서비스을 구축하는 경우 Cloudflare R2 사용을 적극 추천합니다.
* Cloudflare D1 구성 (선택 사항) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#cloudflare-d1-구성-선택-사항), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#cloudflare-d1-구성-선택-사항))
> [!NOTE]
> 어플리모드는 기본적으로 해시태그 검색을 지원합니다. 전문(full-text) 검색을 사용하려는 경우 Cloudflare D1을 사용하세요.
* Cloudflare CDN 구성 (선택 사항) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#cloudflare-cdn-구성-선택-사항), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#cloudflare-cdn-구성-선택-사항))
* Youtube 이미지 프록시 구성 (선택 사항) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#youtube-이미지-프록시-구성-선택-사항), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#youtube-이미지-프록시-구성-선택-사항))
* Youtube 비디오 프록시 구성 (선택 사항) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#youtube-비디오-프록시-구성-선택-사항), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#youtube-비디오-프록시-구성-선택-사항))
* 사용자 정의 도메인 사용 (선택 사항) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#사용자-정의-도메인-사용-선택-사항), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#사용자-정의-도메인-사용-선택-사항))
* 새 Applimode 버전으로 프로젝트 업그레이드 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#새-applimode-버전으로-프로젝트-업그레이드), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#새-applimode-버전으로-프로젝트-업그레이드))
* 전화번호 로그인 추가 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#전화번호-로그인-추가), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#전화번호-로그인-추가))
* AI 어시스턴트 설정 (Gemini) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#ai-어시스턴트-설정-google-gemini), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#ai-어시스턴트-설정-google-gemini))
* 푸시 알림 구성 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#푸시-알림-구성), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#푸시-알림-구성))
* Cloud Firestore 보안 규칙 구성 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#cloud-firestore-보안-규칙-구성), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#cloud-firestore-보안-규칙-구성))
* 관리자만 글쓰기 허용으로 설정 변경 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#관리자만-글쓰기-허용으로-설정-변경), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#관리자만-글쓰기-허용으로-설정-변경))
* 앱의 기본 색상 변경 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#앱의-기본-색상-변경), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#앱의-기본-색상-변경))
* 앱 이름 변경 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#앱-이름-변경), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#앱-이름-변경))
* 앱의 조직 이름 변경 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#앱의-조직-이름-변경), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#앱의-조직-이름-변경))
* 문제 해결 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.ko.md#문제-해결), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.ko.md#문제-해결))


## 주요 기능
* 5가지 디자인 스타일
* Android, iOS, Web(PWA) 지원
* 이메일 및 전화번호를 통한 회원 가입 지원
* 포스트 작성 시 마크다운 지원
* 포스트 작성 시 텍스트, 이미지, 비디오 삽입 지원
* AI(Google Gemini)를 활용한 글 쓰기 지원
* 댓글 작성 시 텍스트, 이미지 삽입 지원
* 포스트와 댓글에 대한 좋아요, 싫어요 기능 제공
* 해시태그 기반 검색 지원
* 카테고리 설정 지원
* 포스트, 댓글에 대한 요일별, 월별, 년도별 순위 제공
* 포스트, 댓글에 대한 신고하기 기능 지원
* 관리자 설정 페이지 및 관리 모드 지원
* 관리자에 의한 사용자 및 포스트 차단 지원


## 배포(출시)를 위한 고려 사항
#### 초기 배포
* 처음에는 **Web (PWA)**로 배포하는 것을 권장합니다.
* 웹 배포는 초기 비용이 없으며, 소규모 운영 시 유지 비용도 거의 들지 않습니다.
* 배포 과정이 간단하고 별다른 제한 사항이 없어 빠르게 시작할 수 있습니다.
#### 규모 확장 시 모바일 앱 출시
* 사용자가 증가하면 **Google Play (Android)**와 **App Store (iOS)**에 출시를 고려해 보세요.
* 모바일 앱 배포를 위해서는 각각의 플랫폼에서 요구하는 유료 멤버십 가입이 필요합니다.
#### 추가 정보
* **Google Play** 출시에 대한 자세한 내용은 [여기](https://codewithandrea.com/articles/how-to-release-flutter-google-play-store/)를 참고하세요.
* **App Store** 출시에 대한 자세한 내용은 [여기](https://codewithandrea.com/articles/how-to-release-flutter-ios-app-store/)를 참고하세요.


## 로드맵
* 사용자들이 서비스를 더욱 쉽고 간단하게 배포할 수 있도록 개선.
* AI 도구를 활용해 서비스 관리와 최적화를 효과적으로 지원.
* WebAssembly(WASM)를 도입해 성능을 개선하고 로딩 속도를 향상.
* 모든 설정을 관리자 패널에서 직접 관리할 수 있도록 변경.


<!--
## 기여 가이드라인
향후 업데이트 될 예정입니다.
-->


## 버전 기록
다음 [페이지](https://github.com/mycalls/applimode/blob/main/CHANGELOG.md)를 방문하세요. 


## 감사의 말
어플리모드를 개발에 많은 도움을 준 다음 프로젝트에 특별히 감사드립니다.
* [CODE WITH ANDREA](https://codewithandrea.com/)
* [Riverpod](https://riverpod.dev/)
