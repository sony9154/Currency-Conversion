import UIKit

protocol UINodeLifecycleImplementation: NodeLifecycleImplementation {
    
}

extension UINodeLifecycleImplementation {
    func nodeSetup() {
        
        let node = self as? Node
        let uiNode = self as? UINode
        
        if let vc = uiNode?.viewController as? NodeVCProtocol,
           let node = node {
            vc.setOwnerNode(node)
        }
        
        if let displayContext = node?.displayContext as? UIDisplayContext,
            let vc = uiNode?.viewControllerToDisplay(for: displayContext) {
            
            vc.view.accessibilityIdentifier = "\(String(describing: Self.self))_view"

            displayContext.display(vc)
        }
    }
    
    func nodeUninstall() {
        let node = self as? Node
        
        if let displayContext = node?.displayContext as? UIDisplayContext,
           let vc = (self as? UINode)?.viewControllerToDisplay(for: displayContext) {
            displayContext.undisplay(vc)
        }
    }
    
}
