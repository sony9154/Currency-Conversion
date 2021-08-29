import UIKit
import RxSwift
import RxCocoa

class BaseVC: UIViewController,
              UINavigationControllerDelegate {
    
    private var viewHasAppeared = false
    var viewWillAppearFirstTime = PublishSubject<Void>()
    
    var wantsNavigationBarHidden: Bool = false
    
    var navigationBackButton: UIBarButtonItem?
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Customizaing Navigation Bar Button
        if let customizing = self as? CustomizingNavigationBackButton {
            navigationItem.hidesBackButton = true
            navigationBackButton = customizing.customizedNavigationBackButton()
            navigationBackButton?.target = self
            navigationBackButton?.action = #selector(clickedNavigationBackButton(_:))
            navigationItem.leftBarButtonItem = navigationBackButton
        }
        
        // Customizaing Dismiss Button
        if let customizing = self as? CustomizingDismissButton {
            navigationItem.hidesBackButton = true
            navigationBackButton = customizing.customizedDismissButton()
            navigationBackButton?.target = self
            navigationBackButton?.action = #selector(clickedDismissButton(_:))
            navigationItem.leftBarButtonItem = navigationBackButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
        
        if viewHasAppeared == false {
            viewWillAppearFirstTime.onNext(())
            viewHasAppeared = true
        }
    }
    
    // MARK: - IB Action
    @objc func clickedNavigationBackButton(_ sender: Any) {
        if self == navigationController?.viewControllers.first {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func clickedDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation Controller Delegate
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        let closure = { () -> Void in
            if viewController == self {
                navigationController.setNavigationBarHidden(
                    self.wantsNavigationBarHidden, animated: true)
            } else {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
            
            if navigationController.delegate === self {
                navigationController.delegate = navigationController as? UINavigationControllerDelegate
            }
        }
        
        if Thread.isMainThread { // Check we're on main thread due to weird app crashes.
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    
    
}



protocol CustomizingNavigationBackButton {
    func customizedNavigationBackButton() -> UIBarButtonItem?
}

protocol CustomizingDismissButton {
    func customizedDismissButton() -> UIBarButtonItem?
}
