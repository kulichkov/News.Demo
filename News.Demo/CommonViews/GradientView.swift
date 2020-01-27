//
//  GradientView.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 24.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

@IBDesignable
final class FadingView: UIView {
	enum Direction: String {
		case up, down, left, right
	}

	// MARK: - Public properties
	@IBInspectable
	var fadingColor: UIColor = .clear {
		didSet {
			setLayerColors(colors)
		}
	}

	var direction: Direction = kDefaultDirection {
		didSet {
			setLayerPoints(direction)
		}
	}

	@IBInspectable
	var directionName: String = "down" {
		willSet {
			guard let newDirection = Direction(rawValue: newValue.lowercased()) else {
				direction = FadingView.kDefaultDirection
				return
			}
			direction = newDirection
		}
	}

	// MARK: - Private properties
	static private let kDefaultDirection: Direction = .down

	override var backgroundColor: UIColor? {
		didSet {
			super.backgroundColor = .clear
		}
	}

	private var colors: [UIColor] {
		[fadingColor.withAlphaComponent(0), fadingColor.withAlphaComponent(0.7), fadingColor].compactMap { $0 }
	}

	private var locations: [CGFloat] {
		[0, 0.35, 1]
	}

	override class var layerClass: AnyClass {
		return CAGradientLayer.self
	}

	// MARK: - Private properties
	private var gradientLayer: CAGradientLayer {
		guard let layer = layer as? CAGradientLayer else {
			fatalError("\(#file): Layer class is not CAGradientLayer")
		}
		return layer
	}

	// MARK: - Public functions

	// MARK: - Private functions
	private func setLayerColors(_ colors: [UIColor]) {
		gradientLayer.colors = colors.map { $0.cgColor }
	}

	private func setLayerLocations(_ locations: [CGFloat]) {
		gradientLayer.locations = locations.map { NSNumber(value: Float($0)) }
	}

	private func setLayerPoints(_ direction: Direction) {
		switch direction {
		case .up:
			gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
			gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		case .down:
			gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
			gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		case .right:
			gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
			gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
		case .left:
			gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
			gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		}
	}

}
