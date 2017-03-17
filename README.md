mac-spotify-rcd
===============

Makes the playback control keys on a MacBook Pro open spotify instead of iTunes.

## Installation

- Automated Installation: This project contains an `install.sh` script that will
  executes all of the necessary commands to build, install, and activate the
  tweak. Simply run the script in Terminal to use it:

  ```
  $ git clone https://github.com/rpendleton/spotify-rcd.git
  $ cd spotify-rcd
  $ ./install.sh
  ```

### Manual Installation: If you prefer to install the plugin manually

1. Download and extract the tweak.tar.gz file from the [latest build](https://github.com/chrowe/spotify-rcd/releases) or build with `xcodebuild clean build`
2. copy the resulting bundle to `/Library/Application Support/Tweaks`. e.g.
  ```
  sudo mkdir /Library/Application\ Support/Tweaks
  sudo cp -R ~/Downloads/build/Release/SpotifyRCD.bundle /Library/Application\ Support/Tweaks/
  ```
3. Copy `/System/Library/LaunchAgents/com.apple.rcd.plist` to
    `/Library/LaunchAgents/com.apple.rcd.patched.plist` e.g.
  ```
  sudo cp /System/Library/LaunchAgents/com.apple.rcd.plist /Library/LaunchAgents/com.apple.rcd.patched.plist
  ```
4. In the copied plist, change the `Label` to `com.apple.rcd.patched` e.g.
  ```
  sudo vim /Library/LaunchAgents/com.apple.rcd.patched.plist
  /Label
  ```
5. Add the following section to the copied plist:

    ```
    <key>Disabled</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
            <key>DYLD_INSERT_LIBRARIES</key>
            <string>/Library/Application Support/Tweaks/SpotifyRCD.bundle/Contents/MacOS/SpotifyRCD</string>
    </dict>
    ```

6. Unload the system LaunchAgent, and load the modified one:

    ```
    $ launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
    $ launchctl load -w /Library/LaunchAgents/com.apple.rcd.patched.plist
    ```
**Note**: Do not use sudo as you will get `Service cannot load in requested session` errors

## Disabling

To disable the tweak, simply unload the modified plist and load the original:

```
$ launchctl unload -w /Library/LaunchAgents/com.apple.rcd.patched.plist
$ launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist
```
