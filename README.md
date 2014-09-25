mac-spotify-rcd
===============

Makes the playback control keys on a MacBook Pro open spotify instead of iTunes

### Installation (not for the faint of heart)

- Create the tweaks directory: (you can use a different directory, this is just the directory I use for my tweaks)
```
$ sudo mkdir -p "/Application Support/Inline-Studios/loader/tweaks"
$ sudo chown -R $USER:staff "/Application Support/Inline-Studios/loader/tweaks"
```

- Compile the project. It will attempt to install itself in `/Application Support/Inline-Studios/loader/tweaks`. If you changed the path above, you'll want to fix this in the Xcode build settings, or copy the product manually.

- Copy `/System/Library/CoreServices/rcd.app/Contents/Info.plist` to somewhere you can edit it, or use an editor that supports editing with root privileges. Make sure you replace it after editing it. (You may want to back it up as well.) The following needs to be added in order to inject the plugin on startup: 
```
<key>LSEnvironment</key>
<dict>
        <key>DYLD_INSERT_LIBRARIES</key>
        <string>/Library/Application Support/Inline-Studios/loader/tweaks/SpotifyRCD.bundle/Contents/MacOS</string>
</dict>
```

- Since the application has been modified, it must be re-codesigned. This can be done using a fake certificate with the following line: `$ sudo codesign -fs - /System/Library/CoreServices/rcd.app`

- Restart your computer and test the Play button. It should now open Spotify instead of iTunes. If you install an OS upgrade, you may have to redo the last two steps.
