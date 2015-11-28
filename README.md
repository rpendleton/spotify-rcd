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

- Manual Installation: If you prefer to install the plugin manually, it is
  possible to do so.

  - Compile the tweak and copy the resulting bundle to
    `/Library/Application Support/Tweaks`
  - Copy `/System/Library/LaunchAgents/com.apple.rcd.plist` to
    `/Library/LaunchAgents/com.apple.rcd.patched.plist`
  - In the copied plist, change the `Label` to `com.apple.rcd.patched`
  - Add the following section to the copied plist:

    ```
    <key>Disabled</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
            <key>DYLD_INSERT_LIBRARIES</key>
            <string>/Library/Application Support/Tweaks/SpotifyRCD.bundle/Contents/MacOS/SpotifyRCD</string>
    </dict>
    ```

  - Unload the system LaunchAgent, and load the modified one:

    ```
    $ launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
    $ launchctl load -w /Library/LaunchAgents/com.apple.rcd.patched.plist
    ```

## Disabling

To disable the tweak, simply unload the modified plist and load the original:

```
$ launchctl unload -w /Library/LaunchAgents/com.apple.rcd.patched.plist
$ launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist
```
