# macOS용 Applimode 구성하기

[English](./macos.md) | 한글

> [!IMPORTANT]
> * 이 가이드는 초보자를 위해 자세히 작성되었습니다. 불필요한 부분은 건너뛰세요.
> * 이 가이드는 Apple Silicon에서 실행되는 macOS용으로 작성되었습니다.
> * Flutter는 macOS 10.15 (Catalina) 이상을 지원합니다.
> * 이 가이드는 Mac에서 zsh를 기본 셸로 실행한다고 가정합니다.

## 목차
* [Xcode 설치 및 구성](#xcode-설치-및-구성)
* [Rosetta 2 설치](#rosetta-2-설치)
* [VSCode 및 Flutter SDK 설치](#vscode-및-flutter-sdk-설치)
* [Android Studio 설치](#android-studio-설치)
* [Homebrew 설치](#homebrew-설치)
* [rbenv, Ruby 및 CocoaPods 설치](#rbenv-ruby-및-cocoapods-설치)
* [Firebase 구성](#firebase-구성)
* [Node.js, Firebase CLI 및 Futterfire 설치](#nodejs-firebase-cli-및-futterfire-cli-설치)
* [프로젝트 구성](#프로젝트-구성)
* [Applimode 앱 빌드](#applimode-앱-빌드)
* [웹 앱 빌드 및 배포](#웹-앱-빌드-및-배포)
* [Android용 APK 빌드](#android용-apk-빌드)
* [앱 아이콘 및 시작 화면 이미지 변경](#앱-아이콘-및-시작-화면-이미지-변경)
* [관리자 추가](#관리자-추가)
* [관리자 설정 및 custom_settings.dart](#관리자-설정-및-custom_settingsdart)
* [Cloudflare R2 구성 (선택 사항)](#cloudflare-r2-구성-선택-사항)
* [Cloudflare D1 구성 (선택 사항)](#cloudflare-d1-구성-선택-사항)
* [Cloudflare CDN 구성 (선택 사항)](#cloudflare-cdn-구성-선택-사항)
* [Youtube 이미지 프록시 구성 (선택 사항)](#youtube-이미지-프록시-구성-선택-사항)
* [Youtube 비디오 프록시 구성 (선택 사항)](#youtube-비디오-프록시-구성-선택-사항)
* [사용자 정의 도메인 사용 (선택 사항)](#사용자-정의-도메인-사용-선택-사항)
* [새 Applimode 버전으로 프로젝트 업그레이드](#새-applimode-버전으로-프로젝트-업그레이드)
* [전화번호 로그인 추가](#전화번호-로그인-추가)
* [AI 어시스턴트 설정 (Gemini)](#ai-어시스턴트-설정-google-gemini)
* [푸시 알림 구성](#푸시-알림-구성)
* [Cloud Firestore 보안 규칙 구성](#cloud-firestore-보안-규칙-구성)
* [관리자만 글쓰기 허용으로 설정 변경](#관리자만-글쓰기-허용으로-설정-변경)
* [앱의 기본 색상 변경](#앱의-기본-색상-변경)
* [앱 이름 변경](#앱-이름-변경)
* [앱의 조직 이름 변경](#앱의-조직-이름-변경)
* [문제 해결](#문제-해결)

<!--
## Git 설치
* [Git](https://git-scm.com/download/mac)을 다운로드하고 설치합니다.
* ```Cmd``` + ```SpaceBar```를 누르고 **Terminal**을 입력하고 클릭합니다.
* 다음 명령을 실행합니다.
```sh
git --version
```
* **Terminal**을 닫습니다.
-->



## Xcode 설치 및 구성
* [Xcode](https://developer.apple.com/xcode/)를 다운로드, 설치 및 실행합니다.
<!--열기 팝업이 추가된 링크-->
<!--https://apps.apple.com/us/app/xcode/id497799835-->
* **Select the platforms** 상자에서 iOS가 선택되지 않은 경우 선택하고 **Install** 또는 **Download & Installl**을 클릭합니다.
* 다운로드가 완료되면 **Xcode**를 닫습니다.
<!--
* 메뉴 막대에서 Spotlight 아이콘을 클릭합니다. (또는 ```Command``` + ```Space Bar```를 누릅니다.)
* 검색 필드에 *terminal*을 입력하고 선택합니다.
* 다음 명령을 실행합니다.
```sh
sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
```
```sh
sudo xcodebuild -license
```
* *agree*를 입력합니다.
-->
<!--
```xcode-select --install```이라는 명령어를 사용하라는 경우도 있다.
하지만 xcode commandline toos는 xcode가 설치될 때, 같이 설치됨으로 위치만 지정해 주는 것이 맞는 듯 하다.
-->



## Rosetta 2 설치
<!--
* 메뉴 막대에서 Spotlight 아이콘을 클릭합니다. (또는 ```Command``` + ```Space Bar```를 누릅니다.)
* 검색 필드에 *terminal*을 입력하고 선택합니다.
-->
* 메뉴 막대에서 Spotlight 아이콘을 클릭합니다. (또는 ```Command``` + ```Space Bar```를 누릅니다.)
* 검색 필드에 *terminal* 또는 *터미널*을 입력하고 선택합니다.
* 터미널의 명령 프롬프트에서 다음 명령을 실행합니다.
```sh
sudo softwareupdate --install-rosetta --agree-to-license
```

## VSCode 및 Flutter SDK 설치
* [VSCode](https://code.visualstudio.com/)를 다운로드, 설치 및 실행합니다.
<!--* Command Palette를 열려면 ```Command``` + ```Shift``` + ```P```를 누릅니다. (또는 **View** > **Command Palette** 선택)
* *shell*을 입력하고 **Shell Command: Install 'code' command in PATH**를 선택합니다.-->
* ```Command``` + ```Shift``` + ```X```를 누릅니다. (또는 **View** > **Extensions** 선택)
* *flutter*를 입력하고 **Install**을 클릭합니다.
* Command Palette를 열려면 ```Command``` + ```Shift``` + ```P```를 누릅니다. (또는 **View** > **Command Palette** 선택)
* **Command Palette**에서 *flutter*를 입력합니다.
* **Flutter: New Project**를 선택합니다.
* 오른쪽 하단에서 **Download SDK**를 클릭합니다.
* 폴더를 만들고 (File > New Folder 선택 또는 ```Command``` + ```Shift``` + ```N``` 누르기) 이름을 *development*로 지정합니다.
* **Clone Flutter**를 클릭합니다.
* 완료되면 Flutter SDK가 ~/development/flutter 디렉토리에 있어야 합니다.
* **Terminal**을 열거나 이동합니다.
* Flutter를 PATH 환경 변수에 추가하려면 다음 명령을 실행합니다.
```sh
nano ~/.zshenv
```
> [!NOTE]
> 원하는 텍스트 편집기를 사용하십시오.
* 다음 줄을 복사하여 ~/.zshenv 파일 끝에 붙여넣습니다.
```sh
export PATH=$HOME/development/flutter/bin:$PATH
```
* ~/.zshenv 파일을 저장하려면 ```control``` + ```O```를 누른 다음 **Enter**를 누르고 마지막으로 ```control``` + ```X```를 누릅니다.
<!--
* 이 변경 사항을 적용하려면 열려 있는 모든 Terminal 세션을 다시 시작하십시오.
-->
* 다음 명령을 실행합니다.
```sh
source ~/.zshenv
```
<!--
```sh
flutter doctor
```
-->
* **VSCode**를 닫습니다.

<!--
## Flutter 다운로드 및 설치
* 이 [페이지](https://docs.flutter.dev/get-started/install/macos/mobile-ios)를 열고 아래로 스크롤합니다.
* **Install the Flutter SDK** 섹션에서 **Download and install**을 클릭합니다.
* **flutter_macos_arm64_x.xx.x-stable.zip**을 클릭합니다.
* **Terminal**을 열거나 이동합니다.
* 다음 명령을 실행합니다.
> [!CAUTION]
> 명령에서 **x.xx.x**를 파일의 현재 버전으로 변경하십시오.
```sh
unzip ~/Downloads/flutter_macos_arm64_x.xx.x-stable.zip \
       -d ~/development/
```
* 완료되면 Flutter SDK가 ~/development/flutter 디렉토리에 있어야 합니다.
* Flutter를 PATH 환경 변수에 추가하려면 다음 명령을 실행합니다.
```sh
nano ~/.zshenv
```
> [!NOTE]
> 원하는 텍스트 편집기를 사용하십시오.
* 다음 줄을 복사하여 ~/.zshenv 파일 끝에 붙여넣습니다.
```sh
export PATH=$HOME/development/flutter/bin:$PATH
```
* ~/.zshenv 파일을 저장하려면 ```control``` + ```O```를 누른 다음 **Enter**를 누르고 마지막으로 ```control``` + ```X```를 누릅니다.
* 이 변경 사항을 적용하려면 열려 있는 모든 Terminal 세션을 다시 시작하십시오.
* 다음 명령을 실행합니다.
```sh
flutter doctor
```
-->



## Android Studio 설치
* [Android Studio](https://developer.android.com/studio)를 다운로드, 설치 및 실행합니다.
* 왼쪽 사이드바에서 **Pulgins**를 클릭하고 *flutter*를 입력하고 **Install**을 클릭한 다음 **Restart IDE**를 클릭합니다.
* 왼쪽 사이드바에서 **Projects**를 클릭하고 중앙에서 **More Actions**를 클릭한 다음 **SDK Manager**를 클릭합니다.
* 상단 메뉴에서 **SDK Tools**를 클릭합니다.
* **Android SDK Command-line Tools**를 선택하고 오른쪽 하단의 **Apply**를 클릭합니다.
* **Terminal**을 열거나 이동합니다.
* 다음 명령을 실행하고 모든 질문에 ```y```를 누릅니다.
```sh
flutter doctor --android-licenses
```
<!--
```sh
flutter doctor
```
-->
* **Android Studio**와 **Terminal**을 닫습니다.



## Homebrew 설치
* **Terminal**을 열거나 이동합니다.
* 다음 명령을 실행합니다.
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
> 자세한 내용은 [이 페이지](https://brew.sh/)를 참조하십시오.
* 명령을 실행한 후 출력된 내용에 따라 두 명령을 실행합니다.
```sh
===> Next steps:
- Run these two commands in your terminal to add Homebrew to your PATH:
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/<USERNAME>/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
```
<!--
```sh
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/<USERNAME>/.zprofile
```
```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```
```sh
brew doctor
```
-->
* **Terminal**을 닫습니다.



## rbenv, Ruby 및 CocoaPods 설치
* **Terminal**을 열거나 이동합니다.
* 다음 명령을 실행합니다.
```sh
brew install rbenv
```
* **rbenv**를 PATH 환경 변수에 추가하기 위해 다음 명령을 실행합니다.
```sh
nano ~/.zshrc
```
* 다음 줄을 복사하여 ~/.zshrc 파일 끝에 붙여넣습니다.
```sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
```
* ~/.zshrc 파일을 저장하려면 ```control``` + ```O```를 누른 다음 **Enter**를 누르고 마지막으로 ```control``` + ```X```를 누릅니다.
* **Terminal**을 닫고 다시 엽니다.
<!--
```sh
source ~/.zshrc
```
-->
* 다음 명령을 실행합니다.
<!--
```sh
rbenv install -l
```
-->
```sh
rbenv install 3.2.3
```
```sh
rbenv global 3.2.3
```
```sh
source ~/.zshrc
```
```sh
sudo gem install cocoapods
```
```sh
sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
```
```sh
sudo xcodebuild -license
```
* *agree*를 입력합니다.
<!--
```sh
sudo gem update --system x.x.x
```
-->
<!--flutter 공식문서만 패스 추가할 것을 권장함.-->
```sh
nano ~/.zshrc
```
* 다음 줄을 복사하여 ~/.zshrc 파일 끝에 붙여넣습니다.
```sh
export PATH=$HOME/.gem/bin:$PATH
```
* ~/.zshrc 파일을 저장하려면 ```control``` + ```O```를 누른 다음 **Enter**를 누르고 마지막으로 ```control``` + ```X```를 누릅니다.
* **Terminal**을 닫습니다.
<!--
```sh
source ~/.zshrc
```
```sh
ruby -v
```
-->



## Firebase 구성
* [Firebase](https://firebase.google.com)에 가입하거나 로그인합니다.
* [Go to console](https://console.firebase.google.com)을 클릭합니다.
* **프로젝트 만들기**를 클릭합니다.
* 프로젝트 이름을 입력하고 **계속**를 클릭합니다.
* **Firebase의 Gemini 사용 설정**을 활성화하고 **계속**을 클릭합니다.
* **이 프로젝트에서 Google 애널리틱스 사용 설정**을 활성화하고 **계속**을 클릭합니다.
* Google Analytics 계정을 선택하거나 **Default Account for Firebase**를 선택합니다. **프로젝트 만들기**를 클릭합니다.
<!--* **Google Analytics**를 비활성화하고 **Create project**를 클릭합니다. (이 설정은 나중에 변경할 수 있습니다.)-->
* **Firebase 프로젝트가 준비되었습니다**라는 문구가 표시되면 하단의 **계속**을 클릭합니다.
* 왼쪽 사이드바 하단에서 **업그레이드**를 클릭합니다.
* **요금제 선택**을 클릭하여 Blaze 요금제를 선택합니다.
* **Cloud Billing 계정 선택**에서 결제 계정을 선택한 후, 결제 예산 금액을 입력하고, **계속**을 클릭하세요.
* **Cloud Billing 계정 연결**을 클릭하고, **완료**를 클릭합니다.
> [!NOTE]
> Cloud Storage, Cloud Functions (푸시 알림), Vertex AI (Gemini AI)와 같은 파이어베이스의 전체 서비스를 사용하려면 기본 **Spark plan** (무료 플랜)을 **Blaze plan** (월별 청구 유료 플랜)으로 **업그레이드**해야 합니다. 유료 플랜은 월별 무료 할당량이 모두 소진된 후의 사용량에만 월별로 요금을 청구합니다. 또한 [예산 알림 설정](https://firebase.google.com/docs/projects/billing/avoid-surprise-bills#set-up-budget-alert-emails)을 통해 매월 지정된 한도 금액을 초과할 경우 알림을 받을 수도 있습니다. 두 요금제를 비교하려면 [Firebase 공식 가격 페이지](https://firebase.google.com/pricing)를 참조하세요.
* 왼쪽 사이드바에서 **빌드**를 클릭하고 **Authentication**을 클릭합니다.
* **시작하기**를 클릭한 다음 **이메일/비밀번호**를 클릭합니다.
* **이메일/비밀번호**를 활성화하고 **저장**을 클릭합니다.
* 왼쪽 사이드바에서 **빌드**를 클릭한 다음 **Firestore Database**를 클릭합니다.
* **데이터베이스 만들기**를 클릭하고 데이터베이스 위치를 선택합니다.
* **다음**을 클릭한 다음 **만들기**를 클릭합니다.
* 왼쪽 사이드바에서 **Build**를 클릭한 다음 **Storage**를 클릭합니다.
* **시작하기**를 클릭한 다음, 스토리지 위치를 선택한 후, **계속**을 클릭하고 마지막으로 **만들기**를 클릭합니다.
<!--todos
Build with Gemini 따로 설정. flutterfire 후에 설정해야 함
* 왼쪽 사이드바에서 **Build with Gemini**를 클릭합니다.
* **Vertex AI in Firebase** 카드에서 **Get started**를 클릭합니다.
* **Enable APIs**를 클릭한 다음 **Continue**를 클릭합니다.
> Enable APIs, the Fultter icon, the close icon in new window, Continue
-->



## Node.js, Firebase CLI 및 Futterfire CLI 설치
* **Terminal**을 열거나 이동합니다.
* 다음 명령을 실행합니다.
```sh
brew install nvm
```
<!--
~/.nvm 있는지 확인할 것.
어떤 문서는 디렉토리를 따로 만들어야 한다고 쓰여 있음.
nvm 설치 후 확인해 볼것
```sh
mkdir ~/.nvm
```
-->
```sh
nano ~/.zshrc
```
* 다음 줄을 복사하여 ~/.zshrc 파일 끝에 붙여넣습니다.
```sh
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
```
* ~/.zshrc 파일을 저장하려면 ```control``` + ```O```를 누른 다음 **Enter**를 누르고 마지막으로 ```control``` + ```X```를 누릅니다.
* 다음 명령을 실행합니다.
```sh
source ~/.zshrc
```
<!--
```sh
nvm -v
```
-->
```sh
nvm install --lts
```
<!--
```sh
여러개 설치되있을 경우 원하는 버전 사용하기
nvm use --lts
node -v
npm -v
```
-->
```sh
npm install -g firebase-tools
```
* **Terminal**을 닫았다가 다시 엽니다.
* 다음 명령을 실행합니다.
```sh
firebase login
```
```sh
dart pub global activate flutterfire_cli
```
```sh
nano ~/.zshrc
```
* 다음 줄을 복사하여 ~/.zshrc 파일 끝에 붙여넣습니다.
```sh
export PATH="$PATH":"$HOME/.pub-cache/bin"
```
* ~/.zshrc 파일을 저장하려면 ```control``` + ```O```를 누른 다음 **Enter**를 누르고 마지막으로 ```control``` + ```X```를 누릅니다.
* 다음 명령을 실행합니다.
```sh
source ~/.zshrc
```



## 프로젝트 구성
* **Terminal**을 열거나 이동합니다.
* 다음 명령을 실행합니다.
```sh
mkdir ~/projects; cd ~/projects;
```
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
cp -r ./applimode/applimode-tool ./; node ./applimode-tool/index.js init; rm -r ./applimode-tool
```
* 프로젝트 이름, 긴 앱 이름, 짧은 앱 이름 및 조직 이름을 입력합니다.
> [!NOTE]
> * 프로젝트 이름은 사용자의 어플리모드 프로젝트 폴더 이름과 앱의 번들 ID (웹, Android, iOS)를 만드는 데 사용됩니다.
> * 긴 앱 이름은 주로 웹 앱에 사용됩니다.
> * 짧은 앱 이름은 주로 모바일 앱 (iOS, Android)에 사용됩니다.
> * 조직 이름은 프로젝트 이름과 함께 App Store 및 Play Store에서 사용할 각 번들 ID를 만드는 데 사용됩니다. 번들 ID는 고유해야 하므로 신중하게 결정하십시오.
* **Terminal**을 닫습니다.
* **VSCode**를 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택하고 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 순서대로 실행합니다.
```sh
flutter pub get
```
```sh
dart run build_runner build -d
```
```sh
flutterfire configure --platforms=android,ios,web
```
> * 질문이 나오면 **n** 또는 **N**을 누르십시오.
> * 만약 해당 명령 결과로 에러가 발생한다면 다음 명령어를 실행시킨 후 다시 실행하세요.
> ```sh
> dart pub global activate flutterfire_cli
> ```
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
> [!NOTE]
> * 명령을 한 번에 모두 입력하려면 다음 명령을 실행하십시오.
> ```sh
> flutter pub get; dart run build_runner build -d; flutterfire configure --platforms=android,ios,web; node ./applimode-tool/index.js firebaserc; firebase deploy --only firestore; firebase deploy --only storage;
> ```
-->
* 웹 브라우저에서 [Google Cloud console](https://console.cloud.google.com/)을 엽니다.
* 가입하거나 로그인합니다.
* 왼쪽 상단에서 사용자의 어플리모드 프로젝트를 선택합니다.
* 오른쪽 상단의 **Cloud Shell 활성화** 버튼을 클릭합니다.
![gcp-console-head](https://github.com/mycalls/applimode-examples/blob/main/assets/gcp-console-head.png?raw=true)
* 하단의 셸에서 다음 명령을 실행합니다.
```sh
echo '[{"origin": ["*"],"method": ["GET"],"maxAgeSeconds": 3600}]' > cors.json
```
<!--
> touch cors.json
> nano cors.json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
-->
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Storage** (왼쪽 사이드바)를 클릭합니다.
* **gs://**로 시작하는 URL 왼쪽의 **폴더 경로 복사** 아이콘을 클릭하여 클라우드 스토리지 버킷의 경로를 복사합니다.
![fb-storage-head](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-storage-head.png?raw=true)
* Google Cloud console로 돌아갑니다.
* 하단의 셸에서 다음 명령을 실행합니다.
```sh
gsutil cors set cors.json gs://<your-cloud-storage-bucket>
```
```sh
exit
```



## Applimode 앱 빌드
> [!IMPORTANT]
> Firestore 인덱싱이 완료된 후 이 장을 수행하십시오. (약 5분 소요) Firestore 인덱싱은 여기에서 확인할 수 있습니다. [Firebase console](https://console.firebase.google.com/) > 프로젝트 > Firestore Database > Indexes

#### 웹 또는 Android
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
![vscode-run](https://github.com/mycalls/applimode-examples/blob/main/assets/vscode-run.png?raw=true)
* 오른쪽 하단의 Select Device 섹션을 클릭합니다. (또는 ```Command``` + ```Shift``` + ```P```를 누른 다음 *flutter*를 입력하고 **Flutter: Select Device**를 선택합니다.)
<!--
* **View** (VSCode 상단 메뉴)를 클릭하고 **Command Palette**를 선택합니다. (또는 ```Command``` + ```Shift``` + ```P```를 누릅니다.)
* *flutter*를 입력하고 **Flutter: Select Device**를 선택합니다.
-->
* Select Device 프롬프트에서 대상 장치를 선택합니다.
* ```Command``` + ```Shift``` + ```D```를 누릅니다. (또는 왼쪽 메뉴에서 **Run and Debug** 버튼을 클릭합니다.)
* 왼쪽 상단의 **Select Debug Mode** 버튼을 클릭하고 **Run (release mode)**을 선택합니다.
<!--
> [!NOTE]
> **custom_settings.dart** 파일에서 설정을 변경하고 Applimode 앱에서 어떻게 적용되는지 확인하려면 **Select Device** 섹션에서 Chrome을 선택하고 **Select Debug Mode** 섹션에서 **Run (debug mode)**을 선택합니다. **custom_settings.dart** 파일에서 값을 수정한 후 ```Command``` + ```S```를 눌러 적용된 변경 사항을 볼 수 있습니다.
-->
* 왼쪽 상단의 **Start Debugging** 버튼을 클릭합니다. (또는 ```F5``` 또는 ```Fn``` + ```F5```를 누릅니다.)
<!--
* **Run** (VSCode 상단 메뉴)을 클릭하고 **Start Debugging**을 선택합니다. (또는 ```F5``` 또는 ```fn``` + ```F5```를 누릅니다.)
-->
> [!NOTE]
> * 웹 앱의 경우 Chrome 또는 Edge를 선택합니다.
> * Android 기기에서 개발자 옵션 및 USB 디버깅을 활성화하려면 [이 페이지](https://developer.android.com/studio/debug/dev-options)를 참조하십시오.
> * Android 기기를 연결했지만 장치 목록에 나타나지 않으면 USB 설정을 충전 또는 파일 전송으로 변경해 보십시오.
<!-- * 설정을 활성화하려면 설정 > 휴대전화 정보 > 소프트웨어 정보 (없을 수 있음) > 빌드 번호로 이동하여 7번 연속으로 클릭합니다. 이전 화면으로 돌아가 하단에서 개발자 옵션을 찾습니다. 그런 다음 USB 디버깅을 켭니다.-->

#### iOS
* [Apple Developer program](https://developer.apple.com/programs/)에 아직 등록하지 않은 경우 지금 등록하십시오.

> 멤버십 유형에 대한 자세한 내용은 [멤버십 선택](https://developer.apple.com/support/compare-memberships)을 확인하십시오.

* iOS 기기에서 **설정** > **개인 정보 보호 및 보안** > **개발자 모드**를 탭합니다.
* **개발자 모드**를 켜짐으로 전환하려면 탭합니다.
* **재시동**을 탭합니다.
* **개발자 모드를 켜시겠습니까?** 대화 상자가 나타나면 **켜기**를 탭합니다.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* iOS 기기를 Mac의 USB 포트에 연결합니다.
![vscode-run](https://github.com/mycalls/applimode-examples/blob/main/assets/vscode-run.png?raw=true)
* 오른쪽 하단의 Select Device 섹션을 클릭합니다. (또는 ```Command``` + ```Shift``` + ```P```를 누른 다음 *flutter*를 입력하고 **Flutter: Select Device**를 선택합니다.)
<!--
* **View** (VSCode 상단 메뉴)를 클릭하고 **Command Palette**를 선택합니다. (또는 ```Command``` + ```Shift``` + ```P```를 누릅니다.)
* *flutter*를 입력하고 **Flutter: Select Device**를 선택합니다.
-->
* **Select Device** 프롬프트에서 iOS 기기를 선택합니다.
* ```Command``` + ```Shift``` + ```D```를 누릅니다. (또는 왼쪽 메뉴에서 **Run and Debug** 버튼을 클릭합니다.)
* 왼쪽 상단의 **Select Debug Mode** 버튼을 클릭하고 **Run (release mode)**을 선택합니다.
* 하단의 내장 터미널을 클릭합니다. (또는 **View** > **Terminal** 선택)
* 다음 명령을 실행합니다.
```sh
open ios/Runner.xcworkspace
```
* 사용자의 어플리모드 프로젝트가 Xcode에서 열립니다.
![xcode-overall](https://github.com/mycalls/applimode-examples/blob/main/assets/xcode-run.png?raw=true)
* **Select Device** 패널에서 iOS 기기를 선택합니다.
* **Targets** 아래의 왼쪽 탐색 패널에서 **Runner**를 선택합니다.
* **Runner settings** 창에서 **Signing & Capabilities**를 클릭합니다.
* 상단에서 **All**을 선택합니다.
* **Automatically manage signing**을 선택합니다.
* **Team** 드롭다운 메뉴에서 팀을 선택합니다.
* **Xcode**의 진행률 창에 활동이 없으면 **Xcode**를 닫습니다.
> [!NOTE]
> * 팀은 Apple Developer Account 페이지의 App Store Connect 섹션에서 생성됩니다. 팀을 생성하지 않은 경우 개인 팀을 선택할 수 있습니다.
> * Team 드롭다운에는 해당 옵션이 Your Name (Personal Team)으로 표시됩니다.
* **VSCode**로 돌아갑니다.
* 왼쪽 상단의 **Start Debugging** 버튼을 클릭합니다. (또는 ```F5``` 또는 ```Fn``` + ```F5```를 누릅니다.)
* VSCode 빌드가 실패합니다.
* 하단의 내장 터미널을 클릭합니다. (또는 **View** > **Terminal** 선택)
* 다음 명령을 실행합니다.
<!--
```sh
flutter pub cache clean
```
-->
```sh
flutter clean
```
```sh
flutter pub get
```
```sh
cd ios
```
<!--
```sh
rm -rf build
```
-->
```sh
rm -rf Pods
```
```sh
rm -rf Podfile.lock
```
```sh
pod install --repo-update
```
```sh
cd ..
```
```sh
open ios/Runner.xcworkspace
```
<!--
```sh
flutter clean; flutter pub get; cd ios; rm -rf Pods; rm -rf Podfile.lock; pod install --repo-update; cd ..; open ios/Runner.xcworkspace;
```
-->
* 사용자의 어플리모드 프로젝트가 Xcode에서 열립니다.
![xcode-overall](https://github.com/mycalls/applimode-examples/blob/main/assets/xcode-run.png?raw=true)
* **Select Device** 패널에서 iOS 기기를 선택합니다.
* **Targets** 아래의 왼쪽 탐색 패널에서 **Runner**를 선택합니다.
* **Product** (Xcode 상단 메뉴)를 클릭한 다음 **Scheme**을 클릭하고 마지막으로 **Edit Scheme**을 클릭합니다.
* 왼쪽 패널에서 **Run**을 클릭합니다.
* **Info** 탭의 **Build Configuration** 드롭다운 메뉴에서 **Release**를 선택합니다.
* **Xcode**의 진행률 창에 활동이 없으면 **Product** (Xcode 상단 메뉴)를 클릭한 다음 **Clean Build Folder**를 클릭합니다.
* 왼쪽 상단의 재생 아이콘 버튼을 클릭합니다. (또는 ```Command``` + ```R``` 누르기)
> [!NOTE]
> * iOS 기기에서 **신뢰할 수 없는 개발자** 오류 메시지가 표시되면 다음 단계를 따르십시오.
> 1. iOS 기기에서 **설정**을 엽니다.
> 2. **일반** > **VPN 및 기기 관리**를 선택합니다.
> 3. 영향을 받는 프로필을 선택하고 신뢰합니다.

> [!NOTE]
> * mac에서 **iproxy** 오류 메시지가 표시되면 다음 단계를 따르십시오.
> 1. mac에서 **시스템 설정**을 엽니다.
> 2. **개인 정보 보호 및 보안** > **VPN 및 기기 관리**를 선택합니다.
> 3. 아래로 스크롤하여 **무시하고 허용**을 클릭합니다.

> [!NOTE]
> **Xcode**에서 **Applimode** 앱을 빌드하지 못하면 [이 단계](#추가로-ios-기기에서-빌드하는-동안-오류가-발생하는-경우-아래-단계를-따르십시오)를 따르십시오.
* 앱 빌드가 완료된 후 [이 장](#앱-빌드가-완료된-후)을 따르십시오.

#### 앱 빌드가 완료된 후
* 앱 빌드가 완료되면 오른쪽 하단의 쓰기 버튼을 클릭합니다.
* 로그인 화면에서 **등록**를 클릭하고 가입을 완료합니다.
* 쓰기 버튼을 클릭하고 첫 번째 게시물을 작성합니다. (Cloudflare R2 또는 CDN을 테스트하는 경우 이미지 또는 비디오와 함께 게시물을 작성하십시오.)
* 테스트 드라이브를 종료하려면 **Run** (VSCode 상단 메뉴)을 클릭하고 **Stop Debugging**을 선택합니다. (또는 ```Shift``` + ```F5``` 또는 ```Shift``` + ```fn``` + ```F5```를 누릅니다.)
<!--
> * 디버깅 모드에서는 대부분의 앱 성능이 매우 느려집니다. 릴리스 모드의 Applimode는 매우 빠르기 때문에 성능에 대해 걱정하지 마십시오.
-->



## 웹 앱 빌드 및 배포
> [!IMPORTANT]
> 앱의 관리자 설정 페이지에서 설정을 변경한 경우를 제외하고, 앱의 설정이나 구성을 변경했을 때는 다음 챕터에 따라 앱을 다시 빌드하고 배포하세요.
<!--
// build/web
> firebase init
> flutter build web --release
> flutter build web --release --web-renderer=html
> flutter build web --release --web-renderer=canvaskit
> firebase deploy
> firebase deploy --only hosting
-->
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
<!--
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* 사용자의 어플리모드 프로젝트 폴더를 선택하고 **Open**을 클릭합니다.
-->
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
flutter build web --release
```
```sh
firebase deploy --only hosting
```
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Hosting** (왼쪽 사이드바)을 클릭합니다.
* 아래로 스크롤하여 **도메인** 섹션을 찾습니다.
* 도메인 주소를 클릭합니다.
* 사용자 정의 도메인을 사용하려면 [이 장](#사용자-정의-도메인-사용-선택-사항)을 읽으십시오.
* 휴대폰 및 컴퓨터에 PWA (Progressive Web App)를 설치하는 방법은 [이 페이지](https://github.com/mycalls/applimode/blob/main/docs/pwa.ko.md)를 방문하십시오.



## Android용 APK 빌드
> [!IMPORTANT]
> 앱의 관리자 설정 페이지에서 설정을 변경한 경우를 제외하고, 앱의 설정이나 구성을 변경했을 때는 다음 챕터에 따라 앱을 다시 빌드하고 배포하세요.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
<!--
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* 사용자의 어플리모드 프로젝트 폴더를 선택하고 **Open**을 클릭합니다.
-->
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
flutter build apk --release --target-platform=android-arm64
```
* apk 파일은 **\<your-project-folder\>\build\app\outputs\apk\release** 또는 **\<your-project-folder\>\build\app\outputs\flutter-apk\app-release.apk**에서 찾을 수 있습니다.
> 자세한 내용은 [이 링크](https://docs.flutter.dev/deployment/android#build-the-app-for-release)를 방문하십시오.



## 앱 아이콘 및 시작 화면 이미지 변경
* 프로젝트의 앱 아이콘과 시작 화면 이미지를 준비한 경우 아래 단계를 따르십시오. 아직 없는 경우 이 단계를 건너뛰고 나중에 설정할 수 있습니다.
<!--Todos 피그마 공유 템플릿 파일 만들고 링크 제공할 것-->
> [!NOTE]
> * [다음 링크](https://www.figma.com/design/mm8b6pe8GFmyz9ZUKenveu/applimode-icons?t=UMJbxaifsW2ssi6e-1)에서 제공된 Figma 템플릿을 사용하거나 선호하는 도구로 아래 나열된 크기를 참조하여 아이콘을 만드십시오.
> * app-bar-logo.png - 128 * 128 (약 4px 여백, 배경 없음)
> * app-icon-512.png - 512 * 512 (1024px 이미지 사용)
> * app-icon-1024.png - 1024 * 1024 (약 160px 여백)
> * app-logo-android12.png - 960 * 960 (약 240px 여백, 배경 없음)
> * app-logo.png - 720 * 720 (약 8px 여백, 배경 없음)
* ```Cmd``` + ```SpaceBar```를 누르고 사용자의 어플리모드 프로젝트 이름을 입력합니다. (또는 **Finder** 열기)
* 사용자의 어플리모드 프로젝트 폴더 (아마도 projects 폴더에 있음)를 열고 **assets** 폴더를 연 다음 **images** 폴더를 엽니다.
* 폴더의 이미지 파일을 준비한 이미지 파일로 바꿉니다.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* 다음 명령을 순서대로 실행합니다.
```sh
dart run flutter_native_splash:create
```
```sh
flutter pub run flutter_launcher_icons
```
```sh
node ./applimode-tool/index.js splash
```



## 관리자 추가
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Authentication** (왼쪽 사이드바)을 클릭합니다.
* **사용자 UID** 옆에 있는 **UID 복사** 버튼을 클릭합니다. (버튼을 표시하려면 **사용자 UID** 위에 마우스 커서를 이동하십시오.)
![fb-auth-head](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-auth-head.png?raw=true)
* **Firestore Database** (왼쪽 사이드바)를 클릭합니다.
* users 컬렉션을 클릭하고 uid를 선택합니다.
* **isAdmin** 필드 옆에 있는 **Edit field** 버튼 (연필 모양)을 클릭합니다. (**Edid field** 버튼을 표시하려면 **isAdmin** 필드 위에 마우스 커서를 이동하십시오.)
![fb-firestore-isadmin](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-firestore-isadmin.png?raw=true)
* 값을 **false**에서 **true**로 변경하고 **Update**를 클릭합니다.
<!--
* **Rules** (상단 메뉴)를 클릭합니다.
* 8행 (또는 그 근처)의 첫 번째 단어 **adminUid**를 uid로 변경합니다. (uid 붙여넣기)
> ex) return request.auth.uid in ["9a6sIEiAldOzFIZ9hO2SxaG6Db63", "adminUid"];
![fb-firestore-rules](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-firestore-rules.png?raw=true)
* **Publish**를 클릭합니다.
-->
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js admin
```
* 복사한 uid를 붙여넣습니다.
* 다음 명령을 실행합니다.
```sh
firebase deploy --only firestore
```

> [!NOTE]
> * 다음 단계를 통해 인증된 사용자만 서비스를 이용할 수 있도록 변경할 수 있습니다.
> * 우선, [다음 챕터](#cloud-firestore-보안-규칙-구성)를 따라 Firestore 보안 규칙을 변경하세요.
> * 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
> * 프로젝트를 클릭합니다.
> * **Firestore Database** (왼쪽 사이드바)를 클릭합니다.
> * users 컬렉션을 클릭하고 uid를 선택합니다.
> * **verified** 필드 옆에 있는 **Edit field** 버튼 (연필 모양)을 클릭합니다. (**Edid field** 버튼을 표시하려면 **verified** 필드 위에 마우스 커서를 이동하십시오.)
> * 값을 **false**에서 **true**로 변경하고 **Update**를 클릭합니다.
> * **uid** 필드에서 uid 값을 복사합니다.
> * **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
> * **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
> * 다음 명령을 실행합니다.
> ```sh
> node ./applimode-tool/index.js verified
> ```
> * 복사한 uid를 붙여넣습니다.
> * 다음 명령을 실행합니다.
> ```sh
> firebase deploy --only firestore
> ```

> [!CAUTION]
> 누군가를 관리자로 지정하면 해당 사용자는 앱에서 관리자 설정을 변경하고, 모든 게시물을 편집, 삭제 또는 차단하고, 특정 사용자의 모든 게시물을 차단할 수도 있습니다.



## 관리자 설정 및 custom_settings.dart
> [!NOTE]
> * **관리자 설정** 페이지와 **custom_settings.dart** 파일은 사용자가 직접 앱의 설정값을 변경할 수 있는 공간입니다.
> * 관리자 설정 페이지는 custom_settings.dart 파일의 항목들을 GUI로 옮겨 놓은 페이지입니다.
> * custom_settings.dart 파일의 모든 항목은 앱의 관리자 설정 페이지로 옮겨질 예정입니다.
> * **custom_settings.dart** 파일을 변경하는 경우 앱에 적용하려면 다시 빌드해야 합니다.
<!--
> * 관리자 설정을 변경할 때 사용자는 앱을 처음 시작할 때 값을 가져오고 앱을 두 번째로 시작할 때 값이 적용됩니다.
> * 관리자 설정의 기본 최소 가져오기 간격은 600초 (10분)이며 **custom_settings.dart** 파일에서 변경할 수 있습니다.
-->

* 앱에서 관리자 설정 탭을 활성화하려면 먼저 [관리자 추가](#관리자-추가)가 필요합니다.
<!--
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* Applimode 앱을 빌드합니다. (```F5``` 또는 ```Fn``` + ```F5```를 누르거나 빌드 방법에 대한 [이 장](#applimode-앱-빌드)을 확인하십시오.)
-->
* Applimode 앱을 엽니다. ([Applimode 앱 빌드](#applimode-앱-빌드) 장에서 대상 장치로 Chrome 또는 Edge를 선택한 경우 ```F5``` 또는 ```Fn``` + ```F5```를 눌러 다시 빌드합니다.)
* 홈 화면 왼쪽 상단의 메뉴 버튼을 클릭합니다.
* **관리자 설정**를 클릭합니다. (관리자 설정 탭을 찾을 수 없으면 앱을 다시 시작하십시오.)
* 설정을 변경한 후 하단의 **저장하기**를 클릭합니다.
<!--todos 각 설정에 대한 상세 설명 페이지 만들고 여기에 링크 추가-->
* **custom_settings.dart** 파일을 변경하려면 **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
<!--
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
-->
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력한 다음 클릭합니다.
* appCreator 및 appVersion을 원하는 값으로 변경합니다.
> [!IMPORTANT]
> fullAppName, shortAppName, underbarAppName, camelAppName, androidBundleId, appleBundleId, firebaseProjectName은 프로젝트를 업그레이드할 때 사용되는 값입니다. 변경하지 마십시오. 변경하려면 [이 장](#프로젝트-구성)을 참조하여 프로젝트를 다시 구성하십시오.
* 이름 앞에 **spare**가 있는 값은 사용자가 앱을 설치한 후 처음 실행할 때 사용됩니다. (관리자 설정이 아직 활성화되지 않은 경우) 원하는 값으로 변경할 수 있습니다.
> [!NOTE]
> * **관리자 설정**에서 값을 변경하는 경우 **custom_settings.dart** 파일에서 해당 spare 값도 변경하는 것이 좋습니다.
> * 예를 들어 **App style** 값을 변경하는 경우 **custom_settings.dart** 파일에서 **sparePostsListType** 값도 변경하십시오.
> * **관리자 설정**의 **App style** 값은 **custom_settings.dart** 파일의 **sparePostsListType** 값에 다음과 같이 대응됩니다.
>   * **리스트 스타일** - **PostsListType.small**
>   * **카드 스타일** - **PostsListType.square**
>   * **페이지 스타일** - **PostsListType.page**
>   * **둥근 카드 스타일** - **PostsListType.round**
>   * **혼합 스타일** - **PostsListType.mixed**
<!--
* App Store 또는 Play Store에 앱을 등록하려면 **termsUrl** 및 **privacyUrl**에 해당 링크를 추가하십시오.
* **isInitialSignIn** 값을 true로 변경하면 로그인한 사용자만 앱을 사용할 수 있습니다. 더 강력한 보안을 위해 Cloud Firestore 보안 규칙을 사용할 수도 있습니다. 자세한 내용은 [이 장](#cloud-firestore-보안-규칙-구성)을 읽으십시오.
* **adminOnlyWrite** 값을 true로 변경하면 관리자로 지정된 사용자만 게시물을 작성할 수 있습니다.
* **useFcmMessage**, **fcmVapidKey**, **useApns** 값을 true로 변경하려면 [이 장](#푸시-알림-구성-선택-사항)을 읽으십시오.
-->
* 모든 변경을 완료했으면 ```Command``` + ```S```를 누릅니다.
* 모든 **관리자 설정** 및 **custom_settings.dart** 파일의 값에 대한 자세한 정보를 곧 준비하겠습니다.



<!--
## iOS 앱 빌드
> [!CAUTION]
이 섹션의 내용은 향후 업데이트될 예정입니다. 자세한 내용은 [이 페이지](https://docs.flutter.dev/deployment/ios)를 참조하십시오.
-->



## Cloudflare R2 구성 (선택 사항)
> [!NOTE]
> * R2의 가장 큰 장점은 전송 비용이 무료라는 것입니다. (Firebase Cloud Storage는 하루 최대 1GB 전송이 무료이며, 이후에는 GB당 $0.12가 부과됩니다.)
> * 도메인을 등록하고 R2와 연결하여 Cloudflare의 CDN도 무료로 사용할 수 있습니다.
> * 비디오 중심 앱을 구축하는 경우 Cloudflare R2 사용을 적극 권장합니다.
> * [R2 가격 정책](https://developers.cloudflare.com/r2/pricing/)
> * [Workers 가격 정책](https://developers.cloudflare.com/workers/platform/pricing/)
* [Cloudflare console](https://dash.cloudflare.com/sign-up)로 이동합니다.
* 가입하거나 로그인합니다.
* **R2 개체 저장 공간** (왼쪽 사이드바)를 클릭합니다.
* **R2** 가입 양식을 작성하고 **R2** 가입을 완료합니다.
* **Terminal**을 엽니다.
* 다음 명령을 실행합니다.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest -- <your_r2_worker_name>
```
> ex) npm create cloudflare@latest -- applimode-r2-worker
* 모든 질문에 대해 기본값을 선택합니다.
* **Terminal**을 닫습니다.
* **VSCode**로 이동하거나 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* <your_r2_worker_name> 폴더를 선택하고 **Open**을 클릭합니다.
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
npx wrangler r2 bucket create <your_r2_bucket_name>
```
> ex) npx wrangler r2 bucket create applimode-bucket
* ```Command``` + ```P```를 누르고 *wrangler.json*을 입력한 다음 클릭합니다.
* **wrangler.json** 파일 중간에 다음을 추가합니다.
```json
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "<your_r2_worker_name>",
  "main": "src/index.ts",
  "compatibility_date": "2025-01-24",
  // 이 부분부터
  "r2_buckets": [
    {
      "binding": "MY_BUCKET",
      "bucket_name": "<YOUR_BUCKET_NAME>"
    }
  ],
  // 이 부분까지 복사해서 해당 위치에 붙여 넣어 주세요.
  // <YOUR_BUCKET_NAME> 은 방금 전 생성한 버켓의 이름으로 변경해 주세요.
  "observability": {
    "enabled": true
  }
}
```
<!--
> * Or you can also find them using the following commands
```sh
npx wrangler whoami 
```
```sh
npx wrangler r2 bucket list
```
-->
* 저장하려면 ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/r_two_Worker/r2_worker.index.ts)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
![copy-raw-file](https://github.com/mycalls/applimode-examples/blob/main/assets/gh-copy-raw-file.png?raw=true)
* VSCode로 돌아갑니다.
* ```Command``` + ```P```를 누르고 *index.ts*를 입력한 다음 클릭합니다.
* ```Command``` + ```A```를 누르고 ```Command``` + ```V```를 누릅니다.
* 저장하려면 ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)
* VSCode 하단의 **Terminal**을 클릭하고 다음 명령을 실행합니다.
```
npx wrangler secret put AUTH_KEY_SECRET
```
> 질문이 나오면 **y** 또는 **Y**을 누르십시오.
<!--Enter a secret value:-->
* 워커의 비밀번호을 입력합니다.
* 위의 과정이 끝나면 다음 명령어를 입력하세요.
```
npx wrangler deploy
```
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 순서대로 실행합니다.
```sh
node ./applimode-tool/index.js worker
```
* 이전에 입력했던 워커의 비밀번호을 입력합니다.
```sh
dart run build_runner clean
```
```sh
dart run build_runner build --delete-conflicting-outputs
```
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력한 다음 클릭합니다.
* ```Command``` + ```F```를 누르고 *useRTwoStorage*를 입력합니다.
* useRTwoStorage 값을 **false**에서 **true**로 변경합니다.
> ex) const bool useRTwoStorage = true;
* [Cloudflare dashboard](https://dash.cloudflare.com/)로 이동합니다.
* 왼쪽 사이드바에서 **컴퓨팅(Workers)** 을  선택한 후, 목록에서 볼드체의 워커 이름을 클릭합니다.
* 상단 탭에서 **설정**을 클릭하고, **도메인 및 경로** 항목에서 **workers.dev**의 값을 복사합니다.
* VSCode로 돌아갑니다.
* ```Command``` + ```F```를 누르고 *rTwoBaseUrl*을 입력합니다.
* rTwoBaseUrl 값을 **yourR2WorkerUrl**에서 복사한 경로로 변경합니다.
> ex) const String rTwoBaseUrl = 'applimode-r2-worker.yourID.workers.dev';
* ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)
* 제대로 작동하는지 확인하려면 [Applimode 앱 빌드](#applimode-앱-빌드) 장을 따르십시오.



## Cloudflare D1 구성 (선택 사항)
> [!NOTE]
> * Applimode는 기본적으로 해시태그 검색을 지원합니다. 게시물을 작성할 때 단어 앞에 #을 추가해야만 검색이 가능합니다.
> * 해시태그 검색만 사용하려면 이 장을 건너뛰고, 전문(full-text) 검색을 사용하려면 이 장을 따르십시오.
> * [D1 가격 정책](https://developers.cloudflare.com/d1/platform/pricing/)
* **Terminal**을 엽니다.
* 다음 명령을 실행합니다.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest -- <your_d1_worker_name>
```
> ex) npm create cloudflare@latest -- applimode-d1-worker
* 모든 질문에 대해 기본값을 선택합니다.
* **Terminal**을 닫습니다.
* **VSCode**로 이동하거나 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* <your_d1_worker_name> 폴더를 선택하고 **Open**을 클릭합니다.
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
npx wrangler d1 create <db-name>
```
> ex) npx wrangler d1 create applimode-d1
* 실행이 성공하면 다음과 같은 정보를 명령창에서 볼 수 있습니다.
```
[[d1_databases]]
binding = "DB"
database_name = "<db-name>"
database_id = "<unique-ID-for-your-database>"
```
* ```Command``` + ```P```를 누르고 *wrangler.json*을 입력한 다음 클릭합니다.
* **wrangler.json** 파일 중간에 다음을 추가합니다.
```json
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "<your_d1_worker_name>",
  "main": "src/index.ts",
  "compatibility_date": "2025-01-24",
  // 이 부분부터
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "<db-name>",
      "database_id": "<unique-ID-for-your-database>"
    }
  ],
  // 이 부분까지 복사해서 해당 위치에 붙여 넣어 주세요.
  // <db-name>과 <unique-ID-for-your-database>를 이전에 출력된 정보에 따라 변경해 주세요.
  "observability": {
    "enabled": true
  }
}
```
* 저장하려면 ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/d_one_worker/d1.posts.sql)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
* VSCode로 돌아갑니다.
* **File**을 클릭하고 **New File...**을 클릭합니다. (또는 New File 버튼 클릭)
![vscode-new-file](https://github.com/mycalls/applimode-examples/blob/main/assets/vs-create-file.png?raw=true)
* *posts.sql*을 입력하고 ```Enter```를 누르고 **Create File**을 클릭합니다. (프로젝트 루트 폴더에)
* 붙여넣고 저장하려면 ```Command``` + ```V```와 ```Command``` + ```S```를 누릅니다.
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/d_one_worker/d1_worker.index.ts)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
* VSCode로 돌아갑니다.
* ```Command``` + ```P```를 누르고 *index.ts*를 입력한 다음 클릭합니다.
* ```Command``` + ```A```를 누르고 ```Command``` + ```V```를 누릅니다.
* 저장하려면 ```Command``` + ```S```를 누릅니다.
* VSCode 하단의 **Terminal**을 클릭하고 다음 명령을 실행합니다. (**<your-d1-db-name>**을 찾으려면 **wrangler.json** 파일로 이동하여 **database_name**을 참조하십시오.)
```
npx wrangler d1 execute <your-d1-db-name> --remote --file=./posts.sql
```
```
npx wrangler deploy
```
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력한 다음 클릭합니다.
* ```Command``` + ```F```를 누르고 *useDOneForSearch*를 입력합니다.
* useDOneForSearch 값을 **false**에서 **true**로 변경합니다.
> ex) const bool useDOneForSearch = true;
* [Cloudflare dashboard](https://dash.cloudflare.com/)로 이동합니다.
* 왼쪽 사이드바에서 **컴퓨팅(Workers)** 을  선택한 후, 목록에서 볼드체의 워커 이름을 클릭합니다.
* 상단 탭에서 **설정**을 클릭하고, **도메인 및 경로** 항목에서 **workers.dev**의 값을 복사합니다.
* VSCode로 돌아갑니다.
* ```Command``` + ```F```를 누르고 *dOneBaseUrl*을 입력합니다.
* dOneBaseUrl 값을 **yourD1WorkerUrl**에서 복사한 경로로 변경합니다.
> ex) const String rTwoBaseUrl = 'applimode-d1-worker.yourID.workers.dev';
* ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)
* 제대로 작동하는지 확인하려면 [Applimode 앱 빌드](#applimode-앱-빌드) 장을 따르십시오.



## Cloudflare CDN 구성 (선택 사항)
> [!IMPORTANT]
> * Cloudflare의 CDN을 사용하려면 도메인이 Cloudflare에 등록되어 있어야 합니다.
> * 도메인이 없는 경우 [Cloudflare console](https://dash.cloudflare.com/)로 이동하여 **Domain Registration** (왼쪽 사이드바)을 클릭하고 **Register Domain**을 클릭합니다.
> * 도메인을 Cloudflare로 이전해야 하는 경우 [Cloudflare console](https://dash.cloudflare.com/)로 이동하여 **Domain Registration** (왼쪽 사이드바)을 클릭하고 **Transfer Domain**을 클릭합니다.
> * [도메인 등록 문서](https://developers.cloudflare.com/registrar/get-started/register-domain)
> * [도메인 이전 문서](https://developers.cloudflare.com/registrar/get-started/transfer-domain-to-cloudflare/)

* [Cloudflare console](https://dash.cloudflare.com/)로 이동합니다.
* **R2 개체 저장 공간** (왼쪽 사이드바)를 클릭하고 **개요**에서 원하는 버킷을 선택합니다.
* 상단의 **설정**를 클릭하고 아래로 스크롤하여 **공개 액세스** 섹션을 찾습니다.
* **사용자 지정 도메인**에서 **도메인 연결**을 클릭합니다.
* CDN에 사용할 도메인을 입력하고 **계속**을 클릭합니다.
> applimode.com이라는 도메인이 있는 경우 *<n>media.<n>applimode.<n>com* 또는 *<n>cdn.<n>applimode.<n>com* 또는 *<n>content.<n>applimode.<n>com*과 같은 하위 도메인을 입력합니다.
* **계정 홈** (왼쪽 사이드바)를 클릭하고 도메인을 클릭합니다.
* **규칙** (왼쪽 사이드바)를 클릭하고, 하단 우측의 **응답 헤더 변환 규칙 관리**를 클릭합니다.
* **+ 규칙 생성**을 클릭합니다.
* *applimode-r2-cors*와 같이 규칙 이름을 입력합니다.
* **사용자 설정 필터 식**을 선택합니다.
* **필드**에서 **호스트 이름**을 선택하고 **연산자**에서 **같음**를 선택하고 **값**에 R2 버킷에 연결한 하위 도메인을 입력합니다. (*<n>media.<n>applimode.<n>com* 또는 *<n>cdn.<n>applimode.<n>com* 또는 *<n>content.<n>applimode.<n>com*과 같음)
* **항목 선택**에서 **추가**를 선택합니다.
* **헤더 이름**에 다음 표현식을 복사하여 붙여넣습니다.
```
access-control-allow-origin
```
* **값**에 *를 입력합니다.
* **배포**를 클릭합니다.
![cf-websites-rules](https://github.com/mycalls/applimode-examples/blob/main/assets/cf-websites-rules.png?raw=true)
* **VSCode**로 이동하거나 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택하고 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력한 다음 클릭합니다.
* ```Command``` + ```F```를 누르고 *useCfCdn*을 입력합니다.
* useCfCdn 값을 **false**에서 **true**로 변경합니다.
> ex) const bool useCfCdn = true;
* ```Command``` + ```F```를 누르고 *cfDomainUrl*을 입력합니다.
* cfDomainUrl 값을 **yourCustomDomainUrl**에서 R2 버킷에 연결한 하위 도메인으로 변경합니다. (*<n>media.<n>applimode.<n>com* 또는 *<n>cdn.<n>applimode.<n>com* 또는 *<n>content.<n>applimode.<n>com*과 같음)
> ex) const String cfDomainUrl = 'media.applimod.com';
* ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)
* 제대로 작동하는지 확인하려면 [Applimode 앱 빌드](#applimode-앱-빌드) 장을 따르십시오.



## Youtube 이미지 프록시 구성 (선택 사항)
> [!NOTE]
> * YouTube 링크가 포함된 게시물에서 CORS 문제로 인해 미리보기 이미지를 가져올 수 없는 경우가 있습니다.
> * YouTube 이미지에 대한 프록시 워커를 구성하여 이 문제를 해결할 수 있습니다.
* **Terminal**을 엽니다.
* 다음 명령을 실행합니다.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest -- yt-thumbnail-worker
```
* 모든 질문에 대해 기본값을 선택합니다.
* **Terminal**을 닫습니다.
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/yt_thumbnail_worker/yt_thumbnail_worker.index.ts)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
* **VSCode**로 이동하거나 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* **yt-thumbnail-worker** 폴더를 선택하고 **Open**을 클릭합니다.
* ```Command``` + ```P```를 누르고 *index.ts*를 입력하고 클릭합니다.
* ```Command``` + ```A```를 누르고 ```Command``` + ```V```를 누릅니다.
* 저장하려면 ```Command``` + ```S```를 누릅니다.
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```
npx wrangler deploy
```
* [Cloudflare dashboard](https://dash.cloudflare.com/)로 이동합니다.
* 왼쪽 사이드바에서 **컴퓨팅(Workers)** 을  선택한 후, 목록에서 **yt-thumbnail-worker**를 클릭합니다.
* 상단 탭에서 **설정**을 클릭하고, **도메인 및 경로** 항목에서 **workers.dev**의 값을 복사합니다.
* VSCode로 돌아갑니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택하고 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력하고 클릭합니다.
* ```Command``` + ```F```를 누르고 *youtubeImageProxyUrl*을 입력합니다.
* youtubeImageProxyUrl 값을 **yt-thumbnail-worker.jongsukoh80.workers.dev**에서 복사한 경로로 변경합니다.
> ex) const String rTwoBaseUrl = 'yt-thumbnail-worker.yourID.workers.dev';
* ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)



## Youtube 비디오 프록시 구성 (선택 사항)
> [!NOTE]
> * 게시물에서 YouTube 비디오를 열면 비디오가 삽입된 페이지가 전송됩니다.
> * 구성되지 않은 경우 <n>youtube-nocookie.<n>com이 사용됩니다.
* **Terminal**을 엽니다.
* 다음 명령을 실행합니다.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest -- yt-iframe-wroker
```
* 모든 질문에 대해 기본값을 선택합니다.
* **Terminal**을 닫습니다.
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/yt_iframe_worker/yt_iframe_worker.index.ts)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
* **VSCode**로 이동하거나 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
* **yt_iframe_worker** 폴더를 선택하고 **Open**을 클릭합니다.
* ```Command``` + ```P```를 누르고 *index.ts*를 입력하고 클릭합니다.
* ```Command``` + ```A```를 누르고 ```Command``` + ```V```를 누릅니다.
* 저장하려면 ```Command``` + ```S```를 누릅니다.
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```
npx wrangler deploy
```
* [Cloudflare dashboard](https://dash.cloudflare.com/)로 이동합니다.
* 왼쪽 사이드바에서 **컴퓨팅(Workers)** 을  선택한 후, 목록에서 **yt_iframe_worker**를 클릭합니다.
* 상단 탭에서 **설정**을 클릭하고, **도메인 및 경로** 항목에서 **workers.dev**의 값을 복사합니다.
* VSCode로 돌아갑니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택하고 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력하고 클릭합니다.
* ```Command``` + ```F```를 누르고 *youtubeIframeProxyUrl*을 입력합니다.
* youtubeIframeProxyUrl 값에 복사한 경로를 붙여넣습니다.
> ex) const String youtubeIframeProxyUrl = 'yt-iframe-worker.yourID.workers.dev';
* ```Command``` + ```S```를 누릅니다. (또는 **File** > **Save**)



## 사용자 정의 도메인 사용 (선택 사항)
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Hosting** (왼쪽 사이드바)을 클릭합니다.
* 아래로 스크롤하여 **Domains** 섹션을 찾습니다.
* **Add custom domain**을 클릭합니다.
<!--todos 내용 추가해줄 것-->
<!--
// 확인하는 동안 Records 항목의 Proxy 꺼줄것
// SSL/TLS 설정 Flexible 에서 Full 로 변경할 것
-->



## 새 Applimode 버전으로 프로젝트 업그레이드
<!--
* 기존 **applimode**(또는 **applimode-main**) 폴더를 삭제합니다. (**projects** 폴더에 있는 경우)
-->
* **Terminal**을 엽니다.
* 다음 명령을 실행합니다.
```sh
flutter upgrade
```
```sh
cd ~/projects;
```
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
cp -r ./applimode/applimode-tool ./; node ./applimode-tool/index.js upgrade; rm -r ./applimode-tool
```
* 기존 프로젝트 디렉토리 이름을 입력합니다.
* **Terminal**을 닫습니다.
* **VSCode**를 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택하고 새 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 순서대로 실행합니다.
```sh
flutter pub get
```
```sh
dart run flutter_native_splash:create
```
```sh
flutter pub run flutter_launcher_icons
```
```sh
node ./applimode-tool/index.js splash
```
```sh
dart run build_runner build -d
```
```sh
flutterfire configure --platforms=android,ios,web
```
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
> [!NOTE]
> * 명령을 한 번에 모두 입력하려면 다음 명령을 실행하십시오.
> ```sh
> flutter pub get; dart run flutter_native_splash:create; flutter pub run flutter_launcher_icons; node ./applimode-tool/index.js splash; dart run build_runner build -d; flutterfire configure --platforms=android,ios,web; node ./applimode-tool/index.js firebaserc; firebase deploy --only firestore; firebase deploy --only storage;
> ```
-->
* 이전 프로젝트 폴더를 삭제합니다.



## 전화번호 로그인 추가
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Authentication** (왼쪽 사이드바)을 클릭합니다.
* **로그인 방법** 탭을 선택합니다.
* **새 제공업체 추가**를 클릭한 다음 **전화**을 클릭합니다.
* **전화** 스위치를 찾아 활성화합니다.
* **저장** 버튼을 클릭합니다.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js auth
```
* ```2``` (전화만) 또는 ```3``` (이메일 및 전화)을 입력하고 ```Enter```를 누릅니다.
#### 웹
* 웹 앱 (PWA)만 배포하는 경우 특별한 조치가 필요하지 않습니다.
#### Android
> [!NOTE]
> 앱을 출시하는 동안 Play Console에서 키를 가져와야 합니다. [여기](https://docs.flutterflow.io/integrations/authentication/firebase/initial-setup#getting-sha-keys-for-release-mode)는 도움이 되는 링크입니다.
* 다음 명령을 실행합니다.
```sh
keytool -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
```
> [!NOTE]
> 컴퓨터에 Java가 설치되어 있지 않으면 오류가 발생합니다. 먼저 Java를 설치하십시오.
* 키 암호를 묻는 메시지가 표시되면 *android*를 입력하고 ```Enter```를 누릅니다.
* SHA1 키를 복사합니다.
* [Firebase console](https://console.firebase.google.com/) > 프로젝트 > **프로젝트 개요** > **프로젝트 설정**를 열고 아래로 스크롤하여 **내 앱** 섹션을 찾습니다.
* 왼쪽 메뉴에서 Android 앱을 선택합니다.
* **SHA 인증서 지문** 섹션을 찾아 **디지털 지문 추가**를 클릭합니다.
* 복사한 SHA-1을 입력 상자에 입력하고 **저장**를 클릭합니다.
* [Google Developers Console](https://console.developers.google.com/)을 엽니다. (상단의 드롭다운에서 프로젝트가 선택되어 있는지 확인하십시오.)
* 상단의 검색창에 **Google Play Integrity API**를 입력하고, 제품 세부정보 페이지로 들어가 활성화합니다. 
#### iOS
* [Firebase console](https://console.firebase.google.com/) > 프로젝트 > **프로젝트 개요** > **프로젝트 설정**를 열고 아래로 스크롤하여 **내 앱** 섹션을 찾습니다.
* 왼쪽 메뉴에서 Apple 앱을 선택합니다.
* **인코딩된 앱 ID** 섹션을 찾아 값을 복사합니다 (app-1-xxxxxxxxxxxx-ios-xxxxxxxxxxxxxxxxxxxxxx).
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
open ios/Runner.xcworkspace
```
* 왼쪽 트리 보기에서 **Runner**를 클릭합니다.
* TARGETS 섹션에서 **Runner**를 클릭한 다음 **Info** 탭을 선택하고 **URL Types** 섹션을 확장합니다.
* ```+``` 버튼을 클릭하고 **Encoded App ID**를 **URL Schemes**로 추가합니다.
* 다른 필드는 비워 둡니다.
* 완료되면 구성이 다음과 유사해야 합니다 (단, 애플리케이션 특정 값 사용).
![url-schemes](https://firebase.google.com/static/docs/auth/images/app-id-url-scheme.png)
* 작업을 완료하려면 [푸시 알림 구성](#configure-push-notification-optional) 섹션의 단계를 따르십시오.



## AI 어시스턴트 설정 (Google Gemini)
* Applimode 앱에서 게시물을 작성할 때 AI 어시스턴트를 사용하려면 다음 단계를 따르십시오.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js ai
```
* ```y```를 입력하고 ```Enter```를 누릅니다.
* Flash와 Pro 중에서 선택합니다. (Flash는 빠르고 비용 효율적이지만 Pro는 더 강력하지만 더 비쌉니다.)
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* 현재 페이지를 새로고침합니다.
* **AI** (왼쪽 사이드바)를 클릭하고 **AI Logic**을 클릭합니다.
* **시작하기**를 클릭합니다.
* **Gemini Developer API** 섹션에서 **이 API 시작하기**를 클릭하세요.
* * **사용 설정**을 클릭한 다음 **계속**를 클릭합니다.
<!--
* **VSCode**로 돌아와 터미널에서 다음 명령어를 실행하세요.
```sh
flutterfire configure --platforms=android,ios,web
```
> * 질문이 나오면 **y** 또는 **Y**을 누르십시오.
> * 만약 해당 명령 결과로 에러가 발생한다면 다음 명령어를 실행시킨 후 다시 실행하세요.
> ```sh
> dart pub global activate flutterfire_cli
> ```
* 웹 브라우저의 Firebase console로 돌아와 페이지를 새로 고침하세요.
* 필요하다면 **Add your app** 섹션에서 플러터 아이콘을 선택하고, **계속**를 클릭합니다.
-->



## 푸시 알림 구성
> [!NOTE]
> * APNs (Apple Push Notification service)를 사용하려면 [Apple Developer Program](https://developer.apple.com/programs/)에 등록해야 합니다. (99 USD)
<!--
> * Apple 통합에 대한 자세한 내용은 [이 페이지](https://firebase.flutter.dev/docs/messaging/apple-integration)를 참조하십시오.
-->
* **VSCode**로 이동하거나 엽니다.
* **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택하고 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
* **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js fcm
```
> [!NOTE]
> * vapid 키를 찾으려면 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
> * 프로젝트를 클릭합니다.
> * 왼쪽 사이드바 상단의 설정 버튼을 클릭합니다.
> * **프로젝트 설정**을 클릭합니다.
![fb-project-settings](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-project-settings.png?raw=true)
> * 상단 탭 메뉴에서 **클라우드 메시징**을 클릭하고 하단으로 스크롤합니다.
> * **Generate key pair**를 클릭합니다.
> * **웹 푸시 인증서**의 **키 쌍**를 복사합니다.
![fb-cloud-message-web](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-cloud-message-web.png?raw=true)
<!--
```
firebase init functions
```
-->
```
cd functions
```
```
npm install
```
```
firebase deploy --only functions
```
```
cd ..
```
<!--
iOS APNS 사용하기 위해서 링크 참고
https://firebase.flutter.dev/docs/messaging/apple-integration
custom_settings 에서 useApns 변경
-->
* 웹 브라우저에서 [Apple Developer page](https://developer.apple.com/membercenter/index.action)를 엽니다.
* **인증서, ID 및 프로파일** 섹션에서 키(영문)를 클릭합니다.
* 파란색 더하기 버튼을 클릭합니다.
* **Key Name** 상자에 키 이름을 입력합니다. (무엇이든 상관없음)
* **Apple Push Notifications service (APNs)**를 활성화합니다.
* **Continue**를 클릭한 다음 **Save**를 클릭합니다.
* 저장되면 개인 **Key ID**와 키를 다운로드할 수 있는 기능이 표시된 화면이 나타납니다. ID를 복사하고 **Download**를 클릭하여 파일을 로컬 컴퓨터에 다운로드합니다.
![copy-key-id](https://firebase.flutter.dev/assets/images/ios-apple-dev-copy-download-d865d57ffeb870bc011b00eb8e6ca175.png)
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/project/_/settings/cloudmessaging)을 엽니다.
* 프로젝트를 클릭합니다.
<!--
* **Firebase Console**에서 **Project settings**로 이동하여 **Cloud Messaging** 탭을 선택합니다.
-->
* **Apple app configuration** 제목 아래에서 iOS 애플리케이션을 선택합니다.
* **APNs Authentication Key** 제목 아래에서 **Upload**를 클릭합니다.
* 다운로드한 파일을 업로드하고 Key & Team ID를 입력합니다.
> [!NOTE]
> **Team ID**를 찾으려면 웹 브라우저에서 [이 페이지](https://developer.apple.com/account)를 엽니다. 그런 다음 ```Command``` + ```F```를 누르고 *team id*를 입력합니다.
<!--
![upload-apns-file](https://images.prismic.io/invertase/74bd1df4-c9e9-465c-9e0f-cacf6e26d68c_7539b8ec-c310-40dd-91e5-69f19009786f_apple-fcm-upload-key.gif)
-->
* **Xcode**에서 열려 있는 프로젝트로 돌아갑니다. (**Xcode**를 닫은 경우 [이 섹션](#xcode에서-applimode-프로젝트-열기)을 참조하십시오.)
* 프로젝트를 선택합니다.
* 프로젝트 대상을 선택합니다.
* **Signing & Capabilities** 탭을 선택합니다.
![xcode-signing](https://firebase.flutter.dev/assets/images/ios-signing-capabilities-e74450e3f1cd627127e033075610940a.png)
* **+ Capabilities** 버튼을 클릭합니다.
* *Push Notifications*를 검색합니다.
![apns-push](https://firebase.flutter.dev/assets/images/ios-enable-push-notifications-8a3043ac972a837a545f79bb30bddeec.png)
* 선택되면 기능이 다른 활성화된 기능 아래에 표시됩니다. 검색 시 옵션이 나타나지 않으면 기능이 이미 활성화되었을 수 있습니다.
* **+ Capabilities** 버튼을 클릭합니다.
* **Background Modes**를 검색합니다.
* 선택되면 기능이 다른 활성화된 기능 아래에 표시됩니다. 검색 시 옵션이 나타나지 않으면 기능이 이미 활성화되었을 수 있습니다.
* **Background fetch**와 **Remote notifications** 하위 모드가 모두 활성화되어 있는지 확인합니다.
<!--
![apns-background-fetch](https://images.prismic.io/invertase/3a618574-dd9f-4478-9f39-9834d142b2e5_xcode-background-modes-check.gif)
-->
* **Bundle Identifier**를 복사합니다.
![xcode-bundle-id](https://firebase.flutter.dev/assets/images/ios-xcode-bundle-id-9f0f92a850217305ca2e98ab14885019.png)
* 웹 브라우저에서 [Apple Developer page](https://developer.apple.com/membercenter/index.action)로 돌아갑니다.
* **Identifiers** 사이드 메뉴 항목을 클릭합니다.
* 더하기 버튼을 클릭하여 App Identifier를 등록합니다.
* **App IDs** 옵션을 선택하고 **Continue**를 클릭합니다.
* **App** 유형 옵션을 선택하고 **Continue**를 클릭합니다.
<!--
![apns-identifiers-1](https://images.prismic.io/invertase/944b25ff-8360-456f-8a43-da8c3cd80644_ios-apple-dev-register-app-id2.gif)
-->
* 식별자에 대한 설명을 입력합니다.
* **Xcode**에서 복사한 **Bundle ID**를 입력합니다.
* 아래로 스크롤하여 **Push Notifications** 기능 (및 앱에서 사용하는 다른 기능)을 활성화합니다.
<!--
![apns-identifiers-2](https://images.prismic.io/invertase/0e711691-ccd2-43ab-9c0c-7696b6790153_apple-identifier.gif)
-->
* **Continue**를 클릭합니다.



## Cloud Firestore 보안 규칙 구성
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js security
```
* 원하는 보안 규칙을 선택합니다. (a, s, v)
> [!NOTE]
> * a (모든 사용자 접근 허용) - 모든 사용자에게 액세스 권한이 부여됩니다. 인증 상태와 관계없습니다.
> * s (로그인한 사용자만 접근 허용) - 애플리케이션에 로그인한 사용자로 액세스가 제한됩니다.
> * v (인증된 사용자만 접근 허용) - 관리자가 허용한 사용자로 액세스가 제한됩니다.
* 다음 명령을 실행합니다.
```sh
firebase deploy --only firestore
```
<!--
* 이전 Firestore 규칙에 관리자 또는 인증된 사용자 ID를 추가한 경우 다음 단계를 따르십시오.
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Firestore Database** (왼쪽 사이드바)를 클릭합니다.
> [!NOTE]
> 새 관리자 또는 인증된 사용자를 추가하려면 먼저 다음 단계를 따르십시오.
> * users 컬렉션을 클릭하고 uid를 선택합니다.
> * **isAdmin** 또는 **verified** 필드 옆에 있는 **Edit field** 버튼 (연필 모양)을 클릭합니다. (**isAdmin** 또는 **verified** 필드 위로 마우스 커서를 이동하면 **Edid field** 버튼이 표시됩니다.)
> * 값을 **false**에서 **true**로 변경하고 **Update**를 클릭합니다.
* 상단의 **Rules**를 클릭합니다.
* 관리자 ID 또는 인증된 ID를 추가합니다. 이 작업을 수행하는 방법을 잊어버린 경우 [이 페이지](#관리자-추가)를 따르십시오.
* **Publish**를 클릭합니다.
-->
<!--
#### 로그인한 사용자로 액세스 제한
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력한 다음 클릭합니다.
* ```Command``` + ```F```를 누르고 *isInitialSignIn*을 입력합니다.
* **isInitialSignIn** 값을 **false**에서 **true**로 변경합니다.
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/fs_authed.firestore.rules)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
![copy-raw-file](https://github.com/mycalls/applimode-examples/blob/main/assets/gh-copy-raw-file.png?raw=true)
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* 프로젝트를 클릭합니다.
* **Firestore Database** (왼쪽 사이드바)를 클릭합니다.
* 상단의 **Rules**를 클릭합니다.
* 복사한 내용을 붙여넣습니다.
* 관리자 ID를 추가합니다. 이 작업을 수행하는 방법을 잊어버린 경우 [이 페이지](#관리자-추가)를 따르십시오.
* **Publish**를 클릭합니다.
#### 인증된 사용자로 액세스 제한
* 로그인한 사용자뿐만 아니라 승인한 사용자만 앱에 액세스할 수 있도록 규칙을 구성하려면 다음 지침을 따르십시오.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* ```Command``` + ```P```를 누르고 *custom_settings.dart*를 입력한 다음 클릭합니다.
* ```Command``` + ```F```를 누르고 *isInitialSignIn*을 입력합니다.
* **isInitialSignIn** 값을 **false**에서 **true**로 변경합니다.
* ```Command``` + ```F```를 누르고 *verifiedOnlyWrite*을 입력합니다.
* **verifiedOnlyWrite** 값을 **false**에서 **true**로 변경합니다.
* 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
* **Firestore Database** (왼쪽 사이드바)를 클릭합니다.
* users 컬렉션을 클릭하고 액세스 권한을 부여하려는 사용자의 UID를 선택합니다.
* **verified** 필드 옆에 있는 **Edit field** 버튼 (연필 모양)을 클릭합니다. (**verified** 필드 위로 마우스 커서를 이동하면 **Edid field** 버튼이 표시됩니다.)
* 값을 **false**에서 **true**로 변경하고 **Update**를 클릭합니다.
* 이 [페이지](https://github.com/mycalls/applimode-examples/blob/main/fs_verified.firestore.rules)를 열고 파일 보기의 오른쪽 상단에 있는 **Copy raw file** 버튼 (**Raw** 버튼 옆)을 클릭합니다.
* 복사한 내용을 Firestore 규칙에 붙여넣습니다.
* 관리자 ID와 인증된 ID를 추가합니다.
* **Publish**를 클릭합니다.
-->



## 관리자만 글쓰기 허용으로 설정 변경
* 관리자로 지정된 사용자만 쓰기를 허용하려면 다음 단계를 따르십시오.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js write
```
* ```y```를 입력하고 ```Enter```를 누릅니다.



## 앱의 기본 색상 변경
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js color
```
* 16진수 형식의 색상 코드를 입력합니다 (예: fcb126, f37d76).
> [!NOTE]
> 앱을 시작한 후 **관리자 설정**에서 기본 색상을 변경할 수도 있습니다. 자세한 지침은 [다음 장](#관리자-설정-및-custom_settingsdart)을 참조하십시오.



## 앱 이름 변경
> [!NOTE]
> * 긴 앱 이름은 주로 웹 앱에 사용됩니다.
> * 짧은 앱 이름은 주로 모바일 앱 (iOS, Android)에 사용됩니다.
* Applimode 앱의 전체 또는 짧은 이름을 변경하려면 다음 단계를 따르십시오.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 전체 이름을 변경하려면 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js fullname
```
* 짧은 이름을 변경하려면 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js shortname
```
* 원하는 이름을 입력하고 Enter를 누릅니다.



## 앱의 조직 이름 변경
> [!CAUTION]
> 꼭 필요한 경우가 아니면 조직 이름을 변경하지 않는 것이 좋습니다.
* Applimode 앱의 조직 이름을 변경하려면 다음 단계를 따르십시오.
* **VSCode**에서 사용자의 어플리모드 프로젝트로 이동하거나 엽니다.
* **View** (VSCode 상단 메뉴)를 클릭한 다음 **Terminal**을 선택합니다.
* 다음 명령을 실행합니다.
```sh
node ./applimode-tool/index.js organization
```
* 원하는 조직 이름을 입력하고 Enter를 누릅니다.



## 문제 해결

### 업로드한 게시물에 이미지나 비디오가 보이지 않는 경우 다음 단계를 따르십시오. (CORS 문제)
1. 웹 브라우저에서 [Google Cloud console](https://console.cloud.google.com/)을 엽니다.
2. 가입하거나 로그인합니다.
3. 왼쪽 상단에서 프로젝트를 선택합니다.
4. 오른쪽 상단의 **Cloud Shell 활성화** 버튼을 클릭합니다.
![gcp-console-head](https://github.com/mycalls/applimode-examples/blob/main/assets/gcp-console-head.png?raw=true)
5. 하단의 셸에서 다음 명령을 실행합니다.
```sh
echo '[{"origin": ["*"],"method": ["GET"],"maxAgeSeconds": 3600}]' > cors.json
```
<!--
> touch cors.json
> nano cors.json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
-->
6. 웹 브라우저에서 [Firebase console](https://console.firebase.google.com/)을 열거나 이동합니다.
7. 프로젝트를 클릭합니다.
8. **Storage** (왼쪽 사이드바)를 클릭합니다.
9. **gs://**로 시작하는 URL 오른쪽에서 **폴더 경로 복사** 아이콘을 클릭하여 클라우드 스토리지 버킷을 복사합니다.
![fb-storage-head](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-storage-head.png?raw=true)
10. Google Cloud console로 돌아갑니다.
11. 하단의 셸에서 다음 명령을 실행합니다.
```sh
gsutil cors set cors.json gs://<your-cloud-storage-bucket>
```

### iOS 기기에서 **신뢰할 수 없는 개발자** 오류 메시지가 표시되면 다음 단계를 따르십시오.
1. iOS 기기에서 **설정**을 엽니다.
2. **일반** > **VPN 및 기기 관리**를 선택합니다.
3. 영향을 받는 프로필을 선택하고 신뢰합니다.

### mac에서 **iproxy** 오류 메시지가 표시되면 다음 단계를 따르십시오.
1. mac에서 **시스템 설정**을 엽니다.
2. **개인 정보 보호 및 보안** > **VPN 및 기기 관리**를 선택합니다.
3. 아래로 스크롤하여 **무시하고 허용**을 클릭합니다.

### iOS 기기에서 빌드할 때 다음 오류 메시지가 표시되는 경우:
> In iOS 14+, debug mode Flutter apps can only be launched from Flutter tooling, IDEs with Flutter plugins or from Xcode. Alternatively, build in profile or release modes to enable launching from the home screen.
1. **Product** (Xcode 상단 메뉴)를 클릭한 다음 **Scheme**을 클릭하고 마지막으로 **Edit Scheme**을 클릭합니다.
2. 왼쪽 패널에서 **Run**을 클릭합니다.
3. **Info** 탭의 **Build Configuration** 드롭다운 메뉴에서 **Release**를 선택합니다.

<!--
// error: Unable to load contents of file list
* Xcode 종료
* VSCode 에서 프로젝트 열고 터미널 열기
> cd ios
> pod deintegrate
> pod update
> cd ..
> open ios/Runner.xcworkspace
* xcode에서 product -> clean 을 해주고 실행
> cd ios; pod deintegrate; pod update; cd ..; open ios/Runner.xcworkspace;
-->

### 추가로 iOS 기기에서 빌드하는 동안 오류가 발생하는 경우 아래 단계를 따르십시오.
1. Xcode를 닫습니다.
2. **VSCode**를 열거나 이동합니다.
3. 필요한 경우 사용자의 어플리모드 프로젝트를 엽니다. (**File** > **Open Folder**)
4. 하단의 내장 터미널을 클릭합니다. (또는 **View** > **Terminal** 선택)
5. 다음 명령을 실행합니다.
```sh
flutter clean
```
```sh
flutter pub get
```
```sh
cd ios
```
```sh
rm -rf Pods
```
```sh
rm -rf Podfile.lock
```
```sh
pod install --repo-update
```
```sh
cd ..
```
```sh
open ios/Runner.xcworkspace
```
<!--
```sh
cd ios; rm -rf Pods; rm -rf Podfile.lock; pod install --repo-update; cd ..; open ios/Runner.xcworkspace;
```
-->
6. 사용자의 어플리모드 프로젝트가 Xcode에서 열립니다.
![xcode-overall](https://github.com/mycalls/applimode-examples/blob/main/assets/xcode-run.png?raw=true)
7. **Xcode**의 진행률 창에 활동이 없으면 **Product** (Xcode 상단 메뉴)를 클릭한 다음 **Clean Build Folder**를 클릭합니다.
8. 왼쪽 상단의 재생 아이콘 버튼을 클릭합니다. (또는 ```Command``` + ```R``` 누르기)

### Android 기기로 빌드할 때 오류가 발생하는 경우 다음 단계를 따르십시오.
1. **VSCode**를 엽니다.
2. **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
3. 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
4. **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
5. 다음 명령을 순서대로 실행합니다.
```sh
flutter clean
```
```sh
flutter pub cache repair
```
```sh
flutter pub get
```

### 대상 장치 목록에 Android 장치가 보이지 않는 경우 다음 단계를 따르십시오.
1. Android 기기에서 개발자 옵션 및 USB 디버깅을 활성화합니다.
2. Android 기기에서 개발자 옵션 및 USB 디버깅을 활성화하려면 [이 페이지](https://developer.android.com/studio/debug/dev-options)를 참조하십시오.
3. USB 설정을 충전 또는 파일 전송으로 변경해 보십시오.
4. 다시 연결합니다.

### Cloudflare R2를 사용할 때 이미지나 비디오가 첨부된 게시물을 업로드할 수 없는 경우 다음 단계를 따르십시오.
1. **VSCode**를 엽니다.
2. **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
3. 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
4. **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
5. 다음 명령을 순서대로 실행합니다.
```sh
dart run build_runner clean
```
```sh
dart run build_runner build --delete-conflicting-outputs
```

### Xcode에서 Applimode 프로젝트 열기
1. **VSCode**를 엽니다.
2. **File** (VSCode 상단 메뉴)을 클릭하고 **Open Folder**를 선택합니다.
3. 사용자의 어플리모드 프로젝트 폴더 (아마도 **projects** 폴더에 있음)를 선택하고 **Open**을 클릭합니다.
4. **View** (VSCode 상단 메뉴)를 클릭하고 **Terminal**을 선택합니다.
5. 다음 명령을 실행합니다.
```sh
open ios/Runner.xcworkspace
```

<!--
// xcode 에서 열기
> open ios/Runner.xcworkspace

// xcode 빌드 에러

// [Xcode] The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.
* Xcode 종료
* VSCode 에서 프로젝트 열고 터미널 열기
> cd ios
> rm -rf Pods
> rm -rf Podfile.lock
> pod install --repo-update
> cd ..
> open ios/Runner.xcworkspace
* xcode에서 product -> clean 을 해주고 실행
> cd ios; rm -rf Pods; rm -rf Podfile.lock; pod install --repo-update; cd ..; open ios/Runner.xcworkspace;
-->

<!--
// .zshrc
```sh
gsukoh/development/flutter/bin"
export PATH=/opt/homebrew/bin:$PATH
eval "$(rbenv init -)"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/$
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"
```
-->
