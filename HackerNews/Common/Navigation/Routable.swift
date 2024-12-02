//
//  Routable.swift
//  YapeChallenge
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

protocol Routable {
    
    func pushViewController<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type
    )
    
    func pushViewController<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type,
        moduleConfiguration: (T) -> Void
    )
    
    func present<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type,
        shouldBlockSwipeDown: Bool,
        shouldShowInFullScreen: Bool,
        shouldAnimate: Bool,
        presentationMode: UIModalPresentationStyle?,
        moduleConfiguration: (T) -> Void
    )

    func replaceRoot<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type,
        moduleConfiguration: (T) -> Void
    )
}

extension Routable {

    func pushViewController<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type
    ) {
        let nextViewController = nextViewControllerType.init()
        configuration.configure(viewController: nextViewController)
        viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func pushViewController<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type,
        moduleConfiguration: (T) -> Void
    ) {
        let nextViewController = nextViewControllerType.init()
        configuration.configure(viewController: nextViewController)
        moduleConfiguration(nextViewController)
        viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func present<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type,
        shouldBlockSwipeDown: Bool = false,
        shouldShowInFullScreen: Bool = false,
        shouldAnimate: Bool = true,
        presentationMode: UIModalPresentationStyle? = nil,
        moduleConfiguration: (T) -> Void
    ) {
        let nextViewController = nextViewControllerType.init()
        let navigationController = UINavigationController(rootViewController: nextViewController)

        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = shouldBlockSwipeDown
        }

        if shouldShowInFullScreen {
            navigationController.modalPresentationStyle = .fullScreen
        }

        if let presentationMode = presentationMode {
            navigationController.modalPresentationStyle = presentationMode
        }

        configuration.configure(viewController: nextViewController)
        moduleConfiguration(nextViewController)
        viewController.present(navigationController, animated: shouldAnimate)
    }
    
    func replaceRoot<T: UIViewController, C: ModuleConfigurator>(
        from viewController: UIViewController,
        to nextViewControllerType: T.Type,
        configuration: C.Type,
        moduleConfiguration: (T) -> Void
    ) {
        let nextViewController = nextViewControllerType.init()
        let viewControllers =  [nextViewController]
    
        configuration.configure(viewController: nextViewController)
        moduleConfiguration(nextViewController)
        viewController.navigationController?.setViewControllers(viewControllers, animated: true)
    }
}
