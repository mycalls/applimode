<p align="center">
    <img src="https://github.com/mycalls/applimode-examples/blob/main/assets/am-campaign-head-v2.png?raw=true">
</p>


# Applimode
<!--
English | [한글](README_ko.md)
-->
Applimode is a powerful, next-generation solution for building apps and websites, designed to outperform traditional CMS platforms like WordPress. Built with Flutter, Applimode offers unmatched flexibility, enabling you to seamlessly create and deploy high-performance apps across Android, iOS, web, and PWA—all from a single codebase. Whether you're crafting a blog, a forum, or complex media-driven platforms, Applimode empowers even non-developers to build fully functional, modern applications and deploy them effortlessly to Google Firebase, all at minimal cost.

<p align="center">
    <img src="https://github.com/mycalls/applimode-examples/blob/main/assets/am-preview-480p-10f-240829.gif?raw=true" width="320">
</p>


## Configure your Applimode app
* [Configure Applimode for Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.md)
* [Configure Applimode for macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md)



## Overview of Configuration
> [!IMPORTANT]
> This guide is a summary. If you have any questions or encounter any problems during the process, please refer to this section ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md)).

* Download and install the following packages:
**Git** (only [Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-git)), **VSCode** · **Flutter SDK** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-vscode-and-the-flutter-sdk), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-vscode-and-the-flutter-sdk)), **Android Studio** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-android-studio), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-android-studio)), **Xcode** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-and-configure-xcode)), **Rosetta 2** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-rosetta-2)), **Homebrew** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-homebrew)), **rbenv** · **Ruby** · **CocoaPods** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-rbenv-ruby-and-cocoapods)), **Node.js** · **Firebase CLI** · **Flutterfire CLI** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-nodejs-and-the-firebase-cli-and-the-futterfire-cli), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-nodejs-and-the-firebase-cli-and-the-futterfire))
* Visit the [Firebase console](https://console.firebase.google.com/), create a new project, and enable [Authentication](https://console.firebase.google.com/project/_/authentication), [Firestore Database](https://console.firebase.google.com/project/_/firestore), and [Storage](https://console.firebase.google.com/project/_/storage).
* Clone the Applimode repository and initialize it.
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
cp -r ./applimode/applimode-tool ./; node ./applimode-tool/index.js init; rm -r ./applimode-tool
```
* Open your initialized Applimode project in VS Code, and run the following command.
```sh
flutter pub get; dart run build_runner build -d; flutterfire configure --platforms=android,ios,web; node ./applimode-tool/index.js firebaserc; firebase deploy --only firestore; firebase deploy --only storage;
```
> [!NOTE]
> when asked something, press **n** or **N**.
* If images are not displayed when building for the web (CORS issue), follow [this step](https://github.com/mycalls/applimode/blob/main/docs/macos.md#if-you-dont-see-images-or-videos-in-your-uploaded-post-follow-these-steps-cors-issue).

Additionally, you can set or configure the following:
* Change the images for the app icon and the launch screen ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-images-for-the-app-icon-and-the-launch-screen), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-images-for-the-app-icon-and-the-launch-screen))
* Change the app's main color ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-apps-main-color), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-apps-main-color))
* Add administrator ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#add-administrator), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#add-administrator))
* Admin settings and custom settings ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#admin-settings-and-custom-settings), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#admin-settings-and-custom-settings))
* Add phone sign-in ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#add-phone-sign-in-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#add-phone-sign-in-optional))
* Configure push notification ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-push-notification-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-push-notification-optional))
* Configure Cloudflare R2 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-r2-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-r2-optional))
> [!NOTE]
> * Instead of Firebase Cloud Storage, you can set up Cloudflare R2 as your media file storage
> * The biggest advantage of R2 is that transfer fees are free. If you are building a video-centric app, I highly recommend using Cloudflare R2.
* Configure Cloudflare D1 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-d1-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-d1-optional))
> [!NOTE]
> Applimode supports hashtag search by default. If you want to use full-text search, use Cloudflare D1.
* Configure Cloudflare CDN ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-cdn-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-cdn-optional))
* Configure Youtube image proxy ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-youtube-image-proxy-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-youtube-image-proxy-optional))
* Configure Youtube video proxy ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-youtube-video-proxy-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-youtube-video-proxy-optional))
* Use your custom domain ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#use-your-custom-domain-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#use-your-custom-domain-optional))
* Upgrade your project with the new Applimode version ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#upgrade-your-project-with-the-new-applimode-version), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#upgrade-your-project-with-the-new-applimode-version))
* Configure Cloud Firestore Security Rules ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloud-firestore-security-rules), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloud-firestore-security-rules))
* Configure writing access for admin users only ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-writing-access-for-admin-users-only), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-writing-access-for-admin-users-only))
* Change the app's name ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-apps-name), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-apps-name))
* Change the organization name for the app ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-organization-name-for-the-app), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-organization-name-for-the-app))
* Set up the AI assistant ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#set-up-the-ai-assistant-google-gemini), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#set-up-the-ai-assistant-google-gemini))
* Troubleshooting ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#troubleshooting), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#troubleshooting))


## Main Features
* 5 distinct bulletin board styles: list, box, rounded box, page, and mixed layout
* Multi-platform support: Android, iOS, Web, and PWA
* Versatile post types: text, images, videos
* Markdown support for posts
* AI-powered post creation
* Commenting options: text and images
* Like and dislike functionality
* Hashtags and search capability
* Categories and ranking system
* Extensive admin settings
* User blocking feature

## Demo
* [Applimode Demo Web](https://applimode-demo.web.app/)
* [Applimode Dev Web](https://applimode-type-b.web.app/)
<!--
* [Android]()
* iOS will be updated in the future.
-->

<!--
## FAQs
* 앱 스타일 변경 방법
* 링크형식의 이미지나 비디오 삽입 방법
* 비디오 썸네일 직접 지정하는 방법
* 박스 또는 페이지 스타일에서 제목, 저자 숨기는 방법
-->

## Deployment Recommendations
* It is recommended to first deploy as a web app (PWA) and expand to a native app (for Android and iOS) as the scale grows.
* Applimode's web and native apps share the same features.
* Native apps generally perform better than web apps.
* However, web apps are easier to deploy (including updates) and do not require paid developer memberships from Apple or Google.
* The performance of Flutter’s web apps is rapidly improving, and applying WebAssembly (WASM) can lead to a significant performance boost.

## Goals
> With Applimode, I want you to save your time and money.
* Build a community or blog service that supports web, iOS, and Android in just a few hours.
* Achieve zero initial cost and minimal maintenance costs.
* Make it easy to build, even for non-developers.
* Build and manage on your own server.

## Roadmap
The content of this section will be updated in the future.

## Contributing
The content of this section will be updated in the future.

## Releases
Please see the [changelog](https://github.com/mycalls/applimode/blob/main/CHANGELOG.md) for more details about a given release.

## Acknowledgements
Special thanks to these amazing projects which help power Applimode:
* [CODE WITH ANDREA](https://codewithandrea.com/)
* [Riverpod](https://riverpod.dev/)
