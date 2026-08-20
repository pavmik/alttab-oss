# AltTab OSS

AltTab OSS is an unofficial, source-only fork of [AltTab for macOS](https://github.com/lwouis/alt-tab-macos). It is not affiliated with or endorsed by the original AltTab project or its maintainers.

This fork keeps the original AltTab experience while providing an unrestricted open-source build under the GNU General Public License v3.0. It uses the separate app name `AltTab OSS` and bundle identifier `com.frekr.alttab-oss`, so it can be tested independently from the official app.

No prebuilt or signed application is provided. Build it locally if you want to use it.

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
  CURRENT_PROJECT_VERSION=11.5.0
open "DerivedData/Build/Products/Debug/AltTab OSS.app"
```

macOS will ask for Accessibility permission because a window switcher needs it to inspect and focus windows. Ad-hoc signing may cause macOS to ask for permission again after a rebuild.

The upstream repository also includes `scripts/codesign/setup_local.sh`, which creates a stable local self-signed identity for development builds. Review the script before running it because it changes your Keychain trust settings.

## Differences from upstream

- Separate application name and bundle identifier
- OSS build condition
- License trial and paid-feature gates disabled in the OSS build
- Purchase, account, feedback, update-check, and QA menu items hidden
- Automatic update checks disabled

All other functionality and most of the source come from the original AltTab project. See its [repository](https://github.com/lwouis/alt-tab-macos) for the upstream project, documentation, and history.

## License

Copyright remains with the original contributors and later contributors to this fork. The project is distributed under the [GNU General Public License v3.0](LICENSE).

There is no warranty and no official support from the upstream AltTab maintainers.
