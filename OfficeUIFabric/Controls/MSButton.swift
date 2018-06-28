//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

open class MSButton : UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open func initialize() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
    }
}
