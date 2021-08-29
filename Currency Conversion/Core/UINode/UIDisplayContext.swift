import UIKit

class UIDisplayContext: DisplayContext {
    var method: Method
    
    init(method: Method) {
        self.method = method
    }
    
    // MARK: - Display Method
    func display(_ vc: UIViewController) {

        switch method {
        case .none:
            break
        case .present(let source, let animated, let style):
        
            if animated, let target = vc as? CustomizingPresentAnimation {
                target.startPresenting(from: source)
            } else {
                vc.modalPresentationStyle = style
                source.present(vc, animated: animated, completion: nil)
            }
        
        case .push(let source, let animated):
            if let navigationController = source as? UINavigationController
                                                ?? source.navigationController {
                navigationController.pushViewController(vc, animated: animated)
            }
            
        case .embed(let source, let view):
            let sourceView = view ?? source.view ?? UIView()
            vc.view.frame = sourceView.bounds
            vc.view.translatesAutoresizingMaskIntoConstraints = true
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            if let nc = vc as? UINavigationController,
               source.tabBarController != nil {
                // Fix a problem of extra gap to bottom when embedding navigation controllors
                nc.children.forEach { $0.extendedLayoutIncludesOpaqueBars = true }
            }

            source.addChild(vc)
            sourceView.addSubview(vc.view)
            vc.didMove(toParent: source)

        case .appendToTabBarController(let source):
            guard let source = source as? UITabBarController else { break }
            var viewControllers = source.viewControllers ?? []
            viewControllers.append(vc)
            source.viewControllers = viewControllers

        case .custom(let source):
            if let source = source as? CustomDisplayable {
               source.display(target: vc)
            } else {
                print("Warning⚠️: Source is not CustomDisplayable")
            }
        }
    }
    
    
    func undisplay(_ vc: UIViewController?) {
        guard let vc = vc else { return }

        switch method {
        case .none:
            break
        case .present(_, let animated, _):
            if vc.presentedViewController != nil {
                vc.dismiss(animated: false, completion: nil)
            }
            
            if animated, let target = vc as? CustomizingPresentAnimation {
                target.startDismissing(completion: nil)
            } else {
                vc.dismiss(animated: animated, completion: nil)
            }

        case .push(let source, let animated):
            if vc.presentedViewController != nil { // dismiss presented children first
                vc.dismiss(animated: false, completion: nil)
            }

            if let navigationController = source as? UINavigationController
                                                  ?? source.navigationController {
                if navigationController.topViewController == vc {
                    navigationController.popViewController(animated: animated)
                } else if let index = navigationController.viewControllers.firstIndex(of: vc),
                          index >= 1 {
                    navigationController.popToViewController(
                        navigationController.viewControllers[index-1],
                        animated: animated)
                }
            }
        case .embed(_, _):
            if vc.presentedViewController != nil { // dismiss presented children first
                vc.dismiss(animated: false, completion: nil)
            }

            vc.removeFromParent()
            vc.view.removeFromSuperview()
            vc.didMove(toParent: nil)

        case .appendToTabBarController(let source):
            guard let source = source as? UITabBarController else { break }
            var viewControllers = source.viewControllers ?? []
            if let index = viewControllers.firstIndex(of: source) {
                viewControllers.remove(at: index)
                source.viewControllers = viewControllers
            }
        case .custom(let source):
            if let source = source as? CustomDisplayable {
                source.undisplay(target: vc)
            } else {
                print("Warning⚠️: Source is not CustomDisplayable")
            }
        }
    }

    // MARK: - Type Definitions
    enum Method {
        case none
        case present(source: UIViewController, animated: Bool, style: UIModalPresentationStyle)
        case push(source: UIViewController, animated: Bool)
        case embed(source: UIViewController, view: UIView?)
        case appendToTabBarController(source: UIViewController)
        case custom(source: UIViewController)
    }
    
}

protocol CustomDisplayable {
  func display(target: UIViewController)
  func undisplay(target: UIViewController)
}

protocol CustomizingPresentAnimation {
  func startPresenting(from source: UIViewController)
  func startDismissing(completion: (() -> Void)?)
}
