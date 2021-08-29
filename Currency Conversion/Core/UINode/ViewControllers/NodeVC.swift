import UIKit
import RxSwift
import RxCocoa


protocol NodeVCProtocol {
    func setOwnerNode(_ node: Node?)
    
    var shouldUninstallWhenRemovedFromParentViewController: Bool { get set }
}


class NodeVC: BaseVC, NodeVCProtocol {
    
    var shouldUninstallWhenRemovedFromParentViewController: Bool = true
    
    var disposeBag = DisposeBag()
    
    deinit {
        print("deinit nodeVC \(self)")
    }
    
    weak var ownerNode: Node? {
        didSet {
            guard let node = ownerNode else { return }
            bindNode(node)
        }
    }
    
    func setOwnerNode(_ node: Node?) {
        // TODO: Should unbind first
        
        ownerNode = node
    }
    
    func bindNode(_ node: Node) {
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        // Make sure module is uninstalled when view disappears.
        // This might happen when user taps  the navigation back button.
        if shouldUninstallWhenRemovedFromParentViewController
         , parent == nil
         , ownerNode?.parent != nil {
            ownerNode?.displayContext = nil // Clear display method to avoid undisplay again
            ownerNode?.act(Node.BasicAction.uninstall)
        }
    }
}
