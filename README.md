# AngineDeSaveScreen

A macOS screen saver inspired by the band [Angine de Poitrine](https://en.wikipedia.org/wiki/Angine_de_Poitrine) — the Quebec math-rock duo known for their black-and-white polka-dot costumes and gold triangle symbol.

## What it looks like

- Screen split vertically: white left half, black right half
- Black and white polka dots of varied sizes accumulate one by one on both sides, stacking on each other over time. Once 4,000 dots fill the canvas (~22 minutes), it wipes clean and the cycle begins again
- A gold triangle bounces around the screen DVD-screensaver style, always floating on top of the dots throughout every cycle
- **Options**: click the Options button in System Settings to switch the bouncing element between the gold pyramid (default) and the band artwork image

## Requirements

- macOS 13 (Ventura) or later

## Install (download)

**1. Download**

Grab `AngineDeSaveScreen.zip` from the [latest release](https://github.com/nworbleahcim/AngineDeSaveScreen/releases/latest), unzip it, and double-click `AngineDeSaveScreen.saver`.

macOS will ask whether to install for all users or just you — pick **Just for Me**.

**2. Gatekeeper warning**

Because this app is not notarized, macOS may block it with *"cannot be opened because the developer cannot be verified."* To get past this:

1. Open **System Settings → Privacy & Security**
2. Scroll down to the Security section
3. You should see a message about AngineDeSaveScreen being blocked — click **Open Anyway**
4. Double-click the `.saver` file again to install

**3. Activate**

Open **System Settings → Screen Saver** and select **AngineDeSaveScreen** from the list.

## Uninstall

```bash
rm -rf ~/Library/Screen\ Savers/AngineDeSaveScreen.saver
```

Then select a different screen saver in System Settings.

## Build from source

Requires Xcode 14 or later.

**1. Clone**
```bash
git clone https://github.com/nworbleahcim/AngineDeSaveScreen.git
cd AngineDeSaveScreen
```

**2. Build**
```bash
xcodebuild -project AngineDeSaveScreen.xcodeproj -scheme AngineDeSaveScreen -configuration Release build
```

**3. Install**
```bash
open ~/Library/Developer/Xcode/DerivedData/AngineDeSaveScreen-*/Build/Products/Release/AngineDeSaveScreen.saver
```

## About the band

Angine de Poitrine is a masked Quebec math-rock duo. Their visual identity — black-and-white polka-dot costumes, oversized papier-mâché masks, and a gold triangle as a rallying symbol — is the direct inspiration for this screen saver.

- [Wikipedia](https://en.wikipedia.org/wiki/Angine_de_Poitrine)
- [Euronews profile](https://www.euronews.com/culture/2026/04/07/who-are-viral-math-rock-duo-angine-de-poitrine-and-is-the-hype-justified)
