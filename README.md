spotify-rcd
===============

On a standard installation of macOS, pressing the playback control keys on an
Apple keyboard opens iTunes if no other media applications are open. The purpose
of this project is to patch this behavior such that Spotify is opened instead.

## :warning: Compatibility

This is the README for the legacy version of the project. The legacy version is
known to work on a few older versions of macOS, but the exact list of supported
versions is not known.

Based on issues and commit dates, it seems reasonable to expect the legacy
version to support macOS Mavericks (10.9) through Sierra (10.12). It's possible
that some older versions of macOS could be supported as well. Compatibility with
High Sierra (10.13) and newer is known to be broken. (Adding support for a newer
version of macOS is being tracked by #3.)

This tweak has been tested primarily using the internal keyboard of a MacBook
Pro, but the tweak should also work with external keyboards. Compatibility with
the MacBook Pro's Touch Bar is unknown.

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

## Uninstallation

To disable the tweak, simply unload the modified plist and load the original:

```
$ launchctl unload -w /Library/LaunchAgents/com.apple.rcd.patched.plist
$ launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist
```

After the tweak has been disabled, you can completely uninstally it by simply
deleting the tweak bundle:

```
$ rm -rf /Library/Application Support/Tweaks/SpotifyRCD.bundle
```
