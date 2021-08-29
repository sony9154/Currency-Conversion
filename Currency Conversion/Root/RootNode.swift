//
//  RootNode.swift
//  GitHubApiDemo
//
//  Created by Hsu Hua on 2021/7/8.
//

import Foundation
import RxSwift
import RxCocoa


class RootNode: Node {
  
    // MARK: - Store
  
    // MARK: - Action
    enum Action {
        case showHome
    }
    
    func act(_ action: Action, done: ActionCompletion? = nil) {
        switch action {
        case .showHome:
            router?.route(MainRouter.Routes.rootToHome, from: self)
            done?()
        }
    }
  
    // MARK: - Setup
    override func setup() {
        super.setup()
        self.act(.showHome)
    }
}
