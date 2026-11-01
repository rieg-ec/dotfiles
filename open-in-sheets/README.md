# Open in Sheets

Open `.xlsx` files from Finder in Google Sheets.

When you double-click an `.xlsx` file, the app uploads the file to your
Google Drive as a Google Sheet. Then it opens the sheet in your browser.
The sheet goes into the root folder of My Drive.

## Requirements

- macOS with Homebrew in `/opt/homebrew`.
- `gws`, the Google Workspace CLI, in `/opt/homebrew/bin/gws`.
- A desktop OAuth client for `gws` in `~/.config/gws/client_secret.json`.
  `gws auth setup` can make one. It needs `gcloud`.

## Install

1. Sign in to Google:

   ```sh
   gws auth login --scopes https://www.googleapis.com/auth/drive.file
   ```

   The `drive.file` scope gives `gws` access only to the files that it makes.

2. Run the install script:

   ```sh
   ./install.sh
   ```

   The script builds `~/Applications/Open in Sheets.app`. Then it sets the app
   as the default app for `.xlsx` files.

The first time that the app runs, macOS can ask for access to the keychain.
Click **Always Allow**.

## Limits

- Each double-click makes a new sheet in Drive.
- Changes in Google Sheets do not go back to the local file.

## Uninstall

1. In Finder, select an `.xlsx` file and click **File > Get Info**.
2. Under **Open with**, select a different app and click **Change All…**.
3. Delete `~/Applications/Open in Sheets.app`.
