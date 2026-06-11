# Fastlane — Android

This folder contains Fastlane lanes for the Flowers App Android build process.

## Available Lanes

### `dev`
Builds a debug APK for internal QA testing, then uploads it to Firebase App Distribution.

**What it does:**
1. Reads the current Git branch and commit hash
2. Increments the build number in `pubspec.yaml`
3. Builds a debug APK
4. Renames the APK with branch and commit info
5. Uploads the APK to Firebase App Distribution
6. Notifies the testers group via email

## Setup (First Time Only)

### 1. Install Ruby and Fastlane

Make sure you have Ruby installed, then install Fastlane:

```bash
gem install fastlane -NV
```

### 2. Get a Firebase Service Account JSON file

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Save the JSON file **outside** of this project (e.g., in `E:/private/`)
4. Never commit this file!

### 3. Create your `.env` file

Copy the example file:
```bash
cp .env.example .env
```

Then open `.env` and fill in your values:
- `FIREBASE_APP_ID` — from Firebase Console → Project Settings → Your apps
- `FIREBASE_SERVICE_ACCOUNT_PATH` — full path to your service account JSON

### 4. Set environment variables (Windows PowerShell)

Before running Fastlane, set the variables in your terminal:

```powershell
$env:FIREBASE_APP_ID = "your_app_id"
$env:FIREBASE_SERVICE_ACCOUNT_PATH = "path/to/your/service-account.json"
```

## Running the Lane

From the `android` folder:

```bash
cd android
fastlane dev
```

The build takes approximately 3-5 minutes. When done, the APK is automatically uploaded to Firebase, and testers receive an email.

## Troubleshooting

### Build fails with "Couldn't find gradlew"
Make sure you're running from the `android` folder, not from the project root.

### Firebase upload fails with authentication error
Check that your `FIREBASE_SERVICE_ACCOUNT_PATH` is correct and the file exists.

### Build fails with "di.config.dart references missing files"
Run code generation first:
```bash
cd ..
dart run build_runner build --delete-conflicting-outputs
```