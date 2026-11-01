#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

app="$HOME/Applications/Open in Sheets.app"
bundle_id=local.rieg.open-in-sheets
xlsx_type=org.openxmlformats.spreadsheetml.sheet

rm -rf "$app"
osacompile -o "$app" open-in-sheets.applescript
cp open-in-sheets.sh "$app/Contents/Resources/"

# osacompile declares that the app opens all file types. We declare only .xlsx,
# so that the app does not show in "Open With" for other files.
/usr/libexec/PlistBuddy \
  -c "Add :CFBundleIdentifier string $bundle_id" \
  -c "Delete :CFBundleDocumentTypes" \
  -c "Add :CFBundleDocumentTypes array" \
  -c "Add :CFBundleDocumentTypes:0 dict" \
  -c "Add :CFBundleDocumentTypes:0:CFBundleTypeName string 'Excel Workbook'" \
  -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Viewer" \
  -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Default" \
  -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" \
  -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:0 string $xlsx_type" \
  "$app/Contents/Info.plist"

# The Info.plist changes above break the signature that osacompile adds, so we
# sign the app again.
codesign --force --sign - "$app"

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"

# macOS has no built-in command to set the default app for a file type, so we
# call Launch Services from JavaScript.
osascript -l JavaScript - "$xlsx_type" "$bundle_id" <<'EOF'
ObjC.import("CoreServices")
function run([type, bundleId]) {
  const status = $.LSSetDefaultRoleHandlerForContentType($(type), $.kLSRolesAll, $(bundleId))
  if (status !== 0) throw new Error(`LSSetDefaultRoleHandlerForContentType failed with status ${status}`)
}
EOF

echo "Installed $app and set it as the default app for .xlsx files."
