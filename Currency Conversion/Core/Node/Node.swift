
import Foundation
import RxSwift
import RxCocoa

class Node: NSObject {

    // Heirarchy
    weak var parent: Node?
    var children: [Node] = []

    // Common Events
    var didUninstall = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    
    // Display
    var displayContext: DisplayContext?
    
    // Routing
    var router: Router?
  
    // Object lifecycle
    deinit {
        print("deinit node \(self)")
    }
    
    // MARK: - Heirarchy Manipulation
    func add(child: Node, displayContext: DisplayContext?) {
        children.append(child)
        child.parent = self
        
        child.displayContext = displayContext
        
        child.setup()
    }
    
    func uninstall() {
        
        if let implementation = self as? NodeLifecycleImplementation {
            implementation.nodeUninstall()
        }
        
        if let index = parent?.children.firstIndex(where: { $0 === self }) {
            parent?.children.remove(at: index)
        }
        
        displayContext = nil
        
        parent = nil
        
        didUninstall.onNext(())
    }
    
    // MARK: - Setup
    func setup() {
        if let implementation = self as? NodeLifecycleImplementation {
            implementation.nodeSetup()
        }
    }
    
    // MARK: - Actions
    enum BasicAction {
        case uninstall
    }
    
    open func act(_ action: BasicAction, done: ActionCompletion? = nil) {
        switch action {
        case .uninstall:
            uninstall()
            done?()
        }

    }
    
    
    typealias ActionCompletion = (() -> Void)
}
