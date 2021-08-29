//
//  MainRouter.swift
//  UnitUITestDemo
//
//  Created by Hsu Hua on 2021/7/8.
//

import UIKit
import RxSwift
import RxCocoa


class MainRouter: Router {
 
    enum Routes: Routable {
        case rootToHome
        var routeBehavior: RouteBehavior {
            switch self {
            default:
                return .install
            }
        }
    }
    
    override func targetNode(for route: Routable, from source: Node) -> Node? {
        guard let route = route as? Routes
        else { return nil }
        
        var target: Node?
        
        switch route {
        case .rootToHome:
            target = CurrencyUINode()
            target?.router = self

        }
        return target
    }
    
    override func displayContext(for route: Routable,
                                 from source: Node) -> DisplayContext? {
        guard let route = route as? Routes,
              let vc = (source as? UINode)?.viewController
        else { return nil }
        
        switch route {
        case .rootToHome:
            return UIDisplayContext(method: .embed(source: vc, view: nil))
        }
    }
    
    
    override func configure(for route: Routable, source: Node, target: Node) {
        guard let route = route as? Routes
        else { return  }
        
        switch route {
        case .rootToHome:
            break
        }
    }
    
}
