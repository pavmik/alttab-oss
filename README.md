# AltTab OSS

AltTab OSS is an unofficial fork of [AltTab for macOS](https://github.com/lwouis/alt-tab-macos). It is not affiliated with or endorsed by the original AltTab project or its maintainers.

This fork keeps the original AltTab experience while providing an unrestricted open-source build under the GNU General Public License v3.0. It uses the separate app name `AltTab OSS` and bundle identifier `com.frekr.alttab-oss`, so it can be tested independently from the official app.

The current fork is based on upstream **11.9.2**.

## Install

Download the DMG from [Releases](https://github.com/pavmik/alttab-oss/releases), open it, and drag `AltTab OSS.app` to Applications. Release builds support Apple Silicon and Intel on macOS 12 or later.

The app is ad-hoc signed, not Apple-notarized. macOS may require approval in System Settings > Privacy & Security after the first launch attempt. Grant Accessibility and Screen Recording permissions when prompted. Quit other window switchers before testing conflicting shortcuts.

Automatic updates are disabled. Install newer releases manually. Source code for each binary is available at its release tag. Checksums are included with each release.

## Build locally

Requirements:

- macOS
- A full Xcode installation
- Git

Clone the repository and build an ad-hoc signed Debug app:

```sh
git clone https://github.com/pavmik/alttab-oss.git
cd alttab-oss
xcodebuild \
  -project alt-tab-macos.xcodeproj \
  -scheme Debug \
  -configuration Debug \
  -derivedDataPath DerivedData \
  CODE_SIGN_IDENTITY=- \
  OTHER_CODE_SIGN_FLAGS= \
  MACOSX_DEPLOYMENT_TARGET=12.0 \
  SWIFT_TREAT_WARNINGS_AS_ERRORS=NO \
  CURRENT_PROJECT_VERSION=11.9.2
open "DerivedData/Build/Products/Debug/AltTab OSS.app"
```

For a universal optimized build and DMG, run `bash scripts/package_oss_release.sh`. This requires Xcode and creates files in `dist/` without notarizing or uploading them.

macOS will ask for Accessibility permission because a window switcher needs it to inspect and focus windows. Ad-hoc signing may cause macOS to ask for permission again after a rebuild.

The upstream repository also includes `scripts/codesign/setup_local.sh`, which creates a stable local self-signed identity for development builds. Review the script before running it because it changes your Keychain trust settings.

## Validation

Run upstream unit tests with `bash ai/test.sh`, adding local signing overrides if needed. To check that an expired trial or stored license cannot lock OSS features or trigger validation, run:

```sh
xcodebuild test -project alt-tab-macos.xcodeproj -scheme Test -configuration Debug \
  -derivedDataPath DerivedData-OSSTests CODE_SIGN_IDENTITY=- OTHER_CODE_SIGN_FLAGS= \
  CURRENT_PROJECT_VERSION=11.9.2 'SWIFT_ACTIVE_COMPILATION_CONDITIONS=DEBUG OSS' \
  -only-testing:unit-tests/OSSLicenseManagerTests
```

For standard Gatekeeper installation on other Macs, a distribution build needs the fork publisher's own Developer ID Application certificate, hardened runtime, a secure timestamp, and successful Apple notarization. The current packages are ad-hoc signed and do not meet that distribution requirement. A self-signed certificate does not replace Developer ID and notarization.

## Differences from upstream

- Separate application name and bundle identifier
- OSS build condition
- License trial and paid-feature gates disabled in the OSS build
- Purchase, account, feedback, update-check, and QA menu items hidden
- Automatic update checks disabled

All other functionality and most of the source come from the original AltTab project. See its [repository](https://github.com/lwouis/alt-tab-macos) for the upstream project, documentation, and history.

## License

Copyright remains with the original contributors and later contributors to this fork. The project is distributed under the [GNU General Public License v3.0](LICENCE.md).

There is no warranty and no official support from the upstream AltTab maintainers.
