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
	
	/// progressbar's track
	var trackLayer = CALayer()

	/// gradient layer that slides across the track
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
		layer.addSublayer(trackLayer)
	
		addGradientLayer()
		addAnimation()
	}
	
	open override func didMoveToWindow() {
		super.didMoveToWindow()
		
		if let window = window {
			let lightColor : CGColor = Colors.primary(for: window).withAlphaComponent(0).cgColor
			let darkColor : CGColor = Colors.primary(for: window).cgColor
			
			gradientLayer.colors = [lightColor, darkColor, lightColor]
			trackLayer.backgroundColor = Colors.gray100.cgColor
		}
	}
	
	func addGradientLayer() {
		gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width/2, height: 4.0)
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		gradientLayer.locations = [0.0, 0.5, 1.0]
		layer.addSublayer(gradientLayer)
	}

	func addAnimation() {
		let groupAnimation = CAAnimationGroup()
		
		let position = CABasicAnimation(keyPath: "position.x")
		position.fromValue = -frame.width / 2
		position.toValue = frame.width * 1.5
		
		let opacity = CAKeyframeAnimation(keyPath: "opacity")
		opacity.keyTimes = [0, 0.375, 0.625, 1]
		opacity.values = [0.0, 1.0, 1.0, 0.0]
		opacity.isRemovedOnCompletion = false
		opacity.fillMode = CAMediaTimingFillMode.forwards
		
		groupAnimation.animations = [opacity, position]
		groupAnimation.repeatCount = .infinity
		groupAnimation.duration = 2.5
		groupAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.28, 0.08, 0.72, 0.92)
		
		gradientLayer.add(groupAnimation, forKey: nil)
	}
	
}
