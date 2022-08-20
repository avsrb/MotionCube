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
        
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleTap))
        return tapGesture
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePan))
        return panGesture
    }()
    
    private lazy var pinchGesture: UIPinchGestureRecognizer = {
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(handlePitch))
        return pinchGesture
    }()
    
    private lazy var rotateGesture: UIRotationGestureRecognizer = {
        let rotationGesture = UIRotationGestureRecognizer()
        rotationGesture.addTarget(self, action: #selector(handleRotate))
        return rotationGesture
    }()
    
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    
    private lazy var gravity = UIGravityBehavior(items: [])
    private lazy var collision = UICollisionBehavior(items: [])
    private lazy var elasticity = UIDynamicItemBehavior(items: [])
    private lazy var motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(rotateGesture)

        //TODO: исправть баг
        tapGesture.delegate = self
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotateGesture.delegate = self
        collision.collisionDelegate = self
        
//        tapGesture.require(toFail: tapGesture)
        elasticity.elasticity = 65/100
        collision.translatesReferenceBoundsIntoBoundary = true
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(elasticity)
        // почитать про это
//        motion.startAccelerometerUpdates(to: .main) { <#CMAccelerometerData?#>, <#Error?#> in
//            <#code#>
//        }

    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        
        let center = CGPoint(
            x: location.x - initialSize.width / 2,
            y: location.y - initialSize.height / 2
        )
        
        let newShape = ShapeView(frame: .init(origin: center, size: initialSize))
        
        //гениальная вещь
        [panGesture, pinchGesture, rotateGesture].forEach {
            newShape.addGestureRecognizer($0)
        }
        
        view.addSubview(newShape)
        
        gravity.addItem(newShape)
        collision.addItem(newShape)
        elasticity.addItem(newShape)
    }

    //done
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
        case .ended:
            gravity.addItem(shapeView)
        case .cancelled:
            gravity.addItem(shapeView)
        case .failed:
            gravity.addItem(shapeView)
        @unknown default:
            break
        }
    }
    
    @objc
    private func handlePitch(_ gesture: UIPinchGestureRecognizer) {
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
//            gesture.view?.transform = (gesture.view?.transform)!.scaledBy(x: gesture.scale, y: gesture.scale)
            shapeView.transform = shapeView.transform.scaledBy(
                x: gesture.scale,
                y: gesture.scale
            )
            gesture.scale = 0
            collision.addItem(shapeView)
            elasticity.addItem(shapeView)
            animator.updateItem(usingCurrentState: shapeView)
        case .ended:
            gravity.addItem(shapeView)
        case .cancelled:
            gravity.addItem(shapeView)
        case .failed:
            gravity.addItem(shapeView)
        @unknown default:
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
        case .cancelled:
            gravity.addItem(shapeView)
        case .failed:
            gravity.addItem(shapeView)
        @unknown default:
            break
        }
    }

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        true
//    }
}
