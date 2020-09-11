//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "IndeterminateProgressBarView")
public typealias MSIndeterminateProgressBarView = IndeterminateProgressBarView

/**
Indeterminate progress bar view
 */
@objc(MSFIndeterminateProgressBarView)
open class IndeterminateProgressBarView: UIView {
	
	/// Layers covering the subviews of the container
	var trackLayer = CALayer()

	/// Layer that slides to provide the "shimmer" effect
	var gradientLayer = CAGradientLayer()
	
	@objc override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		trackLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 4.0)
		//trackLayer.backgroundColor = UIColor.lightGray.cgColor
		layer.addSublayer(trackLayer)
		
		addGradientLayer()
		addAnimation()
	}
	
	
	func addGradientLayer() {
		
	
		let lightColor : CGColor = UIColor.blue.withAlphaComponent(0.1).cgColor
		//let darkColor : CGColor = Colors.primary(for: window)
		let darkColor : CGColor = UIColor.blue.cgColor
		
		gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 4.0)
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		gradientLayer.colors = [lightColor, darkColor, lightColor]
		gradientLayer.locations = [0.0, 0.5, 1.0]
		gradientLayer.opacity = 0.0
		layer.addSublayer(gradientLayer)

	}

	func addAnimation() {
		
		let groupAnimation = CAAnimationGroup()
		
		let position = CABasicAnimation(keyPath: "position.x")
		position.fromValue = CGPoint.zero
		position.toValue = frame.width
		
		let opacity = CAKeyframeAnimation(keyPath: "opacity")
		opacity.keyTimes = [0, 0.25, 0.75, 1]
		opacity.values = [0.0, 1.0, 1.0, 0.0]
		opacity.isRemovedOnCompletion = false
		opacity.fillMode = CAMediaTimingFillMode.forwards
		
		let locations = CABasicAnimation(keyPath: "locations")
		locations.fromValue = [-1.0, -0.5, 0.0, 0.5]
		locations.toValue = [1.0, 1.5, 2.0, 2.5]
		
		groupAnimation.animations = [opacity, locations]
		groupAnimation.repeatCount = .infinity
		groupAnimation.duration = 2.5
		groupAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.28, 0.08, 0.72, 0.92)
		
		gradientLayer.add(groupAnimation, forKey: nil)
	}
	
}
