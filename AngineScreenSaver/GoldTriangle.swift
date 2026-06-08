import CoreGraphics
import Foundation

class GoldTriangle {

    var position: CGPoint
    private var velocity: CGPoint
    private let bounds: CGRect
    private let baseSize: CGFloat = 72
    private let speed: CGFloat    = 1.5   // px/frame — slow, hypnotic, corner-hunt energy

    private static let gold     = CGColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.0)
    private static let darkGold = CGColor(red: 0.72, green: 0.53, blue: 0.04, alpha: 1.0)

    init(bounds: CGRect) {
        self.bounds = bounds
        position = CGPoint(x: bounds.midX, y: bounds.midY)

        // Start at a diagonal angle so it immediately hunts corners
        // Avoid purely horizontal/vertical (boring) by clamping to 25°–65°
        let angle = CGFloat.random(in: 0.44...1.13)
        let sx: CGFloat = Bool.random() ? 1 : -1
        let sy: CGFloat = Bool.random() ? 1 : -1
        velocity = CGPoint(x: cos(angle) * speed * sx,
                           y: sin(angle) * speed * sy)
    }

    func update() {
        position.x += velocity.x
        position.y += velocity.y

        // Use baseSize as a conservative margin so triangle never clips edge
        let m = baseSize

        if position.x < m {
            position.x = m
            velocity.x = abs(velocity.x)
        } else if position.x > bounds.width - m {
            position.x = bounds.width - m
            velocity.x = -abs(velocity.x)
        }

        if position.y < m {
            position.y = m
            velocity.y = abs(velocity.y)
        } else if position.y > bounds.height - m {
            position.y = bounds.height - m
            velocity.y = -abs(velocity.y)
        }
    }

    func draw(in ctx: CGContext) {
        let s = baseSize
        ctx.saveGState()
        ctx.translateBy(x: position.x, y: position.y)

        let path = CGMutablePath()
        path.move(to:    CGPoint(x:  0,          y:  s))
        path.addLine(to: CGPoint(x: -s * 0.8660, y: -s * 0.5))
        path.addLine(to: CGPoint(x:  s * 0.8660, y: -s * 0.5))
        path.closeSubpath()

        ctx.addPath(path)
        ctx.setFillColor(GoldTriangle.gold)
        ctx.fillPath()

        ctx.addPath(path)
        ctx.setStrokeColor(GoldTriangle.darkGold)
        ctx.setLineWidth(3.0)
        ctx.strokePath()

        ctx.restoreGState()
    }
}
