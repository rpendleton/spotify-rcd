mac-spotify-rcd
===============

Makes the playback control keys on a MacBook Pro open spotify instead of iTunes

### Installation

- Create the tweaks directory: (you can use a different directory, this is just the directory I use for my tweaks)
```
$ sudo mkdir -p "/Application Support/Inline-Studios/loader/tweaks"
$ sudo chown -R $USER:staff "/Application Support/Inline-Studios/loader/tweaks"
```

- Compile the project. It will attempt to install itself in `/Application Support/Inline-Studios/loader/tweaks`. If you changed the path above, you'll want to fix this in the Xcode build settings, or copy the product manually.

- Copy `/System/Library/LaunchAgents/com.apple.rcd.plist` to somewhere you can edit it, or use an editor that supports editing with root privileges. Make sure you replace it after editing it. (You may want to back it up as well.) The following needs to be added in order to inject the plugin on startup: 
```
<key>EnvironmentVariables</key>
<dict>
        <key>DYLD_INSERT_LIBRARIES</key>
        <string>/Library/Application Support/Inline-Studios/loader/tweaks/SpotifyRCD.bundle/Contents/MacOS/SpotifyRCD</string>
</dict>
```

- Next, restart your computer or manually restart the daemon:
```
$ launchctl unload /System/Library/LaunchAgents/com.apple.rcd.plist
$ launchctl load /System/Library/LaunchAgents/com.apple.rcd.plist
$ killall -kill rcd
```

- Pressing the Play button should now open Spotify. If you install an OS upgrade, you may have to repeat the last two steps (replacing the plist file and restarting the daemon).
