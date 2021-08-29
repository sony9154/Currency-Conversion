import UIKit
import RxSwift
import RxCocoa

protocol UINode: UINodeLifecycleImplementation {
    var viewController: UIViewController? { get }
    func viewControllerToDisplay(for displayContext: DisplayContext) -> UIViewController?
}

extension UINode {
    func viewControllerToDisplay(for displayContext: DisplayContext) -> UIViewController? {
        if let wrapper = self as? CustomizedViewControllerWrapping {
            return wrapper.customizedViewControllerToDisplay(for: displayContext)
                   ?? viewController
        } else {
            return viewController
        }
    }
}


// MARK: - UINode with AnyView option
protocol UINodeWithAnyView: UINode {
    associatedtype ViewT: UIViewController, AnyMakable
    
    var _viewController: ViewT? { get set }
}

extension UINodeWithAnyView {
    var viewController: UIViewController? {
        return _viewController ?? {
            _viewController = ViewT.make() as? ViewT
            return _viewController
        }()
    }
}


// MARK: - Storyboard Makable
protocol StoryboardMakable: AnyMakable {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardMakable {
    static var storyboardName: String {
        return String(describing: Self.self).replacingOccurrences(of: "VC", with: "")
    }
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func make() -> Any? {
        let vc = UIStoryboard(name: storyboardName, bundle: nil)
                    .instantiateViewController(withIdentifier: storyboardIdentifier)
        vc.loadViewIfNeeded()
        return vc
    }
}


protocol CustomizedViewControllerWrapping: AnyObject {
  var viewController: UIViewController? { get }
  func customizedViewControllerToDisplay(for displayContext: DisplayContext) -> UIViewController?
}
