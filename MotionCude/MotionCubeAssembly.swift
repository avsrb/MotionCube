//
//  MotionCubeAssembly.swift
//  MotionCude
//
//  Created by Artem Serebriakov on 19.08.2022.
//

import UIKit

protocol IMotionCude {
    func assemble() -> UIViewController
}

final class MotionCudeAssembly: IMotionCude {
    func assemble() -> UIViewController {
        let viewController = ViewController()
        return viewController
    }
}
