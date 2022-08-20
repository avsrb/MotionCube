//
//  ViewController.swift
//  MotionCude
//
//  Created by Artem Serebriakov on 19.08.2022.
//

import UIKit
import CoreMotion

final class ViewController: UIViewController, UIGestureRecognizerDelegate, UICollisionBehaviorDelegate {

    private lazy var initialSize = CGSize(width: 100, height: 100)
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private lazy var gravity = UIGravityBehavior(items: [])
    private lazy var collision = UICollisionBehavior(items: [])
    private lazy var elasticity = UIDynamicItemBehavior(items: [])
    private lazy var motionManager = CMMotionManager()
    private lazy var motionQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        elasticity.elasticity = 65/100
        collision.translatesReferenceBoundsIntoBoundary = true
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(elasticity)
        activateAccelerometer()
    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        
        let center = CGPoint(
            x: location.x - initialSize.width / 2,
            y: location.y - initialSize.height / 2
        )
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pitch = UIPinchGestureRecognizer(target: self, action: #selector(handlePitch))
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        
        let newShape = ShapeView(frame: .init(origin: center, size: initialSize))
        view.addSubview(newShape)
        
        [pan, pitch, rotate].forEach {
            newShape.addGestureRecognizer($0)
            $0.delegate = self
        }
        
        gravity.addItem(newShape)
        collision.addItem(newShape)
        elasticity.addItem(newShape)
    }

    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let shapeView = gesture.view as? ShapeView else {
            return
        }
        
        switch gesture.state {
        case .possible:
            break
        case .began:
            gravity.removeItem(shapeView)
        case .changed:
            collision.removeItem(shapeView)
            elasticity.removeItem(shapeView)
            shapeView.center = CGPoint(
                x: shapeView.center.x + gesture.translation(in: view).x,
                y: shapeView.center.y + gesture.translation(in: view).y
            )
            collision.addItem(shapeView)
            elasticity.addItem(shapeView)
            animator.updateItem(usingCurrentState: shapeView)
            gesture.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            gravity.addItem(shapeView)
        @unknown default:
            break
        }
    }
    
    @objc
    private func handlePitch(_ gesture: UIPinchGestureRecognizer) {
        guard let shapeView = gesture.view as? ShapeView, let superview = shapeView.superview else { return }
        
        switch gesture.state {
        case .began:
            self.gravity.removeItem(shapeView)
        case .changed:
            collision.removeItem(shapeView)
            elasticity.removeItem(shapeView)
            let newWidth = shapeView.layer.bounds.size.width * gesture.scale
            let newHeigh = shapeView.layer.bounds.size.height * gesture.scale
            if newWidth < superview.bounds.width - 50 && newHeigh < superview.bounds.height - 50 && newWidth > 10 && newHeigh > 10 {
                shapeView.layer.bounds.size.width = newWidth
                shapeView.layer.bounds.size.height = newHeigh
                gesture.scale = 1
            }
            collision.addItem(shapeView)
            elasticity.addItem(shapeView)
        case .ended:
            self.gravity.addItem(shapeView)
        default:
            break
        }
    }

    @objc
    func handleRotate(_ gesture:UIRotationGestureRecognizer) {
        guard let shapeView = gesture.view as? ShapeView else {
            return
        }
        
        switch gesture.state {
        case .possible:
            print("possible")
        case .began:
            gravity.removeItem(shapeView)
        case .changed:
            collision.removeItem(shapeView)
            elasticity.removeItem(shapeView)
            shapeView.transform = shapeView.transform.rotated(
                by: gesture.rotation
            )
            gesture.rotation = 0
            collision.addItem(shapeView)
            elasticity.addItem(shapeView)
            animator.updateItem(usingCurrentState: shapeView)
        case .ended:
            gravity.addItem(shapeView)
        default:
            break
        }
    }
    
    private func activateAccelerometer() {
        motionManager.startDeviceMotionUpdates(to: motionQueue) { deviceMotion, _ in
            guard let motion = deviceMotion else { return }
            let gravity = motion.gravity
            DispatchQueue.main.async {
                self.gravity.gravityDirection = CGVector(dx: -gravity.y * 5, dy: -gravity.x * 5)
            }
        }
    }

}
