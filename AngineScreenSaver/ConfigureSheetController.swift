import Cocoa
import ScreenSaver

class ConfigureSheetController: NSObject {

    private var _sheet: NSWindow?
    private let defaults: ScreenSaverDefaults
    private var radio0: NSButton?
    private var radio1: NSButton?

    init(defaults: ScreenSaverDefaults) {
        self.defaults = defaults
    }

    var sheet: NSWindow {
        if let s = _sheet { return s }

        let w = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 340, height: 148),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        w.title = "AngineDeSaveScreen Options"
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 340, height: 148))

        let label = NSTextField(labelWithString: "Bouncing center image:")
        label.frame = NSRect(x: 20, y: 112, width: 300, height: 18)
        label.font = .boldSystemFont(ofSize: 13)
        view.addSubview(label)

        let mode = defaults.integer(forKey: "centerMode")

        let r0 = NSButton(radioButtonWithTitle: "Gold Pyramid (default)",
                          target: self, action: #selector(modeChanged(_:)))
        r0.frame = NSRect(x: 30, y: 82, width: 280, height: 20)
        r0.tag   = 0
        r0.state = mode == 0 ? .on : .off
        view.addSubview(r0)
        radio0 = r0

        let r1 = NSButton(radioButtonWithTitle: "Band Artwork (hands image)",
                          target: self, action: #selector(modeChanged(_:)))
        r1.frame = NSRect(x: 30, y: 56, width: 280, height: 20)
        r1.tag   = 1
        r1.state = mode == 1 ? .on : .off
        view.addSubview(r1)
        radio1 = r1

        let ok = NSButton(title: "OK", target: self, action: #selector(okTapped(_:)))
        ok.frame       = NSRect(x: 240, y: 14, width: 80, height: 28)
        ok.bezelStyle  = .rounded
        ok.keyEquivalent = "\r"
        view.addSubview(ok)

        w.contentView = view
        _sheet = w
        return w
    }

    @objc private func modeChanged(_ sender: NSButton) {
        defaults.set(sender.tag, forKey: "centerMode")
        defaults.synchronize()
        radio0?.state = sender.tag == 0 ? .on : .off
        radio1?.state = sender.tag == 1 ? .on : .off
    }

    @objc private func okTapped(_ sender: Any) {
        guard let sheet = _sheet else { return }
        if let parent = sheet.sheetParent {
            parent.endSheet(sheet)
        } else {
            sheet.close()
        }
    }
}
