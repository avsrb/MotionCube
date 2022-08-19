//
//  ViewController.swift
//  MotionCude
//
//  Created by Artem Serebriakov on 19.08.2022.
//

import UIKit

final class ViewController: UIViewController, UIGestureRecognizerDelegate {

    private lazy var initialSize = CGSize(width: 100, height: 100)
    
    private lazy var square = UIView(frame: CGRect(x: 10, y: 10, width: 300, height: 300))
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        square.addGestureRecognizer(tapGesture)
        view.backgroundColor = .orange
        
        square.backgroundColor = .red
        view.addSubview(square)
        square.addGestureRecognizer(tapGesture)
        square.addGestureRecognizer(panGesture)
        square.addGestureRecognizer(pinchGesture)
        square.addGestureRecognizer(rotateGesture)

//        let views = view.subviews.filter {
//            $0 is UIView
//        }
//
//        for view in views {
//            let tapGesture = UIGestureRecognizer()
//            tapGesture.addTarget(self, action: #selector(handleTap))

            tapGesture.delegate = self
//            view.addGestureRecognizer(tapGesture)
//        }
        tapGesture.require(toFail: tapGesture)
        
    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {

    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: square)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: square)
        //анимация
        /*
        guard gesture.state == .began else {
            return
        }
        
        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
        
        let slideFactor = 0.1 * slideMultiplier
        
        var finalPoint = CGPoint(
            x: gestureView.center.x + (velocity.x * slideFactor),
            y: gestureView.center.y + (velocity.y * slideFactor)
        )
        
        finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
        finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)
        
        UIView.animate(
            withDuration: Double(slideFactor * 2),
            delay: 0,
            options: .curveEaseIn,
            animations: {
                gestureView.center = finalPoint
            })
         */
    }
    
    @objc
    private func handlePitch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform.scaledBy(
            x: gesture.scale,
            y: gesture.scale
        )
        gesture.scale = 1
    }
    
    @objc
    func handleRotate(_ gesture:UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
 
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

