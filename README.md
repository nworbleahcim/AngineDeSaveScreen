# AngineDeSaveScreen

A macOS screen saver inspired by the band [Angine de Poitrine](https://en.wikipedia.org/wiki/Angine_de_Poitrine) — the Quebec math-rock duo known for their black-and-white polka-dot costumes and gold triangle symbol.

## What it looks like

- Screen split vertically: white left half, black right half
- Black and white polka dots of varied sizes accumulate one by one on both sides, stacking on each other over time
- A gold triangle bounces around the screen DVD-screensaver style, always floating on top of the dots

## Requirements

- macOS 13 (Ventura) or later
- Xcode 14 or later (to build from source)

## Install from source

**1. Clone the repo**
```bash
git clone https://github.com/nworbleahcim/AngineDeSaveScreen.git
cd AngineDeSaveScreen
```

**2. Build**
```bash
xcodebuild -project AngineDeSaveScreen.xcodeproj -scheme AngineDeSaveScreen -configuration Debug build
```

**3. Install**
```bash
open ~/Library/Developer/Xcode/DerivedData/AngineDeSaveScreen-*/Build/Products/Debug/AngineDeSaveScreen.saver
```

macOS will ask whether to install for all users or just you — pick **Just for Me**.

**4. Activate**

Open **System Settings → Screen Saver** and select **AngineDeSaveScreen** from the list.

## Uninstall

```bash
rm -rf ~/Library/Screen\ Savers/AngineDeSaveScreen.saver
```

Then select a different screen saver in System Settings.

## About the band

Angine de Poitrine is a masked Quebec math-rock duo. Their visual identity — black-and-white polka-dot costumes, oversized papier-mâché masks, and a gold triangle as a rallying symbol — is the direct inspiration for this screen saver.

- [Wikipedia](https://en.wikipedia.org/wiki/Angine_de_Poitrine)
- [Euronews profile](https://www.euronews.com/culture/2026/04/07/who-are-viral-math-rock-duo-angine-de-poitrine-and-is-the-hype-justified)
