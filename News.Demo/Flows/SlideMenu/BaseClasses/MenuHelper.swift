//
//  MenuHelper.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 27.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

// https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
import UIKit

enum MenuSlideDirection {
	case up
	case down
	case left
	case right
}

struct MenuHelper {

	//static let menuWidthRatio: CGFloat = 0.6
	static let percentThreshold: CGFloat = 0.3
	//static let snapshotTag = 11111

	static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: MenuSlideDirection) -> CGFloat {
		let pointOnAxis: CGFloat
		let axisLength: CGFloat
		switch direction {
		case .up, .down:
			pointOnAxis = translationInView.y
			axisLength = viewBounds.height
		case .left, .right:
			pointOnAxis = translationInView.x
			axisLength = viewBounds.width
		}
		let movementOnAxis = pointOnAxis / axisLength
		let positiveMovementOnAxis: Float
		let positiveMovementOnAxisPercent: Float
		switch direction {
		case .right, .down: // positive
			positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
			positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
			return CGFloat(positiveMovementOnAxisPercent)
		case .up, .left: // negative
			positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
			positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
			return CGFloat(-positiveMovementOnAxisPercent)
		}
	}

	static func mapGestureStateToInteractor(gestureState: UIGestureRecognizer.State, progress: CGFloat, interactor: MenuInteractor?, triggerSegue: () -> Void) {
		guard let interactor = interactor else { return }
		switch gestureState {
		case .began:
			interactor.hasStarted = true
			triggerSegue()
		case .changed:
			interactor.shouldFinish = progress > percentThreshold
			interactor.update(progress)
		case .cancelled:
			interactor.hasStarted = false
			interactor.cancel()
		case .ended:
			interactor.hasStarted = false
			interactor.shouldFinish
				? interactor.finish()
				: interactor.cancel()
		default:
			break
		}
	}
}
