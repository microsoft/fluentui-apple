//
// Copyright Microsoft Corporation
//

import AppKit

/// CATextLayer with vertically centered text
class CenteredTextLayer: CATextLayer {
    
    /// Translates the drawn text to be vertically centered
    override func draw(in ctx: CGContext) {
        let height = self.bounds.size.height
        let fontHeight = (font?.ascender ?? fontSize) - (font?.descender ?? 0.0)
        let yDiff = (height - fontHeight) / 2
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: -yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
