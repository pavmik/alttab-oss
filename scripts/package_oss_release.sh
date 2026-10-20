#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
version="11.9.2"
build_dir="${OSS_BUILD_DIR:-$PWD/DerivedData-OSS}"
output_dir="${OSS_OUTPUT_DIR:-$PWD/dist}"
staging_dir="$(mktemp -d "${TMPDIR:-/tmp}/alttab-oss-dmg.XXXXXX")"

xcodebuild -project alt-tab-macos.xcodeproj -scheme Release -configuration Release \
  -derivedDataPath "$build_dir" CODE_SIGN_IDENTITY=- OTHER_CODE_SIGN_FLAGS= \
  CURRENT_PROJECT_VERSION="$version" MARKETING_VERSION="$version" \
  MACOSX_DEPLOYMENT_TARGET=12.0 SWIFT_TREAT_WARNINGS_AS_ERRORS=NO \
  'ARCHS=arm64 x86_64' ONLY_ACTIVE_ARCH=NO

app="$build_dir/Build/Products/Release/AltTab OSS.app"
codesign --force --deep --sign - --preserve-metadata=entitlements --timestamp=none "$app"
codesign --verify --deep --strict "$app"
app_archs="$(lipo -archs "$app/Contents/MacOS/AltTab OSS")"
[[ " $app_archs " == *" arm64 "* && " $app_archs " == *" x86_64 "* ]]
mkdir -p "$output_dir"
ditto "$app" "$staging_dir/AltTab OSS.app"
cp LICENCE.md "$staging_dir/LICENCE.md"
ln -s /Applications "$staging_dir/Applications"
hdiutil create -volname "AltTab OSS $version" -srcfolder "$staging_dir" \
  -ov -format UDZO "$output_dir/AltTab-OSS-$version-universal.dmg"
ditto -c -k --sequesterRsrc --keepParent "$app" "$output_dir/AltTab-OSS-$version-universal.zip"
cd "$output_dir"
shasum -a 256 "AltTab-OSS-$version-universal.dmg" "AltTab-OSS-$version-universal.zip" > SHA256SUMS.txt
printf 'Release files: %s\nStaging directory: %s\n' "$output_dir" "$staging_dir"
