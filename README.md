# PSLinkedIn
**LinkedIn without the feed.**\
`Version v0.1.0` | `Tested on LinkedIn 9.1.555`

PSLinkedIn is an iOS tweak that turns LinkedIn into a networking tool. The home feed, the vertical video feed and the post button are gone, so there is nothing to scroll. What stays: My Network, Notifications, Jobs, messaging, search and your profile.

Sister projects: [PSInstagram](https://github.com/pstepanovum/PSInstagram), [PSYoutube](https://github.com/pstepanovum/PSYoutube) and [PSSoundcloud](https://github.com/pstepanovum/PSSoundcloud), the same idea for other apps.

---

## What you get
- **No home feed**: the Home tab is removed (both the classic and the server-driven feed), along with everything in it, such as "Videos for you" and promoted posts
- **No video feed**: the full-screen vertical video player can't be opened
- **No Post tab**
- **Opens on My Network**
- **Settings that don't slip**: strict defaults, backed up to the iOS keychain and restored after a reinstall

## Opening the settings
Hold **four fingers** anywhere on the screen for a second.

## Installing
PSLinkedIn is sideloaded: you inject it into a decrypted LinkedIn IPA and sign that with your own certificate. It gets its own bundle ID (`com.pstepanovum.pslinkedin`), so it installs next to the official LinkedIn app.

### Prerequisites
- Xcode with the command-line tools, and [Homebrew](https://brew.sh)
- [Theos](https://theos.dev/docs/installation) with the iOS 16.2 SDK in `~/theos/sdks` ([SDKs](https://github.com/xybp888/iOS-SDKs))
- [cyan](https://github.com/asdfzxcvbn/pyzule-rw) and [zsign](https://github.com/zhlynn/zsign)
- A decrypted LinkedIn IPA

> [!NOTE]
> Newer Theos versions ship a Logos change that breaks `%orig` inside macros. Pin Logos to the last working commit:
> ```sh
> cd ~/theos/vendor/logos && git checkout a62370066a97e36d59b200a9fa10c5091f5e8972
> ```

### Setup
```sh
git clone --recurse-submodules https://github.com/pstepanovum/PSLinkedIn
cd PSLinkedIn
mkdir -p packages certs
```
Then add:
- `packages/com.linkedin.LinkedIn.ipa`: the decrypted LinkedIn IPA
- `certs/dev.p12`: your signing certificate
- `certs/dev.mobileprovision`: its provisioning profile
- `certs/p12-password`: the certificate password

`packages/` and `certs/` are ignored by git.

### Build, sign and install
With your iPhone connected:
```sh
./dev.sh              # build, sign and install
./dev.sh --clean      # full rebuild first
./dev.sh --no-install # only create packages/PSLinkedIn-signed.ipa
BUNDLE_ID=com.example.linkedin ./dev.sh   # use a different bundle ID
```

`dev.sh` signs with a minimal set of entitlements taken from your profile, because some reseller profiles contain malformed wildcard entitlements that crash LinkedIn.

## Known limitations
- **Updating over an existing install can fail**, in which case `dev.sh` reinstalls it. Your PSLinkedIn settings come back from the keychain, but you may need to sign in to LinkedIn again.
- **App extensions are removed** (share sheet, widgets, rich notifications).
- **Use at your own risk.** Modified clients are against LinkedIn's terms of use.

## Credits
The settings screen and the sideloading fixes come from [PSInstagram](https://github.com/pstepanovum/PSInstagram), which is a fork of [SCInsta](https://github.com/SoCuul/SCInsta) by SoCuul. See [NOTICE](NOTICE).

Bundled libraries:
- [FLEXing](https://github.com/SoCuul/FLEXing) / [FLEX](https://github.com/FLEXTool/FLEX): in-app debugging
- [fishhook](https://github.com/facebook/fishhook): symbol rebinding for the keychain fixes

## License
[GNU General Public License v3.0](LICENSE)
