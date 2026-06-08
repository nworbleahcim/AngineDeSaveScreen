# anginescreen

macOS screen saver for the band **Angine de Poitrine** — a Quebec math-rock duo known for black-and-white polka-dot costumes, oversized papier-mâché masks, and a gold triangle as their rallying symbol.

## Project structure

```
anginescreen.xcodeproj/     Xcode project (Swift, macOS Screen Saver bundle)
AngineScreenSaver/
  AngineScreenSaverView.swift   Main ScreenSaverView — animation loop, drawing
  Figure.swift                  Dot struct
  GoldTriangle.swift            The bouncing gold triangle
  Info.plist                    Bundle metadata (NSPrincipalClass = AngineScreenSaverView)
```

## What it does

- **Background**: screen split vertically — white left half, black right half
- **Dots**: black and white polka dots of varied sizes accumulate one per side every ~0.3 seconds, stacking on each other indefinitely (up to a 4,000-dot cap). White dots have a black outline; black dots have a white outline.
- **Gold triangle**: bounces around the screen DVD-screensaver style, always drawn on top of dots. Starts at a random diagonal angle and reflects off all four edges — never rotates, always tip-up.

## Build & install

```bash
# Build
xcodebuild -project anginescreen.xcodeproj -scheme AngineScreenSaver -configuration Debug build

# Install (open prompts macOS to install the .saver bundle)
open ~/Library/Developer/Xcode/DerivedData/anginescreen-*/Build/Products/Debug/AngineScreenSaver.saver

# Force reload after reinstall
killall ScreenSaverEngine; killall legacyScreenSaver
```

Then open **System Settings → Screen Saver** and select **AngineScreenSaver**.

## Key implementation notes

- `ScreenSaverView` subclass uses `animationTimeInterval = 1/60` for 60fps.
- Dots are painted onto a `CGLayer` once and never redrawn — rendering cost stays flat regardless of how many dots have accumulated.
- `NSPrincipalClass` in Info.plist is `AngineScreenSaverView` (no module prefix) with `@objc(AngineScreenSaverView)` on the Swift class.
- Target: `com.apple.product-type.bundle` with `WRAPPER_EXTENSION = saver`, deployment target macOS 13.0.

## Tuning knobs

| Constant | File | Effect |
|---|---|---|
| `spawnInterval` | AngineScreenSaverView | Frames between dot pairs (lower = faster fill) |
| `hardCap` | AngineScreenSaverView | Max total dots before spawning stops |
| `speed` | GoldTriangle | Triangle px/frame (currently 1.5) |
| `baseSize` | GoldTriangle | Triangle size and bounce margin |
