/// internal v24103002
/// Move this file inside the applimode project
/// applimode 프로젝트 내부로 이동

const fs = require('fs').promises;
const path = require('path');
const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout,
});

// Regular expressions for input validation
const check_eng = /^[a-zA-Z]*$/;
// Only letters allowed
// 영어만 허용
const check_projectName = /^[a-zA-Z_\- ]*$/;
// Project name: letters, spaces, _, - allowed
// 프로젝트 이름: 영어, 공백, _, - 허용
const check_firebaseProjectId = /^[a-zA-Z0-9\-]*$/;
// Firebase project ID: letters, numbers, - allowed
// Firebase 프로젝트 ID: 영어, 숫자, - 허용
const check_version = /([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)/;
// Version format
// 버전 형식
const check_spc = /[~!@#$%^&*()_+|<>?:{}]/;
// Special characters
// 특수 문자
const check_hex_color = /^#?([a-f0-9]{6})$/i;
// Hex color code
// 헥스 색상 코드
const check_password = /^(?=.*[a-zA-Z])[A-Za-z\d!@#$%^&*()_+]{4,}$/;
// Password: at least 4 characters, including at least one letter
// 비밀번호: 최소 4자, 최소 1개의 문자 포함
const urlRegex = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
// Regular expression for URL validation
// URL 유효성 검사를 위한 정규표현식

// Regex for finding values in custom_settings.dart
// custom_settings.dart 파일에서 값을 찾기 위한 regex
const fullNameRegex = /fullAppName =[\s\r\n]*'(.*)';/
const shortNameRegex = /shortAppName =[\s\r\n]*'(.*)';/
const androidBundleIdRegex = /androidBundleId =[\s\r\n]*'(.*)';/
const appleBundleIdRegex = /appleBundleId =[\s\r\n]*'(.*)';/
const mainColorRegex = /spareMainColor =[\s\r\n]*'(.*)';/
const useFcmMessageRegex = /const bool useFcmMessage = (.*);/;
const useApnsRegex = /const bool useApns = (.*);/;
const fcmVapidKeyRegex = /const String fcmVapidKey =[\s\r\n]*'(.*)';/;
const firebaseIdRegex = /const String firebaseProjectId =[\s\r\n]*'(.*)';/
const useAiAssistantRegex = /const bool useAiAssistant = (.*);/;
const aiModelTypeRegex = /const String aiModelType =[\s\r\n]*'(.*)';/;
const useRTwoStorageRegex = /const bool useRTwoStorage = (.*);/;
const rTwoBaseUrlRegex = /const String rTwoBaseUrl =[\s\r\n]*'(.*)';/;
const useRTwoSecureGetRegex = /const bool useRTwoSecureGet = (.*);/;
const useCfCdnRegex = /const bool useCfCdn = (.*);/;
const cfDomainUrlRegex = /const String cfDomainUrl =[\s\r\n]*'(.*)';/;
const useDOneForSearchRegex = /const bool useDOneForSearch = (.*);/;
const dOneBaseUrlRegex = /const String dOneBaseUrl =[\s\r\n]*'(.*)';/;
const youtubeImageProxyUrlRegex = /const String youtubeImageProxyUrl =[\s\r\n]*'(.*)';/;
const youtubeIframeProxyUrlRegex = /const String youtubeIframeProxyUrl =[\s\r\n]*'(.*)';/;
const isInitialSignInRegex = /const bool isInitialSignIn = (.*);/;
const verifiedOnlyWriteRegex = /const bool verifiedOnlyWrite = (.*);/;
const adminOnlyWriteRegex = /const bool adminOnlyWrite = (.*);/;
const fbAuthProvidersRegex = /const List<String> fbAuthProviders =[\s\r\n]*(\[.*\]);/;

// Regex for finding values in firestore.rules
// firestore.rule 파일에서 값을 찾기 위한 regex
const adminFunctionRegex = /function isAdmin\(\) \{\s*return request\.auth\.uid in \[(.*)\];\s*\}/;
const verifiedFunctionRegex = /function isVerified\(\) \{\s*return request\.auth\.uid in \[(.*)\];\s*\}/;
const allUserAccessRegex = /\/\/ Allow read access to all user/;
const signedAccessRegex = /\/\/ Allow read access to any user signed in/;
const verifiedAccessRegex = /\/\/ Allow read access to verified user/;

// Color codes
// 색상 코드
const bold = '\x1b[1m';
// Bold
// 볼드
const underline = '\x1b[4m';
// Underline
// 밑줄
const red = '\x1b[31m';
// Red
// 빨간색
const green = '\x1b[32m';
// Green
// 초록색
const yellow = '\x1b[33m';
// Yellow
// 노랑색
const blue = '\x1b[34m';
// Blue
// 파랑
const redBold = '\x1b[31m\x1b[1m';
// Bold red
// 굵은빨간색
const greenBold = '\x1b[32m\x1b[1m';
// Bold green
// 굵은초록색
const yellowBold = '\x1b[33m\x1b[1m';
// Bold yellow
// 굵은노랑색
const blueBold = '\x1b[34m\x1b[1m';
// Bold blue
// 굵은파랑
const reset = '\x1b[0m';
// Reset color
// 기본 색상으로 초기화

// Assuming this file is inside the applimode project. Use './../..' if it's standalone.
// applimode 프로젝트 내에 있기 때문에, 단독으로 쓸일 경우 ./../
// const projectsPath = './../..';
// const currentProjectPath = './..';
// const currentProjectPath = getCurrentDirectoryName() == 'applimode-tool' ? './..' : '.';
// const projectsPath = `${currentProjectPath}/..`
const currentProjectPath = path.dirname(__dirname);
const projectsPath = path.dirname(path.dirname(__dirname));;


const currentLibPath = `${currentProjectPath}/lib`;

// Settings class for storing values in custom_settings.dart
// custom_settings.dart 파일의 값을 저장하는 Settings 클래스
class Settings {
  constructor(comment, type, key, value) {
    this.comment = comment;
    this.type = type;
    this.key = key;
    this.value = value;
  }
}

// Function to ask a question in the console and return the user's answer
// 콘솔에서 질문을 하고 사용자의 답변을 반환하는 함수
function ask(question) {
  return new Promise(resolve => {
    readline.question(question, answer => {
      resolve(answer);
    });
  });
}

// Function to ask a required question and validate the answer
// 필수 질문을 하고 답변을 검증하는 함수
async function askRequired(question, validator, invalidMessage) {
  let answer;
  do {
    answer = await ask(question);
    if (!validator(answer)) {
      console.log(invalidMessage);
    }
  } while (!validator(answer));
  return answer;
}

// Function to check if a value is empty
// 값이 비어 있는지 확인하는 함수
function isEmpty(value) {
  if (value == "" || value == null || value == undefined || value.trim() == "") {
    return true;
  } else if (typeof value === 'string' && (value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
    // Remove quotes and trim if the value is enclosed in double or single quotes
    // 큰따옴표 또는 작은따옴표로 둘러싸인 경우 따옴표 제거 후 trim() 실행
    value = value.substring(1, value.length - 1).trim();
    if (value == "") {
      return true;
    }
  } 
  return false;
}

// Function to check if a directory exists
// 디렉토리가 존재하는지 확인하는 함수
async function checkDirectoryExists(directoryPath) {
  try {
    await fs.access(directoryPath, fs.constants.F_OK);
    return true;
  } catch (err) {
    return false;
  }
}

// Get parent folder of Applimode project folder
// Applimode 프로젝트 폴더의 상위 폴더 가져오기
async function getProjectsPath() {
  const amMainDirName = await getAmMainDirectoryName();
  const isExTool = await checkDirectoryExists(path.join(currentProjectPath, amMainDirName));
  if (path.basename(currentProjectPath) == amMainDirName) {
    return projectsPath;
  } else if (isExTool) {
    return currentProjectPath;
  } else {
    return '';
  }
}

// Extract current directory name
// 현재 디렉토리 이름 추출
function getCurrentDirectoryName() {
  return path.basename(process.cwd());
}

// Extract parent directory name
// 상위 프로젝트 이름 추출
function getAncestorDirectoryName(levelsUp = 1) {
  let currentPath = process.cwd();
  for (let i = 0; i < levelsUp; i++) {
      currentPath = path.dirname(currentPath);
  }
  return path.basename(currentPath);
}

// Function to check if a value exceeds the maximum length
// 값이 최대 길이를 초과하는지 확인하는 함수
function overMax(value, max) {
  if (value.length > max) {
    return false;
  } else {
    return true;
  }
}

// Function to replace a phrase in a file
// 파일에서 문구를 바꾸는 함수
async function replacePhrase(filePath, oldPhrase, newPhrase) {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    const newData = data.replace(new RegExp(oldPhrase, 'g'), newPhrase);
    if (data !== newData) {
      await fs.writeFile(filePath, newData, 'utf8');
      console.log(`Replaced "${blue}${oldPhrase}${reset}" with "${blue}${newPhrase}${reset}" in ${blue}${filePath}${reset}`);
    }
  } catch (err) {
    console.error(`${red}Error processing ${filePath}: ${err.message}${reset}`);
  }
}

// Function to recursively process a directory and replace phrases in files
// 디렉토리를 재귀적으로 처리하고 파일에서 문구를 바꾸는 함수
async function processDirectory(folderPath, oldPhrase, newPhrase) {
  const files = await fs.readdir(folderPath);

  for (const file of files) {
    const filePath = path.join(folderPath, file);
    const stats = await fs.stat(filePath);
    const extname = path.extname(file);

    // Skip media files
    // 미디어 파일은 건너뛰기
    if (['.jpg', '.jpeg', '.png', '.gif', '.mp3', '.mp4', '.svg', '.webp', '.apng', 'ico'].includes(extname.toLowerCase())) {
      // console.log(`is Media: ${filePath}`);
      continue;
    }

    // Skip 'applimode-tool' folder
    // 'applimode-tool' 폴더는 건너뛰기
    if (file.startsWith('applimode-tool')) {
      console.log(`${blue}Skipping "applimode-tool" folder: ${filePath}${reset}`);
      continue;
    }

    if (stats.isDirectory()) {
      await processDirectory(filePath, oldPhrase, newPhrase);
    } else if (stats.isFile()) {
      await replacePhrase(filePath, oldPhrase, newPhrase);
    }
  }
}

// Function to extract values from custom_settings.dart file
// custom_settings.dart 파일에서 값을 추출하는 함수
function getSettingsList(settingsFile) {
  // Remove import statements and split the file by semicolons
  // import 문을 제거하고 세미콜론으로 파일을 분할
  const settingsRawList = settingsFile.replace(new RegExp('import \'package:(.*);', 'g'), '').split(';');
  let settingsList = [];
  for (let i = 0; i < settingsRawList.length; i++) {
    // Split each line by 'const' or '='
    // 각 줄을 'const' 또는 '='로 분할
    const componants = settingsRawList[i].split(/const|=/);
    const comment = componants[0] == undefined ? '' : componants[0].trim();
    const typeKey = componants[1] == undefined ? '' : componants[1].trim().split(' ');
    const type = typeKey[0] == undefined ? '' : typeKey[0].trim();
    const key = typeKey[1] == undefined ? '' : typeKey[1].trim();
    const value = componants[2] == undefined ? '' : componants[2].trim();
    if (key !== '' && value !== '') {
      settingsList.push(new Settings(comment, type, key, value));
    }

  }
  return settingsList;
}

// Compare and merge the contents of the old and new custom_settings.dart files.
// 이전과 새로운 custom_settings.dart파일의 컨텐츠를 비교하고 병합
function getNewCumtomSettingsStr(importsList, newCustomSettingsList, userCustomSettingsList) {
  let newUserCustomSettingsStr = '';

  // Add import statements
  // import 문 추가
  for (let i = 0; i < importsList.length; i++) {
    newUserCustomSettingsStr += `${importsList[i]}\n`;
  }

  // Add custom settings, preserving user's existing settings
  // 커스텀 설정 추가, 사용자의 기존 설정 유지
  for (let i = 0; i < newCustomSettingsList.length; i++) {
    for (let k = 0; k < userCustomSettingsList.length; k++) {
      if (newCustomSettingsList[i].key == userCustomSettingsList[k].key) {
        // If there is a value in the previous list, update it with the previous value.
        // 이전 리스트에 값이 있을 경우 이전 값으로 업데이트 
        newUserCustomSettingsStr += `\n\n${userCustomSettingsList[k].comment}\nconst ${userCustomSettingsList[k].type} ${userCustomSettingsList[k].key} = ${userCustomSettingsList[k].value};`;
        break;
      }

      if (k == userCustomSettingsList.length - 1 && newCustomSettingsList[i].key !== userCustomSettingsList[k].key) {
        // If there are no values ​​in the previous list until the last item in the list, update it.
        // 리스트 마지막 항목까지 이전 리스트에 값이 없을 경우 새로 업데이트
        newUserCustomSettingsStr += `\n\n${newCustomSettingsList[i].comment}\nconst ${userCustomSettingsList[i].type} ${newCustomSettingsList[i].key} = ${newCustomSettingsList[i].value};`;
        break;
      }
    }
  }

  // Remove extra newlines
  // 추가 줄 바꿈 제거
  newUserCustomSettingsStr = newUserCustomSettingsStr.replace(new RegExp('\n\n\n', 'g'), '\n\n');

  return newUserCustomSettingsStr;
}

// Function to copy files from a source directory to a destination directory
// 소스 디렉토리에서 대상 디렉토리로 파일을 복사하는 함수
async function copyFiles(sourceDir, destinationDir) {
  try {
    const files = await fs.readdir(sourceDir);

    for (const file of files) {
      const sourceFile = path.join(sourceDir, file);
      const destinationFile = path.join(destinationDir, file);

      await fs.copyFile(sourceFile, destinationFile);
      console.log(`copied ${blue}${file}${reset} to ${blue}${destinationDir}${reset}`);
    }
  } catch (err) {
    console.error(`${red}Error moving files: ${err}${reset}`);
  }
}

// Function to parse command line arguments
// 명령줄 인수를 구문 분석하는 함수
function parseArgs(args) {
  const options = {};
  // like --key=value
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    const [key, value] = arg.split('=');
    if (key.startsWith('--')) {
      options[key.slice(2)] = value;
    } else {
      options[key.slice(1)] = value;
    }
  }
  // like -key value
  /*
  let currentOption = null;
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg.startsWith('-')) {
      currentOption = arg.slice(1);
      options[currentOption] = '';
    } else if (currentOption !== null) {
      options[currentOption] = arg;
      currentOption = null;
    }
  }
  */
  return options;
}

// Function to get the name of the main Applimode directory
// 메인 Applimode 디렉토리의 이름을 가져오는 함수
async function getAmMainDirectoryName() {
  const applimodeMain = 'applimode-main';
  const isAmMainDirectory = await checkDirectoryExists(path.join(projectsPath, applimodeMain)) || await checkDirectoryExists(path.join(currentProjectPath, applimodeMain));
  // console.log(`isAmMainDirectory: ${isAmMainDirectory}`);
  if (isAmMainDirectory) {
    return applimodeMain;
  } else {
    return 'applimode';
  }
}

// Function to extract version information from a pubspec.yaml file
// pubspec.yaml 파일에서 버전 정보를 추출하는 함수
function getVersionMatch(pubspecFile) {
  const pubspecLines = pubspecFile.split('\n');
  for (let line of pubspecLines) {
    if (line.startsWith('version:')) {
      return line.match(check_version);
    }
  }
  return '0.0.0+0'.match(check_version);
}

// Function to check if the current Applimode version is the latest
// 현재 Applimode 버전이 최신 버전인지 확인하는 함수
async function isLatestVersion(newPubspecPath, userPubspecPath) {
  const newPubspecFile = await fs.readFile(newPubspecPath, 'utf8');
  const userPubspecFile = await fs.readFile(userPubspecPath, 'utf8');

  const newMatch = getVersionMatch(newPubspecFile);
  const userMatch = getVersionMatch(userPubspecFile);

  const [newVersion, newMajor, newMinor, newPatch, newBuild] = [newMatch[0], parseInt(newMatch[1]), parseInt(newMatch[2]), parseInt(newMatch[3]), parseInt(newMatch[4])];
  const [userVersion, userMajor, userMinor, userPatch, userBuild] = [userMatch[0], parseInt(userMatch[1]), parseInt(userMatch[2]), parseInt(userMatch[3]), parseInt(userMatch[4])];

  console.log(`newVersion: ${blue}${newVersion}${reset}`);
  console.log(`userVersion: ${blue}${userVersion}${reset}`);

  if (!(newMajor > userMajor || newMajor == userMajor && newMinor > userMinor || newMajor == userMajor && newMinor == userMinor && newPatch > userPatch || newMajor == userMajor && newMinor == userMinor && newPatch == userPatch && newBuild > userBuild) || newVersion == '0.0.0+0' || userVersion == '0.0.0+0') {
    return true;
  } else {
    return false;
  }
}

// Function to extract a value from a file using a regular expression
// 파일에서 정규 표현식을 사용하여 값을 추출하는 함수
async function extractValueFromFile(filepath, filename, regex) {
  const filePath = path.join(filepath, filename);

  try {
    const data = await fs.readFile(filePath, 'utf8');
    const match = data.match(regex);

    if (match && match[1]) {
      // console.log(`${blue}current value: ${match[1]}${reset}`);
      return match[1];
    } else {
      console.error(`${red}${regex} not found in ${filename}${reset}`);
      return null;
    }
  } catch (err) {
    console.error(`${red}Error reading or processing ${filePath}: ${err.message}${reset}`);
    return null;
  }
}

// Function to remove quotes from a string
// 문자열에서 따옴표를 제거하는 함수
function removeQuotes(str) {
  if (str.startsWith('"') && str.endsWith('"') || str.startsWith("'") && str.endsWith("'")) {
    return str.slice(1, -1);
  } else {
    return str;
  }
}

// Get command-line arguments
const command = process.argv.slice(2, 3);
// Skip first two arguments (node and script filename)
// node와 스크립트 파일 이름인 처음 두 인수를 건너뜁니다.
const args = process.argv.slice(3);

// Parse arguments
const options = parseArgs(args);

// Define default names
// 기본 이름 정의
const amAndBundleId = 'applimode.my_applimode';
const amIosBundleId = 'applimode.myApplimode'
const amUniName = 'my_applimode';
const amCamelName = 'myApplimode';
const amFullName = 'My Applimode';
const amShortName = 'AMB';
const amFbName = 'my-applimode';
const amOrgnizationName = 'applimode';
const amWorkerKey = 'yourWorkerKey';
const amMainColor = 'FCB126';

// Extract arguments or use default values if not provided
// 인수를 추출하거나 제공되지 않은 경우 기본값을 사용
const oUserProjectName = options['project-name'] || options['p'];
const oUserFullName = options['full-name'] || options['f'];
const oUserShortName = options['short-name'] || options['s'] || oUserFullName;
const oUserOrganizationName = options['organization-name'] || options['o'];
// const oUserFirebaseName = options['firebase-name'] || options['b'];
const oUserProjectFolderName = options['directory-name'] || options['d'];
const oUserCloudflareWorkerKey = options['worker-key'] || options['w'];
const oUserMainColor = options['main-color'] || options['c'];

const customSettingsFile = 'custom_settings.dart';
const envFile = '.env';
const pubspecFile = 'pubspec.yaml';
const indexFile = 'index.html';
const fbMessageFile = 'firebase-messaging-sw.js';
const manifestFile = 'manifest.json';
const firestoreRulesFile = 'firestore.rules';
const firebasercFile = '.firebaserc';
const infoPlistFile = 'Info.plist';

// Initialize Applimode
// Applimode 초기화
async function initApplimode() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's get started.${reset}`);

  // Check if applimode or applimode-main directory exists
  // applimode 또는 applimode-main 디렉토리가 있는지 확인
  const amMainDirName = await getAmMainDirectoryName();

  // Check if applimode-tool is outside the project folder
  // applimode-tool이 프로젝트 폴더 외부에 있을 경우 확인
  const initProjectsPath = await getProjectsPath();
  if (isEmpty(initProjectsPath)) {
    console.log(`${red}The ${amMainDirName} directory does not exist.${reset}`);
    return;
  }
  
  const amMainRootPath = `${initProjectsPath}/${amMainDirName}`;
  const kotlinOrganizationPath = `${amMainRootPath}/android/app/src/main/kotlin/com`
  const kotlinAndBundleIdPath = `${amMainRootPath}/android/app/src/main/kotlin/com/applimode`

  // Check if the main directory exists
  // 메인 디렉토리가 존재하는지 확인
  const checkMainDirectory = await checkDirectoryExists(amMainRootPath);
  if (!checkMainDirectory) {
    console.log(`${red}The ${amMainDirName} directory does not exist.${reset}`);
    return;
  }

  let userProjectName = '';

  // Get project name from parameter
  // 프로젝트 이름을 파라미터로 받는 경우
  if (!isEmpty(oUserProjectName) && check_projectName.test(oUserProjectName)) {
    userProjectName = oUserProjectName
  } else {
    // Get project name from user input
    // 프로젝트 이름 파라미터 없을 경우, 유저 입력
    userProjectName = await askRequired(
      `(1/4) ${greenBold}Enter your project name (letters only, required): ${reset}`,
      answer => !isEmpty(answer) && check_projectName.test(answer),
      `${red}Can only contain letters, spaces, and these characters: _ -${reset}`
    );
  }

  const splits = userProjectName.split(/ |_|-/);

  let underbarName = '';
  let camelName = '';
  let andBundleId = '';
  let iosBundleId = '';
  let appFullName = '';
  let appShortName = '';
  let appOrganizationName = '';

  for (let i = 0; i < splits.length; i++) {
    let word = splits[i].toLowerCase().trim();
    if (word.length === 0) {
      // Skip if word is empty
      // word의 길이가 0이면 다음 반복으로 넘어갑니다.
      continue; 
    }
    if (i == 0) {
      let firstChar = word.charAt(0);
      let others = word.slice(1);
      let firstUpperWord = firstChar.toUpperCase() + others;
      underbarName += word;
      camelName += word;
      appFullName += firstUpperWord;
      appShortName += firstUpperWord;
      appOrganizationName += word;
    } else {
      let firstChar = word.charAt(0);
      let others = word.slice(1);
      let firstUpperWord = firstChar.toUpperCase() + others;
      underbarName += `_${word}`;
      camelName += firstUpperWord;
      appFullName += ` ${firstUpperWord}`;
      appShortName += ` ${firstUpperWord}`;
      appOrganizationName += word;
    }
  }

  // Get app full name from parameter
  // 앱 풀네임 파라미터로 받는 경우
  if (!isEmpty(oUserFullName)) {
    appFullName = oUserFullName;
  } else {
    // Get app full name from user input
    // 풀네임 파라미터 없을 경우, 유저 입력 및 기본값 설정
    const inputAppFullName = await ask(`(2/4) ${greenBold}Enter your full app name (default: ${appFullName}): ${reset}`);
    appFullName = isEmpty(inputAppFullName) ? appFullName : inputAppFullName;
  }

  // Get app short name from parameter
  // 앱 숏네임 파라미터로 받는 경우
  if (!isEmpty(oUserShortName)) {
    appShortName = oUserShortName;
  } else {
    // Get app short name from user input
    // 숏네임 파라미터 없을 경우, 유저 입력 및 기본값 설정, 어디에서 사용되는지도 설명
    const inputAppShortName = await ask(`(3/4) ${greenBold}Enter your short app name (default: ${appShortName}): ${reset}`);
    appShortName = isEmpty(inputAppShortName) ? appShortName : inputAppShortName;
  }

  // Get organization name from parameter
  // 조직이름 파라메터로 받는 경우
  if (!isEmpty(oUserOrganizationName) && check_eng.test(oUserOrganizationName)) {
    appOrganizationName = oUserOrganizationName.trim().toLowerCase();
  } else {
    // Get organization name from user input
    // 조직이름 파라미터 없을 경우, 유저 입력 및 기본값 설정
    const inputAppOrganizationName = await askRequired(
      `(4/4) ${greenBold}Enter your organization name (letters only, default: ${appOrganizationName}): ${reset}`,
      answer => check_eng.test(answer),
      `${red}Can only contain letters${reset}`
    );
    appOrganizationName = isEmpty(inputAppOrganizationName) ? appOrganizationName : inputAppOrganizationName.trim().toLowerCase();
  }

  andBundleId = `${appOrganizationName}.${underbarName}`;
  iosBundleId = `${appOrganizationName}.${camelName}`;

  await processDirectory(amMainRootPath, amAndBundleId, andBundleId);
  await processDirectory(amMainRootPath, amIosBundleId, iosBundleId);
  await processDirectory(amMainRootPath, amUniName, underbarName);
  await processDirectory(amMainRootPath, amCamelName, camelName);
  await processDirectory(amMainRootPath, amFullName, appFullName);
  await processDirectory(amMainRootPath, amShortName, appShortName);

  // If Cloudflare worker key is provided as a parameter
  // 파라미터로 워커키 전달할 경우
  if (!isEmpty(oUserCloudflareWorkerKey)) {
    await processDirectory(amMainRootPath, amWorkerKey, oUserCloudflareWorkerKey);
  }

  // If main color is provided as a parameter
  // 파라미터로 메인컬러 전달할 경우
  if (!isEmpty(oUserMainColor)) {
    await processDirectory(amMainRootPath, amMainColor, oUserMainColor);
  }

  await fs.rename(path.join(kotlinAndBundleIdPath, amUniName), path.join(kotlinAndBundleIdPath, underbarName));
  await fs.rename(path.join(kotlinOrganizationPath, amOrgnizationName), path.join(kotlinOrganizationPath, appOrganizationName));
  await fs.rename(path.join(initProjectsPath, amMainDirName), path.join(initProjectsPath, underbarName));

  console.log(`${yellow}👋 Applimode initialization was successful.${reset}`);
}

// Upgrade Applimode
// Applimode 업그레이드
async function upgradeApplimode() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's get upgraded.${reset}`);

  const amMainDirName = await getAmMainDirectoryName();

  // Check if applimode-tool is outside the project folder
  // applimode-tool이 프로젝트 폴더 외부에 있을 경우 확인
  const initProjectsPath = await getProjectsPath();
  if (isEmpty(initProjectsPath)) {
    console.log(`${red}The ${amMainDirName} directory does not exist.${reset}`);
    return;
  }

  const amMainRootPath = `${initProjectsPath}/${amMainDirName}`;
  const amMainLibPath = `${amMainRootPath}/lib`
  const kotlinOrganizationPath = `${amMainRootPath}/android/app/src/main/kotlin/com`
  const kotlinAndBundleIdPath = `${amMainRootPath}/android/app/src/main/kotlin/com/applimode`

  // Check if the main directory exists
  // 메인 디렉토리가 존재하는지 확인
  const checkMainDirectory = await checkDirectoryExists(amMainRootPath);
  if (!checkMainDirectory) {
    console.log(`${red}The ${amMainDirName} directory does not exist.${reset}`);
    return;
  }

  let userProjectFolderName = '';

  // Get project folder name from parameter
  // 프로젝트 폴더 이름을 파라미터로 받는 경우
  if (!isEmpty(oUserProjectFolderName)) {
    userProjectFolderName = oUserProjectFolderName
  } else {
    // Get project folder name from user input
    // 프로젝트 폴더 이름 파라미터 없을 경우, 유저 입력
    userProjectFolderName = await askRequired(
      `(1/1) ${greenBold}Enter your project folder name (required): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Your project folder name is invalid.${reset}`
    );
  }

  const newRootPath = amMainRootPath;
  const userRootPath = `${initProjectsPath}/${userProjectFolderName}`;

  // Check if the project directory exists
  // 프로젝트 디렉토리가 존재하는지 확인
  const checkProjectDirectory = await checkDirectoryExists(userRootPath);
  if (!checkProjectDirectory) {
    console.log(`${red}Your project directory does not exist.${reset}`);
    return;
  }

  const newLibPath = amMainLibPath;
  const userLibPath = `${userRootPath}/lib`;
  const newImagesPath = `${amMainRootPath}/assets/images`;
  const userImagesPath = `${userRootPath}/assets/images`;
  const newWebPath = `${amMainRootPath}/web`;
  const userWebPath = `${userRootPath}/web`;

  const newPubspecPath = path.join(newRootPath, pubspecFile);
  const userPubspecPath = path.join(userRootPath, pubspecFile);

  const isLatest = await isLatestVersion(newPubspecPath, userPubspecPath);

  if (isLatest) {
    console.log(`${yellow}👋 Your Applimode is up to date.${reset}`);
    return;
  }

  const newEnvPath = path.join(newRootPath, envFile);
  const userEnvPath = path.join(userRootPath, envFile);
  const newCustomSettingsPath = path.join(newLibPath, customSettingsFile);
  const userCustomSettingsPath = path.join(userLibPath, customSettingsFile);
  const newIndexPath = path.join(newWebPath, indexFile);
  const userIndexPath = path.join(userWebPath, indexFile);
  const newFbMessagePath = path.join(newWebPath, fbMessageFile);
  const userFbMessagePath = path.join(userWebPath, fbMessageFile);
  const newManifestPath = path.join(newWebPath, manifestFile);
  const userManifestPath = path.join(userWebPath, manifestFile);

  const newFirebasercPath = path.join(newRootPath, firebasercFile);
  const userFirebasercPath = path.join(userRootPath, firebasercFile);
  const newInfoPlistPath = path.join(newRootPath, 'ios/Runner', infoPlistFile);
  const userInfoPlistPath = path.join(userRootPath, 'ios/Runner', infoPlistFile);

  // const newEnvFile = await fs.readFile(newEnvPath, 'utf8');
  const userEnvFile = await fs.readFile(userEnvPath, 'utf8');
  const newCustomSettingsFile = await fs.readFile(newCustomSettingsPath, 'utf8');
  const userCustomSettingsFile = await fs.readFile(userCustomSettingsPath, 'utf8');
  const userIndexFile = await fs.readFile(userIndexPath, 'utf8');
  const userFbMessageFile = await fs.readFile(userFbMessagePath, 'utf8');
  const userManifestFile = await fs.readFile(userManifestPath, 'utf8');
  // const userFirebasercFile = await fs.readFile(userFirebasercPath, 'utf8');
  const userInfoPlistFile = await fs.readFile(userInfoPlistPath, 'utf8');

  let fullAppName = '';
  let shortAppName = '';
  let underbarAppName = '';
  let camelAppName = '';
  let androidBundleId = '';
  let appleBundleId = '';
  // let firebaseProjectName = '';
  let mainColor = '';

  const importsList = newCustomSettingsFile.match(new RegExp('import \'package:(.*);', 'g'));

  const newCustomSettingsList = getSettingsList(newCustomSettingsFile);
  const userCustomSettingsList = getSettingsList(userCustomSettingsFile);

  for (let i = 0; i < userCustomSettingsList.length; i++) {
    if (userCustomSettingsList[i].key == 'fullAppName') {
      fullAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'shortAppName') {
      shortAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'underbarAppName') {
      underbarAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'camelAppName') {
      camelAppName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'androidBundleId') {
      androidBundleId = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    if (userCustomSettingsList[i].key == 'appleBundleId') {
      appleBundleId = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
    // if (userCustomSettingsList[i].key == 'firebaseProjectId') {
    //   firebaseProjectName = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    // }
    if (userCustomSettingsList[i].key == 'spareMainColor') {
      mainColor = userCustomSettingsList[i].value.replace(new RegExp(/['"]/, 'g'), '').trim();
    }
  }

  const organizationName = androidBundleId.replace(`.${underbarAppName}`, '').trim();

  // Change names in docs
  await processDirectory(amMainRootPath, amAndBundleId, androidBundleId);
  await processDirectory(amMainRootPath, amIosBundleId, appleBundleId);
  await processDirectory(amMainRootPath, amUniName, underbarAppName);
  await processDirectory(amMainRootPath, amCamelName, camelAppName);
  await processDirectory(amMainRootPath, amFullName, fullAppName);
  await processDirectory(amMainRootPath, amShortName, shortAppName);
  // await processDirectory(amMainRootPath, amFbName, firebaseProjectName);
  await processDirectory(amMainRootPath, amMainColor, mainColor);

  // Rename MainActivity.kt
  // MainActivity.kt 이름 변경
  await fs.rename(path.join(kotlinAndBundleIdPath, amUniName), path.join(kotlinAndBundleIdPath, underbarAppName));
  // Rename organization directory
  // 조직 디렉토리 이름 변경
  await fs.rename(path.join(kotlinOrganizationPath, amOrgnizationName), path.join(kotlinOrganizationPath, organizationName));

  // Generate custom_settings.dart file
  // custom_settings.dart 파일 생성
  const newUserCustomSettingsStr = getNewCumtomSettingsStr(importsList, newCustomSettingsList, userCustomSettingsList);
  await fs.writeFile(newCustomSettingsPath, newUserCustomSettingsStr, 'utf8');

  // Generate .env file
  // .env 파일 생성
  await fs.writeFile(newEnvPath, userEnvFile, 'utf8');

  // Copy user's index.html file
  // 사용자의 index.html 파일 복사
  await fs.writeFile(newIndexPath, userIndexFile, 'utf8');

  // Copy user's firebase-messaging-sw.js file
  // 사용자의 firebase-messaging-sw.js 파일 복사
  await fs.writeFile(newFbMessagePath, userFbMessageFile, 'utf8');

  // Copy user's manifest.json file
  // 사용자의 manifest.json 파일 복사
  await fs.writeFile(newManifestPath, userManifestFile, 'utf8');

  // Copy user's .firebaserc file
  // 사용자의 .firebaserc 파일 복사
  // await fs.writeFile(newFirebasercPath, userFirebasercFile, 'utf8');

  // Copy user's Info.plist file
  // 사용자의 Info.plist 파일 복사
  await fs.writeFile(newInfoPlistPath, userInfoPlistFile, 'utf8');
  
  // firestore.rules 파일 업데이트하기

  // 기존 admin 및 verified id들 업데이트하기
  const userRulesPath = path.join(userRootPath, firestoreRulesFile);
  const newRulesPath = path.join(newRootPath, firestoreRulesFile);
  let userRulesContent = await fs.readFile(userRulesPath, 'utf8');
  let newRulesContent;

  // 기존 룰이 allUserAccess 인지 확인
  const isUserRulesAllMatch = userRulesContent.match(allUserAccessRegex);
  // 기존 signedUserAccess 인지 확인
  const isUserRulesSignedMatch = userRulesContent.match(signedAccessRegex);
  // 기존 룰이 verifiedUserAccess 인지 확인
  const isUserRulesVerifiedMatch = userRulesContent.match(verifiedAccessRegex);
  // 기존 룰에서 isAdmin 함수 찾기
  const isUserAdminMatch = userRulesContent.match(adminFunctionRegex);
  // 기존 룰에서 isVerified 함수 찾기
  const isUserVerifiedMatch = userRulesContent.match(verifiedFunctionRegex);
  
  if (isUserRulesSignedMatch) {
    newRulesContent = await fs.readFile(path.join(newRootPath, 'presettings/fs_authed.firestore.rules'), 'utf8');
  } else if (isUserRulesVerifiedMatch) {
    newRulesContent = await fs.readFile(path.join(newRootPath, 'presettings/fs_verified.firestore.rules'), 'utf8');
  } else {
    newRulesContent = await fs.readFile(path.join(newRootPath, 'presettings/fs_open.firestore.rules'), 'utf8');
  }

  if (isUserAdminMatch) {
    newRulesContent = newRulesContent.replace(
      adminFunctionRegex, isUserAdminMatch[0],
    );
  }

  if (isUserVerifiedMatch) {
    newRulesContent = newRulesContent.replace(
      verifiedFunctionRegex, isUserVerifiedMatch[0],
    );
  }
  
  // Update firestore.rules file
  try {
    await fs.writeFile(newRulesPath, newRulesContent, 'utf8');
    console.log(`Updated ${blue}firestore.rules${reset}.`);
  } catch (err) {
    console.error(`${red}Error updating firestore.rules: ${err.message}${reset}`);
  }

  // Move images
  // 이미지 이동
  await copyFiles(userImagesPath, newImagesPath);

  // Rename directories
  // 디렉토리 이름 변경
  await fs.rename(path.join(initProjectsPath, userProjectFolderName), path.join(initProjectsPath, `${userProjectFolderName}_old`));
  await fs.rename(path.join(initProjectsPath, amMainDirName), path.join(initProjectsPath, userProjectFolderName));

  console.log(`${yellow}👋 Applimode upgrade was successful.${reset}`);
}

// Set app full name
// 앱 전체 이름 설정
async function setAppFullName() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app full name.${reset}`);

  let oldFullAppName = '';
  let newFullAppName = '';

  oldFullAppName = await extractValueFromFile(currentLibPath, customSettingsFile, fullNameRegex);
  if (isEmpty(oldFullAppName)) {
    console.log(`${red}fullname not found.${reset}`);
    return;
  }

  const singleArg = args.join(' ');

  if (isEmpty(singleArg)) {
    newFullAppName = await askRequired(
      `(1/1) ${greenBold}Enter a new full app name (required): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter a full app name that is at least 1 character long${reset}`
    );
  } else {
    newFullAppName = removeQuotes(singleArg).trim();
  }

  // Target files for replacement
  // 변경 대상 파일
  const targetFiles = [
    { path: 'linux/my_application.cc', regex: null },
    { path: 'pubspec.yaml', regex: null },
    { path: 'web/index.html', regex: null },
    { path: 'lib/custom_settings.dart', regex: /(const String fullAppName =[\s\r\n]*').*(';)/ },
    { path: 'lib/custom_settings.dart', regex: /(const String spareHomeBarTitle =[\s\r\n]*').*(';)/ },
    { path: 'web/manifest.json', regex: /("name": ").*(",)/ },
    { path: 'web/manifest.json', regex: /("description": ").*(",)/ },
  ];

  for (const file of targetFiles) {
    const filePath = path.join(currentProjectPath, file.path);

    // Check if the file exists
    // 파일 존재 여부 확인
    const fileExists = await checkDirectoryExists(filePath);
    if (!fileExists) {
      console.warn(`${yellow}Warning: File not found: ${filePath}${reset}`);
      continue;
      // Skip to the next file if it doesn't exist
      // 파일이 없으면 다음 파일로 넘어갑니다.
    }

    if (file.regex) {
      // Replace using regex
      // 정규표현식을 사용하여 특정 부분만 변경
      await replacePhraseInFile(filePath, file.regex, `$1${newFullAppName}$2`);
    } else {
      // Replace entire file content
      // 파일 전체에서 문구 변경
      await replacePhrase(filePath, oldFullAppName, newFullAppName);
    }
  }

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// Set app short name
// 앱 짧은 이름 설정
async function setAppShortName() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app short name.${reset}`);

  let oldShortAppName = '';
  let newShortAppName = '';

  oldShortAppName = await extractValueFromFile(currentLibPath, customSettingsFile, shortNameRegex);
  if (isEmpty(oldShortAppName)) {
    console.log(`${red}shortname not found.${reset}`);
    return;
  }

  const singleArg = args.join(' ');

  if (isEmpty(singleArg)) {
    newShortAppName = await askRequired(
      `(1/1) ${greenBold}Enter a new short app name (required): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter a short app name that is at least 1 character long${reset}`
    );
  } else {
    newShortAppName = removeQuotes(singleArg).trim();
  }

  // console.log(`old: ${oldShortAppName}`);
  // console.log(`new: ${newShortAppName}`);

  // Target files for replacement
  // 변경 대상 파일
  const targetFiles = [
    { path: 'android/app/src/main/AndroidManifest.xml', regex: null },
    { path: 'ios/Runner/Info.plist', regex: null },
    { path: 'lib/custom_settings.dart', regex: /(const String shortAppName =[\s\r\n]*').*(';)/ },
    { path: 'web/manifest.json', regex: /("short_name": ").*(",)/ },
  ];

  for (const file of targetFiles) {
    const filePath = path.join(currentProjectPath, file.path);

    // Check if the file exists
    // 파일 존재 여부 확인
    const fileExists = await checkDirectoryExists(filePath);
    if (!fileExists) {
      console.warn(`${yellow}Warning: File not found: ${filePath}${reset}`);
      continue;
      // Skip to the next file if it doesn't exist
      // 파일이 없으면 다음 파일로 넘어갑니다.
    }

    if (file.regex) {
      // Replace using regex
      // 정규표현식을 사용하여 특정 부분만 변경
      await replacePhraseInFile(filePath, file.regex, `$1${newShortAppName}$2`);
    } else {
      // Replace entire file content
      // 파일 전체에서 문구 변경
      await replacePhrase(filePath, oldShortAppName, newShortAppName);
    }
  }

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// Set app organization name
// 앱 조직 이름 설정
async function setAppOrganizationName() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app organization name.${reset}`);

  let oldOrganizationName = '';
  let newOrganizationName = '';

  const androidBundleId = await extractValueFromFile(currentLibPath, customSettingsFile, androidBundleIdRegex);
  const appleBundleId = await extractValueFromFile(currentLibPath, customSettingsFile, appleBundleIdRegex);
  if (isEmpty(androidBundleId) || isEmpty(appleBundleId) || !androidBundleId.includes('.') || !appleBundleId.includes('.')) {
    console.log(`${red}organization not found.${reset}`);
    return;
  }

  oldOrganizationName = androidBundleId.split('.')[0];
  const androidUnderbarName = androidBundleId.split('.')[1];
  const appleCamelName = appleBundleId.split('.')[1];

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || !check_eng.test(singleArg)) {
    if (!isEmpty(singleArg) && !check_eng.test(singleArg)) {
      console.log(`${red}Can only contain letters${reset}`);
    }
    newOrganizationName = await askRequired(
      `(1/1) ${greenBold}Enter a new organization name (required): ${reset}`,
      answer => !isEmpty(answer) && check_eng.test(answer),
      `${red}Can only contain letters${reset}`
    );
  } else {
    newOrganizationName = removeQuotes(singleArg).trim();
  }

  // console.log(`old: ${oldOrganizationName}`);
  // console.log(`new: ${newOrganizationName}`);

  const newAndroidBundleId = `${newOrganizationName}.${androidUnderbarName}`;
  const newAppleBundleId = `${newOrganizationName}.${appleCamelName}`;

  const kotlinOrganizationPath = `${currentProjectPath}/android/app/src/main/kotlin/com`

  await processDirectory(currentProjectPath, androidBundleId, newAndroidBundleId);
  await processDirectory(currentProjectPath, appleBundleId, newAppleBundleId);

  await fs.rename(path.join(kotlinOrganizationPath, oldOrganizationName), path.join(kotlinOrganizationPath, newOrganizationName));

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// Generate .firebaserc file
// .firebaserc 파일 생성
async function generateFirebaserc() {
  try {
    const firebaseJson = JSON.parse(await fs.readFile(`${currentProjectPath}/firebase.json`, 'utf8'));

    // Extract projectId
    // projectId 추출
    let projectId = firebaseJson.flutter?.platforms?.android?.default?.projectId;

    if (!projectId) {
      const firebaseOptionsContent = await fs.readFile(`${currentProjectPath}/lib/firebase_options.dart`, 'utf8');
      const regex = /projectId:\s*'([^']+)'/; 
      // Regex for extracting projectId
      // projectId 추출을 위한 정규 표현식
      const match = firebaseOptionsContent.match(regex);
      projectId = match ? match[1] : null;
    }

    // Throw error if projectId is not found
    // projectId를 찾지 못하면 오류 발생
    if (!projectId) {
      throw new Error(`${red}error: We can't find your Firebase project id. Run${reset} ${blueBold}firebase init firestore${reset}${red}, then type n to all questions.${reset}`);
    }

    // Create .firebaserc file content
    // .firebaserc 파일 내용 생성
    const firebasercContent = {
      "projects": {
        "default": projectId
      }
    };

    // Write .firebaserc file asynchronously
    // .firebaserc 파일 작성 (비동기)
    await fs.writeFile(`${currentProjectPath}/.firebaserc`, JSON.stringify(firebasercContent, null, 2) + '\n');
    // Update firebaseProjectId in custom_settings.dart
    // custom_settings.dart 의 firebaseProjectId 값 변경
    await replacePhraseInFile(
      `${currentLibPath}/${customSettingsFile}`,
      firebaseIdRegex,
      `const String firebaseProjectId = '${projectId}';`
    );

    console.log(`${yellow}👋 .firebaserc file has been created.${reset}`);
  } catch (error) {
    console.error(`${red}error: We can't find your Firebase project id. Run${reset} ${blueBold}firebase init firestore${reset}${red}, then type n to all questions.${reset}`);
  }
}

// Set app main color
// 앱 메인 색상 설정
async function setAppMainColor() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the app main color.${reset}`);

  let oldMainColor = '';
  let newMainColor = '';

  oldMainColor = await extractValueFromFile(currentLibPath, customSettingsFile, mainColorRegex);
  if (isEmpty(oldMainColor)) {
    console.log(`${red}main color not found.${reset}`);
    return;
  }

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || !check_hex_color.test(removeQuotes(singleArg))) {
    if (!isEmpty(singleArg) && !check_hex_color.test(removeQuotes(singleArg))) {
      console.log(`${red}Please enter a valid 6-digit hexadecimal color code.${reset}`);
    }
    newMainColor = await askRequired(
      `(1/1) ${greenBold}Enter a main color for your app (required): ${reset}`,
      answer => check_hex_color.test(answer),
      `${red}Please enter a valid 6-digit hexadecimal color code.${reset}`
    );
  } else {
    newMainColor = removeQuotes(singleArg);
  }

  newMainColor = newMainColor.replace(/^#/, '');

  // console.log(`old: ${oldMainColor}`);
  // console.log(`new: ${newMainColor}`);

  // Target files for replacement
  // 변경 대상 파일
  const targetFiles = [
    { path: 'flutter_launcher_icons.yaml', regex: /(theme_color: "#).*(")/ },
    { path: 'lib/custom_settings.dart', regex: /(const String spareMainColor =[\s\r\n]*').*(';)/ },
    { path: 'lib/src/app_settings/app_settings_controller.dart', regex: null },
    { path: 'lib/src/features/admin_settings/domain/app_main_category.dart', regex: null },
    { path: 'lib/src/utils/format.dart', regex: null },
    // 안드로이드 system bar를 검정색으로 유지하기 위해 변경하지 않음
    // { path: 'web/manifest.json', regex: /("theme_color": "#).*(",)/ },
  ];

  for (const file of targetFiles) {
    const filePath = path.join(currentProjectPath, file.path);

    // Check if the file exists
    // 파일 존재 여부 확인
    const fileExists = await checkDirectoryExists(filePath);
    if (!fileExists) {
      console.warn(`${yellow}Warning: File not found: ${filePath}${reset}`);
      continue;
      // Skip to the next file if it doesn't exist
      // 파일이 없으면 다음 파일로 넘어갑니다.
    }

    if (file.regex) {
      // Replace using regex
      // 정규표현식을 사용하여 특정 부분만 변경
      await replacePhraseInFile(filePath, file.regex, `$1${newMainColor}$2`);
    } else {
      // Replace entire file content
      // 파일 전체에서 문구 변경
      await replacePhrase(filePath, oldMainColor, newMainColor);
    }
  }

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// Set app worker key
// 앱 worker 키 설정
async function setWorkerKey() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the Worker key.${reset}`);

  let newWorkerKey = '';

  const singleArg = args.join(' ');

  if (isEmpty(singleArg) || !check_password.test(removeQuotes(singleArg))) {
    if (!isEmpty(singleArg) && !check_password.test(removeQuotes(singleArg))) {
      console.log(`${red}Please enter a password of at least 4 characters, including at least one letter.${reset}`);
    }
    newWorkerKey = await askRequired(
      `(1/1) ${greenBold}Enter a Worker key for your app (required): ${reset}`,
      answer => check_password.test(answer),
      `${red}Please enter a password of at least 4 characters, including at least one letter.${reset}`
    );
  } else {
    newWorkerKey = removeQuotes(singleArg);
  }

  const newWorkerKeyContent = `WORKER_KEY=${newWorkerKey}`;

  await fs.writeFile(`${currentProjectPath}/.env`, newWorkerKeyContent, 'utf8');

  console.log(`${yellow}👋 The operation was successful.${reset}`);
}

// Set Firebase Cloud Messaging settings
// Firebase 클라우드 메시징 설정
async function setFcm() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the Firebase Cloud Messaging.${reset}`);

  const useFcmForAndroid = await askRequired(
    `(1/3) ${greenBold}Enable FCM for Android? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  const useFcmForIos = await askRequired(
    `(2/3) ${greenBold}Enable FCM for iOS (APNs)? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  const useFcmForWeb = await askRequired(
    `(3/3) ${greenBold}Enable FCM for Web? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  let vapidKey = '';
  if (/^(y|yes)$/i.test(useFcmForWeb)) {
    vapidKey = await askRequired(
      `(4/4) ${greenBold}Enter your VAPID key for Web (required, You can check your vapid here. Firebase Console > your project > Project settings > Cloud Messaging - Web Push certificates.): ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter your VAPID key.${reset}`
    );
  }

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useFcmMessageRegex,
    `const bool useFcmMessage = ${/^(y|yes)$/i.test(useFcmForAndroid)};`
  );

  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useApnsRegex,
    `const bool useApns = ${/^(y|yes)$/i.test(useFcmForIos)};`
  );

  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    fcmVapidKeyRegex,
    `const String fcmVapidKey = '${vapidKey}';`
  );

  // Extract values from firebase_options.dart and update firebase-messaging-sw.js and index.html
  // firebase_options.dart 파일에서 값 추출 및 firebase-messaging-sw.js, index.html에 입력
  if (/^(y|yes)$/i.test(useFcmForWeb)) {
    await updateFirebaseMessagingSw();
    // Update index.html if FCM for Web is enabled
    // FCM for Web 활성화 시 index.html 수정
    await updateIndexHtml(true); 
  } else {
    // Update index.html if FCM for Web is disabled
    // FCM for Web 비활성화 시 index.html 수정
    await updateIndexHtml(false); 
  }

  console.log(`${yellow}👋 Firebase Cloud Messaging settings have been updated.${reset}`);
}

// Function to replace a phrase in a file using regex
// 정규식을 사용하여 파일에서 특정 구문을 바꾸는 함수
async function replacePhraseInFile(filePath, regex, newPhrase) {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    const newData = data.replace(regex, newPhrase);
    await fs.writeFile(filePath, newData, 'utf8');
    console.log(`Updated ${blue}${filePath}${reset}`);
  } catch (err) {
    console.error(`${red}Error updating ${filePath}: ${err.message}${reset}`);
  }
}

// Update firebase-messaging-sw.js with values from firebase_options.dart
// firebase_options.dart의 값으로 firebase-messaging-sw.js 업데이트
async function updateFirebaseMessagingSw() {
  const firebaseOptionsPath = `${currentLibPath}/firebase_options.dart`;
  const firebaseMessagingSwPath = `${currentProjectPath}/web/firebase-messaging-sw.js`;

  try {
    const firebaseOptionsContent = await fs.readFile(firebaseOptionsPath, 'utf8');

    // Extract web options
    // 웹 옵션 부분 추출
    const webOptionsMatch = firebaseOptionsContent.match(/static const FirebaseOptions web = FirebaseOptions\(([\s\S]*?)\);/);
    if (!webOptionsMatch) {
      throw new Error(`${red}Error: Could not find FirebaseOptions for web in ${firebaseOptionsPath}${reset}`);
    }
    const webOptionsContent = webOptionsMatch[1];

    const apiKey = extractValueFromFirebaseOptions(webOptionsContent, /apiKey:\s*'([^']+)'/);
    const authDomain = extractValueFromFirebaseOptions(webOptionsContent, /authDomain:\s*'([^']+)'/);
    const projectId = extractValueFromFirebaseOptions(webOptionsContent, /projectId:\s*'([^']+)'/);
    const storageBucket = extractValueFromFirebaseOptions(webOptionsContent, /storageBucket:\s*'([^']+)'/);
    const messagingSenderId = extractValueFromFirebaseOptions(webOptionsContent, /messagingSenderId:\s*'([^']+)'/);
    const appId = extractValueFromFirebaseOptions(webOptionsContent, /appId:\s*'([^']+)'/);
    const measurementId = extractValueFromFirebaseOptions(webOptionsContent, /measurementId:\s*'([^']+)'/);

    let newContent = await fs.readFile(firebaseMessagingSwPath, 'utf8');

    // Find firebase.initializeApp section
    // firebase.initializeApp 부분 찾기
    const appInitMatch = newContent.match(/firebase\.initializeApp\(\{([\s\S]*?)\}\);/);
    if (!appInitMatch) {
      throw new Error(`${red}Error: Could not find firebase.initializeApp in ${firebaseMessagingSwPath}${reset}`);
    }
    const appInitContent = appInitMatch[1];

    // Replace values
    // 각 값을 새로운 값으로 치환
    let updatedAppInitContent = appInitContent
      .replace(/apiKey:\s*"[^"]*"/, `apiKey: "${apiKey}"`)
      .replace(/authDomain:\s*"[^"]*"/, `authDomain: "${authDomain}"`)
      .replace(/projectId:\s*"[^"]*"/, `projectId: "${projectId}"`)
      .replace(/storageBucket:\s*"[^"]*"/, `storageBucket: "${storageBucket}"`)
      .replace(/messagingSenderId:\s*"[^"]*"/, `messagingSenderId: "${messagingSenderId}"`)
      .replace(/appId:\s*"[^"]*"/, `appId: "${appId}"`)
      .replace(/measurementId:\s*"[^"]*"/, measurementId ? `measurementId: "${measurementId}"` : `// measurementId: "..."`);
      // measurementId가 없으면 주석 처리
      // Comment out measurementId if it doesn't exist


    // Update file content
    // 새로운 내용으로 파일 업데이트
    newContent = newContent.replace(appInitMatch[0], `firebase.initializeApp({\n${updatedAppInitContent}\n});`);

    await fs.writeFile(firebaseMessagingSwPath, newContent, 'utf8');
    console.log(`Updated ${blue}${firebaseMessagingSwPath}${reset}`);

  } catch (err) {
    console.error(`${red}Error updating ${firebaseMessagingSwPath}: ${err.message}${reset}`);
  }
}

// Function to extract a value from firebase options content using regex
// firebase options 내용에서 정규식을 사용하여 값을 추출하는 함수
function extractValueFromFirebaseOptions(content, regex) {
  const match = content.match(regex);
  return match ? match[1] : null;
}

// Update index.html based on FCM for Web setting
// FCM for Web 설정에 따라 index.html 업데이트
async function updateIndexHtml(enableFcmForWeb) {
  const indexHtmlPath = `${currentProjectPath}/web/index.html`;

  try {
    let indexHtmlContent = await fs.readFile(indexHtmlPath, 'utf8');

    // Find flutter_bootstrap.js section
    // flutter_bootstrap.js 부분 찾기
    const flutterBootstrapMatch = indexHtmlContent.match(/<!--flutter_bootstrap.js starts-->([\s\S]*?)<!--flutter_bootstrap.js ends-->/);
    if (!flutterBootstrapMatch) {
      throw new Error(`${red}Error: Could not find flutter_bootstrap.js section in ${indexHtmlPath}${reset}`);
    }

    let updatedFlutterBootstrapContent;

    if (enableFcmForWeb) {
      // Update for FCM enabled
      // FCM 활성화 시: 정해진 문구로 변경
      updatedFlutterBootstrapContent = `
  <!--
  <script src="flutter_bootstrap.js" async=""></script>
  -->
  <!--When using push notification for web app-->
  <script src="flutter_bootstrap.js" async="">
    if ('serviceWorker' in navigator) {
        // Service workers are supported. Use them.
        window.addEventListener('load', function () {
          // Register Firebase Messaging service worker.
          navigator.serviceWorker.register('firebase-messaging-sw.js', {
            scope: '/firebase-cloud-messaging-push-scope',
          });
        });
      }
  </script>
  `;
    } else {
      // Update for FCM disabled
      // FCM 비활성화 시: 정해진 문구로 변경
      updatedFlutterBootstrapContent = `
  <script src="flutter_bootstrap.js" async=""></script>
  <!--When using push notification for web app-->
  <!--
  <script src="flutter_bootstrap.js" async="">
    if ('serviceWorker' in navigator) {
        // Service workers are supported. Use them.
        window.addEventListener('load', function () {
          // Register Firebase Messaging service worker.
          navigator.serviceWorker.register('firebase-messaging-sw.js', {
            scope: '/firebase-cloud-messaging-push-scope',
          });
        });
      }
  </script>
  -->
  `;
    }

    // Update file content
    // 새로운 내용으로 파일 업데이트
    indexHtmlContent = indexHtmlContent.replace(flutterBootstrapMatch[0], `<!--flutter_bootstrap.js starts-->${updatedFlutterBootstrapContent}<!--flutter_bootstrap.js ends-->`);

    await fs.writeFile(indexHtmlPath, indexHtmlContent, 'utf8');
    console.log(`Updated ${blue}${indexHtmlPath}${reset}`);
  } catch (err) {
    console.error(`${red}Error updating ${indexHtmlPath}: ${err.message}${reset}`);
  }
}

// Configure AI settings in custom_settings.dart
// custom_settings.dart 파일의 ai 설정 변경
async function setAi() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the AI settings.${reset}`);

  const useAi = await askRequired(
    `(1/2) ${greenBold}Enable AI Assistant? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  if (/^(n|no)$/i.test(useAi)) {
    // Disable AI Assistant
    // AI 사용 안 함
    await replacePhraseInFile(
      `${currentLibPath}/${customSettingsFile}`,
      useAiAssistantRegex,
      `const bool useAiAssistant = false;`
    );
    console.log(`${yellow}👋 AI Assistant has been disabled.${reset}`);
    return;
  }

  // Select AI model
  // AI 모델 선택
  const aiModel = await askRequired(
    `(2/2) ${greenBold}Select AI Model (p/f or pro/flash): ${reset}`,
    answer => /^(p|pro|f|flash)$/i.test(answer),
    `${red}Please enter p, pro, f, or flash.${reset}`
  );

  const aiModelType = /^(p|pro)$/i.test(aiModel) ? 'gemini-1.5-pro' : 'gemini-1.5-flash';

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useAiAssistantRegex,
    `const bool useAiAssistant = true;`
  );
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    aiModelTypeRegex,
    `const String aiModelType = '${aiModelType}';`
  );

  console.log(`${yellow}👋 AI Assistant has been enabled with ${aiModelType} model.${reset}`);
  console.log(`${yellow}Please go to ${blueBold}https://console.firebase.google.com/project/_/genai${reset} ${yellow}and enable APIs.${reset}`);
}

// Configure R2 Storage settings in custom_settings.dart
// custom_settings.dart 파일의 rtwo 설정
async function setRTwoStorage() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the R2 Storage settings.${reset}`);

  let useRTwo;
  let rTwoBaseUrl;

  // If URL is provided as a parameter
  // 파라미터로 URL 전달된 경우
  if (args.length > 0 && urlRegex.test(args[0])) {
    useRTwo = 'yes';
    rTwoBaseUrl = args[0];
  } else {
    // Ask for R2 Storage enable/disable
    // 파라미터가 없거나 URL 형식이 아닌 경우 질문 시작
    useRTwo = await askRequired(
      `(1/2) ${greenBold}Enable R2 Storage? (y/n or yes/no): ${reset}`,
      answer => /^(y|yes|n|no)$/i.test(answer),
      `${red}Please enter y, yes, n, or no.${reset}`
    );

    if (/^(n|no)$/i.test(useRTwo)) {
      // Disable R2 Storage
      // R2 Storage 사용 안 함
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        useRTwoStorageRegex,
        `const bool useRTwoStorage = false;`
      );
      console.log(`${yellow}👋 R2 Storage has been disabled.${reset}`);
      return;
    }

    // Get R2 base URL
    // R2 Base URL 입력
    rTwoBaseUrl = await askRequired(
      `(2/2) ${greenBold}Enter your R2 worker URL (e.g., https://your-worker.your-id.workers.dev): ${reset}`,
      answer => urlRegex.test(answer),
      `${red}Please enter a valid URL.${reset}`
    );
  }

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useRTwoStorageRegex,
    `const bool useRTwoStorage = true;`
  );
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    rTwoBaseUrlRegex,
    `const String rTwoBaseUrl = '${rTwoBaseUrl}';`
  );

  console.log(`${yellow}👋 R2 Storage has been enabled with your R2 worker URL: ${rTwoBaseUrl}${reset}`);
}

// Configure Cloudflare CDN settings in custom_settings.dart
// custom_settings.dart 파일의 cfcdn 설정
async function setCfCdn() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the Cloudflare CDN settings.${reset}`);

  let useCfCdn;
  let cfDomainUrl;

  // If URL is provided as a parameter
  // 파라미터로 URL 전달된 경우
  if (args.length > 0 && urlRegex.test(args[0])) {
    useCfCdn = 'yes';
    cfDomainUrl = args[0];
  } else {
    // Ask for Cloudflare CDN enable/disable
    // 파라미터가 없거나 URL 형식이 아닌 경우 질문 시작
    useCfCdn = await askRequired(
      `(1/2) ${greenBold}Enable Cloudflare CDN? (y/n or yes/no): ${reset}`,
      answer => /^(y|yes|n|no)$/i.test(answer),
      `${red}Please enter y, yes, n, or no.${reset}`
    );

    if (/^(n|no)$/i.test(useCfCdn)) {
      // Disable Cloudflare CDN
      // CF CDN 사용 안 함
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        useCfCdnRegex,
        `const bool useCfCdn = false;`
      );
      console.log(`${yellow}👋 Cloudflare CDN has been disabled.${reset}`);
      return;
    }

    // Get Cloudflare custom domain URL
    // CF CDN URL 입력
    cfDomainUrl = await askRequired(
      `(2/2) ${greenBold}Enter your Cloudflare custom domain URL (e.g., https://your-domain.com): ${reset}`,
      answer => urlRegex.test(answer),
      `${red}Please enter a valid URL.${reset}`
    );
  }

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useCfCdnRegex,
    `const bool useCfCdn = true;`
  );
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    cfDomainUrlRegex,
    `const String cfDomainUrl = '${cfDomainUrl}';`
  );

  console.log(`${yellow}👋 Cloudflare CDN has been enabled with base URL: ${cfDomainUrl}${reset}`);
}

// Configure D1 database settings in custom_settings.dart
// custom_settings.dart 파일의 done 설정
async function setDOne() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the D1 settings.${reset}`);

  let useDOne;
  let dOneBaseUrl;

  // If URL is provided as parameter
  // 파라미터로 URL 전달된 경우
  if (args.length > 0 && urlRegex.test(args[0])) {
    useDOne = 'yes';
    dOneBaseUrl = args[0];
  } else {
    // Ask for D1 database enable/disable
    // 파라미터가 없거나 URL 형식이 아닌 경우 질문 시작
    useDOne = await askRequired(
      `(1/2) ${greenBold}Enable D1 database? (y/n or yes/no): ${reset}`,
      answer => /^(y|yes|n|no)$/i.test(answer),
      `${red}Please enter y, yes, n, or no.${reset}`
    );

    if (/^(n|no)$/i.test(useDOne)) {
      // Disable D1 database
      // D1 사용 안 함
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        useDOneForSearchRegex,
        `const bool useDOneForSearch = false;`
      );
      console.log(`${yellow}👋 D1 database has been disabled.${reset}`);
      return;
    }

    // Get D1 base URL
    // D1 Base URL 입력
    dOneBaseUrl = await askRequired(
      `(2/2) ${greenBold}Enter your D1 worker URL (e.g., https://your-worker.your-id.workers.dev): ${reset}`,
      answer => urlRegex.test(answer),
      `${red}Please enter a valid URL.${reset}`
    );
  }

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useDOneForSearchRegex,
    `const bool useDOneForSearch = true;`
  );
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    dOneBaseUrlRegex,
    `const String dOneBaseUrl = '${dOneBaseUrl}';`
  );

  console.log(`${yellow}👋 D1 database has been enabled with your D1 worker URL: ${dOneBaseUrl}${reset}`);
}


// Configure R2 Secure Get settings in custom_settings.dart
// custom_settings.dart 파일의 rtwo secure get 설정
async function setRTwoSecureGet() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the R2SecureGet settings.${reset}`);

  // Ask for R2 Secure Get enable/disable
  const useRTwoSecureGet = await askRequired(
    `(1/1) ${greenBold}Enable R2SecureGet? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  if (/^(n|no)$/i.test(useRTwoSecureGet)) {
    // Disable R2 Secure Get
    // R2 secure get 사용 안 함
    await replacePhraseInFile(
      `${currentLibPath}/${customSettingsFile}`,
      useRTwoSecureGetRegex,
      `const bool useRTwoSecureGet = false;`
    );
    console.log(`${yellow}👋 R2SecurGet has been disabled.${reset}`);
    return;
  }

  // Enable R2 Secure Get
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    useRTwoSecureGetRegex,
    `const bool useRTwoSecureGet = true;`
  );
  
  console.log(`${yellow}👋 R2SecureGet has been enabled.${reset}`);
}

// Set youtubeImageProxyUrl in custom_settings.dart
// custom_settings.dart 파일의 youtubeImageProxyUrl 설정
async function setYoutubeImageProxyUrl() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the youtubeImageProxyUrl settings.${reset}`);

  let youtubeImageProxyUrl;

  // If URL is provided as parameter
  // 파라미터로 URL 전달된 경우
  if (args.length > 0 && urlRegex.test(args[0])) {
    youtubeImageProxyUrl = args[0];
  } else {
    // Get youtubeImageProxyUrl from user input
    // youtubeImageProxyUrl 입력
    youtubeImageProxyUrl = await askRequired(
      `(1/1) ${greenBold}Enter your youtubeImageProxyUrl (e.g., https://your-worker.your-id.workers.dev): ${reset}`,
      answer => urlRegex.test(answer),
      `${red}Please enter a valid URL.${reset}`
    );
  }

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    youtubeImageProxyUrlRegex,
    `const String youtubeImageProxyUrl = '${youtubeImageProxyUrl}';`
  );

  console.log(`${yellow}👋 youtubeImageProxyUrl has been updated with this URL: ${youtubeImageProxyUrl}${reset}`);
}

// Set youtubeIframeProxyUrl in custom_settings.dart
// custom_settings.dart 파일의 youtubeIframeProxyUrl 설정
async function setYoutubeIframeProxyUrl() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the youtubeIframeProxyUrl settings.${reset}`);

  let youtubeIframeProxyUrl;

  // If URL is provided as a parameter
  // 파라미터로 URL 전달된 경우
  if (args.length > 0 && urlRegex.test(args[0])) {
    youtubeIframeProxyUrl = args[0];
  } else {
    // Get youtubeIframeProxyUrl from user input
    // youtubeIframeProxyUrl 입력
    youtubeIframeProxyUrl = await askRequired(
      `(1/1) ${greenBold}Enter your youtubeIframeProxyUrl (e.g., https://your-worker.your-id.workers.dev): ${reset}`,
      answer => urlRegex.test(answer),
      `${red}Please enter a valid URL.${reset}`
    );
  }

  // Update custom_settings.dart
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    youtubeIframeProxyUrlRegex,
    `const String youtubeIframeProxyUrl = '${youtubeIframeProxyUrl}';`
  );

  console.log(`${yellow}👋 youtubeIframeProxyUrl has been updated with this URL: ${youtubeIframeProxyUrl}${reset}`);
}

// Change Firestore security rules
// firestore의 security rule 변경
async function setSecurity() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the security settings.${reset}`);

  // Display security settings options
  console.log(`${greenBold}Security Settings Options:${reset}`);
  console.log(`* ${blueBold}a (all users)${reset} - Access is granted to all users, regardless of authentication status.`);
  // 모든 사용자에게 액세스 권한이 부여됩니다. 인증 상태와 관계없습니다.
  console.log(`* ${blueBold}s (signed-in users)${reset} - Access is restricted to users who have signed in to the application.`);
  // 애플리케이션에 로그인한 사용자로 액세스가 제한됩니다.
  console.log(`* ${blueBold}v (verified users)${reset} - Access is restricted to users who have been verified by an administrator.`);
  // 관리자가 확인한 사용자로 액세스가 제한됩니다.


  // Get user input for security setting
  const securitySetting = await askRequired(
    `${greenBold}Select a security setting (a/s/v): ${reset}`,
    answer => /^(a|s|v)$/i.test(answer),
    `${red}Please enter a, s, or v.${reset}`
  );

  let newRulesContent;

  switch (securitySetting.toLowerCase()) {
    case 'a':
      // All users
      // 모든 사용자
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        isInitialSignInRegex,
        `const bool isInitialSignIn = false;`
      );
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        verifiedOnlyWriteRegex,
        `const bool verifiedOnlyWrite = false;`
      );
      newRulesContent = await fs.readFile(path.join(currentProjectPath, 'presettings/fs_open.firestore.rules'), 'utf8');
      break;
    case 's':
      // Signed-in users
      // 로그인한 사용자
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        isInitialSignInRegex,
        `const bool isInitialSignIn = true;`
      );
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        verifiedOnlyWriteRegex,
        `const bool verifiedOnlyWrite = false;`
      );
      newRulesContent = await fs.readFile(path.join(currentProjectPath, 'presettings/fs_authed.firestore.rules'), 'utf8');
      break;
    case 'v':
      // Verified users
      // 인증된 사용자
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        isInitialSignInRegex,
        `const bool isInitialSignIn = true;`
      );
      await replacePhraseInFile(
        `${currentLibPath}/${customSettingsFile}`,
        verifiedOnlyWriteRegex,
        `const bool verifiedOnlyWrite = true;`
      );
      newRulesContent = await fs.readFile(path.join(currentProjectPath, 'presettings/fs_verified.firestore.rules'), 'utf8');
      break;
  }

  // 기존 admin 및 verified id들 업데이트하기
  const currentRulesPath = path.join(currentProjectPath, firestoreRulesFile);
  let currentRulesContent = await fs.readFile(currentRulesPath, 'utf8');

  // isAdmin 함수 찾기
  const isAdminMatch = currentRulesContent.match(adminFunctionRegex);
  // isVerified 함수 찾기
  const isVerifiedMatch = currentRulesContent.match(verifiedFunctionRegex);

  if (isAdminMatch) {
    newRulesContent = newRulesContent.replace(
      adminFunctionRegex, isAdminMatch[0],
    );
  }

  if (isVerifiedMatch) {
    newRulesContent = newRulesContent.replace(
      verifiedFunctionRegex, isVerifiedMatch[0],
    );
  }
  

  // Update firestore.rules file
  try {
    await fs.writeFile(currentRulesPath, newRulesContent, 'utf8');
    console.log(`Updated ${blue}firestore.rules${reset} with new security settings.`);
  } catch (err) {
    console.error(`${red}Error updating firestore.rules: ${err.message}${reset}`);
  }

  console.log(`${yellow}👋 Security settings have been updated.${reset}`);
  console.log(`${yellow}To apply the new rules, run the following command:${reset}`);
  console.log(`${blueBold}firebase deploy --only firestore${reset}`);
}

// Configure adminOnlyWrite setting in custom_settings.dart
// custom_settings.dart 파일의 adminOnlyWrite 설정 변경
async function setAdminOnlyWrite() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the adminOnlyWrite settings.${reset}`);

  // Ask for adminOnlyWrite enable/disable
  const adminOnlyWrite = await askRequired(
    `(1/1) ${greenBold}Enable adminOnlyWrite? (y/n or yes/no): ${reset}`,
    answer => /^(y|yes|n|no)$/i.test(answer),
    `${red}Please enter y, yes, n, or no.${reset}`
  );

  if (/^(n|no)$/i.test(adminOnlyWrite)) {
    // Disable adminOnlyWrite
    // adminOnlyWrite 사용 안 함
    await replacePhraseInFile(
      `${currentLibPath}/${customSettingsFile}`,
      adminOnlyWriteRegex,
      `const bool adminOnlyWrite = false;`
    );
    console.log(`${yellow}👋 adminOnlyWrite has been disabled.${reset}`);
    return;
  }
  
  // Enable adminOnlyWrite
  // custom_settings.dart 파일 수정
  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    adminOnlyWriteRegex,
    `const bool adminOnlyWrite = true;`
  );
  
  console.log(`${yellow}👋 adminOnlyWrite has been enabled.${reset}`);
}

// Add admin id to firestore.rules file
// firestore.rules 파일에 admin id 추가
async function addAdminToFirestoreRules() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's add an admin to Firestore rules.${reset}`);

  const firestoreRulesPath = `${currentProjectPath}/firestore.rules`;

  try {
    // firestore.rules 파일 존재 확인
    await fs.access(firestoreRulesPath, fs.constants.F_OK);
  } catch (err) {
    console.error(`${red}Error: firestore.rules file not found. Please create it in the root of your project.${reset}`);
    return;
  }

  let newAdminUid;
  // 추가할 admin uid 받기
  if (args.length > 0) {
    newAdminUid = args[0];
  } else {
    newAdminUid = await askRequired(
      `(1/1) ${greenBold}Enter the UID of the admin you want to add: ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter a valid UID.${reset}`
    );
  }


  try {
    let rulesContent = await fs.readFile(firestoreRulesPath, 'utf8');

    // isAdmin 함수 찾기
    const isAdminMatch = rulesContent.match(adminFunctionRegex);

    if (!isAdminMatch) {
      console.error(`${red}Error: Could not find the isAdmin function in firestore.rules. Please ensure it exists and is in the correct format.${reset}`);
      return;
    }

    const currentAdmins = isAdminMatch[1].split(',').map(uid => uid.trim().replace(/["']/g, '')).filter(uid => uid !== '');

    // 이미 존재하는지 확인하고 추가
    if (!currentAdmins.includes(newAdminUid)) {
      currentAdmins.push(newAdminUid);
    }


    const updatedAdminsString = currentAdmins.map(uid => `"${uid}"`).join(', ');

    // firestore.rules 파일 업데이트
    const updatedRulesContent = rulesContent.replace(
      adminFunctionRegex,
      `function isAdmin() {\n      return request.auth.uid in [${updatedAdminsString}];\n    }`
    );


    await fs.writeFile(firestoreRulesPath, updatedRulesContent, 'utf8');

    console.log(`${green}Successfully added admin UID "${newAdminUid}" to firestore.rules.${reset}`);
  } catch (err) {
    console.error(`${red}Error updating firestore.rules: ${err.message}${reset}`);
  }
}

// Add verified id to firestore.rules file
// firestore.rules 파일에 verified id 추가
async function addVerifiedToFirestoreRules() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's add an verified to Firestore rules.${reset}`);

  const firestoreRulesPath = `${currentProjectPath}/firestore.rules`;

  try {
    // firestore.rules 파일 존재 확인
    await fs.access(firestoreRulesPath, fs.constants.F_OK);
  } catch (err) {
    console.error(`${red}Error: firestore.rules file not found. Please create it in the root of your project.${reset}`);
    return;
  }

  let newVerifiedUid;
  // 추가할 verified uid 받기
  if (args.length > 0) {
    newVerifiedUid = args[0];
  } else {
    newVerifiedUid = await askRequired(
      `(1/1) ${greenBold}Enter the UID of the verified you want to add: ${reset}`,
      answer => !isEmpty(answer),
      `${red}Please enter a valid UID.${reset}`
    );
  }


  try {
    let rulesContent = await fs.readFile(firestoreRulesPath, 'utf8');

    // isVerified 함수 찾기
    const isVerifiedMatch = rulesContent.match(verifiedFunctionRegex);

    if (!isVerifiedMatch) {
      console.error(`${red}Error: Could not find the isVerified function in firestore.rules. Please ensure it exists and is in the correct format.${reset}`);
      return;
    }

    const currentVerifieds = isVerifiedMatch[1].split(',').map(uid => uid.trim().replace(/["']/g, '')).filter(uid => uid !== '');

    // 이미 존재하는지 확인하고 추가
    if (!currentVerifieds.includes(newVerifiedUid)) {
      currentVerifieds.push(newVerifiedUid);
    }


    const updatedVerifiedsString = currentVerifieds.map(uid => `"${uid}"`).join(', ');

    // firestore.rules 파일 업데이트
    const updatedRulesContent = rulesContent.replace(
      verifiedFunctionRegex,
      `function isVerified() {\n      return request.auth.uid in [${updatedVerifiedsString}];\n    }`
    );


    await fs.writeFile(firestoreRulesPath, updatedRulesContent, 'utf8');

    console.log(`${green}Successfully added verified UID "${newVerifiedUid}" to firestore.rules.${reset}`);
  } catch (err) {
    console.error(`${red}Error updating firestore.rules: ${err.message}${reset}`);
  }
}


async function setFbAuthProviders() {
  console.log(`${yellow}🧡 Welcome to Applimode-Tool. Let's set the Firebase Authentication providers.${reset}`);

  // Display authentication provider options
  console.log(`${greenBold}Firebase Authentication Provider Options:${reset}`);
  console.log(`1. ${blueBold}Email only${reset}`);
  console.log(`2. ${blueBold}Phone only${reset}`);
  console.log(`3. ${blueBold}Email and Phone${reset}`);

  // Get user input for authentication provider
  const authProviderOption = await askRequired(
    `${greenBold}Select an authentication provider option (1/2/3): ${reset}`,
    answer => /^(1|2|3)$/.test(answer),
    `${red}Please enter 1, 2, or 3.${reset}`
  );

  // Update custom_settings.dart based on user input
  let newFbAuthProvidersValue;
  switch (authProviderOption) {
    case '1':
      newFbAuthProvidersValue = `['email']`;
      break;
    case '2':
      newFbAuthProvidersValue = `['phone']`;
      break;
    case '3':
      newFbAuthProvidersValue = `['email', 'phone']`;
      break;
  }

  await replacePhraseInFile(
    `${currentLibPath}/${customSettingsFile}`,
    fbAuthProvidersRegex,
    `const List<String> fbAuthProviders = ${newFbAuthProvidersValue};`
  );

  console.log(`${yellow}👋 Firebase Authentication providers have been updated.${reset}`);
}

// Check if the folder exists and execute the command
// 폴더가 존재하는지 확인하고 명령어 실행
fs.access(projectsPath)
  .then(async () => {
    if (command[0].trim() == 'init') {
      await initApplimode();
    } else if (command[0].trim() == 'upgrade') {
      await upgradeApplimode();
    } else if (command[0].trim() == 'fullname') {
      await setAppFullName();
    } else if (command[0].trim() == 'shortname') {
      await setAppShortName();
    } else if (command[0].trim() == 'organization') {
      await setAppOrganizationName();
    } else if (command[0].trim() == 'firebaserc') {
      await generateFirebaserc();
    } else if (command[0].trim() == 'color') {
      await setAppMainColor();
    } else if (command[0].trim() == 'worker') {
      await setWorkerKey();
    } else if (command[0].trim() == 'fcm') {
      await setFcm();
    } else if (command[0].trim() == 'ai') {
      await setAi();
    } else if (command[0].trim() == 'rtwo') {
      await setRTwoStorage();
    } else if (command[0].trim() == 'cdn') {
      await setCfCdn();
    } else if (command[0].trim() == 'done') {
      await setDOne();
    } else if (command[0].trim() == 'rtwosecureget') {
      await setRTwoSecureGet();
    } else if (command[0].trim() == 'youtubeimage') {
      await setYoutubeImageProxyUrl();
    } else if (command[0].trim() == 'youtubevideo') {
      await setYoutubeIframeProxyUrl();
    } else if (command[0].trim() == 'security') {
      await setSecurity();
    } else if (command[0].trim() == 'write') {
      await setAdminOnlyWrite();
    } else if (command[0].trim() == 'admin') {
      await addAdminToFirestoreRules();
    } else if (command[0].trim() == 'verified') {
      await addVerifiedToFirestoreRules();
    } else if (command[0].trim() == 'auth') {
      await setFbAuthProviders();
    } else {
      console.error(`${red}Error:', 'The command must start with init, upgrade, fullname, shortname, organization, firebaserc, color, worker, fcm, ai, rtwo, cdn, done, rtwosecureget, youtubeimage, youtube video, security, write.${reset}`);
      process.exit(1);
    }
    readline.close();
  })
  .catch(err => {
    console.error(`${red}Error: ${err}${reset}`);
    process.exit(1);
  });
