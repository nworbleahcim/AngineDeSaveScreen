import ScreenSaver

@objc(AngineScreenSaverView)
class AngineScreenSaverView: ScreenSaverView {

    private var triangle: GoldTriangle!

    // Dot canvas — dots are painted here once and never redrawn
    private var dotLayer: CGLayer?
    private var pendingDots: [Dot] = []

    private var totalSpawned: Int = 0
    private var frameCounter: Int = 0

    // ~3 pairs per second; 4 000 dots takes ~22 minutes — safe memory & perf ceiling
    private let spawnInterval = 18
    private let hardCap       = 4_000

    // MARK: - Init

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        animationTimeInterval = 1.0 / 60.0
        triangle = GoldTriangle(bounds: bounds)
    }

    // MARK: - Animation

    override func animateOneFrame() {
        super.animateOneFrame()
        frameCounter += 1

        triangle.update()

        if totalSpawned < hardCap, frameCounter % spawnInterval == 0 {
            pendingDots.append(makeDot(onLeftSide: true))
            pendingDots.append(makeDot(onLeftSide: false))
            totalSpawned += 2
        }

        needsDisplay = true
    }

    // MARK: - Drawing

    override func draw(_ rect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        // First draw: create the layer and paint the background into it
        if dotLayer == nil {
            dotLayer = CGLayer(ctx, size: bounds.size, auxiliaryInfo: nil)
            if let lctx = dotLayer?.context {
                paintBackground(in: lctx)
            }
        }

        // Paint any new dots onto the persistent layer
        if let lctx = dotLayer?.context, !pendingDots.isEmpty {
            for dot in pendingDots {
                paint(dot, in: lctx)
            }
            pendingDots.removeAll()
        }

        // Composite the dot layer — single draw call regardless of dot count
        if let layer = dotLayer {
            ctx.draw(layer, at: .zero)
        }

        // Pyramid is always drawn fresh on top — never obscured by dots
        triangle.draw(in: ctx)
    }

    // MARK: - Helpers

    private func paintBackground(in ctx: CGContext) {
        let mid = bounds.midX
        ctx.setFillColor(CGColor.white)
        ctx.fill(CGRect(x: 0, y: 0, width: mid, height: bounds.height))
        ctx.setFillColor(CGColor.black)
        ctx.fill(CGRect(x: mid, y: 0, width: bounds.width - mid, height: bounds.height))
    }

    private func paint(_ dot: Dot, in ctx: CGContext) {
        let r    = dot.radius
        let rect = CGRect(x: dot.position.x - r, y: dot.position.y - r,
                          width: r * 2, height: r * 2)
        ctx.setFillColor(dot.isWhite ? CGColor.white : CGColor.black)
        ctx.fillEllipse(in: rect)
        ctx.setStrokeColor(dot.isWhite ? CGColor.black : CGColor.white)
        ctx.setLineWidth(max(2.0, r * 0.055))
        ctx.strokeEllipse(in: rect)
    }

    private func makeDot(onLeftSide: Bool) -> Dot {
        let pad: CGFloat = 10
        let mid = bounds.midX
        let x: CGFloat = onLeftSide
            ? .random(in: pad...(mid - pad))
            : .random(in: (mid + pad)...(bounds.width - pad))
        let y = CGFloat.random(in: pad...(bounds.height - pad))
        // Take the larger of two samples → biases toward bigger, chunkier dots
        let r = max(CGFloat.random(in: 12...70), CGFloat.random(in: 12...70))
        return Dot(position: CGPoint(x: x, y: y), radius: r, isWhite: Bool.random())
    }

    // MARK: - Config

    override var hasConfigureSheet: Bool { false }
    override var configureSheet: NSWindow? { nil }
}
