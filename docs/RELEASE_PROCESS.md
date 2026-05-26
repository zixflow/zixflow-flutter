# Zixflow Flutter SDK - Release Process Guide

Complete guide for releasing new versions of the Zixflow Flutter SDK to pub.dev.

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Version Management](#version-management)
4. [Pre-Release Checklist](#pre-release-checklist)
5. [Release Process](#release-process)
6. [Publishing to pub.dev](#publishing-to-pubdev)
7. [CI/CD Automation](#cicd-automation)
8. [Post-Release Verification](#post-release-verification)
9. [Rollback Procedures](#rollback-procedures)
10. [Hotfix Process](#hotfix-process)
11. [Native SDK Dependencies](#native-sdk-dependencies)
12. [Known Issues & Workarounds](#known-issues--workarounds)
13. [Troubleshooting](#troubleshooting)

---

## Introduction

This guide documents the complete release process for publishing new versions of the Zixflow Flutter SDK to pub.dev.

### Target Audience

- Release engineers
- SDK maintainers
- DevOps team members

### Release Channels

- **Main Branch**: Stable releases (e.g., `1.0.0`, `1.1.0`)
- **Beta Branch**: Pre-release versions (e.g., `1.1.0-beta.1`)
- **Alpha Branch**: Alpha versions (e.g., `1.1.0-alpha.1`)

---

## Prerequisites

### Required Tools

- **Flutter SDK**: 3.41.9 or higher
- **Dart SDK**: 2.17.6 or higher
- **Git**: Latest version
- **semantic-release** (for CI/CD): v22.0.1+
- **sd** (string replacement tool): For version updates

### Required Access

- GitHub repository write access: `https://github.com/zixflow/zixflow-flutter`
- pub.dev publishing rights for `zixflow` package
- CI/CD access (GitHub Actions)
- Slack webhook for notifications

### pub.dev Account Setup

1. **Create pub.dev account**: https://pub.dev
2. **Login via CLI**:
   ```bash
   dart pub login
   ```
3. **Verify access**:
   ```bash
   flutter pub publish --dry-run
   ```

### Verify Publishing Rights

Ensure you're added as an uploader:
```bash
dart pub uploader --list
```

---

## Version Management

### Semantic Versioning

The SDK follows [Semantic Versioning](https://semver.org/):

**Format**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes (e.g., `1.0.0` → `2.0.0`)
- **MINOR**: New features, backward-compatible (e.g., `1.0.0` → `1.1.0`)
- **PATCH**: Bug fixes, backward-compatible (e.g., `1.0.0` → `1.0.1`)

**Pre-release versions**:
- Beta: `1.1.0-beta.1`
- Alpha: `1.1.0-alpha.1`
- Snapshot: `1.1.0-SNAPSHOT`

### Version Files

Version must be updated in:

1. **`pubspec.yaml`**
   ```yaml
   version: 1.0.1
   ```

2. **`lib/customer_io_plugin_version.dart`**
   ```dart
   const version = "1.0.1";
   ```

3. **`android/src/main/res/values/customer_io_config.xml`**
   ```xml
   <string name="cio_flutter_plugin_version">1.0.1</string>
   ```

### Version Update Script

**Script**: `/scripts/update-version.sh`

```bash
./scripts/update-version.sh "1.0.1"
```

This script automatically updates all three version files using the `sd` tool.

---

## Pre-Release Checklist

Complete all items before releasing:

### 1. Code Quality

- [ ] All unit tests passing: `flutter test`
- [ ] All integration tests passing
- [ ] No warnings: `flutter analyze` or `dart analyze`
- [ ] Code formatted: `dart format --set-exit-if-changed .`
- [ ] Dependencies up to date: `flutter pub outdated`

### 2. Documentation

- [ ] `CHANGELOG.md` updated with new version
- [ ] `README.md` reviewed for accuracy
- [ ] API documentation updated if needed
- [ ] Example apps tested and working
- [ ] Migration guide updated (if breaking changes)

### 3. Version Updates

- [ ] Version updated in `pubspec.yaml`
- [ ] Version updated in `customer_io_plugin_version.dart`
- [ ] Version updated in Android `customer_io_config.xml`
- [ ] Version consistency verified

### 4. Native SDK Dependencies

- [ ] Android SDK version verified (currently v1.0.1)
- [ ] iOS SDK version verified (currently v1.0.0)
- [ ] Native SDKs published to Maven Central and CocoaPods
- [ ] Compatibility tested

### 5. Testing

- [ ] Sample apps built and tested (SPM and CocoaPods)
- [ ] Manual testing on Android emulator
- [ ] Manual testing on iOS simulator
- [ ] Manual testing on physical devices
- [ ] Firebase integration tested
- [ ] Push notifications tested
- [ ] In-app messaging tested
- [ ] Location tracking tested

### 6. Dry Run

- [ ] Dry run successful: `flutter pub publish --dry-run`
- [ ] No validation errors
- [ ] Package structure verified

---

## Release Process

### Automated Release (Recommended)

The automated CI/CD process is the recommended approach.

#### Step 1: Prepare Release

1. Ensure all changes committed to `main` branch
2. Update `CHANGELOG.md` with the new version
3. Commit changes:

```bash
git add .
git commit -m "chore: prepare for release X.Y.Z"
```

#### Step 2: Push to Trigger Release

```bash
git push origin main
```

The CI/CD pipeline will automatically:
1. Analyze commits using Conventional Commits
2. Determine next version number
3. Update version files via `update-version.sh`
4. Update `CHANGELOG.md`
5. Create git tag
6. Publish to GitHub Releases
7. Publish to pub.dev
8. Build and test sample apps
9. Notify team via Slack

#### Step 3: Monitor Release

Watch GitHub Actions: https://github.com/zixflow/zixflow-flutter/actions

---

### Manual Release (Fallback)

Use manual release if CI/CD is unavailable.

#### Step 1: Update Version

```bash
./scripts/update-version.sh "1.0.1"
```

#### Step 2: Update CHANGELOG

Add entry to `CHANGELOG.md`:

```markdown
## [1.0.1] - 2026-05-26

### Added
- New feature descriptions

### Changed
- Modified functionality

### Fixed
- Bug fix descriptions

### Breaking Changes
- Any breaking changes (if MAJOR version)
```

#### Step 3: Commit Changes

```bash
git add .
git commit -m "chore: release version 1.0.1"
```

#### Step 4: Create Git Tag

```bash
git tag -a 1.0.1 -m "Release 1.0.1"
git push origin main --tags
```

#### Step 5: Publish to pub.dev

Follow the [Publishing to pub.dev](#publishing-to-pubdev) section.

---

## Publishing to pub.dev

### Automated Publishing (via CI/CD)

The CI/CD pipeline automatically publishes to pub.dev.

**Workflow**: `.github/workflows/tag-and-deploy.yml`

### Manual Publishing

#### Step 1: Login to pub.dev

```bash
dart pub login
```

Follow the OAuth2 flow to authenticate.

#### Step 2: Dry Run

Test the package before publishing:

```bash
flutter pub publish --dry-run
```

Review the output for:
- Files to be published
- Warnings or errors
- Package size

#### Step 3: Publish

```bash
flutter pub publish
```

Confirm when prompted.

#### Step 4: Verify Publication

Visit https://pub.dev/packages/zixflow and verify:
- Version visible
- README renders correctly
- CHANGELOG visible
- API documentation generated
- Pub points score (target: 130+)

---

## CI/CD Automation

### Workflow Overview

**File**: `.github/workflows/tag-and-deploy.yml`

The deployment workflow runs in three stages:

#### Stage 1: Git Tag Creation (deploy-git-tag)

1. Checkout code from `main` branch
2. Run `semantic-release`:
   - Analyze commit messages (Conventional Commits)
   - Determine next version
   - Run `./scripts/update-version.sh ${nextRelease.version}`
   - Update `CHANGELOG.md`
   - Commit changes with `[skip ci]`
   - Create and push git tag
   - Create GitHub Release
3. Post Slack notification

**Output**: `new_release_published` flag

#### Stage 2: pub.dev Publication (deploy-to-pub-dev)

1. Runs only if `new_release_published == true`
2. Checkout the created git tag
3. Use `k-paxian/dart-package-publisher@master` action
4. Publish to pub.dev using `CREDENTIAL_JSON` secret
5. Post Slack notification on success/failure

#### Stage 3: Sample App Testing (publish-sample-apps-public-builds)

1. Runs after successful pub.dev publication
2. Builds `flutter_sample_spm` with latest SDK version
3. Verifies integration
4. Posts results to Zixflow workspace
5. Posts Slack notification

### Triggering Releases

**Automatic**: Push to `main` branch

```bash
git push origin main
```

**Manual**: GitHub Actions workflow dispatch

1. Go to https://github.com/zixflow/zixflow-flutter/actions
2. Select **tag-and-deploy** workflow
3. Click **Run workflow**
4. Select branch and run

### Commit Message Format

Use Conventional Commits for version determination:

**Patch Release** (1.0.0 → 1.0.1):
```
fix: resolve crash on Android 13
```

**Minor Release** (1.0.0 → 1.1.0):
```
feat: add support for custom event properties
```

**Major Release** (1.0.0 → 2.0.0):
```
feat!: redesign push notification API

BREAKING CHANGE: Push notification initialization changed
```

### Semantic Release Configuration

**File**: `.releaserc.json`

```json
{
  "tagFormat": "${version}",
  "branches": [
    "main",
    {"name": "beta", "prerelease": true},
    {"name": "alpha", "prerelease": true}
  ],
  "plugins": [
    [
      "@semantic-release/commit-analyzer",
      {"preset": "conventionalcommits"}
    ],
    [
      "@semantic-release/release-notes-generator",
      {"preset": "conventionalcommits"}
    ],
    [
      "@semantic-release/changelog",
      {"changelogFile": "CHANGELOG.md"}
    ],
    [
      "@semantic-release/exec",
      {
        "verifyReleaseCmd": "./scripts/update-version.sh ${nextRelease.version}"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": [
          "CHANGELOG.md",
          "pubspec.yaml",
          "lib/customer_io_plugin_version.dart",
          "android/src/main/res/values/customer_io_config.xml"
        ],
        "message": "chore: prepare for ${nextRelease.version} [skip ci]"
      }
    ],
    ["@semantic-release/github", {"labels": false}]
  ]
}
```

### GitHub Secrets Required

- `CREDENTIAL_JSON`: pub.dev OAuth2 credentials (generated via `dart pub login`)
- `SLACK_WEBHOOK_URL`: Slack webhook for #mobile-deployments channel
- `CIO_APP_CLIENT_ID`: GitHub app client ID
- `CIO_APP_SECRET`: GitHub app secret

---

## Post-Release Verification

### 1. Verify Git Tag

```bash
# List recent tags
git tag --list | tail -5

# Verify tag on remote
git ls-remote --tags origin | grep 1.0.1
```

### 2. Verify GitHub Release

1. Visit https://github.com/zixflow/zixflow-flutter/releases
2. Confirm release `1.0.1` exists
3. Check release notes

### 3. Verify pub.dev

#### Check pub.dev Website

1. Visit https://pub.dev/packages/zixflow
2. Verify version `1.0.1` appears
3. Check README renders correctly
4. Verify CHANGELOG is visible
5. Check API documentation generated
6. Review pub points score (target: 130+)

#### Check via CLI

```bash
# Search for package
dart pub global activate zixflow

# Check package info
dart pub info zixflow
```

### 4. Test Installation in New Project

Create test Flutter project:

```bash
flutter create test_project
cd test_project
```

Add dependency to `pubspec.yaml`:

```yaml
dependencies:
  zixflow: ^1.0.1
```

Install and verify:

```bash
flutter pub get
flutter pub deps | grep zixflow
```

### 5. Test Sample Apps

```bash
cd apps/flutter_sample_spm
flutter pub get
flutter pub upgrade
flutter run
```

Verify:
- App builds successfully
- SDK initializes
- Events tracked correctly

### 6. Manual Functional Testing

On physical devices:
- [ ] SDK initializes successfully
- [ ] User identification works
- [ ] Events are tracked
- [ ] Push notifications received
- [ ] In-app messages display
- [ ] Location tracking works

---

## Rollback Procedures

### pub.dev Rollback

**pub.dev does NOT support deleting published packages**.

**Options**:

#### Option 1: Publish Patch Version (Recommended)

For minor issues:

```bash
./scripts/update-version.sh "1.0.2"
git commit -m "fix: resolve critical issue from 1.0.1"
git push origin main
```

#### Option 2: Yank Version (Extreme Cases Only)

For critical security issues:

```bash
# Install pub_api_client
dart pub global activate pub_api_client

# Yank the version (marks as "do not use")
dart pub global run pub_api_client:main yank zixflow 1.0.1

# Users can still use it, but won't be recommended
```

**Note**: Yanking doesn't delete the package, just marks it as problematic.

#### Option 3: Communication

- Update README with warning
- Create GitHub issue documenting the problem
- Post in Slack channels
- Update documentation

### Git Tag Rollback

**Only safe before pub.dev publication**.

```bash
# Delete local tag
git tag -d 1.0.1

# Delete remote tag
git push origin :refs/tags/1.0.1

# Delete GitHub Release manually via web UI
```

---

## Hotfix Process

For critical bugs requiring immediate release:

### Step 1: Create Hotfix Branch

```bash
git checkout main
git pull origin main
git checkout -b hotfix/1.0.2
```

### Step 2: Apply Fix

```bash
# Make necessary changes
git add .
git commit -m "fix: resolve critical security issue"
```

### Step 3: Test Thoroughly

```bash
# Run all tests
flutter test

# Test sample apps
cd apps/flutter_sample_spm
flutter run
```

### Step 4: Bump Version

```bash
./scripts/update-version.sh "1.0.2"
```

### Step 5: Update CHANGELOG

```markdown
## [1.0.2] - 2026-05-26

### Fixed
- **CRITICAL**: Security vulnerability in authentication
```

### Step 6: Merge and Release

```bash
git add .
git commit -m "chore: hotfix release 1.0.2"

# Merge to main
git checkout main
git merge hotfix/1.0.2
git push origin main

# Follow standard release process
```

---

## Native SDK Dependencies

The Flutter SDK wraps native Android and iOS SDKs.

### Current Versions

**File**: `pubspec.yaml`

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: io.customer.customer_io
        pluginClass: CustomerIOPlugin
      ios:
        pluginClass: CustomerIOPlugin
        native_sdk_version: 1.0.0
        firebase_wrapper_version: 1.0.0
```

### Updating Native SDKs

#### Update iOS SDK Version

1. Update in `pubspec.yaml`:
   ```yaml
   native_sdk_version: 1.0.1
   ```

2. Update in `ios/zixflow.podspec`:
   ```ruby
   s.dependency 'ZixflowDataPipelines', '1.0.1'
   ```

3. Test with sample apps

#### Update Android SDK Version

1. Update in `android/build.gradle`:
   ```groovy
   implementation 'com.zixflow.android:datapipelines:1.0.1'
   ```

2. Test with sample apps

### Compatibility Matrix

| Flutter SDK | iOS Native | Android Native |
|-------------|------------|----------------|
| 1.0.0       | 1.0.0      | 1.0.1          |
| 1.0.1       | 1.0.0      | 1.0.1          |

---

## Known Issues & Workarounds

### Issue 1: pub.dev Publication Delay

**Symptom**: Package published but not immediately visible on pub.dev

**Cause**: CDN propagation delay (usually 5-10 minutes)

**Workaround**: Wait 10-15 minutes, then refresh pub.dev page

---

### Issue 2: Pub Points Below 130

**Symptom**: Package pub points score below target

**Causes**:
- Missing documentation
- Platform support gaps
- Maintenance issues

**Solutions**:
1. Add comprehensive API documentation
2. Update pubspec.yaml with complete metadata
3. Ensure all platforms supported (iOS, Android)
4. Keep dependencies up to date

---

### Issue 3: Credentials Expired

**Symptom**: `dart pub publish` fails with authentication error

**Cause**: OAuth2 token expired (60-day expiration)

**Solution**:
```bash
dart pub login
# Re-authenticate
```

---

## Troubleshooting

### Build Failures

**Problem**: Flutter build fails

**Solution**:
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter build apk  # Android
flutter build ios  # iOS
```

---

### Publishing Errors

#### Error: Authentication Failed

**Problem**: pub.dev authentication fails

**Solution**: Re-login
```bash
dart pub login
```

#### Error: Version Already Exists

**Problem**: Version already published

```
version 1.0.1 already exists
```

**Solution**: Version exists. Increment to 1.0.2 or abort.

#### Error: Package Validation Failed

**Problem**: Package doesn't meet pub.dev requirements

**Solution**: Run dry-run and fix reported issues
```bash
flutter pub publish --dry-run
```

---

### CI/CD Failures

#### Error: semantic-release Failure

**Problem**: Can't determine version from commits

**Solution**: Use Conventional Commits format

#### Error: GitHub Actions Permission Denied

**Problem**: Can't push tags

**Solution**: Verify GitHub Actions has write permissions in repository settings

#### Error: pub.dev Upload Timeout

**Problem**: Upload times out during CI

**Solution**: Retry workflow or publish manually

---

### Verification Issues

#### Problem: Package Not Found

**Solution**:
```bash
# Update pub cache
dart pub cache repair

# Force fetch
flutter pub get --force
```

#### Problem: Wrong Version Installed

**Solution**: Clear cache and reinstall
```bash
flutter pub cache clean
flutter pub get
```

---

## Support Contacts

- **GitHub Issues**: https://github.com/zixflow/zixflow-flutter/issues
- **pub.dev Package**: https://pub.dev/packages/zixflow
- **Email**: apps@zixflow.com
- **Slack**: #mobile-deployments channel

---

## Appendix: Quick Reference Commands

### Version Update
```bash
./scripts/update-version.sh "X.Y.Z"
```

### Git Tagging
```bash
git tag -a X.Y.Z -m "Release X.Y.Z"
git push origin X.Y.Z
```

### pub.dev Publishing
```bash
# Dry run
flutter pub publish --dry-run

# Login
dart pub login

# Publish
flutter pub publish
```

### Verification
```bash
# Check pub.dev
dart pub info zixflow

# Test installation
flutter pub get
flutter pub deps | grep zixflow
```

### Testing
```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format --set-exit-if-changed .
```

---

**Need help?** Contact the team via Slack or open a GitHub issue.
