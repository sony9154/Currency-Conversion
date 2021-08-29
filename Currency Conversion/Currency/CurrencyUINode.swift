//
//  CurrencyUINode.swift
//  Currency Conversion
//
//  Created by Hsu Hua on 2021/8/21.
//

import UIKit

class CurrencyUINode: CurrencyNode,
                      UINodeWithAnyView {
    
    typealias ViewT = CurrencyVC
    var _viewController: ViewT?
    
}
