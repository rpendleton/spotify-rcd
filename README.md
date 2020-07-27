spotify-rcd
===============

On a standard installation of macOS, pressing the playback control keys on an
Apple keyboard opens iTunes if no other media applications are open. The purpose
of this project is to patch this behavior such that Spotify is opened instead.

## :warning: Catalina support is experimental

This project hasn't worked since High Sierra. This branch is a work-in-progress
that adds support for Catalina, but the instructions and installer are outdated,
nor have I tested the changes thoroughly. If you want to try your luck, you can
use this branch to patch the `com.apple.mediaremoted` launch daemon instead of
`com.apple.rcd`.

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

## How it works

spotify-rcd works by [injecting][injection] itself into the `com.apple.rcd`
system daemon, after which it uses [method swizzling][swizzling] to alter the
daemon's behavior.

(I'd recommend reading this section so that you know what the patch is actually
doing to your system and what risks it comes with, but you can skip to the
installation section if you're not interested in the technical details.)

### Injection

In order to load spotify-rcd into the system daemon, we take advantage of
`DYLD_INSERT_LIBRARIES`, an environment variable that allows us to load custom
images into other processes during launch. (At the moment, this injection vector
works fine for the needs of this project. However, additional restrictions are
placed on DYLD injection as part of each release of macOS, so it's likely only
a matter of time before a new injection vector will be needed.)

For `DYLD_INSERT_LIBRARIES` to work, we have to find some way of setting the
environment variable in the target process before it is launched. Conveniently,
macOS allows you to persistently unload system launch daemons and replace them
with your own patched versions as long as the labels are different. As such, all
we need to do for this to work is copy the system launch daemon configuration,
alter the label to something unique, add our environment variable, and then use
`launchctl` to persistently disable the system daemon and enable our patched
version.

### Swizzling

Now that spotify-rcd has been injected into the system daemon, we actually need
to alter the daemon's behavior to do what we want. This is where [method
swizzling][swizzling] comes in. By intercepting all AppleScript execution, we
can watch for any requests to launch iTunes and replace those with requests to
launch Spotify instead.

### Caveats

As you can imagine, all of this can be a somewhat fragile process. It's possible
that any release of macOS can break the injection *or* the swizzling. Even so,
this patch tends to be relatively safe.

Unlike other versions of this tweak, installation doesn't require modifying any
system files. The tweak can also be reverted by simply disabling the patched
daemon and enabling the unpatched daemon. Given that `com.apple.rcd` isn't a
critical system service, this makes the liklihood of serious side-effects very
unlikely.

[injection]: https://knight.sc/malware/2019/03/15/code-injection-on-macos.html
[swizzling]: https://nshipster.com/method-swizzling/

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
$ rm -rf "/Library/Application Support/Tweaks/SpotifyRCD.bundle"
```
