<p align="center">
    <img src="https://github.com/mycalls/applimode-examples/blob/main/assets/am-campaign-head-v2.png?raw=true">
</p>


# Applimode

English | [한글](README.ko.md)

Applimode is an open-source project inspired by the following ideas:

* Anyone, even without development experience, should be able to easily create their own blog or community service.
* Starting a service should have no upfront costs, and scaling it should remain affordable.
* Services should run seamlessly across multiple platforms.

Built on Firebase and Flutter, Applimode works smoothly on Android, iOS, and Web (PWA).With Applimode, you can create your own blog or community service in just a few hours.

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
**Git** (only [Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-git)), **VSCode** · **Flutter SDK** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-vscode-and-the-flutter-sdk), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-vscode-and-the-flutter-sdk)), **Android Studio** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-android-studio), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-android-studio)), **Xcode** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-and-configure-xcode)), **Rosetta 2** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-rosetta-2)), **Homebrew** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-homebrew)), **rbenv** · **Ruby** · **CocoaPods** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-rbenv-ruby-and-cocoapods)), **Node.js** · **Firebase CLI** · **Flutterfire CLI** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-nodejs-and-the-firebase-cli-and-the-futterfire-cli), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-nodejs-and-the-firebase-cli-and-the-futterfire-cli))
* Visit the [Firebase console](https://console.firebase.google.com/), create a new project, and enable [Authentication](https://console.firebase.google.com/project/_/authentication), [Firestore Database](https://console.firebase.google.com/project/_/firestore), and [Storage](https://console.firebase.google.com/project/_/storage).
* Clone the Applimode repository and initialize it.
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
cp -r ./applimode/applimode-tool ./; node ./applimode-tool/index.js init; rm -r ./applimode-tool
```
* Open your initialized Applimode project in VS Code, and run the following commands.
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
> when asked something, press **n** or **N**.
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
> when asked something, press **n** or **N**.
-->
* If images are not displayed when building for the web (CORS issue), follow [this step](https://github.com/mycalls/applimode/blob/main/docs/macos.md#if-you-dont-see-images-or-videos-in-your-uploaded-post-follow-these-steps-cors-issue).

Additionally, you can set or configure the following:
* Build your Applimode app ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#build-your-applimode-app), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#build-your-applimode-app))
* Build and release a web app ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#build-and-release-a-web-app), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#build-and-release-a-web-app))
* Build an APK for Android ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#build-an-apk-for-android), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#build-an-apk-for-android))
* Change the images for the app icon and the launch screen ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-images-for-the-app-icon-and-the-launch-screen), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-images-for-the-app-icon-and-the-launch-screen))
* Add administrator ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#add-administrator), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#add-administrator))
* Admin settings and custom_settings.dart ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#admin-settings-and-custom_settingsdart), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#admin-settings-and-custom_settingsdart))
* Configure Cloudflare R2 (Optional) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-r2-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-r2-optional))
> [!NOTE]
> * Instead of Firebase Cloud Storage, you can set up Cloudflare R2 as your media file storage
> * The biggest advantage of R2 is that transfer fees are free. If you are building a video-centric app, I highly recommend using Cloudflare R2.
* Configure Cloudflare D1 (Optional) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-d1-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-d1-optional))
> [!NOTE]
> Applimode supports hashtag search by default. If you want to use full-text search, use Cloudflare D1.
* Configure Cloudflare CDN (Optional) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-cdn-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-cdn-optional))
* Configure Youtube image proxy (Optional) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-youtube-image-proxy-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-youtube-image-proxy-optional))
* Configure Youtube video proxy (Optional) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-youtube-video-proxy-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-youtube-video-proxy-optional))
* Use your custom domain (Optional) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#use-your-custom-domain-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#use-your-custom-domain-optional))
* Upgrade your project with the new Applimode version ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#upgrade-your-project-with-the-new-applimode-version), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#upgrade-your-project-with-the-new-applimode-version))
* Add phone sign-in ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#add-phone-sign-in), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#add-phone-sign-in))
* Set up the AI assistant (Gemini) ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#set-up-the-ai-assistant-google-gemini), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#set-up-the-ai-assistant-google-gemini))
* Configure push notification ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-push-notification), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-push-notification))
* Configure Cloud Firestore Security Rules ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloud-firestore-security-rules), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloud-firestore-security-rules))
* Configure writing access for admin users only ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-writing-access-for-admin-users-only), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-writing-access-for-admin-users-only))
* Change the app's main color ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-apps-main-color), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-apps-main-color))
* Change the app's name ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-apps-name), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-apps-name))
* Change the organization name for the app ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#change-the-organization-name-for-the-app), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#change-the-organization-name-for-the-app))
* Troubleshooting ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#troubleshooting), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#troubleshooting))


## Demo
* [Applimode Demo Web](https://applimode-demo.web.app/)
* [Applimode Dev Web](https://applimode-type-b.web.app/)


## Main Features
* 5 Design Styles
* Support for Android, iOS, and Web (PWA)
* User registration via email and phone number
* Markdown support for post creation
* Text, image, and video insertion support for post creation
* AI writing assistance (Google Gemini)
* Text and image insertion support for comment creation
* Like and dislike feature for posts and comments
* Hashtag-based search support
* Category setting support
* Daily, monthly, and yearly ranking of posts and comments
* Report features for posts and comments
* Administrator settings page and management mode support
* User and post blocking by administrators


## Considerations for Deployment and Release
#### Initial Deployment
* Start with **Web (PWA)** for your initial deployment.
* Web deployment involves no upfront costs and minimal maintenance expenses for small-scale operations.
* The process is straightforward, with no significant restrictions, making it easy to get started.
#### Releasing Mobile Apps
* As your user base grows, consider releasing your app on **Google Play** (Android) and **App Store** (iOS).
* Publishing on these platforms requires a paid membership for each.
#### Additional Information
* For detailed guidance on **Google Play** release, visit [here](https://codewithandrea.com/articles/how-to-release-flutter-google-play-store/).
* For detailed guidance on **App Store** release, visit [here](https://codewithandrea.com/articles/how-to-release-flutter-ios-app-store/).


## Roadmap
* Make it even easier and more straightforward for users to deploy their services.
* Enable AI tools to assist in managing and optimizing services effectively.
* Introduce WebAssembly (WASM) to improve performance and speed up page loading.
* Allow all settings to be managed directly through the admin panel for greater convenience and control.


<!--
## Contributing
The content of this section will be updated in the future.
-->


## Releases
Please see the [changelog](https://github.com/mycalls/applimode/blob/main/CHANGELOG.md) for more details about a given release.

## Acknowledgements
Special thanks to these amazing projects which help power Applimode:
* [CODE WITH ANDREA](https://codewithandrea.com/)
* [Riverpod](https://riverpod.dev/)
