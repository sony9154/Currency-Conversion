import Foundation

enum RouteBehavior {
    case install
    case uninstall
    case custom
}

protocol Routable {
    var routeBehavior: RouteBehavior { get }
}

class Router {
    
    func route(_ route: Routable, from source: Node) {
        let target = targetNode(for: route, from: source)
        let displayContext = self.displayContext(for: route, from: source)
        
        switch route.routeBehavior {
        case .install:
            if let target = target,
               let displayContext = displayContext {
                
                source.add(child: target, displayContext: displayContext)
                
                configure(for: route, source: source, target: target)
            }
        case .uninstall:
            target?.uninstall()
        case .custom:
            break
        }   
    }
    
    func targetNode(for route: Routable, from source: Node) -> Node? {
        return nil
    }
    
    func displayContext(for route: Routable, from source: Node) -> DisplayContext? {
        return nil
    }
    
    func configure(for route: Routable, source: Node, target: Node) {
        
    }
    
}
