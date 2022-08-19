//
//  ViewController.swift
//  MotionCude
//
//  Created by Artem Serebriakov on 19.08.2022.
//

import UIKit

final class ViewController: UIViewController, UIGestureRecognizerDelegate {

    private lazy var initialSize = CGSize(width: 100, height: 100)
    
    private lazy var square = UIView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        square.addGestureRecognizer(tapGesture)
        view.backgroundColor = .orange
        
        square.backgroundColor = .red
        view.addSubview(square)
        square.addGestureRecognizer(panGesture)
//        let views = view.subviews.filter {
//            $0 is UIView
//        }
//
//        for view in views {
//            let tapGesture = UIGestureRecognizer()
//            tapGesture.addTarget(self, action: #selector(handleTap))
//
//            tapGesture.delegate = self
//            view.addGestureRecognizer(tapGesture)
//        }
//        tapGesture.require(toFail: tapGesture)
        
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
    }
    
    @objc
    private func handlePitch(_ gesture: UIPinchGestureRecognizer) {
        
    }
    
}

