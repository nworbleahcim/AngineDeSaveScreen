import Cocoa

enum CenterMode: Int {
    case pyramid  = 0
    case bandImage = 1
}

class GoldTriangle {

    var position: CGPoint
    var mode: CenterMode = .pyramid

    private var velocity: CGPoint
    private let bounds: CGRect
    private let baseSize: CGFloat = 72
    private let speed: CGFloat    = 1.5

    private static let gold     = CGColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.0)
    private static let darkGold = CGColor(red: 0.72, green: 0.53, blue: 0.04, alpha: 1.0)

    // Loaded once from the bundle, decoded straight to CGImage for direct blit
    private lazy var bandCGImage: CGImage? = {
        Bundle(for: GoldTriangle.self)
            .url(forResource: "hands", withExtension: "png")
            .flatMap { CGDataProvider(url: $0 as CFURL) }
            .flatMap { CGImage(pngDataProviderSource: $0, decode: nil, shouldInterpolate: true, intent: .defaultIntent) }
    }()

    // Computed once and cached — result is constant for the lifetime of the saver
    private lazy var scaledImageSize: CGSize = {
        guard let img = bandCGImage else {
            return CGSize(width: baseSize * 2, height: baseSize * 2)
        }
        let targetHeight: CGFloat = baseSize * 1.5        // 108 pt — same as drawn pyramid tip-to-base
        let triangleFrac: CGFloat = 0.33                  // triangle occupies ~33% of image height
        let scale = targetHeight / (CGFloat(img.height) * triangleFrac)
        return CGSize(width: CGFloat(img.width) * scale, height: CGFloat(img.height) * scale)
    }()

    private var xMargin: CGFloat {
        mode == .bandImage ? scaledImageSize.width  / 2 : baseSize
    }
    private var yMargin: CGFloat {
        mode == .bandImage ? scaledImageSize.height / 2 : baseSize
    }

    init(bounds: CGRect) {
        self.bounds = bounds
        position = CGPoint(x: bounds.midX, y: bounds.midY)
        let angle = CGFloat.random(in: 0.44...1.13)
        let sx: CGFloat = Bool.random() ? 1 : -1
        let sy: CGFloat = Bool.random() ? 1 : -1
        velocity = CGPoint(x: cos(angle) * speed * sx,
                           y: sin(angle) * speed * sy)
    }

    func update() {
        position.x += velocity.x
        position.y += velocity.y

        let mx = xMargin
        let my = yMargin

        if position.x < mx {
            position.x = mx;  velocity.x =  abs(velocity.x)
        } else if position.x > bounds.width - mx {
            position.x = bounds.width - mx;  velocity.x = -abs(velocity.x)
        }
        if position.y < my {
            position.y = my;  velocity.y =  abs(velocity.y)
        } else if position.y > bounds.height - my {
            position.y = bounds.height - my;  velocity.y = -abs(velocity.y)
        }
    }

    func draw(in ctx: CGContext) {
        switch mode {
        case .pyramid:   drawPyramid(in: ctx)
        case .bandImage: drawBandImage(in: ctx)
        }
    }

    private func drawPyramid(in ctx: CGContext) {
        let s = baseSize
        ctx.saveGState()
        ctx.translateBy(x: position.x, y: position.y)

        let path = CGMutablePath()
        path.move(to:    CGPoint(x:  0,          y:  s))
        path.addLine(to: CGPoint(x: -s * 0.8660, y: -s * 0.5))
        path.addLine(to: CGPoint(x:  s * 0.8660, y: -s * 0.5))
        path.closeSubpath()

        ctx.addPath(path);  ctx.setFillColor(GoldTriangle.gold);    ctx.fillPath()
        ctx.addPath(path);  ctx.setStrokeColor(GoldTriangle.darkGold)
        ctx.setLineWidth(3.0);  ctx.strokePath()

        ctx.restoreGState()
    }

    private func drawBandImage(in ctx: CGContext) {
        guard let image = bandCGImage else { drawPyramid(in: ctx); return }

        let sz   = scaledImageSize
        let rect = CGRect(x: position.x - sz.width  / 2,
                          y: position.y - sz.height / 2,
                          width: sz.width, height: sz.height)
        ctx.draw(image, in: rect)
    }
}
