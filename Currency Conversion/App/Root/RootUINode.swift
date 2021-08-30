//
//  RootUINode.swift
//  GitHubApiDemo
//
//  Created by Hsu Hua on 2021/7/8.
//

import UIKit

class RootUINode: RootNode, UINodeWithAnyView {
  
    typealias ViewT = RootVC
    var _viewController: ViewT?
  
 
    // MARK: - Singleton
    static var shared = RootUINode()
}
