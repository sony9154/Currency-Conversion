//
//  MainViewController.swift
//  UnitUITestDemo
//
//  Created by Hsu Hua on 2021/7/8.
//

import UIKit

class MainViewController: UIViewController {

    var node: Node?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if node == nil {
            node = RootUINode.shared
            
            let dc = UIDisplayContext(method:
                        .present(source: self,
                                 animated: false,
                                 style: .fullScreen))
            node?.displayContext = dc
            
            let router = MainRouter()
            node?.router = router
            
            node?.setup()
    
        }

    }
    

   

}
